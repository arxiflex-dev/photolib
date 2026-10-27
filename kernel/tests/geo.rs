//! Offline reverse geocoding (ADR-0405) against the real packs of app/assets/geo/: the tree of places, their names in
//! the UI language, the time zone, the user's places and the failure paths.
#![allow(
    clippy::disallowed_types,
    clippy::disallowed_methods,
    clippy::indexing_slicing,
    clippy::unwrap_used,
    clippy::expect_used,
    clippy::panic
)]

use photolib_kernel::Keyring;
use photolib_kernel::proto::kernel::v1::{
    CallErrorCode, CallResponse, GeoDropRequest, GeoDropResponse, GeoLevel, GeoLoadRequest, GeoLoadResponse, GeoNode,
    GeoResolveRequest, GeoResolveResponse, GeoSort, GeoTimezoneRequest, GeoTimezoneResponse, GeoUserPlace, Method,
    call_response,
};
use prost::Message;
use std::path::PathBuf;

fn pack_file(name: &str) -> Vec<u8> {
    let dir = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../app/assets/geo");
    std::fs::read(dir.join(name)).unwrap_or_else(|e| panic!("{name}: {e}"))
}

fn call<Q: Message, R: Message + Default>(ring: &mut Keyring, method: Method, request: &Q) -> Result<R, CallErrorCode> {
    let answer = CallResponse::decode(ring.call(method as u32, &request.encode_to_vec()).as_slice()).unwrap();
    match answer.result {
        Some(call_response::Result::Response(bytes)) => Ok(R::decode(bytes.as_slice()).unwrap()),
        Some(call_response::Result::Error(e)) => Err(CallErrorCode::try_from(e.code).unwrap()),
        None => panic!("empty answer"),
    }
}

fn load(ring: &mut Keyring, names: Option<&str>) -> u32 {
    let request = GeoLoadRequest {
        core: pack_file("places.bin"),
        names: names.map(pack_file).unwrap_or_default(),
    };
    call::<_, GeoLoadResponse>(ring, Method::GeoLoad, &request)
        .unwrap()
        .pack
}

fn resolve(ring: &mut Keyring, pack: u32, points: &[(f64, f64)]) -> GeoResolveResponse {
    resolve_with(ring, pack, points, &[], false, GeoSort::Count)
}

fn resolve_with(
    ring: &mut Keyring,
    pack: u32,
    points: &[(f64, f64)],
    user_places: &[GeoUserPlace],
    include_sensitive: bool,
    sort: GeoSort,
) -> GeoResolveResponse {
    let request = GeoResolveRequest {
        pack,
        latitudes: points.iter().map(|p| p.0).collect(),
        longitudes: points.iter().map(|p| p.1).collect(),
        user_places: user_places.to_vec(),
        include_sensitive,
        sort: sort as i32,
    };
    call(ring, Method::GeoResolve, &request).unwrap()
}

const PARIS: (f64, f64) = (48.8566, 2.3522);
const LYON: (f64, f64) = (45.764, 4.8357);
const BERLIN: (f64, f64) = (52.52, 13.405);
const NEW_YORK: (f64, f64) = (40.7128, -74.006);

/// The chain of nodes from the point's deepest node up to its country.
fn chain(response: &GeoResolveResponse, point: usize) -> Vec<&GeoNode> {
    let mut out = Vec::new();
    let mut at = response.assignment[point];
    while at >= 0 {
        let node = &response.nodes[at as usize];
        out.push(node);
        at = node.parent;
    }
    out.reverse();
    out
}

fn names(chain: &[&GeoNode]) -> Vec<String> {
    chain.iter().map(|n| n.name.clone()).collect()
}

#[test]
fn loading_reports_what_the_pack_holds() {
    let mut ring = Keyring::default();
    let response: GeoLoadResponse = call(
        &mut ring,
        Method::GeoLoad,
        &GeoLoadRequest {
            core: pack_file("places.bin"),
            names: Vec::new(),
        },
    )
    .unwrap();
    assert_eq!(
        (response.countries, response.regions, response.cities),
        (252, 2764, 31806)
    );
}

#[test]
fn paris_resolves_to_country_region_and_city() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let found = resolve(&mut ring, pack, &[PARIS]);
    let chain = chain(&found, 0);
    assert_eq!(names(&chain), ["France", "Île-de-France", "Paris"]);
    assert_eq!(
        chain.iter().map(|n| (n.level(), n.code.as_str())).collect::<Vec<_>>(),
        [
            (GeoLevel::Country, "FR"),
            (GeoLevel::Region, "FR.11"),
            (GeoLevel::City, "2988507")
        ]
    );
    assert_eq!(chain[2].timezone, "Europe/Paris");
    assert!((chain[2].latitude - 48.85).abs() < 0.1 && (chain[2].longitude - 2.35).abs() < 0.1);
}

