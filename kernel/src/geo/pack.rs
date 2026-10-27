//! The places packs (docs/dev/places.md): `places.bin` holds countries with their borders, regions, cities and time
//! zones in English; a `names-<locale>.bin` holds the names that differ from English in one language. Both are
//! checked in full when loaded, so that a damaged pack is refused here and never trusted by a lookup.

use crate::{CallError, reject};
use std::collections::BTreeMap;
use std::ops::Range;

/// A region or time zone a city has none of.
pub(super) const NONE: u16 = u16::MAX;
/// Hundredths of a degree, the unit of the borders.
pub(super) const BORDER_UNIT: f64 = 100.0;
/// 1e-5 degree, the unit of the cities.
const CITY_UNIT: f64 = 100_000.0;

pub(crate) struct Country {
    pub code: [u8; 2],
    name: u32,
    /// West, south, east, north in border units.
    pub bounds: [i16; 4],
    /// The country's rings in `Pack::rings`.
    pub rings: Range<usize>,
}

pub(crate) struct Region {
    pub country: u16,
    name: u32,
    /// The GeoNames admin1 code without its country.
    code: u32,
}

pub(crate) struct City {
    pub lat: f64,
    pub lon: f64,
    pub id: u32,
    pub population: u32,
    name: u32,
    pub country: u16,
    pub region: u16,
    pub zone: u16,
}

/// The kind of place a name belongs to.
#[derive(Clone, Copy)]
pub(super) enum Kind {
    Country,
    Region,
    City,
}

pub(crate) struct Pack {
    pub zones: Vec<String>,
    pub countries: Vec<Country>,
    /// Border vertices as (longitude, latitude) in border units.
    pub rings: Vec<Vec<(i16, i16)>>,
    pub regions: Vec<Region>,
    pub cities: Vec<City>,
    strings: String,
    /// City indexes ordered by one-degree cell; `cell_start` has one more entry than there are cells.
    pub by_cell: Vec<u32>,
    pub cell_start: Vec<u32>,
    names: [BTreeMap<u32, String>; 3],
}

struct Reader<'a>(&'a [u8]);

impl<'a> Reader<'a> {
    fn take(&mut self, n: usize) -> Option<&'a [u8]> {
        let (head, rest) = self.0.split_at_checked(n)?;
        self.0 = rest;
        Some(head)
    }

    fn array<const N: usize>(&mut self) -> Option<[u8; N]> {
        self.take(N)?.try_into().ok()
    }

    fn u16(&mut self) -> Option<u16> {
        self.array().map(u16::from_le_bytes)
    }

    fn i16(&mut self) -> Option<i16> {
        self.array().map(i16::from_le_bytes)
    }

    fn u32(&mut self) -> Option<u32> {
        self.array().map(u32::from_le_bytes)
    }

    fn i32(&mut self) -> Option<i32> {
        self.array().map(i32::from_le_bytes)
    }

    fn len(&mut self) -> Option<usize> {
        usize::try_from(self.u32()?).ok()
    }

    /// A count of items of `size` bytes that the rest of the input can hold, so that nothing is allocated for a lie.
    fn count(&mut self, size: usize) -> Option<usize> {
        let n = self.len()?;
        (n.checked_mul(size)? <= self.0.len()).then_some(n)
    }

    fn varint(&mut self) -> Option<u32> {
        let mut value = 0_u32;
        for shift in (0..35).step_by(7) {
            let byte = *self.take(1)?.first()?;
            value |= u32::from(byte & 0x7F).checked_shl(shift)?;
            if byte < 0x80 {
                return Some(value);
            }
        }
        None
    }
}

fn bad<T>(found: Option<T>) -> Result<T, CallError> {
    found.ok_or_else(|| reject("bad_pack"))
}

impl Pack {
    pub(super) fn load(core: &[u8], names: &[u8]) -> Result<Self, CallError> {
        let mut pack = bad(Self::parse(core))?;
        if !names.is_empty() {
            bad(pack.localise(names))?;
        }
        Ok(pack)
    }

