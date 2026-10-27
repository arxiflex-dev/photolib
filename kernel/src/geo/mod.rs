//! Offline reverse geocoding (ADR-0405, MAP-08): the places packs of app/assets/geo/ are held in the keyring and give
//! the country, region, city and time zone of positions, in the language of the names pack, with no network.

mod find;
mod pack;

use crate::proto::kernel::v1::{
    GeoDropRequest, GeoDropResponse, GeoLevel, GeoLoadRequest, GeoLoadResponse, GeoNode, GeoResolveRequest,
    GeoResolveResponse, GeoSort, GeoTimezoneRequest, GeoTimezoneResponse, GeoUserPlace,
};
use crate::{CallError, Keyring, invalid_request};
use find::{Found, metres, on_earth};
pub(crate) use pack::Pack;
use pack::{Kind, NONE};
use std::collections::BTreeMap;

/// The radius of a user place that names none, in metres.
const DEFAULT_RADIUS_M: u32 = 200;

pub(crate) fn load(ring: &mut Keyring, request: &GeoLoadRequest) -> Result<GeoLoadResponse, CallError> {
    let pack = Pack::load(&request.core, &request.names)?;
    let count = |n: usize| u32::try_from(n).unwrap_or(u32::MAX);
    let response = GeoLoadResponse {
        pack: ring.last_pack.saturating_add(1),
        countries: count(pack.countries.len()),
        regions: count(pack.regions.len()),
        cities: count(pack.cities.len()),
    };
    ring.last_pack = response.pack;
    ring.packs.insert(response.pack, pack);
    Ok(response)
}

pub(crate) fn drop_pack(ring: &mut Keyring, request: GeoDropRequest) -> Result<GeoDropResponse, CallError> {
    ring.packs
        .remove(&request.pack)
        .map(|_| GeoDropResponse {})
        .ok_or_else(|| invalid_request("pack"))
}

pub(crate) fn timezone(ring: &Keyring, request: &GeoTimezoneRequest) -> Result<GeoTimezoneResponse, CallError> {
    let pack = pack(ring, request.pack)?;
    if !on_earth(request.latitude, request.longitude) {
        return Err(invalid_request("latitude"));
    }
    let (timezone, country) = pack.zone_at(request.latitude, request.longitude);
    Ok(GeoTimezoneResponse {
        timezone,
        country: country
            .and_then(|c| pack.countries.get(usize::from(c)))
            .map(|c| String::from_utf8_lossy(&c.code).into_owned())
            .unwrap_or_default(),
    })
}

fn pack(ring: &Keyring, handle: u32) -> Result<&Pack, CallError> {
    ring.packs.get(&handle).ok_or_else(|| invalid_request("pack"))
}

/// A node of the tree before it is ordered: what it is.
#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Debug)]
enum Key {
    User(u32),
    Country(u16),
    Region(u16),
    City(u32),
}

/// Where a position goes: its leaf node, or nowhere.
fn leaf(pack: &Pack, user_places: &[GeoUserPlace], include_sensitive: bool, at: (f64, f64)) -> Option<Key> {
    if !on_earth(at.0, at.1) {
        return None;
    }
    let held = user_places
        .iter()
        .zip(0_u32..)
        .filter_map(|(place, i)| {
            let reach = f64::from(if place.radius_m == 0 {
                DEFAULT_RADIUS_M
            } else {
                place.radius_m
            });
            let away = metres(at, (place.latitude, place.longitude));
            (away <= reach).then_some((away, i, place.sensitive))
        })
        .min_by(|a, b| a.0.total_cmp(&b.0));
    if let Some((_, i, sensitive)) = held {
        return (include_sensitive || !sensitive).then_some(Key::User(i));
    }
    let Found { country, region, city } = pack.locate(at.0, at.1);
    city.map(Key::City)
        .or_else(|| region.map(Key::Region))
        .or_else(|| country.map(Key::Country))
}

/// A key's parent: a city's region (else country), a region's country.
fn parent(pack: &Pack, key: Key) -> Option<Key> {
    match key {
        Key::City(i) => {
            let city = pack.cities.get(usize::try_from(i).ok()?)?;
            Some(if city.region == NONE {
                Key::Country(city.country)
            } else {
                Key::Region(city.region)
            })
        }
        Key::Region(i) => Some(Key::Country(pack.regions.get(usize::from(i))?.country)),
        Key::Country(_) | Key::User(_) => None,
    }
}