#[test]
fn the_southern_and_western_hemispheres_resolve_too() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let found = resolve(&mut ring, pack, &[NEW_YORK, (-36.8485, 174.7633), (-33.8688, 151.2093)]);
    assert_eq!(chain(&found, 0)[0].name, "United States");
    assert_eq!(chain(&found, 0)[1].code, "US.NY");
    assert_eq!(chain(&found, 1)[0].name, "New Zealand");
    assert_eq!(names(&chain(&found, 1)).last().unwrap(), "Auckland");
    assert_eq!(chain(&found, 2)[0].name, "Australia");
}

#[test]
fn names_follow_the_language_of_the_names_pack() {
    let mut ring = Keyring::default();
    let english = load(&mut ring, None);
    let german = load(&mut ring, Some("names-de.bin"));
    let japanese = load(&mut ring, Some("names-ja.bin"));
    let munich = (48.1351, 11.582);
    let in_english = resolve(&mut ring, english, &[munich]);
    let in_german = resolve(&mut ring, german, &[munich]);
    let in_japanese = resolve(&mut ring, japanese, &[munich]);
    assert_eq!(names(&chain(&in_english, 0)), ["Germany", "Bavaria", "Munich"]);
    assert_eq!(names(&chain(&in_german, 0)), ["Deutschland", "Bayern", "München"]);
    assert_eq!(chain(&in_japanese, 0)[0].name, "ドイツ");
    // The codes do not depend on the language.
    assert_eq!(chain(&in_german, 0)[2].code, chain(&in_english, 0)[2].code);
}

#[test]
fn a_name_without_a_translation_falls_back_to_english() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, Some("names-zh_Hant.bin"));
    let found = resolve(&mut ring, pack, &[PARIS]);
    assert!(chain(&found, 0).iter().all(|n| !n.name.is_empty()));
    assert_eq!(chain(&found, 0)[0].name, "法國");
}

#[test]
fn siblings_sort_by_count_by_default_and_by_name_on_request() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let points = [PARIS, PARIS, PARIS, LYON, LYON, BERLIN];
    let by_count = resolve(&mut ring, pack, &points);
    let countries: Vec<_> = by_count
        .nodes
        .iter()
        .filter(|n| n.level() == GeoLevel::Country)
        .map(|n| (n.name.as_str(), n.count))
        .collect();
    assert_eq!(countries, [("France", 5), ("Germany", 1)]);
    let cities = |r: &GeoResolveResponse| {
        r.nodes
            .iter()
            .filter(|n| n.level() == GeoLevel::City)
            .map(|n| n.name.clone())
            .collect::<Vec<_>>()
    };
    assert_eq!(cities(&by_count), ["Paris", "Lyon", "Berlin"]);
    let by_name = resolve_with(&mut ring, pack, &points, &[], false, GeoSort::Name);
    assert_eq!(
        cities(&by_name),
        ["Lyon", "Paris", "Berlin"],
        "within a country by name, countries by name"
    );
    assert_eq!(
        by_name
            .nodes
            .iter()
            .filter(|n| n.level() == GeoLevel::Country)
            .map(|n| n.name.as_str())
            .collect::<Vec<_>>(),
        ["France", "Germany"]
    );
}

#[test]
fn ties_in_count_fall_back_to_the_name() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let found = resolve(&mut ring, pack, &[PARIS, BERLIN, LYON, NEW_YORK]);
    let countries: Vec<_> = found
        .nodes
        .iter()
        .filter(|n| n.level() == GeoLevel::Country)
        .map(|n| n.name.as_str())
        .collect();
    assert_eq!(countries, ["France", "Germany", "United States"]);
}

#[test]
fn counts_add_up_through_the_tree_and_parents_come_first() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let points = [PARIS, PARIS, LYON, BERLIN, (0.0, -30.0)];
    let found = resolve(&mut ring, pack, &points);
    for (i, node) in found.nodes.iter().enumerate() {
        assert!(node.parent < i as i32, "a parent comes before its children");
        let children: u32 = found
            .nodes
            .iter()
            .filter(|c| c.parent == i as i32)
            .map(|c| c.count)
            .sum();
        let own = found.assignment.iter().filter(|&&a| a == i as i32).count() as u32;
        assert_eq!(node.count, children + own, "{}", node.name);
    }
    assert_eq!(found.assignment[4], -1, "the open Atlantic has no place");
}

