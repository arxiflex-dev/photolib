//! Where a position is: its country by the borders, its city and region by the nearest city of that country, its time
//! zone by the same. Only f64 arithmetic and `libm`, so that every build gives the same answer.

use super::pack::{BORDER_UNIT, CELL_COLUMNS, CELL_ROWS, City, NONE, Pack, cell_of};

/// How far a city may be and still name the place, and how far the nearest city of the country still names the region.
const CITY_KM: f64 = 50.0;
const REGION_KM: f64 = 200.0;
/// Kilometres in a degree of latitude.
const KM_PER_DEGREE: f64 = 111.195;

/// What a position is in.
#[derive(Clone, Copy, Default, PartialEq, Eq, Debug)]
pub(super) struct Found {
    pub country: Option<u16>,
    pub region: Option<u16>,
    pub city: Option<u32>,
}

/// Whether the numbers are a position on Earth.
pub(super) fn on_earth(lat: f64, lon: f64) -> bool {
    lat.is_finite() && lon.is_finite() && lat.abs() <= 90.0 && lon.abs() <= 180.0
}

/// Kilometres between two positions that are not far apart (the planet taken as a sphere, the longitude difference
/// wrapped), or a good estimate of the order when they are.
pub(super) fn km(from: (f64, f64), to: (f64, f64)) -> f64 {
    let mut east = (to.1 - from.1).rem_euclid(360.0);
    if east > 180.0 {
        east -= 360.0;
    }
    let across = east * libm::cos(from.0.midpoint(to.0).to_radians());
    KM_PER_DEGREE * libm::hypot(across, to.0 - from.0)
}

/// Metres between two positions by the haversine formula.
pub(super) fn metres(from: (f64, f64), to: (f64, f64)) -> f64 {
    let (phi_from, phi_to) = (from.0.to_radians(), to.0.to_radians());
    let half_north = libm::sin((to.0 - from.0).to_radians() / 2.0);
    let half_east = libm::sin((to.1 - from.1).to_radians() / 2.0);
    let h = (libm::cos(phi_from) * libm::cos(phi_to)).mul_add(half_east * half_east, half_north * half_north);
    2.0 * 6_371_008.8 * libm::asin(libm::sqrt(h.clamp(0.0, 1.0)))
}

/// Whether (x, y) lies inside the ring, by the even-odd rule.
fn inside(ring: &[(i16, i16)], x: f64, y: f64) -> bool {
    let corner = |&(x, y): &(i16, i16)| (f64::from(x), f64::from(y));
    let mut odd = false;
    let mut before = ring.last().map(corner);
    for (x2, y2) in ring.iter().map(corner) {
        if let Some((x1, y1)) = before
            && (y1 > y) != (y2 > y)
            && x < (x2 - x1) * (y - y1) / (y2 - y1) + x1
        {
            odd = !odd;
        }
        before = Some((x2, y2));
    }
    odd
}

impl Pack {
    /// The country whose borders hold the position.
    pub(super) fn country_at(&self, lat: f64, lon: f64) -> Option<u16> {
        let (x, y) = (lon * BORDER_UNIT, lat * BORDER_UNIT);
        let mut found = None;
        for (i, country) in self.countries.iter().enumerate() {
            let [west, south, east, north] = country.bounds.map(f64::from);
            if x < west || x > east || y < south || y > north {
                continue;
            }
            let rings = self.rings.get(country.rings.clone())?;
            if rings.iter().filter(|ring| inside(ring, x, y)).count() % 2 == 1 {
                found = u16::try_from(i).ok();
                break;
            }
        }
        found
    }