    fn parse(core: &[u8]) -> Option<Self> {
        let mut r = Reader(core);
        if &r.array::<4>()? != b"PLGC" || r.u32()? != 1 {
            return None;
        }
        let (n_countries, n_regions, n_cities, n_zones) = (r.len()?, r.len()?, r.len()?, r.len()?);
        // Every item takes some bytes; the counts cannot exceed what is left.
        if n_countries.max(n_regions).max(n_cities).max(n_zones) > r.0.len() {
            return None;
        }
        let mut zones = Vec::with_capacity(n_zones);
        for _ in 0..n_zones {
            let n = usize::from(*r.take(1)?.first()?);
            zones.push(String::from_utf8(r.take(n)?.to_vec()).ok()?);
        }
        let n_rings = r.count(4)?;
        let mut countries = Vec::with_capacity(n_countries);
        for _ in 0..n_countries {
            let code = r.array()?;
            let name = r.u32()?;
            let bounds = [r.i16()?, r.i16()?, r.i16()?, r.i16()?];
            let first = r.len()?;
            let rings = first..first.checked_add(r.len()?)?;
            if rings.end > n_rings {
                return None;
            }
            countries.push(Country {
                code,
                name,
                bounds,
                rings,
            });
        }
        let mut rings = Vec::with_capacity(n_rings);
        for _ in 0..n_rings {
            let n = r.count(4)?;
            let mut ring = Vec::with_capacity(n);
            for _ in 0..n {
                ring.push((r.i16()?, r.i16()?));
            }
            rings.push(ring);
        }
        let mut regions = Vec::with_capacity(n_regions);
        for _ in 0..n_regions {
            let country = r.u16()?;
            let (name, code) = (r.u32()?, r.u32()?);
            (usize::from(country) < n_countries).then_some(())?;
            regions.push(Region { country, name, code });
        }
        let cities = Self::cities(&mut r, n_cities)?;
        let size = r.len()?;
        let blob = r.take(size)?;
        let strings = String::from_utf8(blob.to_vec()).ok()?;
        let pack = Self {
            zones,
            countries,
            rings,
            regions,
            cities,
            by_cell: Vec::new(),
            cell_start: Vec::new(),
            strings,
            names: Default::default(),
        };
        pack.valid().then(|| pack.indexed())
    }

    /// The cities, whose columns follow one another in the pack.
    fn cities(r: &mut Reader, n: usize) -> Option<Vec<City>> {
        let mut column = |size: usize| Some(Reader(r.take(n.checked_mul(size)?)?));
        let (mut lat, mut lon) = (column(4)?, column(4)?);
        let (mut population, mut id, mut name) = (column(4)?, column(4)?, column(4)?);
        let (mut country, mut region, mut zone) = (column(2)?, column(2)?, column(2)?);
        let mut cities = Vec::with_capacity(n);
        for _ in 0..n {
            cities.push(City {
                lat: f64::from(lat.i32()?) / CITY_UNIT,
                lon: f64::from(lon.i32()?) / CITY_UNIT,
                id: id.u32()?,
                population: population.u32()?,
                name: name.u32()?,
                country: country.u16()?,
                region: region.u16()?,
                zone: zone.u16()?,
            });
        }
        Some(cities)
    }

    /// Whether every reference of the pack lands inside it.
    fn valid(&self) -> bool {
        let text = |offset: u32| self.string(offset).is_some();
        self.countries.iter().all(|c| text(c.name))
            && self.regions.iter().all(|r| text(r.name) && text(r.code))
            && self.cities.iter().all(|c| {
                text(c.name)
                    && usize::from(c.country) < self.countries.len()
                    && (c.region == NONE || usize::from(c.region) < self.regions.len())
                    && usize::from(c.zone) < self.zones.len()
                    && c.lat.abs() <= 90.0
                    && c.lon.abs() <= 180.0
            })
    }

