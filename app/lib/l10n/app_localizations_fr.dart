// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get actionAddToAlbum => 'Ajouter à l\'album';

  @override
  String get actionArchive => 'Archiver';

  @override
  String get actionCopyTo => 'Copier vers…';

  @override
  String get actionDeleteForever => 'Supprimer définitivement';

  @override
  String get actionFavourite => 'Ajouter aux favoris';

  @override
  String get actionHide => 'Masquer';

  @override
  String get actionMoveTo => 'Déplacer vers…';

  @override
  String get actionRename => 'Renommer';

  @override
  String get actionRestore => 'Restaurer';

  @override
  String get actionShare => 'Partager';

  @override
  String get actionTrash => 'Placer dans la corbeille';

  @override
  String get actionUnarchive => 'Désarchiver';

  @override
  String get actionUndo => 'Annuler';

  @override
  String get actionUnfavourite => 'Retirer des favoris';

  @override
  String get actionUnhide => 'Afficher';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Actif',
      'disabled': 'Désactivé',
      'invited': 'Invité',
      'deleted': 'Supprimé',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Comptes';

  @override
  String get adminAddAccount => 'Ajouter un compte';

  @override
  String get adminAddExternalLibrary => 'Ajouter une bibliothèque externe';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts tentatives',
      many: '$attempts de tentatives',
      one: '$attempts tentative',
      zero: 'pas encore exécutée',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Journal d\'audit';

  @override
  String get adminBackUpNow => 'Sauvegarder maintenant';

  @override
  String get adminBackupQueued =>
      'La sauvegarde est en file d’attente ; un exercice de restauration suivra';

  @override
  String get adminBackups => 'Sauvegardes de la base de données';

  @override
  String get adminCancelJob => 'Annuler la tâche';

  @override
  String get adminCapabilities => 'Fonctionnalités';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Bibliothèques gérées',
      'uploads': 'Envois depuis les appareils, le web et la CLI',
      'folder_browser': 'Navigateur de dossiers',
      'device_folders': 'Dossiers de l’appareil dans les apps connectées',
      'sharing': 'Partage et liens publics',
      'edits': 'Modifications',
      'deletes': 'Suppressions',
      'xmp_writes': 'Écriture des fichiers XMP',
      'face_recognition': 'Reconnaissance faciale',
      'ml_search': 'Recherche intelligente',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Avertissement',
      'fail': 'Échec',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Copié';

  @override
  String get adminCopyBundle => 'Copier les diagnostics pour un rapport de bug';

  @override
  String get adminCopyLink => 'Copier le lien';

  @override
  String get adminDelete => 'Supprimer';

  @override
  String get adminDeviceBackups => 'Sauvegardes des appareils';

  @override
  String get adminDevices => 'Vos appareils';

  @override
  String get adminDisable => 'Désactiver';

  @override
  String adminDrillFailed(String detail) {
    return 'Le dernier exercice de restauration a échoué : $detail';
  }

  @override
  String get adminEdit => 'Modifier';

  @override
  String get adminEmail => 'Adresse e-mail';

  @override
  String get adminEnable => 'Activer';

  @override
  String get adminErrorSignIn => 'Connectez-vous en tant qu\'administrateur';

  @override
  String get adminFacesDefault =>
      'La reconnaissance faciale est activée par défaut pour les nouveaux comptes';

  @override
  String get adminFiles => 'Fichiers par type';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Endommagé',
      'missing': 'Manquant',
      'size': 'Taille incorrecte',
      'hash': 'Remplacé',
      'orphan': 'Fichier orphelin',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size libres';
  }

  @override
  String get adminFreeDisk =>
      'Suspendre les envois sous ce pourcentage d\'espace disque libre, de 0 à 50';

  @override
  String get adminFreeDiskGb =>
      'ou sous cet espace libre en Go, s\'il est inférieur, de 0 à 100000';

  @override
  String get adminHandle => 'Identifiant';

  @override
  String get adminIntegrity => 'Intégrité';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString éléments',
      many: '$countString d\'éléments',
      one: '$countString élément',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'En file d\'attente',
      'running': 'En cours',
      'done': 'Terminée',
      'dead': 'Échouée',
      'cancelled': 'Annulée',
      'other': 'Toutes',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Type de tâche, par exemple render';

  @override
  String get adminJobs => 'Tâches';

  @override
  String adminLastSeen(String time) {
    return 'Vu pour la dernière fois le $time';
  }

  @override
  String get adminLibraries => 'Bibliothèques';

  @override
  String get adminLibraryOwner => 'Propriétaire';

  @override
  String get adminLibraryRoot =>
      'Dossier sur le serveur, par exemple /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'En ligne',
      'offline': 'Hors ligne',
      'scanning': 'Analyse en cours',
      'error': 'Erreur',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Journal du serveur';

  @override
  String get adminName => 'Nom';

  @override
  String get adminNothing => 'Rien pour l\'instant';

  @override
  String get adminOutOfRange => 'Hors limites';

  @override
  String get adminOverview => 'Vue d\'ensemble';

  @override
  String get adminPair => 'Associer un appareil';

  @override
  String get adminPairBody =>
      'Scannez ce code ou envoyez le lien, puis collez-le dans Ajouter un serveur de Photolib sur le nouvel appareil : il apporte toutes les adresses de ce serveur et son certificat, pour que personne n’ait à les taper.';

  @override
  String get adminPasswordSetup => 'Lien de création du mot de passe';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Envoyez ce lien à $name par n\'importe quel moyen, ou faites-lui scanner le code. Il permet de définir un mot de passe une seule fois, jusqu\'au $date.';
  }

  @override
  String get adminPause => 'Suspendre un type de tâche';

  @override
  String adminPauseMinutes(int max) {
    return 'Minutes, de 1 à $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type est suspendu jusqu\'au $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString éléments à sauvegarder',
      many: '$countString d\'éléments à sauvegarder',
      one: '1 élément à sauvegarder',
      zero: 'Rien à sauvegarder',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Règles';

  @override
  String get adminPolicyReset => 'Utiliser la valeur du niveau supérieur';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Activé par défaut',
      'server': 'Défini pour le serveur',
      'user': 'Défini pour ce compte',
      'library': 'Défini pour cette bibliothèque',
      'config': 'Défini dans la configuration',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Appliquer un préréglage';

  @override
  String get adminPresetBody =>
      'Un préréglage définit chaque fonctionnalité pour le serveur et efface ce que les comptes et les bibliothèques ont défini. Tout reste modifiable.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Consultation d’archives',
      'family_backup': 'Sauvegarde familiale',
      'personal': 'Personnel',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Les bibliothèques externes en lecture seule sont la seule source de vérité : ni envois, ni bibliothèques gérées, ni dossiers de l’appareil, ni modifications, ni suppressions, ni écriture XMP',
      'family_backup': 'Tout activé sauf l’écriture XMP',
      'personal': 'Tout activé sauf le partage et les liens publics',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Code QR du lien';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tâches en file d\'attente',
      many: '$countString de tâches en file d\'attente',
      one: '$countString tâche en file d\'attente',
      zero: 'Rien à faire',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Quota de stockage en Go ; laissez vide pour aucune limite';

  @override
  String get adminRemote => 'Accès à distance';

  @override
  String get adminRemoteBody =>
      'Joignez le serveur de partout sans ouvrir de port sur votre routeur. Choisissez une méthode ; chacune lui donne une adresse HTTPS à ajouter aux apps. Testez-la ensuite depuis l’extérieur.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared se connecte vers Cloudflare, qui sert votre domaine en HTTPS. L’offre gratuite limite une requête à 100 Mo, ce que les sauvegardes n’atteignent jamais : elles envoient 8 Mio à la fois.';

  @override
  String get adminRemoteNoAddress =>
      'Ajoutez à cette app l’adresse https:// du serveur pour la tester depuis l’extérieur.';

  @override
  String get adminRemoteReachable => 'Joignable depuis l’extérieur.';

  @override
  String get adminRemoteTailscale =>
      'Installez Tailscale sur la machine du serveur et sur chaque appareil, dans le même tailnet ou votre Headscale, puis lancez ceci sur la machine du serveur et réglez public_url sur l’adresse affichée.';

  @override
  String get adminRemoteTest => 'Tester depuis l’extérieur';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host ouvrira $url depuis ses serveurs dans le monde et connaîtra donc cette adresse. Continuer ?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Injoignable depuis l’extérieur : vérifiez la méthode choisie, puis testez de nouveau.';

  @override
  String get adminRemoteWireguard =>
      'Il faut un port UDP ouvert côté serveur ou sur un relais central. Voici la configuration d’un appareil ; créez les clés avec wg genkey.';

  @override
  String get adminRepair =>
      'Remettez-le en place depuis une sauvegarde ou un appareil qui l\'a encore';

  @override
  String get adminRepairOrphan =>
      'Aucune photo ne le désigne : vérifiez-le, puis supprimez-le ou gardez-le';

  @override
  String get adminReprocess => 'Retraiter';

  @override
  String get adminReprocessFaces => 'Détecter à nouveau les visages';

  @override
  String get adminReprocessFolder =>
      'Dossier, par exemple 2024/05 ; laissez vide pour toute la bibliothèque';

  @override
  String get adminReprocessMetadata => 'Relire les métadonnées';

  @override
  String get adminReprocessRenditions =>
      'Régénérer les miniatures et les aperçus';

  @override
  String get adminRestore => 'Restaurer';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'La restauration de $name a échoué : $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Aucun exercice de restauration n’a encore réussi';

  @override
  String adminRestoreVerified(String when) {
    return 'Dernière restauration vérifiée : $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd s’arrête, puis remplace toute la base de données par $name à son redémarrage. Ce qui a changé depuis cette sauvegarde est perdu, et chaque appareil se resynchronise depuis le début.';
  }

  @override
  String get adminRestoring =>
      'photolibd s’arrête pour restaurer la sauvegarde';

  @override
  String get adminResume => 'Reprendre';

  @override
  String get adminRetry => 'Réessayer';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrateur',
      'user': 'Utilisateur',
      'viewer': 'Lecteur',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Enregistré';

  @override
  String get adminScan => 'Analyser maintenant';

  @override
  String get adminScrubDays =>
      'Jours pour que la vérification contrôle chaque original, de 1 à 3650';

  @override
  String get adminScrubNever => 'Première vérification complète en cours';

  @override
  String adminScrubbed(String time) {
    return 'Dernière vérification complète $time';
  }

  @override
  String get adminSecondAdmin =>
      'Nommez une deuxième personne administrateur, pour que quelqu’un d’autre puisse gérer et restaurer le serveur si vous ne le pouvez pas.';

  @override
  String adminSilent(String time) {
    return 'Silencieux depuis $time';
  }

  @override
  String get adminSilentHours =>
      'Heures sans rapport avant que la sauvegarde d\'un appareil soit silencieuse, de 1 à 8760';

  @override
  String get adminStores => 'Stockage';

  @override
  String get adminThisDevice => 'Cet appareil';

  @override
  String get adminTitle => 'Administration du serveur';

  @override
  String get adminTrashDays => 'Jours dans la corbeille, de 1 à 3650';

  @override
  String get adminTwoFactor =>
      'Tous les comptes doivent configurer un second facteur d\'authentification';

  @override
  String get adminUsage => 'Utilisation par compte';

  @override
  String get albumCover => 'Utiliser comme couverture';

  @override
  String get albumEmpty => 'Cet album est vide';

  @override
  String get albumHideMemories => 'Masquer des souvenirs';

  @override
  String get albumHideTimeline => 'Masquer de la chronologie';

  @override
  String get albumNew => 'Nouvel album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'N’importe quelle date';

  @override
  String get backupCap => 'Élément le plus grand';

  @override
  String get backupCharging => 'Uniquement pendant la charge';

  @override
  String backupCompleted(String time) {
    return 'Dernière sauvegarde complète : $time';
  }

  @override
  String backupContact(String time) {
    return 'Dernier contact avec le serveur : $time';
  }

  @override
  String get backupEnabled => 'Sauvegarder cet appareil';

  @override
  String get backupFolderNo => 'Pas celui-ci';

  @override
  String get backupFolderYes => 'La sauvegarder';

  @override
  String backupHours(int count) {
    return '$count h';
  }

  @override
  String get backupMetered =>
      'Sur les réseaux limités, comme les données mobiles ou un point d’accès';

  @override
  String get backupNever => 'Pas encore de sauvegarde complète';

  @override
  String backupNewFolder(String name) {
    return 'Nouveau dossier $name : le sauvegarder ?';
  }

  @override
  String get backupNoLimit => 'Aucune limite';

  @override
  String get backupNothing => 'Rien en attente';

  @override
  String get backupNow => 'Sauvegarder maintenant';

  @override
  String backupOverdue(int hours, String items) {
    return 'Aucune sauvegarde complète depuis $hours h. En attente : $items';
  }

  @override
  String get backupOverdueTitle => 'La sauvegarde n’est pas terminée';

  @override
  String backupPending(String items) {
    return 'En attente : $items';
  }

  @override
  String backupRetry(String time) {
    return 'Nouvel essai : $time';
  }

  @override
  String get backupRoaming => 'Sauvegarder en itinérance';

  @override
  String get backupSignIn =>
      'Connectez-vous à un serveur pour sauvegarder cet appareil';

  @override
  String get backupSignedOut =>
      'Sauvegarde arrêtée : le serveur a déconnecté cet appareil. Reconnectez-vous dans Paramètres.';

  @override
  String get backupSince => 'Prises depuis';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'La sauvegarde attend que le serveur soit joignable',
      'charging': 'La sauvegarde attend que l’appareil charge',
      'battery_low': 'La sauvegarde attend : la batterie est faible',
      'roaming': 'La sauvegarde attend la fin de l’itinérance',
      'quota': 'Sauvegarde arrêtée : votre espace sur le serveur est plein',
      'second_factor': 'Sauvegarde arrêtée : le serveur demande un second facteur pour ce compte',
      'other': 'Sauvegarde arrêtée : le serveur a répondu $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Sauvegarde';

  @override
  String get backupWaiting => 'Non sauvegardés';

  @override
  String get backupWarnAfter => 'Avertir si incomplète depuis';

  @override
  String get backupWhat => 'Quoi sauvegarder';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'Dans un dossier que vous n’avez pas choisi',
      'folder_new':
          'Dans un nouveau dossier : choisissez s’il faut le sauvegarder',
      'type_excluded': 'Un type d’élément que vous n’avez pas choisi',
      'before_date': 'Pris avant la date choisie',
      'selected': 'En attente de son tour',
      'server_restored':
          'Le serveur l’a perdu lors d’une restauration : nouvel envoi',
      'working': 'En cours de sauvegarde',
      'waiting_for_icloud': 'En attente du téléchargement depuis iCloud',
      'metered': 'En attente d’un réseau non limité',
      'metered_cap': 'Trop lourd pour un réseau limité',
      'unreadable': 'Cet appareil ne peut pas le lire',
      'changed': 'Il a changé pendant l’envoi',
      'quota': 'Votre espace sur le serveur est plein',
      'other': 'Le serveur l’a refusé : $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Le serveur ne fonctionne plus avec cette version de Photolib.';

  @override
  String get checkAppTooOldNext => 'Mettez Photolib à jour.';

  @override
  String get checkChanged =>
      'Le certificat du serveur n’est pas celui auquel vous avez fait confiance.';

  @override
  String get checkChangedNext =>
      'Si votre administrateur l’a remplacé, faites confiance au nouveau. Sinon, quelqu’un écoute peut-être : n’allez pas plus loin.';

  @override
  String get checkClock =>
      'L’horloge de cet appareil et celle du serveur diffèrent de plus de cinq minutes.';

  @override
  String get checkClockNext =>
      'Laissez votre appareil régler la date et l’heure automatiquement.';

  @override
  String get checkDnsFailed => 'Le nom du serveur ne mène à aucune adresse.';

  @override
  String get checkDnsFailedNext =>
      'Vérifiez l’adresse ou connectez-vous au réseau du serveur.';

  @override
  String checkExpired(String date) {
    return 'Le certificat du serveur a expiré le $date.';
  }

  @override
  String get checkFailed => 'Échec';

  @override
  String get checkMetered =>
      'Vous êtes sur un réseau facturé à l’usage, comme les données mobiles.';

  @override
  String get checkMeteredNext =>
      'Connectez-vous au Wi-Fi avant les grosses sauvegardes.';

  @override
  String get checkNotPhotolib =>
      'Autre chose que Photolib répond, comme la page d’erreur d’un proxy ou une page de connexion Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Connectez-vous au Wi-Fi dans votre navigateur ou demandez à votre administrateur de vérifier le proxy.';

  @override
  String get checkOtherServer =>
      'Un autre serveur Photolib répond à cette adresse.';

  @override
  String get checkPassed => 'Réussi';

  @override
  String get checkRefused => 'Rien ne répond à cette adresse.';

  @override
  String get checkRefusedNext =>
      'Vérifiez que le serveur fonctionne et que vous êtes sur son réseau ou son VPN.';

  @override
  String get checkRun => 'Vérifier la connexion';

  @override
  String get checkRunning => 'Vérification';

  @override
  String get checkSelfSigned =>
      'Le serveur utilise son propre certificat, que cet appareil ne connaît pas encore.';

  @override
  String get checkSkipped => 'Non vérifié';

  @override
  String get checkStepAuth => 'Votre connexion au compte';

  @override
  String get checkStepClock => 'L’horloge de votre appareil';

  @override
  String get checkStepDns => 'Trouver l’adresse du serveur';

  @override
  String get checkStepNetwork => 'Votre réseau';

  @override
  String get checkStepServer => 'Photolib sur le serveur';

  @override
  String get checkStepTcp => 'Joindre le serveur';

  @override
  String get checkStepTls => 'Connexion sécurisée et certificat';

  @override
  String get checkStepUpload => 'Gros envois via les proxys';

  @override
  String get checkTimedOut => 'Le serveur met trop de temps à répondre.';

  @override
  String get checkTimedOutNext => 'Vérifiez votre connexion, puis réessayez.';

  @override
  String get checkTitle => 'Vérification de la connexion';

  @override
  String get checkTlsFailed => 'La connexion sécurisée a échoué.';

  @override
  String get checkTrustNext =>
      'Ne lui faites confiance que si son empreinte correspond à celle de votre serveur.';

  @override
  String get checkUntrusted =>
      'Le certificat du serveur provient d’une autorité à laquelle cet appareil ne fait pas confiance.';

  @override
  String get checkUploadCap =>
      'Un proxy sur le chemin refuse les gros envois : les sauvegardes avancent plus lentement, par petits morceaux.';

  @override
  String get checkUploadCapNext =>
      'Demandez à votre administrateur de laisser passer des requêtes de 64 Mo par le proxy.';

  @override
  String get collectionAlbums => 'Albums';

  @override
  String collectionHide(String name) {
    return 'Masquer $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Déplacer $name vers le bas';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Déplacer $name vers le haut';
  }

  @override
  String get collectionPeople => 'Personnes';

  @override
  String collectionPin(String name) {
    return 'Épingler $name';
  }

  @override
  String get collectionPlaces => 'Lieux';

  @override
  String collectionShow(String name) {
    return 'Afficher $name';
  }

  @override
  String get collectionTags => 'Étiquettes';

  @override
  String collectionUnpin(String name) {
    return 'Désépingler $name';
  }

  @override
  String get collectionsCustomise => 'Personnaliser';

  @override
  String get collectionsDone => 'Terminé';

  @override
  String get commandPalette => 'Palette de commandes';

  @override
  String get commandPaletteHint => 'Saisissez une commande';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString sur cet appareil et sauvegardés',
      many: '$countString d\'éléments sur cet appareil et sauvegardés',
      one: '$countString sur cet appareil et sauvegardé',
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
      other: '$countString uniquement sur cet appareil, non sauvegardés',
      many:
          '$countString d\'éléments uniquement sur cet appareil, non sauvegardés',
      one: '$countString uniquement sur cet appareil, non sauvegardé',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Si Photos iCloud est activé, les éléments supprimés de cet appareil disparaissent aussi d\'iCloud et de vos autres appareils Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString uniquement dans votre bibliothèque',
      many: '$countString d\'éléments uniquement dans votre bibliothèque',
      one: '$countString uniquement dans votre bibliothèque',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Retirer de cet appareil';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Les $countString éléments sauvegardés ; votre bibliothèque les conserve',
      many:
          'Les $countString d\'éléments sauvegardés ; votre bibliothèque les conserve',
      one: '$countString élément sauvegardé ; votre bibliothèque le conserve',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Les copies sur cet appareil vont dans sa corbeille : l\'espace est libéré une fois celle-ci vidée.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprimer $countString éléments ?',
      many: 'Supprimer $countString d\'éléments ?',
      one: 'Supprimer $countString élément ?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'De cet appareil et de votre bibliothèque',
      'device': 'De cet appareil uniquement',
      'other': 'De votre bibliothèque',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Absent';

  @override
  String get deviceFolderCard => 'Carte SD';

  @override
  String get deviceFolderExclude => 'Exclure';

  @override
  String get deviceFolderExcludeThis => 'Exclure ce dossier';

  @override
  String get deviceFolderExcludedNotice =>
      'Le dossier de cet élément est exclu de votre bibliothèque';

  @override
  String get deviceFolderForget => 'Retirer de la liste';

  @override
  String get deviceFolderInternal => 'Stockage interne';

  @override
  String get deviceFolderKeep => 'Garder';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, est nouveau';
  }

  @override
  String get deviceFolders => 'Dossiers de l\'appareil';

  @override
  String get deviceFoldersAll => 'Afficher tous les dossiers sauf les exclus';

  @override
  String get deviceFoldersChosen => 'Afficher uniquement les dossiers choisis';

  @override
  String get deviceFoldersExcludedNow => 'Exclu de la bibliothèque';

  @override
  String get deviceFoldersSearch => 'Rechercher des dossiers';

  @override
  String get diagnosticsAdvanced => 'Afficher les diagnostics';

  @override
  String get diagnosticsAllLoggers => 'Tous les journaux';

  @override
  String get diagnosticsCopied => 'Journal copié';

  @override
  String get diagnosticsCopy => 'Copier le journal affiché';

  @override
  String get diagnosticsEmpty => 'Aucune entrée de journal pour l\'instant';

  @override
  String get diagnosticsExport => 'Exporter le paquet de diagnostic';

  @override
  String get diagnosticsExported => 'Paquet de diagnostic enregistré';

  @override
  String get diagnosticsLevel => 'Niveau';

  @override
  String get diagnosticsLogger => 'Journal';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get download => 'Télécharger';

  @override
  String get downloadCurrent => 'Version actuelle, avec ses modifications';

  @override
  String get downloadFailed => 'Échec du téléchargement';

  @override
  String get downloadOriginal => 'Original';

  @override
  String downloadSaved(String name) {
    return '$name enregistré';
  }

  @override
  String get downloadVersion => 'Quelle version ?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Téléchargement de $countString éléments',
      many: 'Téléchargement de $countString d\'éléments',
      one: 'Téléchargement de $countString élément',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Amélioration auto';

  @override
  String get editorCrop => 'Recadrer';

  @override
  String get editorCropOriginal => 'Original';

  @override
  String get editorCropSquare => 'Carré';

  @override
  String get editorEdit => 'Modifier';

  @override
  String get editorFlip => 'Retourner';

  @override
  String get editorRotate => 'Pivoter';

  @override
  String get editorSaveCopy => 'Enregistrer une copie';

  @override
  String get editorSaveFailed => 'Impossible d\'enregistrer la copie';

  @override
  String get editorSaveVersion => 'Enregistrer';

  @override
  String get editorSaved => 'Enregistrée comme copie';

  @override
  String get editorVersionFailed => 'Impossible d\'enregistrer la version';

  @override
  String get editorVersionSaved => 'Enregistré comme nouvelle version';

  @override
  String get editorVersionsUnsupported =>
      'Ce serveur ne peut pas encore conserver de versions de photos retouchées';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString modifications ont été annulées : le serveur les a refusées.',
      many:
          '$countString de modifications ont été annulées : le serveur les a refusées.',
      one: '$countString modification a été annulée : le serveur l\'a refusée.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Fermer';

  @override
  String get editsRejectedForbidden =>
      'Vous pouvez voir ces éléments, mais pas les modifier.';

  @override
  String get editsRejectedInvalid =>
      'Le serveur n\'a pas pu accepter les modifications.';

  @override
  String get editsRejectedNotFound =>
      'Ces éléments ont été supprimés ou ne sont plus partagés avec vous.';

  @override
  String get errorNotFound => 'Cette page n\'existe pas';

  @override
  String get errorRetry => 'Réessayer';

  @override
  String get errorTitle => 'Un problème est survenu';

  @override
  String faceNumber(int number) {
    return 'Visage $number';
  }

  @override
  String get facesAgree => 'J’accepte';

  @override
  String get facesAura =>
      'Décrire les visages avec AuraFace (téléchargement plus lourd)';

  @override
  String get facesNotNow => 'Pas maintenant';

  @override
  String get facesNoticeKeep =>
      'Ce qui est trouvé reste avec vos photos, sur vos appareils et votre serveur. Les descriptions ne sont jamais affichées ni partagées, et tout est supprimé quand vous arrêtez ou supprimez la photo.';

  @override
  String get facesNoticeOptional =>
      'C’est facultatif. Tout le reste de Photolib fonctionne sans cela et vous pouvez arrêter à tout moment dans les réglages.';

  @override
  String get facesNoticeTitle => 'Trouver les visages dans vos photos ?';

  @override
  String get facesNoticeWhat =>
      'Photolib cherche les visages dans vos photos et vidéos et conserve, pour chacun, son emplacement et une liste de nombres qui le décrit, afin de retrouver la même personne. Une telle description peut être considérée comme une donnée biométrique.';

  @override
  String get facesNoticeWhere =>
      'Cela se fait sur cet appareil et, si vous êtes connecté, sur votre propre serveur. Jamais sur un service géré par nous ou par quelqu’un d’autre.';

  @override
  String get facesServerFailed =>
      'Votre serveur n’a pas pu être prévenu. Réessayez.';

  @override
  String get facesServerOff =>
      'Votre serveur ne trouve pas de visages pour vous';

  @override
  String get facesServerOn => 'Votre serveur trouve les visages pour vous';

  @override
  String get facesServerUnavailable =>
      'Votre serveur ne propose pas la reconnaissance faciale';

  @override
  String facesStatusDownloading(int percent) {
    return 'Téléchargement des modèles de visages : $percent %';
  }

  @override
  String get facesStatusMissing =>
      'Votre serveur n’a pas installé les modèles de visages';

  @override
  String get facesStatusNoDecoder =>
      'La recherche de visages est indisponible : la bibliothèque d\'images (libvips) est introuvable. Réinstallez Photolib, ou installez libvips et relancez-la.';

  @override
  String get facesStatusRunning => 'Recherche des visages sur cet appareil';

  @override
  String get facesStatusUnavailable =>
      'Les visages ne peuvent pas être trouvés sur cet appareil';

  @override
  String get facesStatusWaiting =>
      'Les modèles de visages se téléchargent en Wi-Fi';

  @override
  String get facesSwitch => 'Trouver les visages dans mes photos';

  @override
  String get facesSwitchOff =>
      'Désactivé. Rien n’est calculé sur les visages tant que vous n’avez pas accepté.';

  @override
  String get facesSwitchOn =>
      'Activé. Photolib trouve les visages dans vos photos.';

  @override
  String get facesTitle => 'Visages et personnes';

  @override
  String get facesWithdraw => 'Supprimer et arrêter';

  @override
  String get facesWithdrawBody =>
      'Cela supprime tous les visages, descriptions et personnes que Photolib a trouvés pour vous, sur cet appareil et sur votre serveur. Vos photos ne changent pas.';

  @override
  String get facesWithdrawTitle => 'Arrêter de trouver les visages ?';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': 'ko',
      'MB': 'Mo',
      'GB': 'Go',
      'TB': 'To',
      'other': 'o',
    });
    return '$sizeString $_temp0';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fichiers non modifiés : $countString';
  }

  @override
  String get folderAllow => 'Autoriser l\'accès à ce dossier';

  @override
  String get folderDelete => 'Supprimer le dossier';

  @override
  String folderDeleteBody(String name) {
    return 'Placer les photos et vidéos de $name dans la corbeille ?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString éléments',
      many: '$countString d\'éléments',
      one: '$countString élément',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Nouveau dossier';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hors ligne, $countString éléments',
      many: 'Hors ligne, $countString d\'éléments',
      one: 'Hors ligne, $countString élément',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Ce dossier est déjà dans la bibliothèque, ou il contient un dossier de la bibliothèque ou se trouve dans l\'un d\'eux';

  @override
  String get folderRemove => 'Retirer le dossier';

  @override
  String folderRemoveBody(String folder) {
    return 'Les photos et vidéos de $folder seront retirées de la bibliothèque. Les fichiers resteront intacts sur le disque.';
  }

  @override
  String get folderRemoveConfirm => 'Retirer';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Analyse en cours, $countString éléments pour l\'instant',
      many: 'Analyse en cours, $countString d\'éléments pour l\'instant',
      one: 'Analyse en cours, $countString élément pour l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Autoriser l\'accès';

  @override
  String get foldersHideExcluded => 'Masquer les dossiers exclus';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib ne peut plus lire $countString dossiers.',
      many: 'Photolib ne peut plus lire $countString de dossiers.',
      one: 'Photolib ne peut plus lire $countString dossier.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Afficher les dossiers exclus ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Ce navigateur ne peut pas utiliser un dossier comme bibliothèque. Ouvrez Photolib dans Chrome ou Edge sur un ordinateur, ou utilisez l\'application de bureau.';

  @override
  String get galleryButtons => 'Boutons';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Grille';

  @override
  String get galleryMenus => 'Menus et panneaux';

  @override
  String get galleryShowSheet => 'Afficher un panneau';

  @override
  String get galleryTitle => 'Composants';

  @override
  String hiddenCollections(int count) {
    return 'Masquées ($count)';
  }

  @override
  String get indexingAllowMetered => 'Télécharger avec les données mobiles';

  @override
  String get indexingAllowSaver => 'Aussi en mode économie d\'énergie';

  @override
  String get indexingBattery => 'Batterie requise sans chargeur';

  @override
  String get indexingChargingOnly => 'Uniquement pendant la charge';

  @override
  String indexingDownloading(int percent) {
    return 'Téléchargement du modèle de recherche : $percent %';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos n\'ont pas pu être lues',
      many: '$count de photos n\'ont pas pu être lues',
      one: '$count photo n\'a pas pu être lue',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Cet appareil n\'indexe que ses nouvelles photos';

  @override
  String get indexingMissing =>
      'Votre serveur n\'a pas installé le modèle de recherche';

  @override
  String get indexingModels => 'Rechercher sur cet appareil';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Télécharge le modèle de recherche ($megabytesString Mo) depuis $host';
  }

  @override
  String get indexingNoDecoder =>
      'La recherche et la lecture du texte sont indisponibles : la bibliothèque d\'images (libvips) est introuvable. Réinstallez Photolib, ou installez libvips et relancez-la.';

  @override
  String indexingPausedBattery(int percent) {
    return 'En pause tant que la batterie est sous $percent %';
  }

  @override
  String get indexingPausedCharger =>
      'En pause jusqu’à ce que l’appareil charge';

  @override
  String get indexingPausedHeat => 'En pause tant que l’appareil est chaud';

  @override
  String get indexingPausedSaver =>
      'En pause tant que l’économiseur de batterie est activé';

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

    return 'Photos indexées : $doneString sur $totalString';
  }

  @override
  String get indexingText => 'Lire le texte des photos';

  @override
  String indexingTextDownloading(int percent) {
    return 'Téléchargement des modèles de texte : $percent %';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Télécharge les modèles de texte ($megabytesString Mo) depuis $host ; trouve les mots de vos photos';
  }

  @override
  String get indexingTextMissing =>
      'Votre serveur n\'a pas installé les modèles de texte';

  @override
  String get indexingTextPlatform =>
      'Utilise la reconnaissance de texte de votre téléphone ; rien à télécharger. Lit les nouvelles photos';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Photos lues pour le texte : $doneString sur $totalString';
  }

  @override
  String get indexingTextUnavailable =>
      'La lecture du texte n\'est pas disponible ici';

  @override
  String get indexingTextWaiting =>
      'Les modèles de texte se téléchargent en Wi-Fi';

  @override
  String get indexingUnavailable =>
      'La recherche sur cet appareil n\'est pas disponible ici';

  @override
  String get indexingWaiting => 'Le modèle de recherche se télécharge en Wi-Fi';

  @override
  String get infoAddName => 'Ajouter un nom';

  @override
  String get infoAddTag => 'Ajouter un tag';

  @override
  String get infoAlbums => 'Albums';

  @override
  String get infoAllMetadata => 'Voir toutes les métadonnées';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Sauvegardé';

  @override
  String get infoCamera => 'Appareil photo';

  @override
  String get infoChangeAdjust => 'Couleurs ajustées';

  @override
  String get infoChangeCrop => 'Recadrée';

  @override
  String get infoChangeFlip => 'Inversée';

  @override
  String get infoChangeInpaint => 'Zone remplie';

  @override
  String get infoChangeLocal => 'Zone ajustée';

  @override
  String get infoChangeLut => 'Style de couleur appliqué';

  @override
  String get infoChangeOther => 'Retouchée';

  @override
  String get infoChangeTurn => 'Pivotée';

  @override
  String get infoCompare => 'Comparer avec l\'original';

  @override
  String infoConfidence(String percent) {
    return 'Fiabilité : $percent';
  }

  @override
  String get infoCopyPath => 'Copier le chemin';

  @override
  String get infoCurrent => 'Actuelle';

  @override
  String get infoDescription => 'Ajouter une description';

  @override
  String get infoEditDate => 'Modifier la date';

  @override
  String infoEditNumber(int number) {
    return 'Retouche $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Copie modifiée de $name';
  }

  @override
  String get infoFaces => 'Visages';

  @override
  String get infoFile => 'Fichier';

  @override
  String get infoFromFileName => 'du nom du fichier';

  @override
  String get infoHistory => 'Historique des modifications';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      many: '$count d\'éléments',
      one: '$count élément',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Lieu';

  @override
  String get infoMap => 'Carte du lieu de la prise de vue';

  @override
  String get infoMapAgree =>
      'Les tuiles de la carte viennent d\'internet et révèlent la zone que vous regardez';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels Mpx';
  }

  @override
  String infoNewTag(String path) {
    return 'Nouveau tag : $path';
  }

  @override
  String get infoNoAlbum => 'Dans aucun album';

  @override
  String get infoOnDevice => 'Sur cet appareil';

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

    return '$widthString × $heightString pixels';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Retirer de $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Retirer $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Retiré de $album';
  }

  @override
  String get infoRevert => 'Rétablir';

  @override
  String get infoSaveCopy => 'Enregistrer une copie';

  @override
  String get infoShared => 'partagé';

  @override
  String get infoShowFaces => 'Afficher les visages sur la photo';

  @override
  String get infoShowMap => 'Afficher la carte';

  @override
  String get infoTags => 'Tags';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versions',
      many: '$count de versions',
      one: '$count version',
    );
    return '$_temp0 · dernière $time';
  }

  @override
  String get infoWhy => 'Pourquoi cette date ?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Lue dans le fichier, en tant que $tag',
      'name': 'Lue dans le nom du fichier',
      'folder': 'Lue dans le nom d\'un dossier',
      'host': 'Fournie par le service d\'où vient le fichier',
      'unknown': 'Rien dans le fichier ne le date, c\'est donc la date de sa dernière modification qui est utilisée',
      'other': 'Le fichier n\'est pas encore lu, c\'est donc la date fournie par l\'appareil qui est utilisée',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Liste',
      'other': 'Grille',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Nom',
      'taken': 'Date de prise de vue',
      'modified': 'Date de modification',
      'size': 'Taille',
      'random': 'Aléatoire',
      'extension': 'Type',
      'custom': 'Ordre de l\'album',
      'other': 'Date de prise de vue',
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
  String get keyShift => 'Maj';

  @override
  String get languageDevice => 'Langue de l’appareil';

  @override
  String get languageName => 'Français';

  @override
  String get libraryAddFolder => 'Ajouter un dossier';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Non sauvegardé',
      'backed_up': 'Sauvegardé',
      'cloud_only': 'Uniquement dans le cloud',
      'other': 'Tout',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Tout est sauvegardé',
      'backed_up': 'Rien n\'est encore sauvegardé',
      'cloud_only': 'Rien n\'est uniquement sur le serveur',
      'other': 'Rien ici',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Badges de sauvegarde';

  @override
  String get libraryEmpty => 'Vos photos apparaîtront ici';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Grouper par semaine',
      'month': 'Grouper par mois',
      'other': 'Grouper par jour',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Masquer de nouveau les éléments masqués et archivés';

  @override
  String get libraryNoKeyring =>
      'Photolib conserve la clé de votre bibliothèque dans le trousseau du système, qui n\'est pas lancé ou est verrouillé. Lancez ou déverrouillez un trousseau, comme GNOME Keyring ou KWallet, puis réessayez.';

  @override
  String get libraryRevealExcluded =>
      'Afficher les dossiers exclus pendant 5 minutes';

  @override
  String get libraryShowVeiled =>
      'Afficher les éléments masqués et archivés pendant 5 minutes';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Ajoutés récemment',
      'other': 'Date de prise de vue',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib n\'a pas pu ouvrir la bibliothèque conservée sur cet appareil';

  @override
  String get libraryViewOptions => 'Options d\'affichage';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Préparation des miniatures : $doneString sur $totalString';
  }

  @override
  String get libraryZoomIn => 'Miniatures plus grandes';

  @override
  String get libraryZoomOut => 'Miniatures plus petites';

  @override
  String get mapAddTrack => 'Ajouter une trace GPX';

  @override
  String get mapArea => 'Zone de la carte';

  @override
  String get mapAttribution => '© contributeurs d\'OpenStreetMap';

  @override
  String get mapClearLasso => 'Effacer la sélection';

  @override
  String get mapEmpty => 'Aucune photo localisée pour l\'instant';

  @override
  String get mapHeat => 'Carte de chaleur';

  @override
  String get mapLasso => 'Sélectionner en dessinant autour des photos';

  @override
  String get mapLoading => 'Placement des photos sur la carte';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Photos : $countString';
  }

  @override
  String get mapSearchHere => 'Rechercher dans cette zone';

  @override
  String get mapSplit => 'Afficher les photos sous la carte';

  @override
  String get mapTilesAgree =>
      'Le fond de carte vient du serveur d\'OpenStreetMap (tile.openstreetmap.org), qui voit la zone que vous regardez';

  @override
  String get mapTilesShow => 'Afficher le fond de carte';

  @override
  String get mapTime => 'Période';

  @override
  String get mapTitle => 'Carte';

  @override
  String get mapTrackBad => 'Ce fichier ne contient aucune trace GPX';

  @override
  String get mapTrips => 'Voyages';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favori',
      'hidden': 'Masqué',
      'archived': 'Archivé',
      'offline': 'Gardé sur cet appareil',
      'offline': 'Gardé sur cet appareil',
      'offline': 'Gardé sur cet appareil',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Autoriser l\'accès';

  @override
  String get mediaAccessNone =>
      'Photolib a besoin d\'accéder à vos photos et vidéos pour les afficher.';

  @override
  String get mediaAccessPartial =>
      'Photolib ne voit que les photos et vidéos que vous avez sélectionnées. Une galerie doit avoir accès à toutes vos photos et vidéos.';

  @override
  String get mediaAccessSelect => 'Sélectionner plus de photos';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nextAddRoot =>
      'Ajoutez le dossier à external_roots dans la configuration du serveur, puis redémarrez le serveur.';

  @override
  String get nextAskAdmin => 'Demandez à l’administrateur de votre serveur.';

  @override
  String get nextAskOwner =>
      'Demandez à la personne à qui appartient la bibliothèque de vous laisser y ajouter des photos.';

  @override
  String get nextCheckConnection =>
      'Vérifiez la connexion pour savoir pourquoi.';

  @override
  String get nextCheckEntry => 'Vérifiez votre saisie et réessayez.';

  @override
  String get nextConfirm =>
      'Vérifiez combien d\'éléments sont concernés, puis confirmez.';

  @override
  String get nextDeleteWebhook =>
      'Supprimez un webhook dont vous ne vous servez plus, puis réessayez.';

  @override
  String get nextEditConfig =>
      'Modifiez-le dans la configuration du serveur, puis redémarrez le serveur.';

  @override
  String get nextFreeSpace =>
      'Libérez de l’espace ou demandez-en plus à votre administrateur.';

  @override
  String get nextNewLink => 'Demandez-en un nouveau à votre administrateur.';

  @override
  String get nextNewestToken =>
      'Copiez le plus récent depuis le journal de photolibd.';

  @override
  String get nextOtherAdmin => 'Nommez d’abord un autre compte administrateur.';

  @override
  String get nextOtherFolder => 'Choisissez un dossier qui lui soit propre.';

  @override
  String get nextRefresh => 'Actualisez et réessayez.';

  @override
  String get nextReport =>
      'Réessayez. Si cela se reproduit, copiez les détails ci-dessous pour votre administrateur.';

  @override
  String get nextSetUpPrivate =>
      'Terminez la configuration des bibliothèques privées dans les Paramètres, puis réessayez.';

  @override
  String get nextSignIn => 'Reconnectez-vous.';

  @override
  String get nextSignInAccount =>
      'Connectez-vous avec votre compte et réessayez.';

  @override
  String get nextSignInInstead => 'Connectez-vous plutôt.';

  @override
  String get nextTryAgain => 'Réessayez.';

  @override
  String get nextUpdateAndAgree =>
      'Mettez l’app à jour, puis acceptez de nouveau l’avis.';

  @override
  String get nextUseAnother => 'Choisissez-en un autre.';

  @override
  String get nextUseHttps =>
      'Utilisez l’adresse https:// du serveur ou connectez-vous depuis le réseau du serveur.';

  @override
  String get nextWait => 'Attendez une minute, puis réessayez.';

  @override
  String get offlineKeep => 'Garder hors ligne';

  @override
  String offlineKeepHere(String size) {
    return 'Garder sur cet appareil ($size)';
  }

  @override
  String get offlineKeptHere => 'Gardé sur cet appareil';

  @override
  String get offlineStopKeeping => 'Ne plus garder hors ligne';

  @override
  String get otherFiles => 'Autres fichiers';

  @override
  String get passphraseCreate =>
      'Cet ordinateur n\'exécute aucun trousseau (Secret Service) pour conserver les clés de Photolib. Choisissez une phrase secrète d\'au moins 10 caractères pour les protéger : Photolib la demande à chaque démarrage.';

  @override
  String get passphraseLabel => 'Phrase secrète';

  @override
  String get passphraseMismatch => 'Les phrases secrètes ne correspondent pas.';

  @override
  String get passphraseRepeat => 'Confirmer la phrase secrète';

  @override
  String get passphraseTooShort => 'Utilisez au moins 10 caractères.';

  @override
  String get passphraseUnlock =>
      'Saisissez la phrase secrète qui protège les clés de Photolib sur cet ordinateur.';

  @override
  String get passphraseWrong => 'Phrase secrète incorrecte. Réessayez.';

  @override
  String photoPosition(int index, int count) {
    return 'Photo $index sur $count';
  }

  @override
  String get privacyCheckKit => 'Vérifier le kit de récupération';

  @override
  String get privacyDrillDue =>
      'C\'est l\'heure d\'un exercice de récupération : vérifiez que votre kit de récupération déverrouille toujours vos bibliothèques privées.';

  @override
  String get privacyHonest =>
      'Les bibliothèques privées sont chiffrées sur vos appareils, et personne d\'autre ne peut les ouvrir : ni le serveur, ni son administrateur, ni les développeurs de Photolib. Si vous perdez à la fois votre mot de passe et votre kit de récupération, vos photos sont perdues pour de bon, et personne ne pourra les récupérer pour vous.';

  @override
  String get privacyKitBody =>
      'Écrivez ces 24 mots sur papier, dans l\'ordre, et gardez-les en lieu sûr. Ils déverrouillent vos bibliothèques privées si vous oubliez votre mot de passe, pour quiconque les détient.';

  @override
  String get privacyKitDone => 'Votre kit de récupération fonctionne.';

  @override
  String get privacyKitOther =>
      'Ce n\'est pas votre kit de récupération actuel.';

  @override
  String get privacyKitTitle => 'Votre kit de récupération';

  @override
  String get privacyKitUnverified => 'Kit de récupération pas encore vérifié';

  @override
  String privacyKitVerified(String date) {
    return 'Kit de récupération vérifié le $date';
  }

  @override
  String get privacyKitWritten => 'Je les ai notés';

  @override
  String get privacyNotReady =>
      'Les envois privés restent désactivés tant que vous n\'avez pas deux moyens de déverrouillage et un kit de récupération vérifié.';

  @override
  String get privacyPasswordHelp =>
      'Saisissez le mot de passe de votre compte : il devient un moyen de déverrouiller vos bibliothèques privées.';

  @override
  String get privacyPhrase => 'Phrase de récupération';

  @override
  String get privacyPhraseHelp => 'Les 24 mots de votre kit de récupération';

  @override
  String get privacyPhraseInvalid =>
      'Ce n\'est pas une phrase de récupération. Vérifiez chaque mot.';

  @override
  String get privacyReady => 'Les envois privés sont activés.';

  @override
  String get privacyRecoveryKit => 'Kit de récupération';

  @override
  String get privacySetUp => 'Configurer';

  @override
  String get privacyShowWords => 'Afficher à nouveau les mots';

  @override
  String get privacyTitle => 'Bibliothèques privées';

  @override
  String privacyUnknownWord(int number) {
    return 'Le mot $number n\'est pas un mot de kit de récupération.';
  }

  @override
  String get privacyVerify => 'Vérifier';

  @override
  String get privacyVerifyBody =>
      'Saisissez ces mots de votre kit de récupération pour montrer que vous l\'avez conservé.';

  @override
  String get privacyWays => 'Moyens de déverrouillage';

  @override
  String privacyWord(int number) {
    return 'Mot $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Ces mots ne correspondent pas à votre kit de récupération. Vérifiez ce que vous avez noté.';

  @override
  String get privacyWrongPassword =>
      'Ce n\'est pas le mot de passe de votre compte.';

  @override
  String get problemAdminOnly => 'Seul un administrateur peut faire cela.';

  @override
  String get problemBusy => 'Le serveur est occupé ou redémarre.';

  @override
  String get problemChanged => 'Cela a changé entre-temps.';

  @override
  String get problemConfirm =>
      'Cela masquerait ou supprimerait plus d\'éléments que le serveur ne le fait sans confirmation';

  @override
  String get problemContribute =>
      'Vous ne pouvez pas ajouter de photos à cette bibliothèque.';

  @override
  String get problemCopy => 'Copier les détails';

  @override
  String get problemDetails => 'Détails';

  @override
  String get problemDiskLow =>
      'Le disque du serveur est presque plein, les envois sont donc en pause.';

  @override
  String get problemEmailTaken =>
      'Un autre compte utilise cette adresse e-mail.';

  @override
  String get problemExists => 'Cela existe déjà.';

  @override
  String get problemFaceNotice =>
      'Votre serveur demande une version plus récente de l’avis sur les visages que celle de cette app.';

  @override
  String get problemGone => 'Ce n’est plus sur le serveur.';

  @override
  String get problemHandleTaken => 'Un autre compte utilise cet identifiant.';

  @override
  String get problemInterrupted => 'L’envoi a été interrompu.';

  @override
  String get problemInvalid => 'Une valeur n\'est pas valide';

  @override
  String get problemLastAdmin =>
      'Le serveur a besoin d’au moins un administrateur.';

  @override
  String get problemLinkInvalid => 'Ce lien a expiré ou a déjà servi.';

  @override
  String get problemLoginFailed =>
      'E-mail, identifiant ou mot de passe incorrect.';

  @override
  String get problemMaintenanceKey =>
      'Les sauvegardes, les vérifications d\'intégrité et les purges ne peuvent être suspendues qu\'avec une session ouverte, pas avec une clé API';

  @override
  String get problemNotAllowed =>
      'Votre compte n’a pas le droit de faire cela.';

  @override
  String get problemNotExternal =>
      'Seules les bibliothèques des dossiers propres au serveur peuvent être analysées.';

  @override
  String get problemOidcClaim =>
      'Votre fournisseur d’identité n’a pas indiqué qui vous êtes d’une façon que ce serveur accepte.';

  @override
  String get problemOidcDown =>
      'Votre fournisseur d’identité ne répond pas au serveur.';

  @override
  String get problemOidcFailed =>
      'Votre fournisseur d’identité a refusé la connexion.';

  @override
  String get problemOidcNotAllowed =>
      'Votre compte ne peut pas se connecter de cette façon.';

  @override
  String get problemOidcTaken =>
      'Cette connexion est déjà liée à un autre compte Photolib.';

  @override
  String get problemOidcUnknown =>
      'Ce serveur ne propose plus ce mode de connexion.';

  @override
  String get problemPasskeysOff =>
      'Les clés d’accès ne fonctionnent qu’une fois que le serveur a son adresse publique.';

  @override
  String get problemPinned =>
      'Ce réglage est défini dans le fichier de configuration et ne peut pas être modifié ici.';

  @override
  String get problemPolicyOff =>
      'Cette fonction est désactivée sur ce serveur.';

  @override
  String get problemQuota => 'Votre espace sur le serveur est plein.';

  @override
  String get problemRestoreKey =>
      'Une sauvegarde ne peut être restaurée qu\'avec une session ouverte, pas avec une clé API.';

  @override
  String get problemRootDiffers =>
      'Ce dossier ne contient pas les fichiers de cette bibliothèque';

  @override
  String get problemRootNotAllowed =>
      'Ce dossier n\'est pas sous les external_roots de la configuration du serveur';

  @override
  String get problemRootOverlaps =>
      'Ce dossier contient une autre bibliothèque ou les données du serveur lui-même, ou se trouve dans celles-ci';

  @override
  String get problemScanning =>
      'Cette bibliothèque est déjà en cours d\'analyse';

  @override
  String get problemSecondFactor =>
      'Ce compte exige un second facteur, comme un code d\'authentification ou une clé d\'accès, que cette version de Photolib ne sait pas encore fournir.';

  @override
  String get problemSetupDone => 'Ce serveur a déjà un administrateur.';

  @override
  String get problemSetupExpired => 'Cela a pris trop de temps.';

  @override
  String get problemSetupToken => 'Ce jeton de configuration est incorrect.';

  @override
  String get problemSignedOut => 'Vous êtes déconnecté du serveur.';

  @override
  String get problemStepUp =>
      'Cette modification demande d\'abord votre mot de passe ou un code.';

  @override
  String get problemStorage => 'Le serveur n’accède pas à son stockage.';

  @override
  String get problemTooMany => 'Trop de tentatives en peu de temps.';

  @override
  String get problemUnexpected => 'Une erreur inattendue s’est produite.';

  @override
  String get problemUnreachable => 'Le serveur ne répond pas.';

  @override
  String get problemUploadDamaged =>
      'Le fichier a changé ou a été abîmé en route.';

  @override
  String get problemUploadExpired =>
      'Le serveur n’a plus cet envoi : les envois inachevés expirent au bout d’un jour.';

  @override
  String get problemWebhookLimit =>
      'Votre compte a déjà autant de webhooks qu’il peut en avoir.';

  @override
  String get problemWebhooksOff =>
      'Les webhooks sont désactivés sur ce serveur.';

  @override
  String get recoveryCode => 'Code de récupération';

  @override
  String get recoveryCodeAbout =>
      'Ouvre le stockage de Photolib sur cet appareil si le trousseau perd sa clé';

  @override
  String get recoveryCodeEnter => 'Saisir le code de récupération';

  @override
  String get recoveryCreate => 'Créer un code de récupération';

  @override
  String get recoveryLater => 'Plus tard';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString modifications n\'existent que sur cet appareil. Un code de récupération permet de les retrouver si le trousseau perd la clé de Photolib.',
      many:
          '$countString modifications n\'existent que sur cet appareil. Un code de récupération permet de les retrouver si le trousseau perd la clé de Photolib.',
      one:
          '$countString modification n\'existe que sur cet appareil. Un code de récupération permet de la retrouver si le trousseau perd la clé de Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Notez ces 24 mots et gardez-les en lieu sûr : ils ouvrent le stockage de Photolib sur cet appareil sans sa clé du trousseau. Ils remplacent tout code précédent.';

  @override
  String get recoveryUnlock => 'Déverrouiller';

  @override
  String get recoveryWrong =>
      'Ce n\'est pas le code de récupération de ce stockage';

  @override
  String get renameFind => 'Rechercher';

  @override
  String get renamePattern => 'Nouveau nom';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Trop long : un nom compte au plus 255 octets',
      'invalid': 'Nom de fichier non valide',
      'duplicate': 'Donné aussi à un autre fichier',
      'exists': 'Un autre fichier de ce dossier porte ce nom',
      'other': 'Impossible de renommer',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Remplacer par';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fichiers renommés : $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Afficher dans le Finder',
      'windows': 'Afficher dans l\'Explorateur',
      'other': 'Afficher dans le dossier',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Appareil photo';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString éléments',
      many: '$countString d\'éléments',
      one: '$countString élément',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Dates';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Recherchez dans votre bibliothèque';

  @override
  String get searchFavourites => 'Favoris';

  @override
  String get searchFolder => 'Dossier';

  @override
  String get searchHint => 'Nom de fichier ou de dossier';

  @override
  String get searchMotionPhotos => 'Photos animées';

  @override
  String get searchNothing => 'Aucun résultat';

  @override
  String get searchPanoramas => 'Panoramas';

  @override
  String get searchPhotos => 'Photos';

  @override
  String get searchScreenshots => 'Captures d\'écran';

  @override
  String get searchVideo => 'Vidéo';

  @override
  String get searchVideos => 'Vidéos';

  @override
  String get securityAddPasskey => 'Ajouter une clé d\'accès';

  @override
  String get securityCode => 'Code';

  @override
  String get securityCodesHelp =>
      'Conservez ces codes en lieu sûr. Chacun fonctionne une fois à la place de votre second facteur, et ils ne s\'affichent que maintenant.';

  @override
  String securityCodesLeft(int count) {
    return 'Inutilisés : $count';
  }

  @override
  String get securityNewCodes => 'Nouveaux codes';

  @override
  String get securityPasskeyNotAdded => 'Aucune clé d\'accès n\'a été ajoutée.';

  @override
  String get securityRecoveryCodes => 'Codes de récupération';

  @override
  String get securityRemovePasskey => 'Supprimer la clé d\'accès';

  @override
  String get securitySetUp => 'Configurer';

  @override
  String get securityStepUpBody =>
      'Saisissez votre mot de passe, un code de votre application d\'authentification ou un code de récupération pour modifier vos seconds facteurs.';

  @override
  String get securityStepUpTitle => 'Confirmez votre identité';

  @override
  String get securityTitle => 'Seconds facteurs';

  @override
  String get securityTotp => 'Application d\'authentification';

  @override
  String get securityTotpHelp =>
      'Ajoutez cette clé à votre application d\'authentification, puis saisissez le code qu\'elle affiche.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Activée',
      'other': 'Désactivée',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Désactiver';

  @override
  String get securityWrongCode => 'Ce code est incorrect.';

  @override
  String get securityWrongProof => 'Mot de passe ou code incorrect.';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get selectionClear => 'Désélectionner';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString sélectionnés',
      many: '$countString d\'éléments sélectionnés',
      one: '$countString sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Afficher la sélection';

  @override
  String get serverAccount => 'E-mail ou identifiant';

  @override
  String get serverAdd => 'Ajouter un serveur';

  @override
  String get serverAddressInvalid =>
      'Saisissez des adresses comme photos.example.org';

  @override
  String get serverAddresses => 'Adresses';

  @override
  String get serverAddressesHelp =>
      'Une par ligne : le serveur sur votre réseau, sur internet ou via un VPN. L\'app utilise la plus rapide qui répond. Ou collez le lien de création du mot de passe que vous avez reçu.';

  @override
  String get serverCa => 'Certificat de l\'AC privée (PEM)';

  @override
  String get serverCaChoose => 'Choisir un fichier de certificat';

  @override
  String serverCertificateBody(String host) {
    return '$host présente un certificat auquel cet appareil ne fait pas confiance. Ne lui faites confiance que si cette empreinte SHA-256 est celle de votre serveur :';
  }

  @override
  String get serverCertificateTitle => 'Faire confiance à ce certificat ?';

  @override
  String get serverConfirm => 'Confirmer';

  @override
  String get serverConnect => 'Se connecter';

  @override
  String get serverCreateAdmin => 'Créer l\'administrateur';

  @override
  String get serverEnded =>
      'Le serveur a mis fin à cette session. Reconnectez-vous.';

  @override
  String get serverHandleHelp =>
      'Minuscules, chiffres, points, tirets et tirets bas ; il ne change jamais.';

  @override
  String get serverHeaders => 'En-têtes personnalisés';

  @override
  String get serverHeadersHelp =>
      'Un par ligne, au format Name: value ; envoyés uniquement en HTTPS';

  @override
  String get serverHeadersInvalid =>
      'Écrivez chaque en-tête au format Name: value';

  @override
  String get serverIdentity => 'Certificat client (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Choisir un certificat client';

  @override
  String get serverIdentityInvalid =>
      'Ce n\'est pas un certificat PKCS#12, ou son mot de passe est incorrect.';

  @override
  String get serverIdentityPassword => 'Mot de passe du certificat client';

  @override
  String get serverLoading => 'Lecture du serveur enregistré sur cet appareil';

  @override
  String get serverNearby => 'Serveurs sur ce réseau';

  @override
  String get serverNeedsHttps =>
      'Ce serveur a besoin d’une adresse HTTPS : hors de votre réseau local, Photolib ne se connecte pas en HTTP simple.';

  @override
  String get serverNoSignIn =>
      'Ce serveur ne propose aucune connexion prise en charge par cette version de Photolib.';

  @override
  String get serverOffline => 'Le serveur ne répond pas. Vous restez connecté.';

  @override
  String get serverPasskeyFailed =>
      'Aucune clé d\'accès n\'a été utilisée. Réessayez ou utilisez un code.';

  @override
  String get serverPasskeyRequired =>
      'Ce serveur exige une clé d\'accès, que cette version de Photolib ne sait pas encore utiliser.';

  @override
  String get serverPassword => 'Mot de passe';

  @override
  String get serverPasswordAgain => 'Confirmer le mot de passe';

  @override
  String get serverPasswordSetupInvalid =>
      'Ce jeton de définition du mot de passe est erroné, déjà utilisé ou expiré. Demandez-en un nouveau.';

  @override
  String get serverPasswordSetupToken => 'Jeton de définition du mot de passe';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Fourni par votre administrateur, ou affiché par photolibd admin password-setup sur le serveur.';

  @override
  String get serverPasswordsDiffer => 'Les mots de passe ne correspondent pas.';

  @override
  String get serverPrivateLibrariesBody =>
      'Un nouveau mot de passe ne les ouvre pas. Rouvrez-les avec votre kit de récupération, une clé d\'accès ou un appareil encore connecté.';

  @override
  String get serverPrivateLibrariesGo => 'Définir le mot de passe';

  @override
  String get serverPrivateLibrariesTitle =>
      'Vos bibliothèques privées restent verrouillées';

  @override
  String get serverProxy => 'Proxy HTTP, au format host:port';

  @override
  String get serverProxyInvalid => 'Saisissez le proxy au format host:port';

  @override
  String get serverRecoveryCode => 'Code de récupération';

  @override
  String get serverRemove => 'Retirer ce serveur';

  @override
  String get serverRequired => 'Obligatoire';

  @override
  String get serverSecondFactor =>
      'Le second facteur de ce compte est une clé d\'accès, que cette version de Photolib ne sait pas encore utiliser.';

  @override
  String get serverSecondFactorCode =>
      'Ce compte demande aussi un code de votre application d\'authentification ou un code de récupération.';

  @override
  String get serverSecondFactorTitle => 'Confirmez votre identité';

  @override
  String get serverSecondFactorWrong =>
      'Cela n\'a pas fonctionné. Après cinq essais, reconnectez-vous.';

  @override
  String get serverSetPassword => 'Définir le mot de passe';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Pour $handle sur $server';
  }

  @override
  String get serverSetPasswordOpen => 'Définir un mot de passe';

  @override
  String get serverSetPasswordTitle => 'Définissez votre mot de passe';

  @override
  String get serverSetUp => 'Configurer un nouveau serveur';

  @override
  String get serverSetupLinkElsewhere =>
      'Pour utiliser ce lien, déconnectez-vous d\'abord de ce serveur, ou retirez-le si le lien concerne un autre serveur.';

  @override
  String get serverSetupTitle => 'Configurer le serveur';

  @override
  String get serverSetupToken => 'Jeton de configuration';

  @override
  String get serverSetupTokenHelp =>
      'photolibd l\'écrit dans son journal tant que le serveur n\'a pas d\'administrateur ; chaque démarrage en écrit un nouveau.';

  @override
  String get serverSignIn => 'Se connecter';

  @override
  String get serverSignOut => 'Se déconnecter';

  @override
  String serverSignedInAs(String account) {
    return 'Connecté en tant que $account';
  }

  @override
  String get serverSignedOut => 'Déconnecté';

  @override
  String get serverSwitch => 'Changer de compte';

  @override
  String get serverTotpCode => 'Code de votre application d\'authentification';

  @override
  String get serverTrust => 'Faire confiance';

  @override
  String get serverUnreadable =>
      'Impossible de lire le serveur enregistré sur cet appareil';

  @override
  String get serverUsePasskey => 'Utiliser une clé d\'accès';

  @override
  String get serverUseRecoveryCode => 'Utiliser plutôt un code de récupération';

  @override
  String get settingsBackground => 'Derrière les images transparentes';

  @override
  String get settingsDefaultTab => 'Dossiers et albums s\'ouvrent sur';

  @override
  String get settingsFolders => 'Dossiers';

  @override
  String get settingsIndexing => 'Indexation sur cet appareil';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLibrary => 'Bibliothèque';

  @override
  String get settingsServer => 'Serveur';

  @override
  String get settingsStart => 'Écran de démarrage';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Toucher le bord gauche ou droit pour l\'élément précédent ou suivant',
      'oneFingerZoom':
          'Toucher deux fois et faire glisser pour zoomer d\'un doigt',
      'swipes': 'Glisser vers le haut ou le bas à gauche d\'une vidéo pour la luminosité, à droite pour le volume',
      'maxBrightness': 'Luminosité maximale pendant l\'affichage',
      'autoRotate': 'Pivoter selon l\'orientation de chaque photo ou vidéo',
      'mixAudio': 'Lire les vidéos par-dessus l\'autre audio au lieu de le mettre en pause',
      'autoplay': 'Lire les vidéos dès leur ouverture',
      'loop': 'Lire les vidéos en boucle',
      'autoNext': 'Passer à l\'élément suivant à la fin d\'une vidéo',
      'resume': 'Reprendre les vidéos là où elles ont été laissées',
      'other': 'Animer les images animées dans la grille',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Durée de conservation des éléments dans la corbeille de Photolib';

  @override
  String get settingsViewerBar => 'Boutons de la barre de la visionneuse';

  @override
  String get settingsViewing => 'Affichage';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString photos et vidéos partagées attendent que Photolib puisse les ajouter à votre photothèque. Les éléments non enregistrés sont supprimés au bout de 7 jours.',
      many:
          '$countString de photos et vidéos partagées attendent que Photolib puisse les ajouter à votre photothèque. Les éléments non enregistrés sont supprimés au bout de 7 jours.',
      one:
          '$countString photo ou vidéo partagée attend que Photolib puisse l\'ajouter à votre photothèque. Les éléments non enregistrés sont supprimés au bout de 7 jours.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Trop volumineux pour être partagé en une fois : sélectionnez moins d\'éléments';

  @override
  String shareTooMany(int count) {
    return 'Trop d\'éléments à partager en une fois : sélectionnez-en $count au maximum';
  }

  @override
  String get shortcutsTitle => 'Raccourcis clavier';

  @override
  String get slideshow => 'Diaporama';

  @override
  String get slideshowLoop => 'Répéter';

  @override
  String get slideshowOptions => 'Options du diaporama';

  @override
  String get slideshowSeconds => 'Secondes par élément';

  @override
  String get slideshowShuffle => 'Ordre aléatoire';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Décroissant',
      'other': 'Croissant',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Cet appareil';

  @override
  String sourceHide(String name) {
    return 'Masquer $name';
  }

  @override
  String get sourceHideOthers => 'Masquer tout le reste ici';

  @override
  String get sourceLost => 'Aucun accès';

  @override
  String get sourcePartly => 'Affiché en partie';

  @override
  String sourceShow(String name) {
    return 'Afficher $name';
  }

  @override
  String get sourceShowEverything => 'Tout afficher ici';

  @override
  String get sourceShowOnly => 'Afficher uniquement ceci';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Chronologie',
      'folders': 'Dossiers et albums',
      'favourites': 'Favoris',
      'other': 'Chronologie',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Garder une personne hors ligne';

  @override
  String get storageBudget => 'Budget de stockage';

  @override
  String get storageClear => 'Supprimer les copies hors ligne';

  @override
  String get storageClearAction => 'Supprimer';

  @override
  String storageClearBody(String size) {
    return 'Cela supprime $size gardés sur cet appareil et arrête de garder des albums, recherches et photos hors ligne. Votre bibliothèque sur le serveur n\'est pas touchée.';
  }

  @override
  String get storageKeepLibrary => 'Garder toute la bibliothèque';

  @override
  String get storageKeepOriginals => 'Garder aussi les originaux';

  @override
  String get storageNoPeople => 'Aucune personne n\'est encore nommée.';

  @override
  String get storageNoPins =>
      'Rien n\'est épinglé. Épinglez un album, une recherche ou une photo pour la garder hors ligne.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Recherche',
      'person': 'Personne',
      'library': 'Toute la bibliothèque',
      'asset': 'Photo',
      'other': 'Épinglé',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Dépasse le budget : $size de plus nécessaires';
  }

  @override
  String get storagePinNothing =>
      'Rien à télécharger : ses photos sont déjà sur cet appareil';

  @override
  String get storagePinPaused =>
      'En attente : ce réglage ne garde rien hors ligne';

  @override
  String get storagePinPlanning => 'Recherche de ce qu\'il faut garder…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Téléchargement : $haveString sur $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Disponible hors ligne ($size)';
  }

  @override
  String get storagePinWaiting => 'Sera téléchargé une fois en ligne';

  @override
  String get storagePins => 'Gardé hors ligne';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Catalogue seul',
      'spaceSaver': 'Économie d\'espace',
      'travel': 'Albums choisis hors ligne',
      'everything': 'Tout',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Ne garde rien ; les photos se chargent depuis votre serveur à l\'ouverture.',
      'spaceSaver': 'Garde des aperçus de toute votre bibliothèque, les plus récents d\'abord, dans le budget.',
      'travel':
          'Ne garde que ce que vous épinglez : albums, recherches et photos.',
      'everything': 'Garde les originaux de toute votre bibliothèque, les plus récents d\'abord, dans le budget.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Ce que cet appareil garde';

  @override
  String get storageSubtitle => 'Copies hors ligne et budget de stockage';

  @override
  String get storageTitle => 'Stockage';

  @override
  String storageUsed(String used, String budget) {
    return '$used utilisés sur $budget';
  }

  @override
  String get storageWebNote =>
      'Un navigateur ne garde que des aperçus et les efface à la déconnexion.';

  @override
  String get storeNoKeyring =>
      'Photolib garde la clé de son stockage local dans le trousseau du système, qui n\'a pas répondu. Installez et déverrouillez gnome-keyring, KWallet ou KeePassXC avec son Secret Service activé, puis réessayez.';

  @override
  String get storeNoKeystore =>
      'Photolib n\'a pas pu joindre le trousseau de cet appareil, qui contient la clé de son stockage local.';

  @override
  String get storeRebuilt =>
      'Le trousseau de cet appareil n\'avait plus la clé du stockage local de Photolib, qui a donc été reconstruit. Ses réglages et ce qui n\'existait que sur cet appareil sont perdus ; les bibliothèques se synchronisent à nouveau et les miniatures reviennent.';

  @override
  String get storeRecoveryNeeded =>
      'Le trousseau de cet appareil n\'a plus la clé du stockage local de Photolib. Saisissez son code de récupération, ou réinitialisez le stockage et perdez ce qui n\'existe que sur cet appareil.';

  @override
  String get storeReset => 'Réinitialiser le stockage';

  @override
  String get storeResetBody =>
      'Ce qui n\'existe que sur cet appareil est perdu ; les bibliothèques se synchronisent à nouveau et les miniatures reviennent.';

  @override
  String get storeUnavailable =>
      'Le stockage de cet appareil est indisponible : les paramètres et les collections ne sont pas conservés';

  @override
  String get tabCollections => 'Collections';

  @override
  String get tabLibrary => 'Bibliothèque';

  @override
  String get tabSearch => 'Rechercher';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeSystem => 'Système';

  @override
  String get timelineBenchmark => 'Test de performance de la chronologie';

  @override
  String get timelineBenchmarkCopy => 'Copier les résultats';

  @override
  String get timelineCannotPlay => 'Lecture impossible dans ce navigateur';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position sur $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position sur $count, sans aperçu';
  }

  @override
  String get timelineExcluded => 'Dans un dossier exclu';

  @override
  String get timelineScrubber => 'Faire défiler par date';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Date inconnue';

  @override
  String timelineWeek(String date) {
    return 'Semaine du $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Ajouter $action à la barre';
  }

  @override
  String toolbarDown(String action) {
    return 'Descendre $action';
  }

  @override
  String get toolbarInBar => 'Dans la barre';

  @override
  String get toolbarInMenu => 'Dans le menu ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Retirer $action de la barre';
  }

  @override
  String get toolbarReset => 'Rétablir les valeurs par défaut';

  @override
  String toolbarUp(String action) {
    return 'Monter $action';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Déplacer ici',
      'other': 'Copier ici',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Un fichier ou dossier de ce nom s\'y trouve déjà',
      'changed':
          'La copie ne correspondait pas à l\'original et a été supprimée',
      'cancelled': 'Annulé',
      'invalid': 'Nom de dossier non valide',
      'other': 'Échec',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Récents';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Supprimer définitivement $countString éléments ? Cette action est irréversible.',
      many:
          'Supprimer définitivement $countString d\'éléments ? Cette action est irréversible.',
      one:
          'Supprimer définitivement $countString élément ? Cette action est irréversible.',
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
      other: '$daysString jours restants',
      many: '$daysString de jours restants',
      one: '$daysString jour restant',
      zero: 'Supprimé définitivement aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'La corbeille est vide';

  @override
  String get trashEmptyAll => 'Vider la corbeille';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString jours';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString éléments placés dans la corbeille',
      many: '$countString d\'éléments placés dans la corbeille',
      one: '$countString élément placé dans la corbeille',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Retirer de la liste';

  @override
  String trashRetention(int days) {
    return 'Photolib supprime définitivement ce qu\'il garde dans la corbeille au bout de $days jours ; chaque élément indique le temps qu\'il lui reste.';
  }

  @override
  String get trashTitle => 'Corbeille';

  @override
  String get undo => 'Annuler';

  @override
  String get uploadAction => 'Importer des photos et vidéos';

  @override
  String get uploadClear => 'Effacer';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString sur $totalString importés';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Échecs : $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString éléments archivés',
      many: '$countString d\'éléments archivés',
      one: '$countString élément archivé',
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
      other: '$countString éléments masqués',
      many: '$countString d\'éléments masqués',
      one: '$countString élément masqué',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Noir',
      'white': 'Blanc',
      'other': 'Damier',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Cette vidéo ne peut pas être lue sur cet appareil';

  @override
  String get viewerCaptions => 'Sous-titres';

  @override
  String get viewerCompass => 'Verrouillage boussole';

  @override
  String get viewerCopy => 'Copier';

  @override
  String get viewerCopyText => 'Copier le texte';

  @override
  String get viewerCustomize => 'Personnaliser la barre d\'outils…';

  @override
  String get viewerDial =>
      'Cap. Cliquez pour revenir face à l\'avant. Faites glisser pour regarder autour, faites défiler ou pincez pour zoomer, double-cliquez pour réinitialiser';

  @override
  String get viewerFilmstrip => 'Pellicule';

  @override
  String get viewerFirst => 'Premier';

  @override
  String get viewerFisheye => 'Fish-eye';

  @override
  String get viewerGyroscope => 'Bouger pour regarder autour';

  @override
  String get viewerHdr => 'Afficher en HDR';

  @override
  String get viewerInfo => 'Infos';

  @override
  String get viewerInfoLoading => 'Chargement des infos de cet élément';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString sur $countString';
  }

  @override
  String get viewerLast => 'Dernier';

  @override
  String get viewerLenses => 'Choisir un objectif';

  @override
  String get viewerMap => 'Carte';

  @override
  String get viewerMotion => 'Lire le mouvement';

  @override
  String get viewerMotionDenied =>
      'Ce navigateur n\'a pas autorisé l\'accès aux capteurs de mouvement';

  @override
  String get viewerMotionMissing =>
      'Cet appareil n\'a pas de gyroscope pour regarder autour';

  @override
  String get viewerMute => 'Couper le son';

  @override
  String get viewerNext => 'Suivant';

  @override
  String get viewerNextFrame => 'Image suivante';

  @override
  String get viewerPause => 'Pause';

  @override
  String get viewerPlanet => 'Petite planète';

  @override
  String get viewerPlay => 'Lire';

  @override
  String get viewerPrevious => 'Précédent';

  @override
  String get viewerPreviousFrame => 'Image précédente';

  @override
  String get viewerRotate => 'Pivoter';

  @override
  String get viewerSdr => 'Afficher en SDR';

  @override
  String get viewerSeek => 'Position';

  @override
  String get viewerSetAs => 'Définir comme';

  @override
  String get viewerShare => 'Partager';

  @override
  String get viewerSpeed => 'Vitesse de lecture';

  @override
  String get viewerSphere =>
      'Vue à 360°. Faites glisser pour regarder autour, pincez pour zoomer';

  @override
  String get viewerText => 'Texte de cette photo';

  @override
  String get viewerTextCopied => 'Texte copié';

  @override
  String get viewerTextNone => 'Aucun texte trouvé dans cette photo';

  @override
  String get viewerTextUnread =>
      'Le texte de cette photo n\'a pas encore été lu';

  @override
  String get viewerUnmute => 'Activer le son';

  @override
  String get viewerZoomIn => 'Zoom avant';

  @override
  String get viewerZoomOut => 'Zoom arrière';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Carte SD',
      'other': 'Interne',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Zoom avant';

  @override
  String get zoomOut => 'Zoom arrière';
}