fn describe(pack: &Pack, user_places: &[GeoUserPlace], key: Key) -> GeoNode {
    let node = |level: GeoLevel, name: String, code: String| GeoNode {
        level: level.into(),
        name,
        code,
        parent: -1,
        ..Default::default()
    };
    match key {
        Key::User(i) => {
            let place = user_places
                .get(usize::try_from(i).unwrap_or(usize::MAX))
                .cloned()
                .unwrap_or_default();
            GeoNode {
                latitude: place.latitude,
                longitude: place.longitude,
                sensitive: place.sensitive,
                ..node(GeoLevel::User, place.name, place.id)
            }
        }
        Key::Country(i) => {
            let code = pack
                .countries
                .get(usize::from(i))
                .map(|c| String::from_utf8_lossy(&c.code).into_owned());
            node(
                GeoLevel::Country,
                pack.name(Kind::Country, usize::from(i)),
                code.unwrap_or_default(),
            )
        }
        Key::Region(i) => {
            let country = pack
                .regions
                .get(usize::from(i))
                .and_then(|r| pack.countries.get(usize::from(r.country)));
            let prefix = country
                .map(|c| String::from_utf8_lossy(&c.code).into_owned())
                .unwrap_or_default();
            node(
                GeoLevel::Region,
                pack.name(Kind::Region, usize::from(i)),
                format!("{prefix}.{}", pack.region_code(i)),
            )
        }
        Key::City(i) => {
            let city = pack.cities.get(usize::try_from(i).unwrap_or(usize::MAX));
            GeoNode {
                latitude: city.map_or(0.0, |c| c.lat),
                longitude: city.map_or(0.0, |c| c.lon),
                timezone: city
                    .and_then(|c| pack.zones.get(usize::from(c.zone)).cloned())
                    .unwrap_or_default(),
                ..node(
                    GeoLevel::City,
                    pack.name(Kind::City, usize::try_from(i).unwrap_or(usize::MAX)),
                    city.map(|c| c.id.to_string()).unwrap_or_default(),
                )
            }
        }
    }
}

pub(crate) fn resolve(ring: &Keyring, request: &GeoResolveRequest) -> Result<GeoResolveResponse, CallError> {
    let pack = pack(ring, request.pack)?;
    if request.latitudes.len() != request.longitudes.len() {
        return Err(invalid_request("longitudes"));
    }
    let places = &request.user_places;
    // Neighbours in a library are mostly at the same place: a position in the cell of the last one takes its answer.
    let mut last: Option<((i64, i64), Option<Key>)> = None;
    let mut own: BTreeMap<Key, u32> = BTreeMap::new();
    let mut keys = Vec::with_capacity(request.latitudes.len());
    for (&lat, &lon) in request.latitudes.iter().zip(&request.longitudes) {
        let key = match last {
            Some((cell, key)) if places.is_empty() && cell == quantise(lat, lon) => key,
            _ => leaf(pack, places, request.include_sensitive, (lat, lon)),
        };
        last = Some((quantise(lat, lon), key));
        if let Some(key) = key {
            let n = own.entry(key).or_default();
            *n = n.saturating_add(1);
        }
        keys.push(key);
    }
    Ok(tree(pack, request, &own, &keys))
}

/// The position in hundredths of a degree (about a kilometre), or a cell no position has when it is not on Earth.
#[allow(clippy::cast_possible_truncation)] // on-Earth values times 100 fit; off-Earth ones saturate into their own cell
fn quantise(lat: f64, lon: f64) -> (i64, i64) {
    if on_earth(lat, lon) {
        ((lat * 100.0).round() as i64, (lon * 100.0).round() as i64)
    } else {
        (i64::MAX, i64::MAX)
    }
}

/// The nodes in order, parents first and siblings sorted, with the counts of everything beneath each.
fn tree(
    pack: &Pack,
    request: &GeoResolveRequest,
    own: &BTreeMap<Key, u32>,
    keys: &[Option<Key>],
) -> GeoResolveResponse {
    let mut counts: BTreeMap<Key, u32> = BTreeMap::new();
    for (&key, &n) in own {
        let mut at = Some(key);
        while let Some(k) = at {
            let total = counts.entry(k).or_default();
            *total = total.saturating_add(n);
            at = parent(pack, k);
        }
    }
    let mut described: BTreeMap<Key, GeoNode> = counts
        .iter()
        .map(|(&k, &n)| {
            let mut node = describe(pack, &request.user_places, k);
            node.count = n;
            (k, node)
        })
        .collect();
    let mut children: BTreeMap<Option<Key>, Vec<Key>> = BTreeMap::new();
    for &key in counts.keys() {
        children.entry(parent(pack, key)).or_default().push(key);
    }
    let by_name = request.sort() == GeoSort::Name;
    let lower: BTreeMap<Key, String> = described.iter().map(|(&k, n)| (k, n.name.to_lowercase())).collect();
    for siblings in children.values_mut() {
        siblings.sort_by(|a, b| {
            let (na, nb) = (counts.get(a).copied().unwrap_or(0), counts.get(b).copied().unwrap_or(0));
            let count = if by_name {
                std::cmp::Ordering::Equal
            } else {
                nb.cmp(&na)
            };
            count
                .then_with(|| lower.get(a).cmp(&lower.get(b)))
                .then_with(|| a.cmp(b))
        });
    }
    let mut nodes = Vec::with_capacity(described.len());
    let mut index: BTreeMap<Key, i32> = BTreeMap::new();
    let mut pending: Vec<Key> = children
        .get(&None)
        .map(|roots| roots.iter().rev().copied().collect())
        .unwrap_or_default();
    while let Some(key) = pending.pop() {
        let Some(mut node) = described.remove(&key) else {
            continue;
        };
        node.parent = parent(pack, key).and_then(|p| index.get(&p).copied()).unwrap_or(-1);
        index.insert(key, i32::try_from(nodes.len()).unwrap_or(i32::MAX));
        nodes.push(node);
        pending.extend(children.get(&Some(key)).into_iter().flatten().rev());
    }
    GeoResolveResponse {
        nodes,
        assignment: keys
            .iter()
            .map(|k| k.and_then(|k| index.get(&k).copied()).unwrap_or(-1))
            .collect(),
    }
}
