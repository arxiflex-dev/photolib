//! Map clustering (design doc 14): counts, hierarchy, edges and the 1M-asset budget.
#![allow(
    clippy::disallowed_types,
    clippy::disallowed_methods,
    clippy::cast_precision_loss,
    clippy::suboptimal_flops
)]

use photolib_kernel::cluster::{ClusterIndex, Filter};
use std::time::{Duration, Instant};

fn world(index: &ClusterIndex, zoom: u8) -> Vec<photolib_kernel::cluster::Cluster> {
    index.query(-180.0, -85.0, 180.0, 85.0, zoom)
}

fn total(index: &ClusterIndex, zoom: u8) -> u32 {
    world(index, zoom).iter().map(|c| c.count).sum()
}

#[test]
fn every_asset_is_counted_at_every_zoom() {
    let points: Vec<_> = (0..500)
        .map(|i| (f64::from(i % 50) - 25.0, f64::from(i / 50) * 7.0 - 35.0))
        .collect();
    let index = ClusterIndex::build(&points);
    for zoom in 0..=20 {
        assert_eq!(total(&index, zoom), 500, "zoom {zoom}");
    }
}

#[test]
fn nearby_assets_merge_and_deep_zoom_separates_them() {
    let index = ClusterIndex::build(&[(48.8566, 2.3522), (48.8570, 2.3530), (-33.87, 151.21)]);
    assert_eq!(world(&index, 3).len(), 2);
    let near = world(&index, 20);
    assert_eq!(near.len(), 3);
    let mut assets: Vec<_> = near.iter().filter_map(|c| c.asset).collect();
    assets.sort_unstable();
    assert_eq!(assets, [0, 1, 2]);
}

#[test]
fn a_single_asset_keeps_its_position_and_index() {
    let index = ClusterIndex::build(&[(10.0, 20.0), (f64::NAN, 0.0), (45.5, -73.6)]);
    let one = index.query(-74.0, 45.0, -73.0, 46.0, 10);
    assert_eq!(one.len(), 1);
    assert_eq!(one[0].asset, Some(2));
    assert!(
        (one[0].lat - 45.5).abs() < 1e-4 && (one[0].lon + 73.6).abs() < 1e-4,
        "{:?}",
        one[0]
    );
}

#[test]
fn invalid_and_off_map_points_are_skipped() {
    let index = ClusterIndex::build(&[
        (f64::NAN, 1.0),
        (1.0, f64::INFINITY),
        (89.0, 0.0),
        (0.0, 181.0),
        (0.0, 0.0),
    ]);
    assert_eq!(total(&index, 4), 1);
    assert_eq!(total(&ClusterIndex::build(&[]), 4), 0);
}

#[test]
fn duplicates_count_separately_and_cluster_at_every_zoom() {
    let index = ClusterIndex::build(&[(1.0, 1.0); 5]);
    assert_eq!(total(&index, 20), 5);
    assert_eq!(world(&index, 5).len(), 1);
}

#[test]
fn a_box_over_the_antimeridian_finds_both_sides() {
    let index = ClusterIndex::build(&[(0.0, 179.9), (0.0, -179.9), (0.0, 0.0)]);
    let found = index.query(170.0, -10.0, -170.0, 10.0, 8);
    assert_eq!(found.iter().map(|c| c.count).sum::<u32>(), 2);
}

#[test]
fn a_viewport_returns_only_what_is_inside() {
    let points: Vec<_> = (0..100)
        .map(|i| (f64::from(i) * 0.5 - 25.0, f64::from(i) * 0.5 - 25.0))
        .collect();
    let index = ClusterIndex::build(&points);
    let found = index.query(0.0, 0.0, 5.0, 5.0, 12);
    assert!(!found.is_empty() && found.len() < 100);
    assert!(
        found
            .iter()
            .all(|c| (-1.0..6.0).contains(&c.lat) && (-1.0..6.0).contains(&c.lon))
    );
}

fn trip() -> ClusterIndex {
    // Two Paris photos (days 1 and 5), one Lisbon (day 3), one without a place.
    let points = [(48.85, 2.35), (48.86, 2.36), (38.72, -9.14), (f64::NAN, 0.0)];
    ClusterIndex::build_timed(&points, &[86_400, 5 * 86_400, 3 * 86_400, 0])
}