#[test]
fn a_remote_position_has_a_country_but_no_city() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    // The Algerian Sahara, hundreds of kilometres from a town of 15,000.
    let found = resolve(&mut ring, pack, &[(24.0, 6.0)]);
    let chain = chain(&found, 0);
    assert_eq!(chain[0].name, "Algeria");
    assert!(chain.iter().all(|n| n.level() != GeoLevel::City));
}

#[test]
fn a_city_across_the_border_is_not_taken_for_the_one_at_home() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    // French side of the Geneva border, 2 km from the Swiss city's centre.
    let found = resolve(&mut ring, pack, &[(46.1, 6.09)]);
    assert_eq!(chain(&found, 0)[0].code, "FR");
    assert!(chain(&found, 0).iter().all(|n| n.name != "Geneva"));
}

#[test]
fn a_coastal_position_outside_the_borders_takes_the_near_city() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    // A harbour pier a little off the 50 m coastline.
    let found = resolve(&mut ring, pack, &[(37.8044, -122.4658)]);
    assert_eq!(names(&chain(&found, 0))[0], "United States");
}

#[test]
fn time_zones_follow_the_nearest_city_and_the_sea_has_a_nautical_zone() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let zone = |ring: &mut Keyring, lat, lon| -> GeoTimezoneResponse {
        call(
            ring,
            Method::GeoTimezone,
            &GeoTimezoneRequest {
                pack,
                latitude: lat,
                longitude: lon,
            },
        )
        .unwrap()
    };
    assert_eq!(zone(&mut ring, 28.6, 77.2).timezone, "Asia/Kolkata");
    assert_eq!(zone(&mut ring, 21.3, -157.85).timezone, "Pacific/Honolulu");
    assert_eq!(zone(&mut ring, PARIS.0, PARIS.1).country, "FR");
    let sea = zone(&mut ring, 0.0, -30.0);
    assert_eq!((sea.timezone.as_str(), sea.country.as_str()), ("Etc/GMT+2", ""));
    assert_eq!(zone(&mut ring, 0.0, 179.0).timezone, "Etc/GMT-12");
}

#[test]
fn a_user_place_takes_the_positions_in_its_circle() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let place = GeoUserPlace {
        id: "p1".into(),
        name: "Grandma's".into(),
        latitude: PARIS.0,
        longitude: PARIS.1,
        radius_m: 300,
        sensitive: false,
    };
    let found = resolve_with(
        &mut ring,
        pack,
        &[PARIS, (PARIS.0 + 0.001, PARIS.1), (PARIS.0 + 0.01, PARIS.1)],
        &[place],
        false,
        GeoSort::Count,
    );
    let first = chain(&found, 0);
    assert_eq!(names(&first), ["Grandma's"]);
    assert_eq!(
        (first[0].level(), first[0].code.as_str(), first[0].parent),
        (GeoLevel::User, "p1", -1)
    );
    assert_eq!(found.assignment[1], found.assignment[0]);
    assert_eq!(found.nodes[found.assignment[0] as usize].count, 2);
    assert_eq!(chain(&found, 2)[2].name, "Paris", "1 km away is just Paris");
}

#[test]
fn a_sensitive_place_names_and_counts_nothing_unless_asked() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let home = GeoUserPlace {
        id: "home".into(),
        name: "Home".into(),
        latitude: LYON.0,
        longitude: LYON.1,
        radius_m: 500,
        sensitive: true,
    };
    let points = [LYON, PARIS];
    let hidden = resolve_with(
        &mut ring,
        pack,
        &points,
        std::slice::from_ref(&home),
        false,
        GeoSort::Count,
    );
    assert_eq!(hidden.assignment[0], -1, "the position is in no place at all");
    assert!(
        hidden
            .nodes
            .iter()
            .all(|n| !n.sensitive && n.name != "Home" && n.name != "Lyon")
    );
    assert_eq!(
        hidden.nodes.iter().filter(|n| n.level() == GeoLevel::Country).count(),
        1
    );
    let shown = resolve_with(&mut ring, pack, &points, &[home], true, GeoSort::Count);
    let node = &shown.nodes[shown.assignment[0] as usize];
    assert_eq!((node.name.as_str(), node.sensitive, node.count), ("Home", true, 1));
}

