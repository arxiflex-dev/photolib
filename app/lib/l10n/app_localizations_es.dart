// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get actionAddToAlbum => 'Añadir al álbum';

  @override
  String get actionArchive => 'Archivar';

  @override
  String get actionCopyTo => 'Copiar a…';

  @override
  String get actionDeleteForever => 'Eliminar para siempre';

  @override
  String get actionFavourite => 'Añadir a favoritos';

  @override
  String get actionHide => 'Ocultar';

  @override
  String get actionMoveTo => 'Mover a…';

  @override
  String get actionRename => 'Cambiar nombre';

  @override
  String get actionRestore => 'Restaurar';

  @override
  String get actionShare => 'Compartir';

  @override
  String get actionTrash => 'Mover a la papelera';

  @override
  String get actionUnarchive => 'Desarchivar';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionUnfavourite => 'Quitar de favoritos';

  @override
  String get actionUnhide => 'Mostrar';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Activa',
      'disabled': 'Desactivada',
      'invited': 'Invitada',
      'deleted': 'Eliminada',
      'other': 'Desconocida',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Cuentas';

  @override
  String get adminAddAccount => 'Añadir cuenta';

  @override
  String get adminAddExternalLibrary => 'Añadir una biblioteca externa';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts intentos',
      many: '$attempts de intentos',
      one: '1 intento',
      zero: 'aún sin ejecutar',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Registro de auditoría';

  @override
  String get adminBackUpNow => 'Hacer copia ahora';

  @override
  String get adminBackupQueued =>
      'La copia está en cola; le sigue un simulacro de restauración';

  @override
  String get adminBackups => 'Copias de seguridad de la base de datos';

  @override
  String get adminCancelJob => 'Cancelar tarea';

  @override
  String get adminCapabilities => 'Funciones';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Bibliotecas gestionadas',
      'uploads': 'Subidas desde dispositivos, la web y la CLI',
      'folder_browser': 'Explorador de carpetas',
      'device_folders': 'Carpetas del dispositivo en apps conectadas',
      'sharing': 'Compartir y enlaces públicos',
      'edits': 'Ediciones',
      'deletes': 'Eliminaciones',
      'xmp_writes': 'Escritura de archivos XMP',
      'face_recognition': 'Reconocimiento facial',
      'ml_search': 'Búsqueda inteligente',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Advertencia',
      'fail': 'Error',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Copiado';

  @override
  String get adminCopyBundle =>
      'Copiar el diagnóstico para un informe de errores';

  @override
  String get adminCopyLink => 'Copiar enlace';

  @override
  String get adminDelete => 'Eliminar';

  @override
  String get adminDeviceBackups => 'Copias de los dispositivos';

  @override
  String get adminDevices => 'Tus dispositivos';

  @override
  String get adminDisable => 'Desactivar';

  @override
  String adminDrillFailed(String detail) {
    return 'El último simulacro de restauración falló: $detail';
  }

  @override
  String get adminEdit => 'Editar';

  @override
  String get adminEmail => 'Correo electrónico';

  @override
  String get adminEnable => 'Activar';

  @override
  String get adminErrorSignIn => 'Inicia sesión como administrador';

  @override
  String get adminFacesDefault =>
      'El reconocimiento facial se activa de forma predeterminada en las cuentas nuevas';

  @override
  String get adminFiles => 'Archivos por tipo';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Dañado',
      'missing': 'Falta',
      'size': 'Tamaño incorrecto',
      'hash': 'Reemplazado',
      'orphan': 'Archivo suelto',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size libres';
  }

  @override
  String get adminFreeDisk =>
      'Pausar las subidas por debajo de este porcentaje de disco libre, de 0 a 50';

  @override
  String get adminFreeDiskGb =>
      'o por debajo de este espacio libre en GB, si es menor, de 0 a 100000';

  @override
  String get adminHandle => 'Nombre de usuario';

  @override
  String get adminIntegrity => 'Integridad';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos',
      many: '$countString de elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'En cola',
      'running': 'En ejecución',
      'done': 'Completada',
      'dead': 'Fallida',
      'cancelled': 'Cancelada',
      'other': 'Todas',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Tipo de tarea, como render';

  @override
  String get adminJobs => 'Tareas';

  @override
  String adminLastSeen(String time) {
    return 'Visto por última vez $time';
  }

  @override
  String get adminLibraries => 'Bibliotecas';

  @override
  String get adminLibraryOwner => 'Propietario';

  @override
  String get adminLibraryRoot => 'Carpeta del servidor, como /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'En línea',
      'offline': 'Sin conexión',
      'scanning': 'Analizando',
      'error': 'Error',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Registro del servidor';

  @override
  String get adminName => 'Nombre';

  @override
  String get adminNothing => 'Aún no hay nada';

  @override
  String get adminOutOfRange => 'Fuera de rango';

  @override
  String get adminOverview => 'Resumen';

  @override
  String get adminPair => 'Vincular un dispositivo';

  @override
  String get adminPairBody =>
      'Escanea este código o envía el enlace y pégalo en Añadir un servidor de Photolib en el nuevo dispositivo: lleva todas las direcciones de este servidor y su certificado, para que nadie tenga que escribirlos.';

  @override
  String get adminPasswordSetup => 'Enlace para crear contraseña';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Envía este enlace a $name por cualquier medio o deja que escanee el código. Sirve para crear una contraseña una sola vez, hasta el $date.';
  }

  @override
  String get adminPause => 'Pausar un tipo de tarea';

  @override
  String adminPauseMinutes(int max) {
    return 'Minutos, de 1 a $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type está en pausa hasta el $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos pendientes de copiar',
      many: '$countString de elementos pendientes de copiar',
      one: '1 elemento pendiente de copiar',
      zero: 'Nada pendiente de copiar',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Políticas';

  @override
  String get adminPolicyReset => 'Usar el valor del nivel superior';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Activado de forma predeterminada',
      'server': 'Definido para el servidor',
      'user': 'Definido para esta cuenta',
      'library': 'Definido para esta biblioteca',
      'config': 'Definido en la configuración',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Aplicar un ajuste predefinido';

  @override
  String get adminPresetBody =>
      'Un ajuste predefinido establece cada función para el servidor y borra lo que definieron las cuentas y las bibliotecas. Todo sigue siendo editable.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Visor de archivo',
      'family_backup': 'Copia familiar',
      'personal': 'Personal',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Las bibliotecas externas de solo lectura son la única fuente de verdad: sin subidas, bibliotecas gestionadas, carpetas del dispositivo, ediciones, eliminaciones ni escritura XMP',
      'family_backup': 'Todo activado salvo la escritura XMP',
      'personal': 'Todo activado salvo compartir y los enlaces públicos',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Código QR del enlace';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tareas en cola',
      many: '$countString de tareas en cola',
      one: '1 tarea en cola',
      zero: 'Nada que hacer',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Cuota de almacenamiento en GB; déjalo en blanco para no tener límite';

  @override
  String get adminRemote => 'Acceso remoto';

  @override
  String get adminRemoteBody =>
      'Llega al servidor desde cualquier lugar sin abrir un puerto en tu router. Elige una forma; cada una le da una dirección HTTPS para añadir a las apps. Luego pruébala desde fuera.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared se conecta hacia fuera con Cloudflare, que sirve tu dominio por HTTPS. El plan gratuito limita cada petición a 100 MB, algo que las copias nunca alcanzan: envían 8 MiB cada vez.';

  @override
  String get adminRemoteNoAddress =>
      'Añade a esta app la dirección https:// del servidor para probarla desde fuera.';

  @override
  String get adminRemoteReachable => 'Accesible desde fuera.';

  @override
  String get adminRemoteTailscale =>
      'Instala Tailscale en el equipo del servidor y en cada dispositivo, en la misma tailnet o en tu Headscale; luego ejecuta esto en el equipo del servidor y pon en public_url la dirección que muestra.';

  @override
  String get adminRemoteTest => 'Probar desde fuera';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host abrirá $url desde sus servidores en todo el mundo, y así conocerá esta dirección. ¿Continuar?';
  }

  @override
  String get adminRemoteUnreachable =>
      'No es accesible desde fuera: revisa la forma que elegiste y vuelve a probar.';

  @override
  String get adminRemoteWireguard =>
      'Necesita un puerto UDP abierto del lado del servidor o en un nodo central. Esta es la configuración de un dispositivo; crea las claves con wg genkey.';

  @override
  String get adminRepair =>
      'Restáuralo desde una copia de seguridad o desde un dispositivo que aún lo tenga';

  @override
  String get adminRepairOrphan =>
      'Ninguna foto lo nombra: revísalo y luego bórralo o consérvalo';

  @override
  String get adminReprocess => 'Reprocesar';

  @override
  String get adminReprocessFaces => 'Volver a detectar caras';

  @override
  String get adminReprocessFolder =>
      'Carpeta, como 2024/05; déjalo en blanco para toda la biblioteca';

  @override
  String get adminReprocessMetadata => 'Volver a leer los metadatos';

  @override
  String get adminReprocessRenditions =>
      'Regenerar miniaturas y vistas previas';

  @override
  String get adminRestore => 'Restaurar';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'La restauración de $name falló: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Aún no ha superado ningún simulacro de restauración';

  @override
  String adminRestoreVerified(String when) {
    return 'Última restauración verificada: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd se detiene y, al volver a arrancar, sustituye toda la base de datos por $name. Lo que cambió desde esa copia se pierde y todos los dispositivos se sincronizan desde cero.';
  }

  @override
  String get adminRestoring =>
      'photolibd se está deteniendo para restaurar la copia';

  @override
  String get adminResume => 'Reanudar';

  @override
  String get adminRetry => 'Reintentar';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrador',
      'user': 'Usuario',
      'viewer': 'Lector',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Guardado';

  @override
  String get adminScan => 'Analizar ahora';

  @override
  String get adminScrubDays =>
      'Días para que la verificación revise cada original, de 1 a 3650';

  @override
  String get adminScrubNever => 'Primera verificación completa en curso';

  @override
  String adminScrubbed(String time) {
    return 'Última verificación completa $time';
  }

  @override
  String get adminSecondAdmin =>
      'Haz administradora a una segunda persona, para que otra pueda gestionar y restaurar el servidor si tú no puedes.';

  @override
  String adminSilent(String time) {
    return 'En silencio desde $time';
  }

  @override
  String get adminSilentHours =>
      'Horas sin informe hasta que la copia de un dispositivo se considera en silencio, de 1 a 8760';

  @override
  String get adminStores => 'Almacenamiento';

  @override
  String get adminThisDevice => 'Este dispositivo';

  @override
  String get adminTitle => 'Administración del servidor';

  @override
  String get adminTrashDays => 'Días en la papelera, de 1 a 3650';

  @override
  String get adminTwoFactor =>
      'Todas las cuentas deben configurar un segundo factor de autenticación';

  @override
  String get adminUsage => 'Uso por cuenta';

  @override
  String get albumCover => 'Usar como portada';

  @override
  String get albumEmpty => 'Este álbum está vacío';

  @override
  String get albumHideMemories => 'Ocultar de los recuerdos';

  @override
  String get albumHideTimeline => 'Ocultar de la cronología';

  @override
  String get albumNew => 'Nuevo álbum';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Cualquier fecha';

  @override
  String get backupCap => 'Elemento más grande';

  @override
  String get backupCharging => 'Solo mientras se carga';

  @override
  String backupCompleted(String time) {
    return 'Última copia completa: $time';
  }

  @override
  String backupContact(String time) {
    return 'Último contacto con el servidor: $time';
  }

  @override
  String get backupEnabled => 'Hacer copia de seguridad de este dispositivo';

  @override
  String get backupFolderNo => 'Esta no';

  @override
  String get backupFolderYes => 'Hacer copia';

  @override
  String backupHours(int count) {
    return '$count h';
  }

  @override
  String get backupMetered =>
      'En redes de uso medido, como datos móviles o un punto de acceso';

  @override
  String get backupNever => 'Aún no hay una copia completa';

  @override
  String backupNewFolder(String name) {
    return 'Carpeta nueva $name: ¿hacer copia?';
  }

  @override
  String get backupNoLimit => 'Sin límite';

  @override
  String get backupNothing => 'No hay nada pendiente';

  @override
  String get backupNow => 'Hacer copia ahora';

  @override
  String backupOverdue(int hours, String items) {
    return 'Ninguna copia completa en $hours h. Pendientes: $items';
  }

  @override
  String get backupOverdueTitle => 'La copia de seguridad no se ha completado';

  @override
  String backupPending(String items) {
    return 'Pendientes: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Se reintentará: $time';
  }

  @override
  String get backupRoaming => 'Hacer copia en itinerancia';

  @override
  String get backupSignIn =>
      'Inicia sesión en un servidor para hacer copias de este dispositivo';

  @override
  String get backupSignedOut =>
      'La copia se detuvo: el servidor cerró la sesión de este dispositivo. Vuelve a iniciar sesión en Configuración.';

  @override
  String get backupSince => 'Tomadas desde';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'La copia espera a que el servidor esté accesible',
      'charging': 'La copia espera a que el dispositivo se cargue',
      'battery_low': 'La copia espera: la batería está baja',
      'roaming': 'La copia espera mientras haya itinerancia',
      'quota':
          'La copia se detuvo: tu almacenamiento en el servidor está lleno',
      'second_factor': 'La copia se detuvo: el servidor pide un segundo factor para esta cuenta',
      'other': 'La copia se detuvo: el servidor respondió $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Copia de seguridad';

  @override
  String get backupWaiting => 'Sin copia';

  @override
  String get backupWarnAfter => 'Avisar si no se completa en';

  @override
  String get backupWhat => 'Qué copiar';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'En una carpeta que no elegiste',
      'folder_new': 'En una carpeta nueva: elige si hacer copia',
      'type_excluded': 'Un tipo de elemento que no elegiste',
      'before_date': 'Tomado antes de la fecha que elegiste',
      'selected': 'Esperando su turno',
      'server_restored':
          'El servidor lo perdió en una restauración: se envía de nuevo',
      'working': 'Copiándose',
      'waiting_for_icloud': 'Esperando a que iCloud lo descargue',
      'metered': 'Esperando una red sin uso medido',
      'metered_cap': 'Demasiado grande para una red de uso medido',
      'unreadable': 'Este dispositivo no puede leerlo',
      'changed': 'Cambió mientras se enviaba',
      'quota': 'Tu almacenamiento en el servidor está lleno',
      'other': 'El servidor lo rechazó: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'El servidor ya no funciona con esta versión de Photolib.';

  @override
  String get checkAppTooOldNext => 'Actualiza Photolib.';

  @override
  String get checkChanged =>
      'El certificado del servidor no es el que aceptaste.';

  @override
  String get checkChangedNext =>
      'Si tu administrador lo reemplazó, confía en el nuevo. Si no, alguien podría estar escuchando: no continúes.';

  @override
  String get checkClock =>
      'El reloj de este dispositivo y el del servidor difieren en más de cinco minutos.';

  @override
  String get checkClockNext =>
      'Deja que tu dispositivo ajuste la fecha y la hora automáticamente.';

  @override
  String get checkDnsFailed =>
      'El nombre del servidor no lleva a ninguna dirección.';

  @override
  String get checkDnsFailedNext =>
      'Revisa la dirección o conéctate a la red del servidor.';

  @override
  String checkExpired(String date) {
    return 'El certificado del servidor caducó el $date.';
  }

  @override
  String get checkFailed => 'Falló';

  @override
  String get checkMetered =>
      'Estás en una red de uso medido, como los datos móviles.';

  @override
  String get checkMeteredNext =>
      'Conéctate a una Wi-Fi antes de copias grandes.';

  @override
  String get checkNotPhotolib =>
      'Responde algo que no es Photolib, como la página de error de un proxy o una página de acceso a Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Inicia sesión en la Wi-Fi desde tu navegador o pide a tu administrador que revise el proxy.';

  @override
  String get checkOtherServer =>
      'En esta dirección responde otro servidor de Photolib.';

  @override
  String get checkPassed => 'Correcto';

  @override
  String get checkRefused => 'Nada responde en esta dirección.';

  @override
  String get checkRefusedNext =>
      'Comprueba que el servidor esté en marcha y que estés en su red o VPN.';

  @override
  String get checkRun => 'Comprobar la conexión';

  @override
  String get checkRunning => 'Comprobando';

  @override
  String get checkSelfSigned =>
      'El servidor usa un certificado propio que este dispositivo aún no conoce.';

  @override
  String get checkSkipped => 'No comprobado';

  @override
  String get checkStepAuth => 'Tu inicio de sesión';

  @override
  String get checkStepClock => 'El reloj de tu dispositivo';

  @override
  String get checkStepDns => 'Encontrar la dirección del servidor';

  @override
  String get checkStepNetwork => 'Tu red';

  @override
  String get checkStepServer => 'Photolib en el servidor';

  @override
  String get checkStepTcp => 'Llegar al servidor';

  @override
  String get checkStepTls => 'Conexión segura y certificado';

  @override
  String get checkStepUpload => 'Subidas grandes a través de proxies';

  @override
  String get checkTimedOut => 'El servidor tarda demasiado en responder.';

  @override
  String get checkTimedOutNext => 'Revisa tu conexión y vuelve a intentarlo.';

  @override
  String get checkTitle => 'Comprobación de conexión';

  @override
  String get checkTlsFailed => 'La conexión segura falló.';

  @override
  String get checkTrustNext =>
      'Confía en él solo si su huella coincide con la de tu servidor.';

  @override
  String get checkUntrusted =>
      'El certificado del servidor viene de una autoridad en la que este dispositivo no confía.';

  @override
  String get checkUploadCap =>
      'Un proxy en el camino rechaza subidas grandes, así que las copias van más lentas, en trozos pequeños.';

  @override
  String get checkUploadCapNext =>
      'Pide a tu administrador que deje pasar peticiones de 64 MB por el proxy.';

  @override
  String get collectionAlbums => 'Álbumes';

  @override
  String collectionHide(String name) {
    return 'Ocultar $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Mover $name hacia abajo';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Mover $name hacia arriba';
  }

  @override
  String get collectionPeople => 'Personas';

  @override
  String collectionPin(String name) {
    return 'Fijar $name';
  }

  @override
  String get collectionPlaces => 'Lugares';

  @override
  String collectionShow(String name) {
    return 'Mostrar $name';
  }

  @override
  String get collectionTags => 'Etiquetas';

  @override
  String collectionUnpin(String name) {
    return 'Dejar de fijar $name';
  }

  @override
  String get collectionsCustomise => 'Personalizar';

  @override
  String get collectionsDone => 'Listo';

  @override
  String get commandPalette => 'Paleta de comandos';

  @override
  String get commandPaletteHint => 'Escribe un comando';

  @override
  String get dateFormatDefault => 'Predeterminado del idioma';

  @override
  String get dateFormatDmy => 'Día-mes-año';

  @override
  String get dateFormatMdy => 'Mes-día-año';

  @override
  String get dateFormatYmd => 'Año-mes-día';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString en este dispositivo y con copia de seguridad',
      many: '$countString en este dispositivo y con copia de seguridad',
      one: '$countString en este dispositivo y con copia de seguridad',
    );
    return '$_temp0';
  }

  @override
  String deleteDevice(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString solo en este dispositivo, sin copia de seguridad',
      many: '$countString solo en este dispositivo, sin copia de seguridad',
      one: '$countString solo en este dispositivo, sin copia de seguridad',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Con Fotos en iCloud activado, lo que elimines de este dispositivo también desaparece de iCloud y de tus otros dispositivos Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString solo en tu biblioteca',
      many: '$countString solo en tu biblioteca',
      one: '$countString solo en tu biblioteca',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Quitar de este dispositivo';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Los $countString elementos con copia de seguridad; tu biblioteca los conserva',
      many:
          'Los $countString de elementos con copia de seguridad; tu biblioteca los conserva',
      one: 'El elemento con copia de seguridad; tu biblioteca lo conserva',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Las copias de este dispositivo van a su papelera: el espacio se recupera cuando se vacía.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Eliminar $countString elementos?',
      many: '¿Eliminar $countString de elementos?',
      one: '¿Eliminar $countString elemento?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'De este dispositivo y de tu biblioteca',
      'device': 'Solo de este dispositivo',
      'other': 'De tu biblioteca',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'No disponible';

  @override
  String get deviceFolderCard => 'Tarjeta SD';

  @override
  String get deviceFolderExclude => 'Excluir';

  @override
  String get deviceFolderExcludeThis => 'Excluir esta carpeta';

  @override
  String get deviceFolderExcludedNotice =>
      'La carpeta de este elemento está excluida de tu biblioteca';

  @override
  String get deviceFolderForget => 'Quitar de la lista';

  @override
  String get deviceFolderInternal => 'Almacenamiento interno';

  @override
  String get deviceFolderKeep => 'Mantener';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, es nueva';
  }

  @override
  String get deviceFolders => 'Carpetas del dispositivo';

  @override
  String get deviceFoldersAll =>
      'Mostrar todas las carpetas excepto las excluidas';

  @override
  String get deviceFoldersChosen => 'Mostrar solo las carpetas elegidas';

  @override
  String get deviceFoldersExcludedNow => 'Excluida de la biblioteca';

  @override
  String get deviceFoldersSearch => 'Buscar carpetas';

  @override
  String get diagnosticsAdvanced => 'Mostrar diagnóstico';

  @override
  String get diagnosticsAllLoggers => 'Todos los registradores';

  @override
  String get diagnosticsCopied => 'Registro copiado';

  @override
  String get diagnosticsCopy => 'Copiar el registro mostrado';

  @override
  String get diagnosticsEmpty => 'Aún no hay entradas en el registro';

  @override
  String get diagnosticsExport => 'Exportar paquete de diagnóstico';

  @override
  String get diagnosticsExported => 'Paquete de diagnóstico guardado';

  @override
  String get diagnosticsLevel => 'Nivel';

  @override
  String get diagnosticsLogger => 'Registrador';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get download => 'Descargar';

  @override
  String get downloadCurrent => 'Versión actual, con sus ediciones';

  @override
  String get downloadFailed => 'No se pudo descargar';

  @override
  String get downloadOriginal => 'Original';

  @override
  String downloadSaved(String name) {
    return 'Se guardó $name';
  }

  @override
  String get downloadVersion => '¿Qué versión?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargando $countString elementos',
      many: 'Descargando $countString de elementos',
      one: 'Descargando $countString elemento',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Mejora automática';

  @override
  String get editorCrop => 'Recortar';

  @override
  String get editorCropOriginal => 'Original';

  @override
  String get editorCropSquare => 'Cuadrado';

  @override
  String get editorEdit => 'Editar';

  @override
  String get editorFlip => 'Voltear';

  @override
  String get editorRotate => 'Girar';

  @override
  String get editorSaveCopy => 'Guardar copia';

  @override
  String get editorSaveFailed => 'No se pudo guardar la copia';

  @override
  String get editorSaveVersion => 'Guardar';

  @override
  String get editorSaved => 'Guardada como copia';

  @override
  String get editorVersionFailed => 'No se pudo guardar la versión';

  @override
  String get editorVersionSaved => 'Guardado como versión nueva';

  @override
  String get editorVersionsUnsupported =>
      'Este servidor aún no puede guardar versiones de fotos editadas';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se deshicieron $countString cambios: el servidor los rechazó.',
      many: 'Se deshicieron $countString de cambios: el servidor los rechazó.',
      one: 'Se deshizo 1 cambio: el servidor lo rechazó.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Cerrar';

  @override
  String get editsRejectedForbidden =>
      'Puedes ver los elementos, pero no cambiarlos.';

  @override
  String get editsRejectedInvalid => 'El servidor no pudo aceptar los cambios.';

  @override
  String get editsRejectedNotFound =>
      'Los elementos se eliminaron o ya no se comparten contigo.';

  @override
  String get errorNotFound => 'Esta página no existe';

  @override
  String get errorRetry => 'Volver a intentar';

  @override
  String get errorTitle => 'Algo salió mal';

  @override
  String faceNumber(int number) {
    return 'Cara $number';
  }

  @override
  String get facesAgree => 'Acepto';

  @override
  String get facesAura => 'Describir caras con AuraFace (descarga mayor)';

  @override
  String get facesNotNow => 'Ahora no';

  @override
  String get facesNoticeKeep =>
      'Lo que se encuentra se queda con tus fotos, en tus dispositivos y tu servidor. Las descripciones nunca se muestran ni se comparten, y todo se elimina cuando lo dejas o borras la foto.';

  @override
  String get facesNoticeOptional =>
      'Es opcional. Todo lo demás de Photolib funciona sin esto y puedes dejarlo cuando quieras en Ajustes.';

  @override
  String get facesNoticeTitle => '¿Buscar caras en tus fotos?';

  @override
  String get facesNoticeWhat =>
      'Photolib busca caras en tus fotos y vídeos y guarda, de cada una, dónde está y una lista de números que la describe, para poder reconocer de nuevo a la misma persona. Esa descripción puede considerarse un dato biométrico.';

  @override
  String get facesNoticeWhere =>
      'Esto ocurre en este dispositivo y, si has iniciado sesión, en tu propio servidor. Nunca en un servicio nuestro ni de nadie más.';

  @override
  String get facesServerFailed =>
      'No se pudo avisar a tu servidor. Inténtalo de nuevo.';

  @override
  String get facesServerOff => 'Tu servidor no busca caras por ti';

  @override
  String get facesServerOn => 'Tu servidor busca caras por ti';

  @override
  String get facesServerUnavailable =>
      'Tu servidor no ofrece reconocimiento facial';

  @override
  String facesStatusDownloading(int percent) {
    return 'Descargando los modelos de caras: $percent %';
  }

  @override
  String get facesStatusMissing =>
      'Tu servidor no ha instalado los modelos de caras';

  @override
  String get facesStatusNoDecoder =>
      'La búsqueda de caras no está disponible: no se encontró la biblioteca de imágenes (libvips). Reinstala Photolib o instala libvips y reiníciala.';

  @override
  String get facesStatusRunning => 'Buscando caras en este dispositivo';

  @override
  String get facesStatusUnavailable =>
      'No se pueden buscar caras en este dispositivo';

  @override
  String get facesStatusWaiting =>
      'Los modelos de caras se descargan con Wi-Fi';

  @override
  String get facesSwitch => 'Buscar caras en mis fotos';

  @override
  String get facesSwitchOff =>
      'Desactivado. No se calcula nada sobre caras hasta que aceptes.';

  @override
  String get facesSwitchOn =>
      'Activado. Photolib busca las caras de tus fotos.';

  @override
  String get facesTitle => 'Caras y personas';

  @override
  String get facesWithdraw => 'Eliminar y dejar';

  @override
  String get facesWithdrawBody =>
      'Se eliminan todas las caras, descripciones y personas que Photolib encontró para ti, en este dispositivo y en tu servidor. Tus fotos no cambian.';

  @override
  String get facesWithdrawTitle => '¿Dejar de buscar caras?';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': 'kB',
      'MB': 'MB',
      'GB': 'GB',
      'TB': 'TB',
      'other': 'B',
    });
    return '$sizeString $_temp0';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Archivos sin cambiar: $countString';
  }

  @override
  String get folderAllow => 'Permitir el acceso a esta carpeta';

  @override
  String get folderDelete => 'Eliminar carpeta';

  @override
  String folderDeleteBody(String name) {
    return '¿Mover las fotos y los vídeos de $name a la papelera?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos',
      many: '$countString de elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Nueva carpeta';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sin conexión, $countString elementos',
      many: 'Sin conexión, $countString de elementos',
      one: 'Sin conexión, 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Esta carpeta ya está en la biblioteca, o contiene una carpeta de la biblioteca o está dentro de una';

  @override
  String get folderRemove => 'Quitar carpeta';

  @override
  String folderRemoveBody(String folder) {
    return 'Las fotos y los videos de $folder se quitarán de la biblioteca. Los archivos se quedarán en el disco, intactos.';
  }

  @override
  String get folderRemoveConfirm => 'Quitar';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Analizando, $countString elementos hasta ahora',
      many: 'Analizando, $countString de elementos hasta ahora',
      one: 'Analizando, 1 elemento hasta ahora',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Permitir acceso';

  @override
  String get foldersHideExcluded => 'Ocultar carpetas excluidas';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib ya no puede leer $countString carpetas.',
      many: 'Photolib ya no puede leer $countString de carpetas.',
      one: 'Photolib ya no puede leer 1 carpeta.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Mostrar carpetas excluidas ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Este navegador no puede usar una carpeta como tu biblioteca. Abre Photolib en Chrome o Edge en una computadora, o usa la aplicación de escritorio.';

  @override
  String get galleryButtons => 'Botones';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Cuadrícula';

  @override
  String get galleryMenus => 'Menús y paneles';

  @override
  String get galleryShowSheet => 'Mostrar un panel';

  @override
  String get galleryTitle => 'Componentes';

  @override
  String hiddenCollections(int count) {
    return 'Ocultas ($count)';
  }

  @override
  String get indexingAllowMetered => 'Descargar con datos móviles';

  @override
  String get indexingAllowSaver => 'También en modo de ahorro de energía';

  @override
  String get indexingBattery => 'Batería necesaria sin cargador';

  @override
  String get indexingChargingOnly => 'Solo mientras se carga';

  @override
  String indexingDownloading(int percent) {
    return 'Descargando el modelo de búsqueda: $percent %';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No se pudieron leer $count fotos',
      many: 'No se pudieron leer $count de fotos',
      one: 'No se pudo leer 1 foto',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Este dispositivo solo indexa sus fotos nuevas';

  @override
  String get indexingMissing =>
      'Tu servidor no ha instalado el modelo de búsqueda';

  @override
  String get indexingModels => 'Buscar en este dispositivo';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Descarga el modelo de búsqueda ($megabytesString MB) desde $host';
  }

  @override
  String get indexingNoDecoder =>
      'La búsqueda y la lectura de texto no están disponibles: no se encontró la biblioteca de imágenes (libvips). Reinstala Photolib o instala libvips y reiníciala.';

  @override
  String indexingPausedBattery(int percent) {
    return 'En pausa mientras la batería esté por debajo del $percent %';
  }

  @override
  String get indexingPausedCharger =>
      'En pausa hasta que el dispositivo se cargue';

  @override
  String get indexingPausedHeat =>
      'En pausa mientras el dispositivo esté caliente';

  @override
  String get indexingPausedSaver =>
      'En pausa mientras el ahorro de batería esté activado';

  @override
  String indexingPercent(int percent) {
    return '$percent %';
  }

  @override
  String indexingProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Fotos indexadas: $doneString de $totalString';
  }

  @override
  String get indexingText => 'Leer el texto de las fotos';

  @override
  String indexingTextDownloading(int percent) {
    return 'Descargando los modelos de texto: $percent %';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Descarga los modelos de texto ($megabytesString MB) de $host; encuentra las palabras de tus fotos';
  }

  @override
  String get indexingTextMissing =>
      'Tu servidor no ha instalado los modelos de texto';

  @override
  String get indexingTextPlatform =>
      'Usa el reconocimiento de texto de tu teléfono; no hay nada que descargar. Lee las fotos nuevas';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Fotos leídas: $doneString de $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Leer texto no está disponible aquí';

  @override
  String get indexingTextWaiting =>
      'Los modelos de texto se descargan con Wi-Fi';

  @override
  String get indexingUnavailable =>
      'La búsqueda en este dispositivo no está disponible aquí';

  @override
  String get indexingWaiting => 'El modelo de búsqueda se descarga con Wi-Fi';

  @override
  String get infoAddName => 'Añadir nombre';

  @override
  String get infoAddTag => 'Añadir etiqueta';

  @override
  String get infoAlbums => 'Álbumes';

  @override
  String get infoAllMetadata => 'Ver todos los metadatos';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Con copia de seguridad';

  @override
  String get infoCamera => 'Cámara';

  @override
  String get infoChangeAdjust => 'Colores ajustados';

  @override
  String get infoChangeCrop => 'Recortada';

  @override
  String get infoChangeFlip => 'Reflejada';

  @override
  String get infoChangeInpaint => 'Zona rellenada';

  @override
  String get infoChangeLocal => 'Zona ajustada';

  @override
  String get infoChangeLut => 'Aplicado un aspecto de color';

  @override
  String get infoChangeOther => 'Editada';

  @override
  String get infoChangeTurn => 'Girada';

  @override
  String get infoCompare => 'Comparar con el original';

  @override
  String infoConfidence(String percent) {
    return 'Confianza: $percent';
  }

  @override
  String get infoCopyPath => 'Copiar ruta';

  @override
  String get infoCurrent => 'Actual';

  @override
  String get infoDescription => 'Añadir una descripción';

  @override
  String get infoEditDate => 'Editar la fecha';

  @override
  String infoEditNumber(int number) {
    return 'Edición $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Copia editada de $name';
  }

  @override
  String get infoFaces => 'Caras';

  @override
  String get infoFile => 'Archivo';

  @override
  String get infoFromFileName => 'del nombre del archivo';

  @override
  String get infoHistory => 'Historial de ediciones';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      many: '$count de elementos',
      one: '$count elemento',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Ubicación';

  @override
  String get infoMap => 'Mapa del lugar donde se tomó';

  @override
  String get infoMapAgree =>
      'Los mosaicos del mapa vienen de internet y muestran qué zona miras';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Etiqueta nueva: $path';
  }

  @override
  String get infoNoAlbum => 'No está en ningún álbum';

  @override
  String get infoOnDevice => 'En este dispositivo';

  @override
  String get infoOriginal => 'Original';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString píxeles';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Quitar de $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Quitar $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Quitado de $album';
  }

  @override
  String get infoRevert => 'Revertir';

  @override
  String get infoSaveCopy => 'Guardar como copia';

  @override
  String get infoShared => 'compartido';

  @override
  String get infoShowFaces => 'Mostrar caras en la foto';

  @override
  String get infoShowMap => 'Mostrar mapa';

  @override
  String get infoTags => 'Etiquetas';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versiones',
      many: '$count de versiones',
      one: '$count versión',
    );
    return '$_temp0 · última $time';
  }

  @override
  String get infoWhy => '¿Por qué esta fecha?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Leída en el archivo, como $tag',
      'name': 'Leída en el nombre del archivo',
      'folder': 'Leída en el nombre de una carpeta',
      'host': 'Indicada por el servicio del que procede el archivo',
      'unknown': 'Nada en el archivo lo fecha, así que se usa la fecha de su última modificación',
      'other': 'El archivo aún no se ha leído, así que se usa la fecha que da el dispositivo',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Lista',
      'other': 'Cuadrícula',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Nombre',
      'taken': 'Fecha de captura',
      'modified': 'Fecha de modificación',
      'size': 'Tamaño',
      'random': 'Aleatorio',
      'extension': 'Tipo',
      'custom': 'Orden del álbum',
      'other': 'Fecha de captura',
    });
    return '$_temp0';
  }

  @override
  String get keyAlt => 'Alt';

  @override
  String get keyControl => 'Ctrl';

  @override
  String get keyMeta => 'Cmd';

  @override
  String get keyShift => 'Mayús';

  @override
  String get languageDevice => 'Idioma del dispositivo';

  @override
  String get languageName => 'Español';

  @override
  String get libraryAddFolder => 'Añadir carpeta';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Sin copia de seguridad',
      'backed_up': 'Con copia de seguridad',
      'cloud_only': 'Solo en la nube',
      'other': 'Todo',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Todo tiene copia de seguridad',
      'backed_up': 'Aún no hay nada con copia de seguridad',
      'cloud_only': 'No hay nada solo en el servidor',
      'other': 'No hay nada aquí',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Insignias de copia de seguridad';

  @override
  String get libraryEmpty => 'Tus fotos aparecerán aquí';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Agrupar por semana',
      'month': 'Agrupar por mes',
      'other': 'Agrupar por día',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Volver a ocultar los elementos ocultos y archivados';

  @override
  String get libraryNoKeyring =>
      'Photolib guarda la clave de tu biblioteca en el llavero del sistema, que no se está ejecutando o está bloqueado. Inicia o desbloquea un llavero, como GNOME Keyring o KWallet, y vuelve a intentarlo.';

  @override
  String get libraryRevealExcluded =>
      'Mostrar las carpetas excluidas durante 5 minutos';

  @override
  String get libraryShowVeiled =>
      'Mostrar los elementos ocultos y archivados durante 5 minutos';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Añadidos recientemente',
      'other': 'Fecha de captura',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib no pudo abrir la biblioteca guardada en este dispositivo';

  @override
  String get libraryViewOptions => 'Opciones de vista';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Preparando miniaturas: $doneString de $totalString';
  }

  @override
  String get libraryZoomIn => 'Miniaturas más grandes';

  @override
  String get libraryZoomOut => 'Miniaturas más pequeñas';

  @override
  String get mapAddTrack => 'Añadir un track GPX';

  @override
  String get mapArea => 'Zona del mapa';

  @override
  String get mapAttribution => '© colaboradores de OpenStreetMap';

  @override
  String get mapClearLasso => 'Borrar la selección';

  @override
  String get mapEmpty => 'Aún no hay fotos con ubicación';

  @override
  String get mapHeat => 'Mapa de calor';

  @override
  String get mapLasso => 'Seleccionar dibujando alrededor de las fotos';

  @override
  String get mapLoading => 'Colocando las fotos en el mapa';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fotos: $countString';
  }

  @override
  String get mapSearchHere => 'Buscar en esta zona';

  @override
  String get mapSplit => 'Mostrar las fotos bajo el mapa';

  @override
  String get mapTilesAgree =>
      'El fondo del mapa viene del servidor de OpenStreetMap (tile.openstreetmap.org), que ve qué zona miras';

  @override
  String get mapTilesShow => 'Mostrar el fondo';

  @override
  String get mapTime => 'Intervalo de tiempo';

  @override
  String get mapTitle => 'Mapa';

  @override
  String get mapTrackBad => 'Ese archivo no tiene tracks GPX';

  @override
  String get mapTrips => 'Viajes';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favorito',
      'hidden': 'Oculto',
      'archived': 'Archivado',
      'offline': 'Guardado en este dispositivo',
      'offline': 'Guardado en este dispositivo',
      'offline': 'Guardado en este dispositivo',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Permitir el acceso';

  @override
  String get mediaAccessNone =>
      'Photolib necesita acceso a tus fotos y videos para mostrarlos.';

  @override
  String get mediaAccessPartial =>
      'Photolib solo ve las fotos y los videos que seleccionaste. Una galería necesita acceso a todos.';

  @override
  String get mediaAccessSelect => 'Seleccionar más fotos';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nextAddRoot =>
      'Añade la carpeta a external_roots en la configuración del servidor y reinicia el servidor.';

  @override
  String get nextAskAdmin => 'Pregunta al administrador de tu servidor.';

  @override
  String get nextAskOwner =>
      'Pide a la persona dueña de la biblioteca que te deje añadir fotos.';

  @override
  String get nextCheckConnection => 'Comprueba la conexión para ver por qué.';

  @override
  String get nextCheckEntry => 'Revisa lo que escribiste e inténtalo de nuevo.';

  @override
  String get nextConfirm =>
      'Revisa cuántos elementos afecta y luego confírmalo.';

  @override
  String get nextDeleteWebhook =>
      'Elimina un webhook que ya no uses y vuelve a intentarlo.';

  @override
  String get nextEditConfig =>
      'Cámbialo en la configuración del servidor y reinicia el servidor.';

  @override
  String get nextFreeSpace => 'Libera espacio o pide más a tu administrador.';

  @override
  String get nextNewLink => 'Pide uno nuevo a tu administrador.';

  @override
  String get nextNewestToken =>
      'Copia el más reciente del registro de photolibd.';

  @override
  String get nextOtherAdmin => 'Primero haz administradora a otra cuenta.';

  @override
  String get nextOtherFolder => 'Elige una carpeta propia.';

  @override
  String get nextRefresh => 'Actualiza e inténtalo de nuevo.';

  @override
  String get nextReport =>
      'Inténtalo de nuevo. Si vuelve a pasar, copia los detalles de abajo para tu administrador.';

  @override
  String get nextSetUpPrivate =>
      'Termina de configurar las bibliotecas privadas en Configuración y vuelve a intentarlo.';

  @override
  String get nextSignIn => 'Vuelve a iniciar sesión.';

  @override
  String get nextSignInAccount =>
      'Inicia sesión con tu cuenta e inténtalo de nuevo.';

  @override
  String get nextSignInInstead => 'Inicia sesión en su lugar.';

  @override
  String get nextTryAgain => 'Inténtalo de nuevo.';

  @override
  String get nextUpdateAndAgree =>
      'Actualiza la app y vuelve a aceptar el aviso.';

  @override
  String get nextUseAnother => 'Elige otro.';

  @override
  String get nextUseHttps =>
      'Usa la dirección https:// del servidor o conéctate desde la red del servidor.';

  @override
  String get nextWait => 'Espera un minuto y vuelve a intentarlo.';

  @override
  String get offlineKeep => 'Guardar sin conexión';

  @override
  String offlineKeepHere(String size) {
    return 'Guardar en este dispositivo ($size)';
  }

  @override
  String get offlineKeptHere => 'Guardado en este dispositivo';

  @override
  String get offlineStopKeeping => 'Dejar de guardar sin conexión';

  @override
  String get otherFiles => 'Otros archivos';

  @override
  String get passphraseCreate =>
      'Esta computadora no tiene un llavero (Secret Service) que guarde las claves de Photolib. Elige una frase de contraseña de al menos 10 caracteres para protegerlas: Photolib la pedirá cada vez que se inicie.';

  @override
  String get passphraseLabel => 'Frase de contraseña';

  @override
  String get passphraseMismatch => 'Las frases de contraseña no coinciden.';

  @override
  String get passphraseRepeat => 'Repite la frase de contraseña';

  @override
  String get passphraseTooShort => 'Usa al menos 10 caracteres.';

  @override
  String get passphraseUnlock =>
      'Introduce la frase de contraseña que protege las claves de Photolib en esta computadora.';

  @override
  String get passphraseWrong =>
      'Frase de contraseña incorrecta. Vuelve a intentarlo.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index de $count';
  }

  @override
  String get privacyCheckKit => 'Comprobar kit de recuperación';

  @override
  String get privacyDrillDue =>
      'Es hora de un simulacro de recuperación: comprueba que tu kit de recuperación aún desbloquea tus bibliotecas privadas.';

  @override
  String get privacyHonest =>
      'Las bibliotecas privadas se cifran en tus dispositivos y nadie más puede abrirlas: ni el servidor, ni su administrador, ni los desarrolladores de Photolib. Si pierdes tu contraseña y tu kit de recuperación, tus fotos se perderán para siempre y nadie podrá recuperarlas por ti.';

  @override
  String get privacyKitBody =>
      'Escribe estas 24 palabras en papel, en orden, y guárdalas en un lugar seguro. Desbloquean tus bibliotecas privadas si olvidas tu contraseña, para cualquiera que las tenga.';

  @override
  String get privacyKitDone => 'Tu kit de recuperación funciona.';

  @override
  String get privacyKitOther => 'Este no es tu kit de recuperación actual.';

  @override
  String get privacyKitTitle => 'Tu kit de recuperación';

  @override
  String get privacyKitUnverified => 'Kit de recuperación aún sin verificar';

  @override
  String privacyKitVerified(String date) {
    return 'Kit de recuperación verificado el $date';
  }

  @override
  String get privacyKitWritten => 'Ya las he anotado';

  @override
  String get privacyNotReady =>
      'Las subidas privadas siguen desactivadas hasta que tengas dos formas de desbloqueo y hayas verificado tu kit de recuperación.';

  @override
  String get privacyPasswordHelp =>
      'Introduce la contraseña de tu cuenta: será una forma de desbloquear tus bibliotecas privadas.';

  @override
  String get privacyPhrase => 'Frase de recuperación';

  @override
  String get privacyPhraseHelp => 'Las 24 palabras de tu kit de recuperación';

  @override
  String get privacyPhraseInvalid =>
      'Esta no es una frase de recuperación. Revisa cada palabra.';

  @override
  String get privacyReady => 'Las subidas privadas están activadas.';

  @override
  String get privacyRecoveryKit => 'Kit de recuperación';

  @override
  String get privacySetUp => 'Configurar';

  @override
  String get privacyShowWords => 'Mostrar las palabras de nuevo';

  @override
  String get privacyTitle => 'Bibliotecas privadas';

  @override
  String privacyUnknownWord(int number) {
    return 'La palabra $number no es una palabra de un kit de recuperación.';
  }

  @override
  String get privacyVerify => 'Verificar';

  @override
  String get privacyVerifyBody =>
      'Escribe estas palabras de tu kit de recuperación para demostrar que lo guardaste.';

  @override
  String get privacyWays => 'Formas de desbloqueo';

  @override
  String privacyWord(int number) {
    return 'Palabra $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Estas palabras no coinciden con tu kit de recuperación. Revisa lo que anotaste.';

  @override
  String get privacyWrongPassword => 'Esta no es la contraseña de tu cuenta.';

  @override
  String get problemAdminOnly => 'Solo un administrador puede hacer esto.';

  @override
  String get problemBusy => 'El servidor está ocupado o reiniciándose.';

  @override
  String get problemChanged => 'Esto ha cambiado mientras tanto.';

  @override
  String get problemConfirm =>
      'Esto ocultaría o eliminaría más elementos de los que el servidor quita sin una confirmación';

  @override
  String get problemContribute => 'No puedes añadir fotos a esta biblioteca.';

  @override
  String get problemCopy => 'Copiar detalles';

  @override
  String get problemDetails => 'Detalles';

  @override
  String get problemDiskLow =>
      'El disco del servidor está casi lleno, así que las subidas están en pausa.';

  @override
  String get problemEmailTaken => 'Otra cuenta tiene este correo.';

  @override
  String get problemExists => 'Ya existe.';

  @override
  String get problemFaceNotice =>
      'Tu servidor pide una versión más reciente del aviso sobre caras que la que muestra esta app.';

  @override
  String get problemGone => 'Ya no está en el servidor.';

  @override
  String get problemHandleTaken => 'Otra cuenta tiene este nombre de usuario.';

  @override
  String get problemInterrupted => 'La subida se interrumpió.';

  @override
  String get problemInvalid => 'Hay un valor que no es válido';

  @override
  String get problemLastAdmin =>
      'El servidor necesita al menos un administrador.';

  @override
  String get problemLinkInvalid => 'Este enlace ha caducado o ya se usó.';

  @override
  String get problemLoginFailed =>
      'Correo, nombre de usuario o contraseña incorrectos.';

  @override
  String get problemMaintenanceKey =>
      'Las copias de seguridad, las verificaciones de integridad y las purgas solo se pueden pausar con la sesión iniciada, no con una clave de API';

  @override
  String get problemNotAllowed => 'Tu cuenta no puede hacer esto.';

  @override
  String get problemNotExternal =>
      'Solo se pueden analizar las bibliotecas de las carpetas propias del servidor.';

  @override
  String get problemOidcClaim =>
      'Tu proveedor de inicio de sesión no indicó quién eres de una forma que este servidor acepte.';

  @override
  String get problemOidcDown =>
      'Tu proveedor de inicio de sesión no responde al servidor.';

  @override
  String get problemOidcFailed =>
      'Tu proveedor de inicio de sesión rechazó el acceso.';

  @override
  String get problemOidcNotAllowed =>
      'Tu cuenta no puede iniciar sesión de esta forma.';

  @override
  String get problemOidcTaken =>
      'Este inicio de sesión ya está vinculado a otra cuenta de Photolib.';

  @override
  String get problemOidcUnknown =>
      'Este servidor ya no ofrece esta forma de iniciar sesión.';

  @override
  String get problemPasskeysOff =>
      'Las llaves de acceso solo funcionan cuando el servidor tiene su dirección pública.';

  @override
  String get problemPinned =>
      'Esto está definido en el archivo de configuración y no se puede cambiar aquí.';

  @override
  String get problemPolicyOff => 'Esto está desactivado en este servidor.';

  @override
  String get problemQuota => 'Tu almacenamiento en el servidor está lleno.';

  @override
  String get problemRestoreKey =>
      'Una copia de seguridad solo se puede restaurar con la sesión iniciada, no con una clave de API.';

  @override
  String get problemRootDiffers =>
      'Esta carpeta no contiene los archivos de esta biblioteca';

  @override
  String get problemRootNotAllowed =>
      'Esta carpeta no está dentro de las external_roots de la configuración del servidor';

  @override
  String get problemRootOverlaps =>
      'Esta carpeta contiene otra biblioteca o los datos del propio servidor, o está dentro de ellos';

  @override
  String get problemScanning => 'Esta biblioteca ya se está analizando';

  @override
  String get problemSecondFactor =>
      'Esta cuenta necesita un segundo factor, como un código de autenticación o una llave de acceso, que esta versión de Photolib aún no puede aportar.';

  @override
  String get problemSetupDone => 'Este servidor ya tiene un administrador.';

  @override
  String get problemSetupExpired => 'Esto tardó demasiado.';

  @override
  String get problemSetupToken => 'Este token de configuración no es correcto.';

  @override
  String get problemSignedOut => 'Has cerrado la sesión en el servidor.';

  @override
  String get problemStepUp =>
      'Este cambio necesita primero tu contraseña o un código.';

  @override
  String get problemStorage =>
      'El servidor no puede acceder a su almacenamiento.';

  @override
  String get problemTooMany => 'Demasiados intentos en poco tiempo.';

  @override
  String get problemUnexpected => 'Algo inesperado salió mal.';

  @override
  String get problemUnreachable => 'El servidor no responde.';

  @override
  String get problemUploadDamaged =>
      'El archivo cambió o se dañó por el camino.';

  @override
  String get problemUploadExpired =>
      'El servidor ya no tiene esta subida: las subidas sin terminar caducan al cabo de un día.';

  @override
  String get problemWebhookLimit =>
      'Tu cuenta ya tiene tantos webhooks como puede tener.';

  @override
  String get problemWebhooksOff =>
      'Los webhooks están desactivados en este servidor.';

  @override
  String get recoveryCode => 'Código de recuperación';

  @override
  String get recoveryCodeAbout =>
      'Abre el almacén de Photolib en este dispositivo si el almacén de claves pierde su clave';

  @override
  String get recoveryCodeEnter => 'Introducir código de recuperación';

  @override
  String get recoveryCreate => 'Crear código de recuperación';

  @override
  String get recoveryLater => 'Más tarde';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString cambios solo existen en este dispositivo. Un código de recuperación los recupera si el almacén de claves pierde la clave de Photolib.',
      many:
          '$countString cambios solo existen en este dispositivo. Un código de recuperación los recupera si el almacén de claves pierde la clave de Photolib.',
      one: '1 cambio solo existe en este dispositivo. Un código de recuperación lo recupera si el almacén de claves pierde la clave de Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Anota estas 24 palabras y guárdalas en un lugar seguro: abren el almacén de Photolib en este dispositivo sin su clave del almacén de claves. Sustituyen cualquier código anterior.';

  @override
  String get recoveryUnlock => 'Desbloquear';

  @override
  String get recoveryWrong =>
      'Ese no es el código de recuperación de este almacén';

  @override
  String get renameFind => 'Buscar';

  @override
  String get renamePattern => 'Nuevo nombre';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Demasiado largo: un nombre tiene como máximo 255 bytes',
      'invalid': 'No es un nombre de archivo válido',
      'duplicate': 'También se da a otro archivo',
      'exists': 'Otro archivo de esta carpeta tiene este nombre',
      'other': 'No se puede cambiar el nombre',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Reemplazar por';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Archivos renombrados: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Mostrar en el Finder',
      'windows': 'Mostrar en el Explorador',
      'other': 'Mostrar en la carpeta',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Cámara';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos',
      many: '$countString de elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Fechas';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Busca en tu biblioteca';

  @override
  String get searchFavourites => 'Favoritos';

  @override
  String get searchFolder => 'Carpeta';

  @override
  String get searchHint => 'Nombre de archivo o carpeta';

  @override
  String get searchMotionPhotos => 'Fotos con movimiento';

  @override
  String get searchNothing => 'No hay resultados';

  @override
  String get searchPanoramas => 'Panorámicas';

  @override
  String get searchPhotos => 'Fotos';

  @override
  String get searchScreenshots => 'Capturas de pantalla';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Videos';

  @override
  String get securityAddPasskey => 'Añadir llave de acceso';

  @override
  String get securityCode => 'Código';

  @override
  String get securityCodesHelp =>
      'Guarda estos códigos en un lugar seguro. Cada uno funciona una vez en lugar de tu segundo factor y solo se muestran ahora.';

  @override
  String securityCodesLeft(int count) {
    return 'Sin usar: $count';
  }

  @override
  String get securityNewCodes => 'Nuevos códigos';

  @override
  String get securityPasskeyNotAdded => 'No se añadió ninguna llave de acceso.';

  @override
  String get securityRecoveryCodes => 'Códigos de recuperación';

  @override
  String get securityRemovePasskey => 'Quitar llave de acceso';

  @override
  String get securitySetUp => 'Configurar';

  @override
  String get securityStepUpBody =>
      'Introduce tu contraseña, un código de tu app de autenticación o un código de recuperación para cambiar tus segundos factores.';

  @override
  String get securityStepUpTitle => 'Confirma que eres tú';

  @override
  String get securityTitle => 'Segundos factores';

  @override
  String get securityTotp => 'App de autenticación';

  @override
  String get securityTotpHelp =>
      'Añade esta clave a tu app de autenticación y luego introduce el código que muestra.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Activada',
      'other': 'Desactivada',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Desactivar';

  @override
  String get securityWrongCode => 'Ese código no es correcto.';

  @override
  String get securityWrongProof => 'Contraseña o código incorrectos.';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get selectionClear => 'Anular la selección';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString seleccionados',
      many: '$countString de elementos seleccionados',
      one: '1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Mostrar seleccionados';

  @override
  String get serverAccount => 'Correo o nombre de usuario';

  @override
  String get serverAdd => 'Añadir un servidor';

  @override
  String get serverAddressInvalid =>
      'Introduce direcciones como photos.example.org';

  @override
  String get serverAddresses => 'Direcciones';

  @override
  String get serverAddressesHelp =>
      'Una por línea: el servidor en tu red, en internet o a través de una VPN. La app usa la más rápida que responda. O pega el enlace para crear la contraseña que te enviaron.';

  @override
  String get serverCa => 'Certificado de la CA privada (PEM)';

  @override
  String get serverCaChoose => 'Elegir un archivo de certificado';

  @override
  String serverCertificateBody(String host) {
    return '$host presenta un certificado en el que este dispositivo no confía. Confía en él solo si esta huella SHA-256 es la de tu servidor:';
  }

  @override
  String get serverCertificateTitle => '¿Confiar en este certificado?';

  @override
  String get serverConfirm => 'Confirmar';

  @override
  String get serverConnect => 'Conectar';

  @override
  String get serverCreateAdmin => 'Crear administrador';

  @override
  String get serverEnded =>
      'El servidor cerró esta sesión. Vuelve a iniciar sesión.';

  @override
  String get serverHandleHelp =>
      'Minúsculas, cifras, puntos, guiones y guiones bajos; no cambia nunca.';

  @override
  String get serverHeaders => 'Cabeceras personalizadas';

  @override
  String get serverHeadersHelp =>
      'Una por línea, como Name: value; solo se envían por HTTPS';

  @override
  String get serverHeadersInvalid => 'Escribe cada cabecera como Name: value';

  @override
  String get serverIdentity => 'Certificado de cliente (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Elegir un certificado de cliente';

  @override
  String get serverIdentityInvalid =>
      'No es un certificado (PKCS#12) o su contraseña es incorrecta.';

  @override
  String get serverIdentityPassword => 'Contraseña del certificado de cliente';

  @override
  String get serverLoading =>
      'Leyendo el servidor guardado en este dispositivo';

  @override
  String get serverNearby => 'Servidores en esta red';

  @override
  String get serverNeedsHttps =>
      'Este servidor necesita una dirección HTTPS: fuera de tu red local, Photolib no inicia sesión por HTTP sin cifrar.';

  @override
  String get serverNoSignIn =>
      'Este servidor no ofrece ningún inicio de sesión compatible con esta versión de Photolib.';

  @override
  String get serverOffline =>
      'El servidor no responde. Sigues con la sesión iniciada.';

  @override
  String get serverPasskeyFailed =>
      'No se usó ninguna llave de acceso. Inténtalo de nuevo o usa un código.';

  @override
  String get serverPasskeyRequired =>
      'Este servidor exige una llave de acceso, que esta versión de Photolib aún no puede usar.';

  @override
  String get serverPassword => 'Contraseña';

  @override
  String get serverPasswordAgain => 'Repite la contraseña';

  @override
  String get serverPasswordSetupInvalid =>
      'Este token para establecer la contraseña es incorrecto, ya se usó o ha caducado. Pide uno nuevo.';

  @override
  String get serverPasswordSetupToken => 'Token para establecer la contraseña';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Te lo da tu administrador, o lo imprime photolibd admin password-setup en el servidor.';

  @override
  String get serverPasswordsDiffer => 'Las contraseñas no coinciden.';

  @override
  String get serverPrivateLibrariesBody =>
      'Una contraseña nueva no las abre. Vuelve a abrirlas con tu kit de recuperación, una llave de acceso o un dispositivo que siga con la sesión iniciada.';

  @override
  String get serverPrivateLibrariesGo => 'Crear la contraseña';

  @override
  String get serverPrivateLibrariesTitle =>
      'Tus bibliotecas privadas siguen bloqueadas';

  @override
  String get serverProxy => 'Proxy HTTP, como host:port';

  @override
  String get serverProxyInvalid => 'Introduce el proxy como host:port';

  @override
  String get serverRecoveryCode => 'Código de recuperación';

  @override
  String get serverRemove => 'Quitar este servidor';

  @override
  String get serverRequired => 'Obligatorio';

  @override
  String get serverSecondFactor =>
      'El segundo factor de esta cuenta es una llave de acceso, que esta versión de Photolib aún no puede usar.';

  @override
  String get serverSecondFactorCode =>
      'Esta cuenta también necesita un código de tu app de autenticación o un código de recuperación.';

  @override
  String get serverSecondFactorTitle => 'Confirma que eres tú';

  @override
  String get serverSecondFactorWrong =>
      'No ha funcionado. Tras cinco intentos, vuelve a iniciar sesión.';

  @override
  String get serverSetPassword => 'Crear contraseña';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Para $handle en $server';
  }

  @override
  String get serverSetPasswordOpen => 'Establecer una contraseña';

  @override
  String get serverSetPasswordTitle => 'Crea tu contraseña';

  @override
  String get serverSetUp => 'Configurar un servidor nuevo';

  @override
  String get serverSetupLinkElsewhere =>
      'Para usar este enlace, primero cierra sesión en este servidor, o quítalo si el enlace es de otro.';

  @override
  String get serverSetupTitle => 'Configurar el servidor';

  @override
  String get serverSetupToken => 'Token de configuración';

  @override
  String get serverSetupTokenHelp =>
      'photolibd lo escribe en su registro mientras el servidor no tiene administrador; cada inicio escribe uno nuevo.';

  @override
  String get serverSignIn => 'Iniciar sesión';

  @override
  String get serverSignOut => 'Cerrar sesión';

  @override
  String serverSignedInAs(String account) {
    return 'Sesión iniciada como $account';
  }

  @override
  String get serverSignedOut => 'Sesión cerrada';

  @override
  String get serverSwitch => 'Cambiar de cuenta';

  @override
  String get serverTotpCode => 'Código de tu app de autenticación';

  @override
  String get serverTrust => 'Confiar';

  @override
  String get serverUnreadable =>
      'No se puede leer el servidor guardado en este dispositivo';

  @override
  String get serverUsePasskey => 'Usar una llave de acceso';

  @override
  String get serverUseRecoveryCode => 'Usar un código de recuperación';

  @override
  String get settingsBackground => 'Detrás de las imágenes transparentes';

  @override
  String get settingsDateFormat => 'Formato de fecha';

  @override
  String get settingsDefaultTab => 'Carpetas y álbumes se abren en';

  @override
  String get settingsFolders => 'Carpetas';

  @override
  String get settingsIndexing => 'Indexación en este dispositivo';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLibrary => 'Biblioteca';

  @override
  String get settingsServer => 'Servidor';

  @override
  String get settingsStart => 'Pantalla de inicio';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Toca el borde izquierdo o derecho para ir al elemento anterior o siguiente',
      'oneFingerZoom': 'Toca dos veces y arrastra para hacer zoom con un dedo',
      'swipes': 'Desliza arriba o abajo en el lado izquierdo de un vídeo para el brillo y en el derecho para el volumen',
      'maxBrightness': 'Brillo máximo al ver',
      'autoRotate': 'Girar según la orientación de cada foto o vídeo',
      'mixAudio': 'Reproducir vídeos sobre otro audio en vez de pausarlo',
      'autoplay': 'Reproducir los vídeos al abrirlos',
      'loop': 'Repetir vídeos',
      'autoNext': 'Pasar al siguiente elemento cuando termina un vídeo',
      'resume': 'Reanudar los vídeos donde se dejaron',
      'other': 'Reproducir imágenes animadas en la cuadrícula',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Cuánto tiempo guarda Photolib los elementos en la papelera';

  @override
  String get settingsViewerBar => 'Botones de la barra del visor';

  @override
  String get settingsViewing => 'Visualización';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString fotos y videos compartidos esperan a que Photolib pueda añadirlos a tu fototeca. Los elementos no guardados se eliminan a los 7 días.',
      many:
          '$countString de fotos y videos compartidos esperan a que Photolib pueda añadirlos a tu fototeca. Los elementos no guardados se eliminan a los 7 días.',
      one: '1 foto o video compartido espera a que Photolib pueda añadirlo a tu fototeca. Los elementos no guardados se eliminan a los 7 días.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Demasiado grande para compartir a la vez: selecciona menos elementos';

  @override
  String shareTooMany(int count) {
    return 'Demasiados para compartir a la vez: selecciona $count o menos';
  }

  @override
  String get shortcutsTitle => 'Atajos de teclado';

  @override
  String get slideshow => 'Presentación';

  @override
  String get slideshowLoop => 'Repetir';

  @override
  String get slideshowOptions => 'Opciones de la presentación';

  @override
  String get slideshowSeconds => 'Segundos por elemento';

  @override
  String get slideshowShuffle => 'Orden aleatorio';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Descendente',
      'other': 'Ascendente',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Este dispositivo';

  @override
  String sourceHide(String name) {
    return 'Ocultar $name';
  }

  @override
  String get sourceHideOthers => 'Ocultar todo lo demás de aquí';

  @override
  String get sourceLost => 'Sin acceso';

  @override
  String get sourcePartly => 'Mostrado en parte';

  @override
  String sourceShow(String name) {
    return 'Mostrar $name';
  }

  @override
  String get sourceShowEverything => 'Mostrar todo lo de aquí';

  @override
  String get sourceShowOnly => 'Mostrar solo esto';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Cronología',
      'folders': 'Carpetas y álbumes',
      'favourites': 'Favoritos',
      'other': 'Cronología',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Guardar a una persona sin conexión';

  @override
  String get storageBudget => 'Límite de almacenamiento';

  @override
  String get storageClear => 'Quitar copias sin conexión';

  @override
  String get storageClearAction => 'Quitar';

  @override
  String storageClearBody(String size) {
    return 'Se quitan $size guardados en este dispositivo y se dejan de guardar álbumes, búsquedas y fotos sin conexión. Tu biblioteca en el servidor no se toca.';
  }

  @override
  String get storageKeepLibrary => 'Guardar toda la biblioteca';

  @override
  String get storageKeepOriginals => 'Guardar también los originales';

  @override
  String get storageNoPeople => 'Todavía no hay personas con nombre.';

  @override
  String get storageNoPins =>
      'No hay nada fijado. Fija un álbum, una búsqueda o una foto para tenerlo sin conexión.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Álbum',
      'search': 'Búsqueda',
      'person': 'Persona',
      'library': 'Toda la biblioteca',
      'asset': 'Foto',
      'other': 'Fijado',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'No cabe en el límite: faltan $size';
  }

  @override
  String get storagePinNothing =>
      'Nada que descargar: sus fotos ya están en este dispositivo';

  @override
  String get storagePinPaused =>
      'En espera: este ajuste no guarda nada sin conexión';

  @override
  String get storagePinPlanning => 'Buscando qué guardar…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Descargando: $haveString de $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Disponible sin conexión ($size)';
  }

  @override
  String get storagePinWaiting => 'Se descargará cuando haya conexión';

  @override
  String get storagePins => 'Guardado sin conexión';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Solo catálogo',
      'spaceSaver': 'Ahorro de espacio',
      'travel': 'Álbumes elegidos sin conexión',
      'everything': 'Todo',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'No guarda nada; las fotos se cargan desde tu servidor al abrirlas.',
      'spaceSaver': 'Guarda vistas previas de toda tu biblioteca, las más recientes primero, dentro del límite.',
      'travel': 'Guarda solo lo que fijas: álbumes, búsquedas y fotos.',
      'everything': 'Guarda los originales de toda tu biblioteca, los más recientes primero, dentro del límite.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Qué guarda este dispositivo';

  @override
  String get storageSubtitle =>
      'Copias sin conexión y límite de almacenamiento';

  @override
  String get storageTitle => 'Almacenamiento';

  @override
  String storageUsed(String used, String budget) {
    return '$used de $budget usados';
  }

  @override
  String get storageWebNote =>
      'Un navegador solo guarda vistas previas y las borra al cerrar sesión.';

  @override
  String get storeNoKeyring =>
      'Photolib guarda la clave de su almacén local en el llavero del sistema, que no respondió. Instala y desbloquea gnome-keyring, KWallet o KeePassXC con su Secret Service activado y vuelve a intentarlo.';

  @override
  String get storeNoKeystore =>
      'Photolib no pudo acceder al almacén de claves de este dispositivo, que guarda la clave de su almacén local.';

  @override
  String get storeRebuilt =>
      'El almacén de claves de este dispositivo ya no tenía la clave del almacén local de Photolib, así que el almacén se ha reconstruido. Se han perdido sus ajustes y lo que solo existía en este dispositivo; las bibliotecas se sincronizan de nuevo y las miniaturas vuelven.';

  @override
  String get storeRecoveryNeeded =>
      'El almacén de claves de este dispositivo ya no tiene la clave del almacén local de Photolib. Introduce su código de recuperación o restablece el almacén y pierde lo que solo existe en este dispositivo.';

  @override
  String get storeReset => 'Restablecer almacén';

  @override
  String get storeResetBody =>
      'Se pierde lo que solo existe en este dispositivo; las bibliotecas se sincronizan de nuevo y las miniaturas vuelven.';

  @override
  String get storeUnavailable =>
      'El almacén de este dispositivo no está disponible: la configuración y las colecciones no se guardan';

  @override
  String get tabCollections => 'Colecciones';

  @override
  String get tabLibrary => 'Biblioteca';

  @override
  String get tabSearch => 'Buscar';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get timelineBenchmark => 'Prueba de rendimiento de la cronología';

  @override
  String get timelineBenchmarkCopy => 'Copiar los resultados';

  @override
  String get timelineCannotPlay => 'No se puede reproducir en este navegador';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position de $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position de $count, sin vista previa';
  }

  @override
  String get timelineExcluded => 'En una carpeta excluida';

  @override
  String get timelineScrubber => 'Desplazarse por fecha';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Fecha desconocida';

  @override
  String timelineWeek(String date) {
    return 'Semana del $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Añadir $action a la barra';
  }

  @override
  String toolbarDown(String action) {
    return 'Bajar $action';
  }

  @override
  String get toolbarInBar => 'En la barra';

  @override
  String get toolbarInMenu => 'En el menú ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Quitar $action de la barra';
  }

  @override
  String get toolbarReset => 'Restablecer valores predeterminados';

  @override
  String toolbarUp(String action) {
    return 'Subir $action';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Mover aquí',
      'other': 'Copiar aquí',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Ya hay un archivo o una carpeta con este nombre',
      'changed': 'La copia no coincidía con el original y se eliminó',
      'cancelled': 'Cancelado',
      'invalid': 'No es un nombre de carpeta válido',
      'other': 'Error',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Recientes';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Eliminar $countString elementos para siempre? No se puede deshacer.',
      many:
          '¿Eliminar $countString de elementos para siempre? No se puede deshacer.',
      one:
          '¿Eliminar $countString elemento para siempre? No se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String trashDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Quedan $daysString días',
      many: 'Quedan $daysString de días',
      one: 'Queda $daysString día',
      zero: 'Se elimina hoy para siempre',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'La papelera está vacía';

  @override
  String get trashEmptyAll => 'Vaciar la papelera';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString días';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos movidos a la papelera',
      many: '$countString de elementos movidos a la papelera',
      one: '$countString elemento movido a la papelera',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Quitar de la lista';

  @override
  String trashRetention(int days) {
    return 'Photolib elimina para siempre lo que guarda en la papelera al cabo de $days días; cada elemento muestra el tiempo que le queda.';
  }

  @override
  String get trashTitle => 'Papelera';

  @override
  String get undo => 'Deshacer';

  @override
  String get uploadAction => 'Subir fotos y vídeos';

  @override
  String get uploadClear => 'Borrar';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString de $totalString subidos';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fallidos: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos archivados',
      many: '$countString de elementos archivados',
      one: '$countString elemento archivado',
    );
    return '$_temp0';
  }

  @override
  String veilHidden(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos ocultos',
      many: '$countString de elementos ocultos',
      one: '$countString elemento oculto',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Negro',
      'white': 'Blanco',
      'other': 'Cuadros',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Este vídeo no se puede reproducir en este dispositivo';

  @override
  String get viewerCaptions => 'Subtítulos';

  @override
  String get viewerCompass => 'Bloqueo de brújula';

  @override
  String get viewerCopy => 'Copiar';

  @override
  String get viewerCopyText => 'Copiar texto';

  @override
  String get viewerCustomize => 'Personalizar la barra de herramientas…';

  @override
  String get viewerDial =>
      'Dirección. Haz clic para mirar al frente. Arrastra para mirar alrededor, desplaza o pellizca para hacer zoom y haz doble clic para restablecer';

  @override
  String get viewerFilmstrip => 'Tira de imágenes';

  @override
  String get viewerFirst => 'Primero';

  @override
  String get viewerFisheye => 'Ojo de pez';

  @override
  String get viewerGyroscope => 'Mover para mirar alrededor';

  @override
  String get viewerHdr => 'Mostrar en HDR';

  @override
  String get viewerInfo => 'Información';

  @override
  String get viewerInfoLoading => 'Cargando la información de este elemento';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString de $countString';
  }

  @override
  String get viewerLast => 'Último';

  @override
  String get viewerLenses => 'Elegir un objetivo';

  @override
  String get viewerMap => 'Mapa';

  @override
  String get viewerMotion => 'Reproducir movimiento';

  @override
  String get viewerMotionDenied =>
      'Este navegador no permitió el acceso a los sensores de movimiento';

  @override
  String get viewerMotionMissing =>
      'Este dispositivo no tiene giroscopio para mirar alrededor';

  @override
  String get viewerMute => 'Silenciar';

  @override
  String get viewerNext => 'Siguiente';

  @override
  String get viewerNextFrame => 'Fotograma siguiente';

  @override
  String get viewerPause => 'Pausar';

  @override
  String get viewerPlanet => 'Pequeño planeta';

  @override
  String get viewerPlay => 'Reproducir';

  @override
  String get viewerPrevious => 'Anterior';

  @override
  String get viewerPreviousFrame => 'Fotograma anterior';

  @override
  String get viewerRotate => 'Girar';

  @override
  String get viewerSdr => 'Mostrar en SDR';

  @override
  String get viewerSeek => 'Posición';

  @override
  String get viewerSetAs => 'Establecer como';

  @override
  String get viewerShare => 'Compartir';

  @override
  String get viewerSpeed => 'Velocidad de reproducción';

  @override
  String get viewerSphere =>
      'Vista de 360°. Arrastra para mirar alrededor, pellizca para hacer zoom';

  @override
  String get viewerText => 'Texto de esta foto';

  @override
  String get viewerTextCopied => 'Texto copiado';

  @override
  String get viewerTextNone => 'No se encontró texto en esta foto';

  @override
  String get viewerTextUnread => 'El texto de esta foto aún no se ha leído';

  @override
  String get viewerUnmute => 'Activar sonido';

  @override
  String get viewerZoomIn => 'Acercar';

  @override
  String get viewerZoomOut => 'Alejar';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Tarjeta SD',
      'other': 'Interna',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Acercar';

  @override
  String get zoomOut => 'Alejar';
}