#[test]
fn a_time_range_keeps_only_assets_taken_in_it() {
    let index = trip();
    let filter = Filter {
        from: Some(2 * 86_400),
        to: Some(4 * 86_400),
        ..Filter::default()
    };
    let found = index.query_filtered(-180.0, -85.0, 180.0, 85.0, 20, &filter);
    assert_eq!(found.iter().filter_map(|c| c.asset).collect::<Vec<_>>(), [2]);
    let open = Filter {
        from: Some(2 * 86_400),
        ..Filter::default()
    };
    assert_eq!(index.assets(-180.0, -85.0, 180.0, 85.0, &open, 0), (vec![1, 2], 2));
    let none = Filter {
        from: Some(9 * 86_400),
        ..Filter::default()
    };
    assert_eq!(index.query_filtered(-180.0, -85.0, 180.0, 85.0, 3, &none).len(), 0);
}

#[test]
fn filtered_clusters_still_merge_what_is_left() {
    let index = trip();
    let both = Filter {
        from: Some(0),
        to: Some(10 * 86_400),
        ..Filter::default()
    };
    let found = index.query_filtered(-180.0, -85.0, 180.0, 85.0, 3, &both);
    assert_eq!(found.iter().map(|c| c.count).sum::<u32>(), 3);
    assert_eq!(found.len(), 2);
}

#[test]
fn a_lasso_keeps_the_assets_inside_its_polygon() {
    let index = trip();
    let lasso = Filter {
        polygon: vec![[40.0, 0.0], [40.0, 5.0], [50.0, 5.0], [50.0, 0.0]],
        ..Filter::default()
    };
    assert_eq!(index.assets(-180.0, -85.0, 180.0, 85.0, &lasso, 0), (vec![0, 1], 2));
    let found = index.query_filtered(-180.0, -85.0, 180.0, 85.0, 3, &lasso);
    assert_eq!(found.iter().map(|c| c.count).sum::<u32>(), 2);
    let line = Filter {
        polygon: vec![[40.0, 0.0], [50.0, 5.0]],
        ..Filter::default()
    };
    assert_eq!(
        index.assets(-180.0, -85.0, 180.0, 85.0, &line, 0).1,
        3,
        "fewer than three vertices is no lasso"
    );
}

#[test]
fn assets_in_a_viewport_are_limited_but_counted() {
    let index = trip();
    let (assets, total) = index.assets(0.0, 40.0, 5.0, 50.0, &Filter::default(), 1);
    assert_eq!((assets, total), (vec![0], 2));
    assert_eq!(index.assets(-180.0, -85.0, 180.0, 85.0, &Filter::default(), 0).1, 3);
}

#[test]
fn assets_without_times_never_pass_a_time_range() {
    let index = ClusterIndex::build(&[(1.0, 1.0)]);
    let filter = Filter {
        to: Some(5),
        ..Filter::default()
    };
    assert_eq!(index.assets(-180.0, -85.0, 180.0, 85.0, &filter, 0).1, 0);
}

#[test]
fn a_million_assets_cluster_and_pan() {
    let mut seed = 0x9e37_79b9_7f4a_7c15_u64;
    let mut next = move || {
        seed ^= seed << 13;
        seed ^= seed >> 7;
        seed ^= seed << 17;
        (seed >> 11) as f64 / (1_u64 << 53) as f64
    };
    // Ten cities with a spread of a few km, like a library's trips.
    let cities: Vec<(f64, f64)> = (0..10)
        .map(|_| (next() * 120.0 - 60.0, next() * 340.0 - 170.0))
        .collect();
    let points: Vec<_> = (0..1_000_000)
        .map(|i| {
            let (lat, lon) = cities[i % cities.len()];
            (lat + (next() - 0.5) * 0.4, lon + (next() - 0.5) * 0.4)
        })
        .collect();

    let started = Instant::now();
    let index = ClusterIndex::build(&points);
    let build = started.elapsed();
    assert_eq!(total(&index, 0), 1_000_000);

    // A phone-sized viewport (~1000 px wide) panned over a city at several zooms; the fastest sample of each, as
    // AGENTS.md says.
    let mut worst = Duration::ZERO;
    for zoom in [4_u8, 8, 11, 14, 16] {
        let degrees = 360.0 * 1000.0 / (256.0 * f64::from(1_u32 << zoom));
        let (lat, lon) = cities[0];
        let fastest = (0..9)
            .map(|step| {
                let pan = f64::from(step) * degrees / 4.0;
                let started = Instant::now();
                let found = index.query(lon + pan, lat - degrees, lon + pan + degrees, lat + degrees, zoom);
                std::hint::black_box(found.len());
                started.elapsed()
            })
            .min()
            .unwrap_or_default();
        worst = worst.max(fastest);
    }
    eprintln!("1M assets: build {build:?}, slowest viewport query {worst:?}");
    // Time is no assertion of a correctness test: the `map-pan` budget (tools/perf) holds the frame budget. These are
    // hang guards.
    assert!(build.as_secs() < 60, "build {build:?}");
    assert!(worst.as_secs() < 60, "a query took {worst:?}");
}