#[test]
fn bad_input_is_refused_or_left_out() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let mismatched = GeoResolveRequest {
        pack,
        latitudes: vec![1.0, 2.0],
        longitudes: vec![1.0],
        ..Default::default()
    };
    assert_eq!(
        call::<_, GeoResolveResponse>(&mut ring, Method::GeoResolve, &mismatched).unwrap_err(),
        CallErrorCode::InvalidRequest
    );
    let found = resolve(&mut ring, pack, &[(f64::NAN, 0.0), (91.0, 0.0), (0.0, 181.0), PARIS]);
    assert_eq!(&found.assignment[..3], [-1, -1, -1]);
    assert!(found.assignment[3] >= 0);
    assert!(resolve(&mut ring, pack, &[]).nodes.is_empty());
    let unknown = GeoResolveRequest {
        pack: 99,
        ..Default::default()
    };
    assert_eq!(
        call::<_, GeoResolveResponse>(&mut ring, Method::GeoResolve, &unknown).unwrap_err(),
        CallErrorCode::InvalidRequest
    );
}

#[test]
fn damaged_packs_are_refused_not_trusted() {
    let mut ring = Keyring::default();
    let core = pack_file("places.bin");
    let mut load_core = |core: Vec<u8>, names: Vec<u8>| {
        call::<_, GeoLoadResponse>(&mut ring, Method::GeoLoad, &GeoLoadRequest { core, names }).map(|r| r.pack)
    };
    assert_eq!(load_core(Vec::new(), Vec::new()), Err(CallErrorCode::InvalidInput));
    assert_eq!(
        load_core(core[..core.len() / 2].to_vec(), Vec::new()),
        Err(CallErrorCode::InvalidInput)
    );
    let mut wrong_magic = core.clone();
    wrong_magic[0] = b'X';
    assert_eq!(load_core(wrong_magic, Vec::new()), Err(CallErrorCode::InvalidInput));
    let names = pack_file("names-de.bin");
    assert_eq!(
        load_core(core.clone(), names[..names.len() - 3].to_vec()),
        Err(CallErrorCode::InvalidInput)
    );
    assert_eq!(load_core(core, b"junk".to_vec()), Err(CallErrorCode::InvalidInput));
}

#[test]
fn a_dropped_pack_is_gone() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    call::<_, GeoDropResponse>(&mut ring, Method::GeoDrop, &GeoDropRequest { pack }).unwrap();
    assert_eq!(
        call::<_, GeoDropResponse>(&mut ring, Method::GeoDrop, &GeoDropRequest { pack }).unwrap_err(),
        CallErrorCode::InvalidRequest
    );
}

#[test]
fn well_known_places_around_the_world_resolve_to_their_country_and_city() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let known = [
        ("Tokyo", "JP", 35.6762, 139.6503),
        ("Cairo", "EG", 30.0444, 31.2357),
        ("Nairobi", "KE", -1.2921, 36.8219),
        ("São Paulo", "BR", -23.5505, -46.6333),
        ("Mexico City", "MX", 19.4326, -99.1332),
        ("Moscow", "RU", 55.7558, 37.6173),
        ("Sydney", "AU", -33.8688, 151.2093),
        ("Reykjav", "IS", 64.1466, -21.9426),
        ("Singapore", "SG", 1.3521, 103.8198),
        ("Vancouver", "CA", 49.2827, -123.1207),
        ("Istanbul", "TR", 41.0082, 28.9784),
        ("Cape Town", "ZA", -33.9249, 18.4241),
        ("Buenos Aires", "AR", -34.6037, -58.3816),
        ("Mumbai", "IN", 19.076, 72.8777),
        ("Honolulu", "US", 21.3069, -157.8583),
        ("Rome", "IT", 41.9028, 12.4964),
    ];
    let points: Vec<_> = known.iter().map(|k| (k.2, k.3)).collect();
    let found = resolve(&mut ring, pack, &points);
    for (i, (name, country, _, _)) in known.iter().enumerate() {
        let chain = chain(&found, i);
        assert_eq!(chain[0].code, *country, "{name}");
        assert_eq!(chain.last().unwrap().level(), GeoLevel::City, "{name}");
        assert!(
            chain.last().unwrap().name.contains(name.split(' ').next().unwrap()),
            "{name}: {:?}",
            names(&chain)
        );
    }
}

#[test]
fn a_hundred_thousand_positions_resolve_with_exact_counts() {
    let mut ring = Keyring::default();
    let pack = load(&mut ring, None);
    let cities = [PARIS, LYON, BERLIN, NEW_YORK];
    let points: Vec<_> = (0..100_000_u32)
        .map(|i| {
            let (lat, lon) = cities[(i % 4) as usize];
            (lat + f64::from(i % 7) * 0.001, lon + f64::from(i % 5) * 0.001)
        })
        .collect();
    let found = resolve(&mut ring, pack, &points);
    let countries: u32 = found
        .nodes
        .iter()
        .filter(|n| n.level() == GeoLevel::Country)
        .map(|n| n.count)
        .sum();
    assert_eq!(countries, 100_000);
}