    /// A region's admin1 code, such as `11` of `FR.11`.
    pub(super) fn region_code(&self, index: u16) -> &str {
        self.regions
            .get(usize::from(index))
            .and_then(|r| self.string(r.code))
            .unwrap_or_default()
    }

    fn string(&self, offset: u32) -> Option<&str> {
        let tail = self.strings.get(usize::try_from(offset).ok()?..)?;
        tail.split_once('\0').map(|(text, _)| text)
    }

    /// The one-degree cell of a position, as an index into `cell_start`.
    pub(super) fn cell(lat: f64, lon: f64) -> usize {
        let (row, column) = cell_of(lat, lon);
        row.saturating_mul(CELL_COLUMNS).saturating_add(column)
    }

    fn indexed(mut self) -> Self {
        let cells = CELL_ROWS.saturating_mul(CELL_COLUMNS);
        let mut order: Vec<(usize, u32)> = (0_u32..)
            .zip(&self.cities)
            .map(|(i, c)| (Self::cell(c.lat, c.lon), i))
            .collect();
        order.sort_unstable();
        let mut start = vec![0_u32; cells.saturating_add(1)];
        for &(cell, _) in &order {
            if let Some(slot) = start.get_mut(cell.saturating_add(1)) {
                *slot = slot.saturating_add(1);
            }
        }
        let mut total = 0_u32;
        for slot in &mut start {
            total = total.saturating_add(*slot);
            *slot = total;
        }
        self.by_cell = order.into_iter().map(|(_, i)| i).collect();
        self.cell_start = start;
        self
    }

    /// Replaces names with those of a `names-<locale>.bin`; `None` when it is damaged.
    fn localise(&mut self, bytes: &[u8]) -> Option<()> {
        let mut r = Reader(bytes);
        if &r.array::<4>()? != b"PLGN" || r.u32()? != 1 {
            return None;
        }
        let limits = [self.countries.len(), self.regions.len(), self.cities.len()];
        let mut names: [BTreeMap<u32, String>; 3] = Default::default();
        for (map, limit) in names.iter_mut().zip(limits) {
            let count = r.len()?;
            let size = r.len()?;
            let mut section = Reader(r.take(size)?);
            let mut index = 0_u32;
            for _ in 0..count {
                index = index.checked_add(section.varint()?)?;
                let size = usize::try_from(section.varint()?).ok()?;
                let text = section.take(size)?;
                (usize::try_from(index).ok()? < limit).then_some(())?;
                map.insert(index, String::from_utf8(text.to_vec()).ok()?);
            }
            section.0.is_empty().then_some(())?;
        }
        r.0.is_empty().then_some(())?;
        self.names = names;
        Some(())
    }

    /// The name of a place in the pack's language, else in English.
    pub(super) fn name(&self, kind: Kind, index: usize) -> String {
        let (slot, offset) = match kind {
            Kind::Country => (0, self.countries.get(index).map(|c| c.name)),
            Kind::Region => (1, self.regions.get(index).map(|r| r.name)),
            Kind::City => (2, self.cities.get(index).map(|c| c.name)),
        };
        u32::try_from(index)
            .ok()
            .and_then(|i| self.names.get(slot)?.get(&i).cloned())
            .or_else(|| self.string(offset?).map(str::to_owned))
            .unwrap_or_default()
    }
}

/// Rows (south to north) and columns (west to east) of the one-degree grid of cities.
pub(super) const CELL_ROWS: usize = 181;
pub(super) const CELL_COLUMNS: usize = 360;

/// The grid row and column of a position, clamped to the grid.
#[allow(clippy::cast_possible_truncation, clippy::cast_sign_loss)] // clamped to 0..=180 and wrapped to 0..360 first
pub(super) fn cell_of(lat: f64, lon: f64) -> (usize, usize) {
    (
        (lat + 90.0).floor().clamp(0.0, 180.0) as usize,
        (lon + 180.0).floor().rem_euclid(360.0) as usize,
    )
}
