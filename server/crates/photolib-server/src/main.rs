use std::{
    ffi::OsString,
    os::unix::process::CommandExt,
    path::PathBuf,
    process::{Command as Process, ExitCode},
};

use clap::{Parser, Subcommand};
use photolib_models::{REGISTRY, Store, Target};
use photolib_server::{
    auth,
    config::{Config, Outbound},
    doctor, manifest,
    role::Role,
    run::{own_cluster, run},
    upgrade,
};

#[derive(Parser)]
#[command(version, about = "The Photolib server")]
struct Args {
    /// YAML configuration file
    #[arg(long, short, env = "PHOTOLIB_CONFIG")]
    config: Option<PathBuf>,
    /// Roles to run instead of the configured ones: api, scheduler, worker:<class>, ml or all; repeat or separate with commas
    #[arg(long = "role", value_delimiter = ',')]
    roles: Vec<String>,
    #[command(subcommand)]
    command: Option<Command>,
}

#[derive(Subcommand)]
enum Command {
    /// Check the installation: configuration, PostgreSQL, filesystems, markers, stores, proxy headers and client
    /// versions, through the running photolibd when it answers on listen to metrics.token; exits with 1 when a check fails
    Doctor {
        #[command(subcommand)]
        check: Option<Doctor>,
        /// Also write the diagnostics bundle for a bug report (versions, configuration, checks, log tail) here
        #[arg(long)]
        bundle: Option<PathBuf>,
    },
    /// Bring the database schema to this release, as a start does (instance check, pre-upgrade dump, migrations), then
    /// exit; for a pre-upgrade job
    Migrate,
    /// Administer accounts from the host, with the configuration and the database
    Admin {
        #[command(subcommand)]
        action: Admin,
    },
    /// Install ML models into ml.models_dir, by default <data_dir>/models
    Models {
        #[command(subcommand)]
        action: Models,
    },
    /// Replace the database with a dump: by default the newest pre-upgrade dump in <data_dir>/backups. Stop
    /// photolibd first
    Restore { dump: Option<PathBuf> },
    /// Rebuild the database from the newest manifests of the libraries in a store, after it was lost without a dump:
    /// accounts, libraries, assets, their files, tags and albums. Stop photolibd first
    Recover {
        /// The store to read: `local`, the data directory, or one of `stores`
        #[arg(long = "from-storage", value_name = "STORE")]
        from_storage: String,
    },
    /// A sandboxed media child, started by a worker
    #[command(hide = true)]
    MediaChild {
        #[arg(long)]
        policy: String,
        #[arg(last = true)]
        tool: Vec<OsString>,
    },
}

#[derive(Subcommand)]
enum Models {
    /// Download the files of registry models (all of them without ids) that this server runs and that its devices
    /// download from it, checked against their SHA-256
    Fetch { ids: Vec<String> },
    /// Install the models of a bundle, a tar of <id>@<revision> directories, without a network
    Import {
        bundle: PathBuf,
        /// Import bring-your-own models under this licence (an SPDX id); repeat for several
        #[arg(long = "accept-licence", value_name = "SPDX")]
        accepted: Vec<String>,
    },
}

#[derive(Subcommand)]
enum Admin {
    /// Print a password setup token (a link with public_url) for an account, such as the only administrator, whose
    /// owner forgot the password; the old password works until a new one is set
    PasswordSetup { handle: String },
    /// Print a new API key (shown once) for an account, for scripts, `curl` and `photolib upload`
    ApiKey {
        handle: String,
        #[arg(long, default_value = "host")]
        name: String,
        /// view, download, contribute, edit, delete, share, manage_users or manage_server; repeat for several
        #[arg(long = "scope", default_values_t = ["view".to_string(), "download".to_string(), "contribute".to_string()])]
        scopes: Vec<String>,
        #[arg(long, default_value_t = 365)]
        days: u32,
    },
}

#[derive(Subcommand)]
enum Doctor {
    /// Compare the database schema with the one its migrations build; exits with 1 on drift
    Schema,
}

