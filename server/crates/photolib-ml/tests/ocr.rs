//! PP-OCRv5 on ONNX Runtime reading the pictures of `testdata/ocr/`: Latin, Cyrillic, CJK and a payload of markup.

use std::{
    collections::BTreeMap,
    path::Path,
    time::{Duration, Instant},
};

use photolib_ml::{
    MEMORY, Pool, Verdict,
    ocr::{Rgb, read},
    rss, self_test,
};

fn fixture(name: &str) -> Rgb {
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join(format!("../../../testdata/ocr/{name}.png"));
    let picture = image::open(path).unwrap().to_rgb8();
    Rgb {
        width: picture.width() as usize,
        height: picture.height() as usize,
        pixels: picture.into_raw(),
    }
}

fn expected() -> BTreeMap<String, String> {
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../../testdata/ocr/expected.json");
    serde_json::from_str(&std::fs::read_to_string(path).unwrap()).unwrap()
}

/// The text without its spaces: a recogniser keeps none between Chinese or Japanese characters, as there are none.
fn squeezed(text: &str) -> String {
    text.split_whitespace().collect()
}

/// Longer than any machine that is merely loaded needs for a picture: only a hang or a runaway fails it.
const HANG: Duration = Duration::from_secs(60);

#[test]
fn the_pictures_of_every_script_and_a_payload_are_read_as_they_say() {
    pictures_are_read(Duration::ZERO, 1);
}

/// A machine too loaded to read a picture in 5 s reads the same text.
#[test]
fn a_slow_machine_reads_the_same_text() {
    pictures_are_read(Duration::from_secs(2), 1);
}

/// The budget `ocr-read` of tools/perf/budgets.json: the slowest picture's fastest of three reads, in ms, appended to
/// `PERF_RESULTS` for `tools/perf/perf.py` (advisory on hosted CI, where no test asserts it).
#[test]
#[ignore = "measured by tools/perf/run.sh"]
fn ocr_read() {
    let slowest = pictures_are_read(Duration::ZERO, 3);
    println!("slowest picture: {slowest:?}");
    if let Ok(path) = std::env::var("PERF_RESULTS") {
        let line = serde_json::json!({"budget": "ocr-read", "metric": "slowest", "target": "server",
            "value": (slowest.as_secs_f64() * 1e5).round() / 100.0});
        let mut file = std::fs::OpenOptions::new()
            .create(true)
            .append(true)
            .open(path)
            .unwrap();
        std::io::Write::write_all(&mut file, format!("{line}\n").as_bytes()).unwrap();
    }
}

/// Reads every picture `rounds` times, asserts the text and returns the slowest picture's fastest round.
fn pictures_are_read(delay: Duration, rounds: usize) -> Duration {
    let (library, dir, models) = photolib_ml::testing::ocr();
    let ort = photolib_ml::Ort::load(&library).unwrap();
    let reports = self_test(ort, dir.path(), &models);
    assert_eq!(reports.len(), 4, "{reports:?}");
    for report in &reports {
        let cpu = report.backends.iter().find(|(b, _)| *b == photolib_ml::Backend::Cpu);
        assert!(
            matches!(cpu, Some((_, Verdict::Passed { cosine })) if *cosine > 0.999),
            "{report:?}"
        );
    }
    let pool = Pool::new(ort, dir.path(), &reports, MEMORY, rss);
    let mut infer = |file: &str, input| {
        std::thread::sleep(delay);
        let mut outputs = pool.run(file, &[vec![input]])?;
        outputs.pop().ok_or_else(|| "no output".to_owned())
    };
    let mut slowest = Duration::ZERO;
    for (name, says) in expected() {
        let picture = fixture(&name);
        let mut fastest = Duration::MAX;
        let mut text = String::new();
        for _ in 0..rounds {
            let started = Instant::now();
            text = read(&mut infer, &picture).unwrap();
            fastest = fastest.min(started.elapsed());
        }
        println!("{name}: {text:?} in {fastest:?}");
        assert_eq!(squeezed(&text), squeezed(&says), "{name}");
        assert!(fastest < HANG, "{name} took {fastest:?}, longer than {HANG:?}");
        slowest = slowest.max(fastest);
    }
    slowest
}