    /// The city within `radius` km that `accept` takes and that best names the position, and its distance. A town
    /// beats a bigger city only while it is much nearer, so that the centre of Paris is Paris and not its 4th
    /// arrondissement: the score is population over the cube of the distance plus 5 km.
    fn nearest(&self, at: (f64, f64), radius: f64, accept: impl Fn(&City) -> bool) -> Option<(u32, f64)> {
        let mut best: Option<(u32, f64, f64)> = None;
        for cell in cells_within(at, radius) {
            let (Some(&from), Some(&to)) = (self.cell_start.get(cell), self.cell_start.get(cell.saturating_add(1)))
            else {
                continue;
            };
            let range = usize::try_from(from).unwrap_or(0)..usize::try_from(to).unwrap_or(0);
            for &i in self.by_cell.get(range).unwrap_or_default() {
                let Some(city) = usize::try_from(i).ok().and_then(|i| self.cities.get(i)) else {
                    continue;
                };
                let d = km(at, (city.lat, city.lon));
                let score = f64::from(city.population.max(1000)) / (d + 5.0).powi(3);
                if d <= radius && accept(city) && best.is_none_or(|(_, _, top)| score > top) {
                    best = Some((i, d, score));
                }
            }
        }
        best.map(|(i, d, _)| (i, d))
    }

    /// The country, region and city a position is in.
    pub(super) fn locate(&self, lat: f64, lon: f64) -> Found {
        let country = self.country_at(lat, lon);
        let near = self.nearest((lat, lon), CITY_KM, |c| country.is_none_or(|k| c.country == k));
        if let Some(city) = near.and_then(|(i, _)| Some((i, self.cities.get(i as usize)?))) {
            return Found {
                country: Some(city.1.country),
                region: (city.1.region != NONE).then_some(city.1.region),
                city: Some(city.0),
            };
        }
        let Some(country) = country else {
            return Found::default();
        };
        let region = self
            .nearest((lat, lon), REGION_KM, |c| c.country == country && c.region != NONE)
            .and_then(|(i, _)| self.cities.get(i as usize))
            .map(|c| c.region);
        Found {
            country: Some(country),
            region,
            city: None,
        }
    }

    /// The IANA zone of a position and the country it lies in.
    pub(super) fn zone_at(&self, lat: f64, lon: f64) -> (String, Option<u16>) {
        let country = self.country_at(lat, lon);
        let radii: &[f64] = if country.is_some() {
            &[CITY_KM, REGION_KM, 1000.0, 3000.0]
        } else {
            &[REGION_KM]
        };
        let zone = radii.iter().find_map(|&radius| {
            let (i, _) = self.nearest((lat, lon), radius, |c| country.is_none_or(|k| c.country == k))?;
            self.zones.get(usize::from(self.cities.get(i as usize)?.zone)).cloned()
        });
        (zone.unwrap_or_else(|| nautical(lon)), country)
    }
}

/// The zone of the sea: the hour band of the longitude, as `Etc/GMT-5` is five hours east (the sign of POSIX).
fn nautical(lon: f64) -> String {
    let hours = (lon / 15.0).round().clamp(-12.0, 12.0);
    match hours {
        h if h > 0.0 => format!("Etc/GMT-{h}"),
        h if h < 0.0 => format!("Etc/GMT+{}", -h),
        _ => "Etc/GMT".to_owned(),
    }
}

/// The cells of the one-degree grid that may hold a city within `radius` km of a position.
#[allow(clippy::cast_possible_truncation, clippy::cast_sign_loss)] // small, non-negative, rounded up
fn cells_within(at: (f64, f64), radius: f64) -> impl Iterator<Item = usize> {
    let (row, column) = cell_of(at.0, at.1);
    let rows = (radius / KM_PER_DEGREE).ceil() as usize;
    let reach = (radius / (KM_PER_DEGREE * libm::cos(at.0.to_radians()).max(0.01))).ceil() as usize;
    let columns: Vec<usize> = if reach.saturating_mul(2).saturating_add(3) >= CELL_COLUMNS {
        (0..CELL_COLUMNS).collect()
    } else {
        let first = column
            .saturating_add(CELL_COLUMNS)
            .saturating_sub(reach.saturating_add(1));
        (0..reach.saturating_mul(2).saturating_add(3))
            .map(|k| first.saturating_add(k) % CELL_COLUMNS)
            .collect()
    };
    let last = row
        .saturating_add(rows)
        .saturating_add(1)
        .min(CELL_ROWS.saturating_sub(1));
    (row.saturating_sub(rows.saturating_add(1))..=last).flat_map(move |r| {
        let base = r.saturating_mul(CELL_COLUMNS);
        columns.clone().into_iter().map(move |c| base.saturating_add(c))
    })
}