fn main() -> ExitCode {
    let args = Args::parse();
    // Before the runtime starts any thread: the child's sandbox only covers the thread that sets it up.
    if let Some(Command::MediaChild { policy, tool }) = &args.command {
        return photolib_media::child::main(policy, tool);
    }
    let roles = (!args.roles.is_empty()).then_some(args.roles);
    let config = match Config::load(args.config.as_deref(), roles) {
        Ok(config) => config,
        Err(error) => {
            eprintln!("photolibd: the configuration is invalid:\n{error}");
            return ExitCode::from(2);
        }
    };
    // Before any thread: glibc reads these only at a process's start (ADR-0245).
    if args.command.is_none()
        && config.roles.contains(&Role::Ml)
        && std::env::var_os(photolib_ml::MALLOC[0].0).is_none()
    {
        eprintln!(
            "photolibd: cannot restart with glibc's settings for the ml role: {}",
            restart()
        );
        return ExitCode::FAILURE;
    }
    let runtime = tokio::runtime::Runtime::new().expect("the Tokio runtime starts");
    // The server starts the cluster once its log is set up; models need no database.
    let (_cluster, config) = match &args.command {
        None | Some(Command::Models { .. }) => (None, config),
        Some(_) => match runtime.block_on(own_cluster(config)) {
            Ok(owned) => owned,
            Err(error) => {
                eprintln!("photolibd: {error}");
                return ExitCode::FAILURE;
            }
        },
    };
    let result = match args.command {
        None => runtime.block_on(run(config)),
        Some(Command::Doctor { check: None, bundle }) => match runtime.block_on(doctor::cli(config, bundle.as_deref()))
        {
            Ok(true) => Ok(()),
            Ok(false) => return ExitCode::FAILURE,
            Err(error) => Err(error),
        },
        Some(Command::Doctor {
            check: Some(Doctor::Schema),
            ..
        }) => match runtime.block_on(upgrade::doctor_schema(&config)) {
            Ok(drift) if drift.is_empty() => {
                println!("the schema has no drift");
                Ok(())
            }
            Ok(drift) => {
                println!("{}", drift.join("\n"));
                return ExitCode::FAILURE;
            }
            Err(error) => Err(error),
        },
        Some(Command::Migrate) => runtime
            .block_on(upgrade::migrate_only(&config))
            .map(|version| println!("the schema is at {version}")),
        Some(Command::Restore { dump }) => runtime
            .block_on(upgrade::restore(&config, dump.as_deref()))
            .map(|dump| println!("restored {}; start the photolibd release that wrote it", dump.display())),
        Some(Command::Recover { from_storage }) => runtime
            .block_on(manifest::from_storage(&config, &from_storage))
            .map(|recovery| println!("{recovery}start photolibd: it renders every rendition again")),
        Some(Command::Admin { action }) => admin(&config, action, &runtime),
        Some(Command::Models { action }) => models(&config, action, &runtime),
        Some(Command::MediaChild { .. }) => unreachable!("handled before the runtime starts"),
    };
    match result {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("photolibd: {error}");
            ExitCode::FAILURE
        }
    }
}

/// Runs this photolibd again with glibc's settings for ML; returns only when it cannot.
fn restart() -> std::io::Error {
    std::env::current_exe().map_or_else(
        |error| error,
        |photolibd| {
            Process::new(photolibd)
                .args(std::env::args_os().skip(1))
                .envs(photolib_ml::MALLOC)
                .exec()
        },
    )
}

/// The host's own commands: what an operator does with the configuration and the database, signed in as no one.
fn admin(config: &Config, action: Admin, runtime: &tokio::runtime::Runtime) -> Result<(), String> {
    let printed = match action {
        Admin::PasswordSetup { handle } => runtime.block_on(auth::host_password_setup(config, &handle)),
        Admin::ApiKey {
            handle,
            name,
            scopes,
            days,
        } => runtime.block_on(photolib_server::keys::host_api_key(
            config, &handle, &name, &scopes, days,
        )),
    }?;
    println!("{printed}");
    Ok(())
}

fn models(config: &Config, action: Models, runtime: &tokio::runtime::Runtime) -> Result<(), String> {
    let dir = config
        .models_dir()
        .ok_or("data_dir or ml.models_dir: required to install models")?;
    let store = Store::new(dir, &REGISTRY);
    match action {
        Models::Fetch { .. } if config.outbound == Some(Outbound::None) => {
            return Err(
                "outbound: none forbids downloads; install models with `photolibd models import <bundle>`".into(),
            );
        }
        Models::Fetch { ids } => {
            if let Some(id) = ids.iter().find(|id| !REGISTRY.iter().any(|m| &m.id == *id)) {
                return Err(format!(
                    "{id} is not in the registry; bring-your-own models are imported, never downloaded"
                ));
            }
            for model in photolib_models::selected(&REGISTRY, &ids) {
                runtime.block_on(store.fetch(model, &Target::ALL))?;
                println!("fetched {} ({})", model.name(), model.licence.spdx);
            }
        }
        Models::Import { bundle, accepted } => {
            for imported in store.import(&bundle, &accepted)? {
                if let Some(warning) = imported.warning {
                    eprintln!("{warning}");
                }
                println!("imported {}", imported.name);
            }
        }
    }
    Ok(())
}
