# Monitoring

`photolibd` opens one port, `listen`, and serves Prometheus metrics there at `/metrics` to clients that send
`Authorization: Bearer` with [`metrics.token`](configuration.md#settings); without that setting there is no `/metrics`,
so publishing the API never publishes them. The [reverse-proxy templates](reverse-proxy.md) refuse `/metrics` and
`/diagnostics` with `403`, so Prometheus scrapes photolibd directly on the internal network. Every process reports its
requests, one with a database also whether it can read it, its jobs, integrity findings and device backups, one running
the scheduler the sync watermark lag, and one with a data directory its storage and dumps. The choices behind this page
are [ADR-0046](../adr/0046-observability.md).

| Metric | Labels | Meaning |
|---|---|---|
| `photolib_http_request_duration_seconds` | `route`, `status` | Histogram of request durations by route pattern or Connect procedure; other paths share `route="unmatched"`. |
| `photolib_database_up` | | 1 when this scrape read the database, 0 when it failed or took over 2 s. |
| `photolib_jobs` | `type`, `status` | Queued, running and dead jobs; a type with any of them has all three statuses, zeros included. |
| `photolib_jobs_oldest_age_seconds` | `type`, `status` | Seconds since the oldest of those jobs was created. |
| `photolib_sync_watermark_lag_seconds` | | How long changes have waited for a transaction that holds back sync, sampled every 15 s; a transaction left open delays nothing until a later one ends; `NaN` while the database cannot be read. |
| `photolib_storage_size_bytes`, `photolib_storage_free_bytes` | `dir` | The filesystem of `data_dir`, `work_dir` and `database.data_dir`; free is what `photolibd` may still use. |
| `photolib_backup_last_timestamp_seconds` | | When the newest database dump in `<data_dir>/backups`, or the newest [scheduled backup](backups.md) in any store, was written, in Unix time; 0 without one. |
| `photolib_integrity_findings` | `kind` | Open [integrity findings](console.md#integrity-and-backups): `content`, `missing`, `size`, `hash`, `orphan`. |
| `photolib_scrub_cycle_end_timestamp_seconds` | `store` | When the scrub last went through every original of the store, in Unix time. |
| `photolib_device_backup_silent`, `photolib_device_backup_pending`, `photolib_device_last_seen_timestamp_seconds` | `device`, `name`, `user` | For each device that reports its backup: 1 once it has been silent for longer than the policy's hours, the items it had left at its last report, and its last request. |
| `photolib_ml_backend_disabled` | `node`, `file`, `backend` | 1 for each backend an ML node's [self-test](models.md#running-models) disabled for a model file, on the node and on the API it reports to. |
| `photolib_restore_drill_last_success_timestamp_seconds` | | When the newest [restore drill](backups.md#restore-drills) that passed ended, in Unix time; 0 without one. |

## Prometheus and Grafana

[`deploy/observability`][bundle] runs Prometheus with the example alerts and Grafana with the Photolib dashboard on
the host network, next to `photolibd`, both listening on loopback only:

```sh
cd deploy/observability
echo "GRAFANA_ADMIN_PASSWORD=$(openssl rand -hex 16)" > .env
echo "METRICS_TOKEN=$(openssl rand -hex 32)" >> .env
docker compose up -d
```

and give `photolibd` the same `METRICS_TOKEN` as `metrics.token`.

Grafana is at `http://127.0.0.1:3000` (user `admin`) and Prometheus at `http://127.0.0.1:9090`. Grafana's usage
reports, update checks, news feed and Gravatar are off. For another `listen`, change the target in
`prometheus.yml`.

## Alerts

`alerts.yml` holds examples to route through your Alertmanager; `alerts.test.yml` shows each of them firing
(`bash tools/promtool.sh test rules deploy/observability/alerts.test.yml`).

| Alert | Fires when |
|---|---|
| `PhotolibDown` | Prometheus cannot scrape `photolibd` for 5 minutes. |
| `PhotolibDatabaseUnreachable` | `photolibd` answers but cannot read its database for 5 minutes. |
| `PhotolibBackupTooOld` | The newest database dump is over 48 hours old, or there is none. |
| `PhotolibRestoreDrillFailing` | No restore drill has passed for 48 hours: the backups may not restore. |
| `PhotolibJobsDeadLettered` | A job type has more dead jobs than an hour ago. |
| `PhotolibDiskAlmostFull` | A directory's filesystem has been over 90% full for 10 minutes. |
| `PhotolibSyncWatermarkLag` | A transaction has held back sync for more than 5 minutes. |
| `PhotolibIntegrityFindings` | An integrity finding is open. |
| `PhotolibDeviceBackupSilent` | A device has not reported its backup for longer than the admin console's policy (48 hours by default); it names the device, its last seen time and what it had left. |
| `PhotolibMlBackendDisabled` | An ML node's self-test disabled an accelerator for a model; it names the node, the backend and the model file. |

## Traces

With [`traces.otlp_endpoint`](configuration.md#settings) set, `photolibd` also sends its spans over OTLP/HTTP to that
OpenTelemetry collector. Unset, the default, nothing leaves the process.

[bundle]: https://github.com/arxiflex-dev/photolib/tree/main/deploy/observability
