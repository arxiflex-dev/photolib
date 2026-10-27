// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get actionAddToAlbum => 'Adicionar ao álbum';

  @override
  String get actionArchive => 'Arquivar';

  @override
  String get actionCopyTo => 'Copiar para…';

  @override
  String get actionDeleteForever => 'Excluir para sempre';

  @override
  String get actionFavourite => 'Favoritar';

  @override
  String get actionHide => 'Ocultar';

  @override
  String get actionMoveTo => 'Mover para…';

  @override
  String get actionRename => 'Renomear';

  @override
  String get actionRestore => 'Restaurar';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get actionTrash => 'Mover para a lixeira';

  @override
  String get actionUnarchive => 'Desarquivar';

  @override
  String get actionUndo => 'Desfazer';

  @override
  String get actionUnfavourite => 'Remover dos favoritos';

  @override
  String get actionUnhide => 'Reexibir';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Ativa',
      'disabled': 'Desativada',
      'invited': 'Convidada',
      'deleted': 'Excluída',
      'other': 'Desconhecida',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Contas';

  @override
  String get adminAddAccount => 'Adicionar conta';

  @override
  String get adminAddExternalLibrary => 'Adicionar uma biblioteca externa';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts tentativas',
      many: '$attempts de tentativas',
      one: '$attempts tentativa',
      zero: 'ainda não executada',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Registro de auditoria';

  @override
  String get adminBackUpNow => 'Fazer backup agora';

  @override
  String get adminBackupQueued =>
      'O backup está na fila; segue-se um teste de restauração';

  @override
  String get adminBackups => 'Backups do banco de dados';

  @override
  String get adminCancelJob => 'Cancelar tarefa';

  @override
  String get adminCapabilities => 'Recursos';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Bibliotecas gerenciadas',
      'uploads': 'Envios de dispositivos, da web e da CLI',
      'folder_browser': 'Navegador de pastas',
      'device_folders': 'Pastas do dispositivo em apps conectados',
      'sharing': 'Compartilhamento e links públicos',
      'edits': 'Edições',
      'deletes': 'Exclusões',
      'xmp_writes': 'Gravação de arquivos XMP',
      'face_recognition': 'Reconhecimento facial',
      'ml_search': 'Busca inteligente',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Aviso',
      'fail': 'Falha',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Copiado';

  @override
  String get adminCopyBundle => 'Copiar o diagnóstico para um relatório de bug';

  @override
  String get adminCopyLink => 'Copiar link';

  @override
  String get adminDelete => 'Excluir';

  @override
  String get adminDeviceBackups => 'Backups dos dispositivos';

  @override
  String get adminDevices => 'Seus dispositivos';

  @override
  String get adminDisable => 'Desativar';

  @override
  String adminDrillFailed(String detail) {
    return 'O último teste de restauração falhou: $detail';
  }

  @override
  String get adminEdit => 'Editar';

  @override
  String get adminEmail => 'E-mail';

  @override
  String get adminEnable => 'Ativar';

  @override
  String get adminErrorSignIn => 'Faça login como administrador';

  @override
  String get adminFacesDefault =>
      'O reconhecimento facial vem ativado por padrão em contas novas';

  @override
  String get adminFiles => 'Arquivos por tipo';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Danificado',
      'missing': 'Ausente',
      'size': 'Tamanho errado',
      'hash': 'Substituído',
      'orphan': 'Arquivo avulso',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size livres';
  }

  @override
  String get adminFreeDisk =>
      'Pausar uploads abaixo desta porcentagem de espaço livre em disco, de 0 a 50';

  @override
  String get adminFreeDiskGb =>
      'ou abaixo deste espaço livre em GB, se for menor, de 0 a 100000';

  @override
  String get adminHandle => 'Nome de usuário';

  @override
  String get adminIntegrity => 'Integridade';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString itens',
      many: '$countString de itens',
      one: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'Na fila',
      'running': 'Em execução',
      'done': 'Concluída',
      'dead': 'Com falha',
      'cancelled': 'Cancelada',
      'other': 'Todas',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Tipo de tarefa, como render';

  @override
  String get adminJobs => 'Tarefas';

  @override
  String adminLastSeen(String time) {
    return 'Visto pela última vez em $time';
  }

  @override
  String get adminLibraries => 'Bibliotecas';

  @override
  String get adminLibraryOwner => 'Proprietário';

  @override
  String get adminLibraryRoot => 'Pasta no servidor, como /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'On-line',
      'offline': 'Off-line',
      'scanning': 'Analisando',
      'error': 'Erro',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Registro do servidor';

  @override
  String get adminName => 'Nome';

  @override
  String get adminNothing => 'Nada aqui ainda';

  @override
  String get adminOutOfRange => 'Fora do intervalo';

  @override
  String get adminOverview => 'Visão geral';

  @override
  String get adminPair => 'Parear um dispositivo';

  @override
  String get adminPairBody =>
      'Escaneie este código ou envie o link e cole-o em Adicionar um servidor no Photolib do novo dispositivo: ele leva todos os endereços deste servidor e o certificado, para ninguém precisar digitá-los.';

  @override
  String get adminPasswordSetup => 'Link para definir a senha';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Envie este link para $name por qualquer meio ou deixe que escaneie o código. Ele define uma senha uma única vez, até $date.';
  }

  @override
  String get adminPause => 'Pausar um tipo de tarefa';

  @override
  String adminPauseMinutes(int max) {
    return 'Minutos, de 1 a $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type está pausado até $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString itens a fazer backup',
      many: '$countString de itens a fazer backup',
      one: '1 item a fazer backup',
      zero: 'Nada a fazer backup',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Políticas';

  @override
  String get adminPolicyReset => 'Usar o valor do nível acima';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Ativado por padrão',
      'server': 'Definido para o servidor',
      'user': 'Definido para esta conta',
      'library': 'Definido para esta biblioteca',
      'config': 'Definido na configuração',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Aplicar uma predefinição';

  @override
  String get adminPresetBody =>
      'Uma predefinição ajusta todos os recursos do servidor e apaga o que contas e bibliotecas definiram. Tudo continua editável.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Visualizador de arquivo',
      'family_backup': 'Backup da família',
      'personal': 'Pessoal',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'As bibliotecas externas somente leitura são a única fonte da verdade: sem envios, bibliotecas gerenciadas, pastas do dispositivo, edições, exclusões nem gravações XMP',
      'family_backup': 'Tudo ativado, exceto gravações XMP',
      'personal': 'Tudo ativado, exceto compartilhamento e links públicos',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Código QR do link';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tarefas na fila',
      many: '$countString de tarefas na fila',
      one: '$countString tarefa na fila',
      zero: 'Nada a fazer',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Cota de armazenamento em GB; deixe em branco para não ter limite';

  @override
  String get adminRemote => 'Acesso remoto';

  @override
  String get adminRemoteBody =>
      'Acesse o servidor de qualquer lugar sem abrir portas no roteador. Escolha um jeito; cada um dá a ele um endereço HTTPS para adicionar aos apps. Depois teste de fora.';

  @override
  String get adminRemoteCloudflare =>
      'O cloudflared se conecta de dentro para fora com a Cloudflare, que serve seu domínio por HTTPS. O plano gratuito limita cada solicitação a 100 MB, que os backups nunca atingem: eles enviam 8 MiB por vez.';

  @override
  String get adminRemoteNoAddress =>
      'Adicione a este app o endereço https:// do servidor para testá-lo de fora.';

  @override
  String get adminRemoteReachable => 'Acessível de fora.';

  @override
  String get adminRemoteTailscale =>
      'Instale o Tailscale no computador do servidor e em cada dispositivo, na mesma tailnet ou no seu Headscale; depois rode isto no computador do servidor e defina public_url com o endereço exibido.';

  @override
  String get adminRemoteTest => 'Testar de fora';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host vai abrir $url a partir dos servidores dele no mundo todo e, assim, conhecer este endereço. Continuar?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Inacessível de fora: confira o jeito escolhido e teste de novo.';

  @override
  String get adminRemoteWireguard =>
      'Precisa de uma porta UDP aberta do lado do servidor ou em um nó central. Esta é a configuração de um dispositivo; crie as chaves com wg genkey.';

  @override
  String get adminRepair =>
      'Restaure-o de um backup ou de um dispositivo que ainda o tenha';

  @override
  String get adminRepairOrphan =>
      'Nenhuma foto o nomeia: verifique-o e depois exclua-o ou mantenha-o';

  @override
  String get adminReprocess => 'Reprocessar';

  @override
  String get adminReprocessFaces => 'Detectar rostos novamente';

  @override
  String get adminReprocessFolder =>
      'Pasta, como 2024/05; deixe em branco para a biblioteca inteira';

  @override
  String get adminReprocessMetadata => 'Ler os metadados novamente';

  @override
  String get adminReprocessRenditions =>
      'Gerar miniaturas e visualizações novamente';

  @override
  String get adminRestore => 'Restaurar';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'A restauração de $name falhou: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Nenhum teste de restauração passou ainda';

  @override
  String adminRestoreVerified(String when) {
    return 'Última restauração verificada: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'O photolibd para e, ao reiniciar, substitui todo o banco de dados por $name. O que mudou desde esse backup é perdido, e cada dispositivo sincroniza do zero.';
  }

  @override
  String get adminRestoring =>
      'O photolibd está parando para restaurar o backup';

  @override
  String get adminResume => 'Retomar';

  @override
  String get adminRetry => 'Tentar novamente';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrador',
      'user': 'Usuário',
      'viewer': 'Leitor',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Salvo';

  @override
  String get adminScan => 'Analisar agora';

  @override
  String get adminScrubDays =>
      'Dias para a verificação conferir cada original, de 1 a 3650';

  @override
  String get adminScrubNever => 'Primeira verificação completa em andamento';

  @override
  String adminScrubbed(String time) {
    return 'Última verificação completa $time';
  }

  @override
  String get adminSecondAdmin =>
      'Torne uma segunda pessoa administradora, para que outra pessoa possa gerenciar e restaurar o servidor se você não puder.';

  @override
  String adminSilent(String time) {
    return 'Em silêncio desde $time';
  }

  @override
  String get adminSilentHours =>
      'Horas sem relatório até o backup de um dispositivo ficar em silêncio, de 1 a 8760';

  @override
  String get adminStores => 'Armazenamento';

  @override
  String get adminThisDevice => 'Este dispositivo';

  @override
  String get adminTitle => 'Administração do servidor';

  @override
  String get adminTrashDays => 'Dias na lixeira, de 1 a 3650';

  @override
  String get adminTwoFactor =>
      'Todas as contas precisam configurar um segundo fator de autenticação';

  @override
  String get adminUsage => 'Uso por conta';

  @override
  String get albumCover => 'Usar como capa';

  @override
  String get albumEmpty => 'Este álbum está vazio';

  @override
  String get albumHideMemories => 'Ocultar das memórias';

  @override
  String get albumHideTimeline => 'Ocultar da linha do tempo';

  @override
  String get albumNew => 'Novo álbum';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Qualquer data';

  @override
  String get backupCap => 'Maior item';

  @override
  String get backupCharging => 'Somente durante o carregamento';

  @override
  String backupCompleted(String time) {
    return 'Último backup completo: $time';
  }

  @override
  String backupContact(String time) {
    return 'Último contato com o servidor: $time';
  }

  @override
  String get backupEnabled => 'Fazer backup deste dispositivo';

  @override
  String get backupFolderNo => 'Esta não';

  @override
  String get backupFolderYes => 'Fazer backup';

  @override
  String backupHours(int count) {
    return '$count h';
  }

  @override
  String get backupMetered =>
      'Em redes limitadas, como dados móveis ou um ponto de acesso';

  @override
  String get backupNever => 'Ainda não há backup completo';

  @override
  String backupNewFolder(String name) {
    return 'Nova pasta $name: fazer backup?';
  }

  @override
  String get backupNoLimit => 'Sem limite';

  @override
  String get backupNothing => 'Nada pendente';

  @override
  String get backupNow => 'Fazer backup agora';

  @override
  String backupOverdue(int hours, String items) {
    return 'Nenhum backup completo há $hours h. Pendentes: $items';
  }

  @override
  String get backupOverdueTitle => 'O backup não foi concluído';

  @override
  String backupPending(String items) {
    return 'Pendentes: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Nova tentativa: $time';
  }

  @override
  String get backupRoaming => 'Fazer backup em roaming';

  @override
  String get backupSignIn =>
      'Entre em um servidor para fazer backup deste dispositivo';

  @override
  String get backupSignedOut =>
      'Backup interrompido: o servidor desconectou este dispositivo. Entre novamente em Configurações.';

  @override
  String get backupSince => 'Capturadas desde';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'O backup aguarda o servidor ficar acessível',
      'charging': 'O backup aguarda o dispositivo carregar',
      'battery_low': 'O backup aguarda: a bateria está fraca',
      'roaming': 'O backup aguarda enquanto houver roaming',
      'quota': 'Backup interrompido: seu armazenamento no servidor está cheio',
      'second_factor': 'Backup interrompido: o servidor pede um segundo fator para esta conta',
      'other': 'Backup interrompido: o servidor respondeu $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupWaiting => 'Sem backup';

  @override
  String get backupWarnAfter => 'Avisar se não concluir em';

  @override
  String get backupWhat => 'O que fazer backup';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'Em uma pasta que você não escolheu',
      'folder_new': 'Em uma pasta nova: escolha se fará backup',
      'type_excluded': 'Um tipo de item que você não escolheu',
      'before_date': 'Capturado antes da data escolhida',
      'selected': 'Aguardando a vez',
      'server_restored':
          'O servidor o perdeu em uma restauração: enviando de novo',
      'working': 'Fazendo backup',
      'waiting_for_icloud': 'Aguardando o download do iCloud',
      'metered': 'Aguardando uma rede não limitada',
      'metered_cap': 'Grande demais para uma rede limitada',
      'unreadable': 'Este dispositivo não consegue lê-lo',
      'changed': 'Mudou enquanto era enviado',
      'quota': 'Seu armazenamento no servidor está cheio',
      'other': 'O servidor o recusou: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'O servidor não funciona mais com esta versão do Photolib.';

  @override
  String get checkAppTooOldNext => 'Atualize o Photolib.';

  @override
  String get checkChanged =>
      'O certificado do servidor não é o que você aceitou.';

  @override
  String get checkChangedNext =>
      'Se o administrador o trocou, confie no novo. Se não, alguém pode estar escutando: não continue.';

  @override
  String get checkClock =>
      'O relógio deste dispositivo e o do servidor diferem em mais de cinco minutos.';

  @override
  String get checkClockNext =>
      'Deixe o dispositivo ajustar a data e a hora automaticamente.';

  @override
  String get checkDnsFailed => 'O nome do servidor não leva a nenhum endereço.';

  @override
  String get checkDnsFailedNext =>
      'Confira o endereço ou conecte-se à rede do servidor.';

  @override
  String checkExpired(String date) {
    return 'O certificado do servidor expirou em $date.';
  }

  @override
  String get checkFailed => 'Falhou';

  @override
  String get checkMetered =>
      'Você está em uma rede limitada, como dados móveis.';

  @override
  String get checkMeteredNext =>
      'Conecte-se ao Wi-Fi antes de backups grandes.';

  @override
  String get checkNotPhotolib =>
      'Outra coisa que não o Photolib responde, como a página de erro de um proxy ou uma página de login do Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Entre no Wi-Fi pelo navegador ou peça ao administrador para verificar o proxy.';

  @override
  String get checkOtherServer =>
      'Outro servidor do Photolib responde neste endereço.';

  @override
  String get checkPassed => 'Aprovado';

  @override
  String get checkRefused => 'Nada responde neste endereço.';

  @override
  String get checkRefusedNext =>
      'Verifique se o servidor está ligado e se você está na rede ou VPN dele.';

  @override
  String get checkRun => 'Verificar a conexão';

  @override
  String get checkRunning => 'Verificando';

  @override
  String get checkSelfSigned =>
      'O servidor usa um certificado próprio, que este dispositivo ainda não conhece.';

  @override
  String get checkSkipped => 'Não verificado';

  @override
  String get checkStepAuth => 'Seu login';

  @override
  String get checkStepClock => 'O relógio do seu dispositivo';

  @override
  String get checkStepDns => 'Encontrar o endereço do servidor';

  @override
  String get checkStepNetwork => 'Sua rede';

  @override
  String get checkStepServer => 'Photolib no servidor';

  @override
  String get checkStepTcp => 'Chegar ao servidor';

  @override
  String get checkStepTls => 'Conexão segura e certificado';

  @override
  String get checkStepUpload => 'Envios grandes por proxies';

  @override
  String get checkTimedOut =>
      'O servidor está demorando demais para responder.';

  @override
  String get checkTimedOutNext => 'Verifique sua conexão e tente de novo.';

  @override
  String get checkTitle => 'Verificação da conexão';

  @override
  String get checkTlsFailed => 'A conexão segura falhou.';

  @override
  String get checkTrustNext =>
      'Confie nele só se a impressão digital for igual à do seu servidor.';

  @override
  String get checkUntrusted =>
      'O certificado do servidor vem de uma autoridade em que este dispositivo não confia.';

  @override
  String get checkUploadCap =>
      'Um proxy no caminho recusa envios grandes, então os backups ficam mais lentos, em pedaços pequenos.';

  @override
  String get checkUploadCapNext =>
      'Peça ao administrador para deixar passar pelo proxy solicitações de 64 MB.';

  @override
  String get collectionAlbums => 'Álbuns';

  @override
  String collectionHide(String name) {
    return 'Ocultar $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Mover $name para baixo';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Mover $name para cima';
  }

  @override
  String get collectionPeople => 'Pessoas';

  @override
  String collectionPin(String name) {
    return 'Fixar $name';
  }

  @override
  String get collectionPlaces => 'Lugares';

  @override
  String collectionShow(String name) {
    return 'Mostrar $name';
  }

  @override
  String get collectionTags => 'Tags';

  @override
  String collectionUnpin(String name) {
    return 'Desafixar $name';
  }

  @override
  String get collectionsCustomise => 'Personalizar';

  @override
  String get collectionsDone => 'Concluído';

  @override
  String get commandPalette => 'Paleta de comandos';

  @override
  String get commandPaletteHint => 'Digite um comando';

  @override
  String get dateFormatDefault => 'Padrão do idioma';

  @override
  String get dateFormatDmy => 'Dia-mês-ano';

  @override
  String get dateFormatMdy => 'Mês-dia-ano';

  @override
  String get dateFormatYmd => 'Ano-mês-dia';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString neste dispositivo e com backup',
      many: '$countString de itens neste dispositivo e com backup',
      one: '$countString neste dispositivo e com backup',
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
      other: '$countString só neste dispositivo, sem backup',
      many: '$countString de itens só neste dispositivo, sem backup',
      one: '$countString só neste dispositivo, sem backup',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Com as Fotos do iCloud ativadas, os itens excluídos deste dispositivo também saem do iCloud e dos seus outros dispositivos Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString só na sua biblioteca',
      many: '$countString de itens só na sua biblioteca',
      one: '$countString só na sua biblioteca',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Remover deste dispositivo';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Os $countString itens com backup; sua biblioteca os mantém',
      many: 'Os $countString de itens com backup; sua biblioteca os mantém',
      one: '$countString item com backup; sua biblioteca o mantém',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'As cópias neste dispositivo vão para a lixeira dele: o espaço volta quando ela for esvaziada.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Excluir $countString itens?',
      many: 'Excluir $countString de itens?',
      one: 'Excluir $countString item?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Deste dispositivo e da sua biblioteca',
      'device': 'Só deste dispositivo',
      'other': 'Da sua biblioteca',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Não presente';

  @override
  String get deviceFolderCard => 'Cartão SD';

  @override
  String get deviceFolderExclude => 'Excluir';

  @override
  String get deviceFolderExcludeThis => 'Excluir esta pasta';

  @override
  String get deviceFolderExcludedNotice =>
      'A pasta deste item está excluída da sua biblioteca';

  @override
  String get deviceFolderForget => 'Remover da lista';

  @override
  String get deviceFolderInternal => 'Armazenamento interno';

  @override
  String get deviceFolderKeep => 'Manter';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, é nova';
  }

  @override
  String get deviceFolders => 'Pastas do dispositivo';

  @override
  String get deviceFoldersAll => 'Mostrar todas as pastas exceto as excluídas';

  @override
  String get deviceFoldersChosen => 'Mostrar só as pastas escolhidas';

  @override
  String get deviceFoldersExcludedNow => 'Excluída da biblioteca';

  @override
  String get deviceFoldersSearch => 'Pesquisar pastas';

  @override
  String get diagnosticsAdvanced => 'Mostrar diagnóstico';

  @override
  String get diagnosticsAllLoggers => 'Todos os registradores';

  @override
  String get diagnosticsCopied => 'Registro copiado';

  @override
  String get diagnosticsCopy => 'Copiar o registro exibido';

  @override
  String get diagnosticsEmpty => 'Nenhuma entrada de registro ainda';

  @override
  String get diagnosticsExport => 'Exportar pacote de diagnóstico';

  @override
  String get diagnosticsExported => 'Pacote de diagnóstico salvo';

  @override
  String get diagnosticsLevel => 'Nível';

  @override
  String get diagnosticsLogger => 'Registrador';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get download => 'Baixar';

  @override
  String get downloadCurrent => 'Versão atual, com as edições';

  @override
  String get downloadFailed => 'Não foi possível baixar';

  @override
  String get downloadOriginal => 'Original';

  @override
  String downloadSaved(String name) {
    return '$name salvo';
  }

  @override
  String get downloadVersion => 'Qual versão?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baixando $countString itens',
      many: 'Baixando $countString de itens',
      one: 'Baixando $countString item',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Melhorar automaticamente';

  @override
  String get editorCrop => 'Cortar';

  @override
  String get editorCropOriginal => 'Original';

  @override
  String get editorCropSquare => 'Quadrado';

  @override
  String get editorEdit => 'Editar';

  @override
  String get editorFlip => 'Espelhar';

  @override
  String get editorRotate => 'Girar';

  @override
  String get editorSaveCopy => 'Salvar cópia';

  @override
  String get editorSaveFailed => 'Não foi possível salvar a cópia';

  @override
  String get editorSaveVersion => 'Guardar';

  @override
  String get editorSaved => 'Salva como cópia';

  @override
  String get editorVersionFailed => 'Não foi possível guardar a versão';

  @override
  String get editorVersionSaved => 'Guardado como nova versão';

  @override
  String get editorVersionsUnsupported =>
      'Este servidor ainda não consegue guardar versões de fotos editadas';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString alterações foram desfeitas: o servidor as recusou.',
      many:
          '$countString de alterações foram desfeitas: o servidor as recusou.',
      one: '$countString alteração foi desfeita: o servidor a recusou.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Fechar';

  @override
  String get editsRejectedForbidden =>
      'Você pode ver os itens, mas não alterá-los.';

  @override
  String get editsRejectedInvalid =>
      'O servidor não conseguiu aceitar as alterações.';

  @override
  String get editsRejectedNotFound =>
      'Os itens foram excluídos ou não são mais compartilhados com você.';

  @override
  String get errorNotFound => 'Esta página não existe';

  @override
  String get errorRetry => 'Tentar novamente';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String faceNumber(int number) {
    return 'Rosto $number';
  }

  @override
  String get facesAgree => 'Concordo';

  @override
  String get facesAura => 'Descrever rostos com o AuraFace (download maior)';

  @override
  String get facesNotNow => 'Agora não';

  @override
  String get facesNoticeKeep =>
      'O que é encontrado fica com as suas fotos, nos seus dispositivos e no seu servidor. As descrições nunca são exibidas nem compartilhadas, e tudo é apagado quando você para ou apaga a foto.';

  @override
  String get facesNoticeOptional =>
      'É opcional. Todo o resto do Photolib funciona sem isso, e você pode parar a qualquer momento nos Ajustes.';

  @override
  String get facesNoticeTitle => 'Encontrar rostos nas suas fotos?';

  @override
  String get facesNoticeWhat =>
      'O Photolib procura rostos nas suas fotos e vídeos e guarda, para cada um, onde está e uma lista de números que o descreve, para encontrar a mesma pessoa de novo. Essa descrição pode ser considerada um dado biométrico.';

  @override
  String get facesNoticeWhere =>
      'Isso acontece neste dispositivo e, se você estiver conectado, no seu próprio servidor. Nunca em um serviço nosso ou de terceiros.';

  @override
  String get facesServerFailed =>
      'Não foi possível avisar o seu servidor. Tente de novo.';

  @override
  String get facesServerOff => 'Seu servidor não encontra rostos para você';

  @override
  String get facesServerOn => 'Seu servidor encontra rostos para você';

  @override
  String get facesServerUnavailable =>
      'Seu servidor não oferece reconhecimento facial';

  @override
  String facesStatusDownloading(int percent) {
    return 'Baixando os modelos de rostos: $percent%';
  }

  @override
  String get facesStatusMissing =>
      'Seu servidor não instalou os modelos de rostos';

  @override
  String get facesStatusNoDecoder =>
      'A busca de rostos não está disponível: a biblioteca de imagens (libvips) não foi encontrada. Reinstale o Photolib, ou instale o libvips e reinicie-o.';

  @override
  String get facesStatusRunning => 'Encontrando rostos neste dispositivo';

  @override
  String get facesStatusUnavailable =>
      'Não é possível encontrar rostos neste dispositivo';

  @override
  String get facesStatusWaiting => 'Os modelos de rostos são baixados no Wi-Fi';

  @override
  String get facesSwitch => 'Encontrar rostos nas minhas fotos';

  @override
  String get facesSwitchOff =>
      'Desativado. Nada sobre rostos é calculado até você concordar.';

  @override
  String get facesSwitchOn =>
      'Ativado. O Photolib encontra os rostos nas suas fotos.';

  @override
  String get facesTitle => 'Rostos e pessoas';

  @override
  String get facesWithdraw => 'Apagar e parar';

  @override
  String get facesWithdrawBody =>
      'Isso apaga todos os rostos, descrições e pessoas que o Photolib encontrou para você, neste dispositivo e no seu servidor. Suas fotos não mudam.';

  @override
  String get facesWithdrawTitle => 'Parar de encontrar rostos?';

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

    return 'Arquivos não alterados: $countString';
  }

  @override
  String get folderAllow => 'Permitir acesso a esta pasta';

  @override
  String get folderDelete => 'Excluir pasta';

  @override
  String folderDeleteBody(String name) {
    return 'Mover as fotos e os vídeos de $name para a lixeira?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString itens',
      many: '$countString de itens',
      one: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Nova pasta';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Off-line, $countString itens',
      many: 'Off-line, $countString de itens',
      one: 'Off-line, $countString item',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Esta pasta já está na biblioteca, ou contém uma pasta da biblioteca ou está dentro de uma';

  @override
  String get folderRemove => 'Remover pasta';

  @override
  String folderRemoveBody(String folder) {
    return 'As fotos e os vídeos de $folder serão removidos da biblioteca. Os arquivos continuarão intactos no disco.';
  }

  @override
  String get folderRemoveConfirm => 'Remover';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Analisando, $countString itens até agora',
      many: 'Analisando, $countString de itens até agora',
      one: 'Analisando, $countString item até agora',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Permitir acesso';

  @override
  String get foldersHideExcluded => 'Ocultar pastas excluídas';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O Photolib já não consegue ler $countString pastas.',
      many: 'O Photolib já não consegue ler $countString de pastas.',
      one: 'O Photolib já não consegue ler $countString pasta.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Mostrar pastas excluídas ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Este navegador não pode usar uma pasta como sua biblioteca. Abra o Photolib no Chrome ou no Edge em um computador ou use o app para desktop.';

  @override
  String get galleryButtons => 'Botões';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Grade';

  @override
  String get galleryMenus => 'Menus e painéis';

  @override
  String get galleryShowSheet => 'Mostrar um painel';

  @override
  String get galleryTitle => 'Componentes';

  @override
  String hiddenCollections(int count) {
    return 'Ocultas ($count)';
  }

  @override
  String get indexingAllowMetered => 'Baixar com dados móveis';

  @override
  String get indexingAllowSaver => 'Também no modo de economia de energia';

  @override
  String get indexingBattery => 'Bateria necessária sem carregador';

  @override
  String get indexingChargingOnly => 'Apenas durante o carregamento';

  @override
  String indexingDownloading(int percent) {
    return 'Baixando o modelo de busca: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Não foi possível ler $count fotos',
      many: 'Não foi possível ler $count de fotos',
      one: 'Não foi possível ler $count foto',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Este dispositivo indexa só as fotos novas';

  @override
  String get indexingMissing => 'Seu servidor não instalou o modelo de busca';

  @override
  String get indexingModels => 'Buscar neste dispositivo';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Baixa o modelo de busca ($megabytesString MB) de $host';
  }

  @override
  String get indexingNoDecoder =>
      'A busca e a leitura de texto não estão disponíveis: a biblioteca de imagens (libvips) não foi encontrada. Reinstale o Photolib, ou instale o libvips e reinicie-o.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Em pausa enquanto a bateria estiver abaixo de $percent%';
  }

  @override
  String get indexingPausedCharger => 'Em pausa até o dispositivo carregar';

  @override
  String get indexingPausedHeat =>
      'Em pausa enquanto o dispositivo estiver quente';

  @override
  String get indexingPausedSaver =>
      'Em pausa enquanto a economia de bateria estiver ativa';

  @override
  String indexingPercent(int percent) {
    return '$percent%';
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
  String get indexingText => 'Ler o texto das fotos';

  @override
  String indexingTextDownloading(int percent) {
    return 'A transferir os modelos de texto: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Transfere os modelos de texto ($megabytesString MB) de $host; encontra as palavras nas suas fotos';
  }

  @override
  String get indexingTextMissing =>
      'O seu servidor não instalou os modelos de texto';

  @override
  String get indexingTextPlatform =>
      'Usa o reconhecimento de texto do telemóvel; nada a transferir. Lê as fotos novas';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Fotos lidas para texto: $doneString de $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Ler texto não está disponível aqui';

  @override
  String get indexingTextWaiting =>
      'Os modelos de texto são transferidos por Wi-Fi';

  @override
  String get indexingUnavailable =>
      'A busca neste dispositivo não está disponível aqui';

  @override
  String get indexingWaiting => 'O modelo de busca é baixado pelo Wi-Fi';

  @override
  String get infoAddName => 'Adicionar nome';

  @override
  String get infoAddTag => 'Adicionar tag';

  @override
  String get infoAlbums => 'Álbuns';

  @override
  String get infoAllMetadata => 'Ver todos os metadados';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Com backup';

  @override
  String get infoCamera => 'Câmera';

  @override
  String get infoChangeAdjust => 'Cores ajustadas';

  @override
  String get infoChangeCrop => 'Recortada';

  @override
  String get infoChangeFlip => 'Espelhada';

  @override
  String get infoChangeInpaint => 'Área preenchida';

  @override
  String get infoChangeLocal => 'Área ajustada';

  @override
  String get infoChangeLut => 'Aplicado um estilo de cor';

  @override
  String get infoChangeOther => 'Editada';

  @override
  String get infoChangeTurn => 'Rodada';

  @override
  String get infoCompare => 'Comparar com o original';

  @override
  String infoConfidence(String percent) {
    return 'Confiança: $percent';
  }

  @override
  String get infoCopyPath => 'Copiar caminho';

  @override
  String get infoCurrent => 'Atual';

  @override
  String get infoDescription => 'Adicionar uma descrição';

  @override
  String get infoEditDate => 'Editar a data';

  @override
  String infoEditNumber(int number) {
    return 'Edição $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Cópia editada de $name';
  }

  @override
  String get infoFaces => 'Rostos';

  @override
  String get infoFile => 'Arquivo';

  @override
  String get infoFromFileName => 'do nome do arquivo';

  @override
  String get infoHistory => 'Histórico de edições';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      many: '$count de itens',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Local';

  @override
  String get infoMap => 'Mapa do local onde foi tirada';

  @override
  String get infoMapAgree =>
      'Os blocos do mapa vêm da internet e revelam a área que você vê';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Nova tag: $path';
  }

  @override
  String get infoNoAlbum => 'Não está em nenhum álbum';

  @override
  String get infoOnDevice => 'Neste dispositivo';

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
    return 'Remover de $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Remover $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Removido de $album';
  }

  @override
  String get infoRevert => 'Reverter';

  @override
  String get infoSaveCopy => 'Salvar como cópia';

  @override
  String get infoShared => 'compartilhado';

  @override
  String get infoShowFaces => 'Mostrar rostos na foto';

  @override
  String get infoShowMap => 'Mostrar mapa';

  @override
  String get infoTags => 'Tags';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versões',
      many: '$count de versões',
      one: '$count versão',
    );
    return '$_temp0 · última $time';
  }

  @override
  String get infoWhy => 'Por que esta data?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Lida no arquivo, como $tag',
      'name': 'Lida no nome do arquivo',
      'folder': 'Lida no nome de uma pasta',
      'host': 'Informada pelo serviço de onde veio o arquivo',
      'unknown': 'Nada no arquivo indica a data, então vale a data da última alteração',
      'other': 'O arquivo ainda não foi lido, então vale a data informada pelo dispositivo',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Lista',
      'other': 'Grade',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Nome',
      'taken': 'Data de captura',
      'modified': 'Data de modificação',
      'size': 'Tamanho',
      'random': 'Aleatório',
      'extension': 'Tipo',
      'custom': 'Ordem do álbum',
      'other': 'Data de captura',
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
  String get keyShift => 'Shift';

  @override
  String get languageDevice => 'Idioma do dispositivo';

  @override
  String get languageName => 'Português (Brasil)';

  @override
  String get libraryAddFolder => 'Adicionar pasta';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Sem backup',
      'backed_up': 'Com backup',
      'cloud_only': 'Só na nuvem',
      'other': 'Tudo',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Tudo tem backup',
      'backed_up': 'Nada tem backup ainda',
      'cloud_only': 'Nada está só no servidor',
      'other': 'Nada aqui',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Selos de backup';

  @override
  String get libraryEmpty => 'Suas fotos vão aparecer aqui';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Agrupar por semana',
      'month': 'Agrupar por mês',
      'other': 'Agrupar por dia',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Ocultar de novo os itens ocultos e arquivados';

  @override
  String get libraryNoKeyring =>
      'O Photolib guarda a chave da sua biblioteca no chaveiro do sistema, que não está em execução ou está bloqueado. Inicie ou desbloqueie um chaveiro, como o GNOME Keyring ou o KWallet, e tente novamente.';

  @override
  String get libraryRevealExcluded =>
      'Mostrar as pastas excluídas por 5 minutos';

  @override
  String get libraryShowVeiled =>
      'Mostrar os itens ocultos e arquivados por 5 minutos';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Adicionados recentemente',
      'other': 'Data de captura',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'O Photolib não conseguiu abrir a biblioteca guardada neste dispositivo';

  @override
  String get libraryViewOptions => 'Opções de visualização';

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
  String get libraryZoomIn => 'Miniaturas maiores';

  @override
  String get libraryZoomOut => 'Miniaturas menores';

  @override
  String get mapAddTrack => 'Adicionar um trajeto GPX';

  @override
  String get mapArea => 'Área do mapa';

  @override
  String get mapAttribution => '© colaboradores do OpenStreetMap';

  @override
  String get mapClearLasso => 'Limpar a seleção';

  @override
  String get mapEmpty => 'Ainda não há fotos com localização';

  @override
  String get mapHeat => 'Mapa de calor';

  @override
  String get mapLasso => 'Selecionar desenhando em volta das fotos';

  @override
  String get mapLoading => 'A colocar as fotos no mapa';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fotos: $countString';
  }

  @override
  String get mapSearchHere => 'Pesquisar nesta área';

  @override
  String get mapSplit => 'Mostrar as fotos sob o mapa';

  @override
  String get mapTilesAgree =>
      'O fundo do mapa vem do servidor do OpenStreetMap (tile.openstreetmap.org), que vê que área você está olhando';

  @override
  String get mapTilesShow => 'Mostrar o fundo';

  @override
  String get mapTime => 'Intervalo de tempo';

  @override
  String get mapTitle => 'Mapa';

  @override
  String get mapTrackBad => 'Este arquivo não tem trajetos GPX';

  @override
  String get mapTrips => 'Viagens';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favorito',
      'hidden': 'Oculto',
      'archived': 'Arquivado',
      'offline': 'Mantido neste dispositivo',
      'offline': 'Mantido neste dispositivo',
      'offline': 'Mantido neste dispositivo',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Permitir acesso';

  @override
  String get mediaAccessNone =>
      'O Photolib precisa de acesso às suas fotos e vídeos para mostrá-los.';

  @override
  String get mediaAccessPartial =>
      'O Photolib só vê as fotos e os vídeos que você selecionou. Uma galeria precisa de acesso a todos eles.';

  @override
  String get mediaAccessSelect => 'Selecionar mais fotos';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nextAddRoot =>
      'Adicione a pasta a external_roots na configuração do servidor e reinicie o servidor.';

  @override
  String get nextAskAdmin => 'Pergunte ao administrador do seu servidor.';

  @override
  String get nextAskOwner =>
      'Peça a quem é dono da biblioteca para deixar você adicionar fotos.';

  @override
  String get nextCheckConnection => 'Verifique a conexão para saber o porquê.';

  @override
  String get nextCheckEntry => 'Confira o que você digitou e tente de novo.';

  @override
  String get nextConfirm =>
      'Confira quantos itens são afetados e depois confirme.';

  @override
  String get nextDeleteWebhook =>
      'Exclua um webhook que você não usa mais e tente novamente.';

  @override
  String get nextEditConfig =>
      'Altere isso na configuração do servidor e reinicie o servidor.';

  @override
  String get nextFreeSpace =>
      'Libere espaço ou peça mais ao seu administrador.';

  @override
  String get nextNewLink => 'Peça um novo ao seu administrador.';

  @override
  String get nextNewestToken => 'Copie o mais recente do log do photolibd.';

  @override
  String get nextOtherAdmin => 'Primeiro torne outra conta administradora.';

  @override
  String get nextOtherFolder => 'Escolha uma pasta só dela.';

  @override
  String get nextRefresh => 'Atualize e tente de novo.';

  @override
  String get nextReport =>
      'Tente de novo. Se acontecer outra vez, copie os detalhes abaixo para o seu administrador.';

  @override
  String get nextSetUpPrivate =>
      'Termine de configurar as bibliotecas privadas em Configurações e tente de novo.';

  @override
  String get nextSignIn => 'Entre de novo.';

  @override
  String get nextSignInAccount => 'Entre com sua conta e tente de novo.';

  @override
  String get nextSignInInstead => 'Entre em vez disso.';

  @override
  String get nextTryAgain => 'Tente de novo.';

  @override
  String get nextUpdateAndAgree =>
      'Atualize o app e concorde com o aviso de novo.';

  @override
  String get nextUseAnother => 'Escolha outro.';

  @override
  String get nextUseHttps =>
      'Use o endereço https:// do servidor ou conecte-se pela rede do servidor.';

  @override
  String get nextWait => 'Espere um minuto e tente de novo.';

  @override
  String get offlineKeep => 'Manter off-line';

  @override
  String offlineKeepHere(String size) {
    return 'Manter neste dispositivo ($size)';
  }

  @override
  String get offlineKeptHere => 'Mantido neste dispositivo';

  @override
  String get offlineStopKeeping => 'Parar de manter off-line';

  @override
  String get otherFiles => 'Outros arquivos';

  @override
  String get passphraseCreate =>
      'Este computador não executa nenhum chaveiro (Secret Service) para guardar as chaves do Photolib. Escolha uma frase secreta de pelo menos 10 caracteres para protegê-las: o Photolib a pede sempre que é iniciado.';

  @override
  String get passphraseLabel => 'Frase secreta';

  @override
  String get passphraseMismatch => 'As frases secretas não coincidem.';

  @override
  String get passphraseRepeat => 'Repita a frase secreta';

  @override
  String get passphraseTooShort => 'Use pelo menos 10 caracteres.';

  @override
  String get passphraseUnlock =>
      'Digite a frase secreta que protege as chaves do Photolib neste computador.';

  @override
  String get passphraseWrong => 'Frase secreta incorreta. Tente novamente.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index de $count';
  }

  @override
  String get privacyCheckKit => 'Verificar kit de recuperação';

  @override
  String get privacyDrillDue =>
      'Hora de um teste de recuperação: confira se seu kit de recuperação ainda desbloqueia suas bibliotecas privadas.';

  @override
  String get privacyHonest =>
      'As bibliotecas privadas são criptografadas nos seus dispositivos, e ninguém mais pode abri-las: nem o servidor, nem o administrador dele, nem os desenvolvedores do Photolib. Se você perder a senha e o kit de recuperação, suas fotos estarão perdidas para sempre, e ninguém poderá recuperá-las para você.';

  @override
  String get privacyKitBody =>
      'Escreva estas 24 palavras em papel, na ordem, e guarde-as em um lugar seguro. Elas desbloqueiam suas bibliotecas privadas se você esquecer a senha, para quem as tiver.';

  @override
  String get privacyKitDone => 'Seu kit de recuperação funciona.';

  @override
  String get privacyKitOther => 'Este não é o seu kit de recuperação atual.';

  @override
  String get privacyKitTitle => 'Seu kit de recuperação';

  @override
  String get privacyKitUnverified => 'Kit de recuperação ainda não verificado';

  @override
  String privacyKitVerified(String date) {
    return 'Kit de recuperação verificado em $date';
  }

  @override
  String get privacyKitWritten => 'Já anotei';

  @override
  String get privacyNotReady =>
      'Os envios privados continuam desativados até você ter duas formas de desbloqueio e verificar seu kit de recuperação.';

  @override
  String get privacyPasswordHelp =>
      'Digite a senha da sua conta: ela se torna uma forma de desbloquear suas bibliotecas privadas.';

  @override
  String get privacyPhrase => 'Frase de recuperação';

  @override
  String get privacyPhraseHelp => 'As 24 palavras do seu kit de recuperação';

  @override
  String get privacyPhraseInvalid =>
      'Esta não é uma frase de recuperação. Confira cada palavra.';

  @override
  String get privacyReady => 'Os envios privados estão ativados.';

  @override
  String get privacyRecoveryKit => 'Kit de recuperação';

  @override
  String get privacySetUp => 'Configurar';

  @override
  String get privacyShowWords => 'Mostrar as palavras de novo';

  @override
  String get privacyTitle => 'Bibliotecas privadas';

  @override
  String privacyUnknownWord(int number) {
    return 'A palavra $number não é uma palavra de kit de recuperação.';
  }

  @override
  String get privacyVerify => 'Verificar';

  @override
  String get privacyVerifyBody =>
      'Digite estas palavras do seu kit de recuperação para mostrar que você o guardou.';

  @override
  String get privacyWays => 'Formas de desbloqueio';

  @override
  String privacyWord(int number) {
    return 'Palavra $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Estas palavras não correspondem ao seu kit de recuperação. Confira o que você anotou.';

  @override
  String get privacyWrongPassword => 'Esta não é a senha da sua conta.';

  @override
  String get problemAdminOnly => 'Só um administrador pode fazer isso.';

  @override
  String get problemBusy => 'O servidor está ocupado ou reiniciando.';

  @override
  String get problemChanged => 'Isso mudou nesse meio-tempo.';

  @override
  String get problemConfirm =>
      'Isso ocultaria ou apagaria mais itens do que o servidor faz sem uma confirmação';

  @override
  String get problemContribute =>
      'Você não pode adicionar fotos a esta biblioteca.';

  @override
  String get problemCopy => 'Copiar detalhes';

  @override
  String get problemDetails => 'Detalhes';

  @override
  String get problemDiskLow =>
      'O disco do servidor está quase cheio, por isso os envios estão em pausa.';

  @override
  String get problemEmailTaken => 'Outra conta tem este e-mail.';

  @override
  String get problemExists => 'Já existe.';

  @override
  String get problemFaceNotice =>
      'Seu servidor pede uma versão mais nova do aviso sobre rostos do que a mostrada por este app.';

  @override
  String get problemGone => 'Não está mais no servidor.';

  @override
  String get problemHandleTaken => 'Outra conta tem este nome de usuário.';

  @override
  String get problemInterrupted => 'O envio foi interrompido.';

  @override
  String get problemInvalid => 'Um valor não é válido';

  @override
  String get problemLastAdmin =>
      'O servidor precisa de pelo menos um administrador.';

  @override
  String get problemLinkInvalid => 'Este link expirou ou já foi usado.';

  @override
  String get problemLoginFailed =>
      'E-mail, nome de usuário ou senha incorretos.';

  @override
  String get problemMaintenanceKey =>
      'Backups, verificações de integridade e exclusões definitivas só podem ser pausados após fazer login, não com uma chave de API';

  @override
  String get problemNotAllowed => 'Sua conta não pode fazer isso.';

  @override
  String get problemNotExternal =>
      'Só é possível verificar bibliotecas das pastas do próprio servidor.';

  @override
  String get problemOidcClaim =>
      'Seu provedor de login não informou quem você é de um jeito que este servidor aceite.';

  @override
  String get problemOidcDown =>
      'Seu provedor de login não responde ao servidor.';

  @override
  String get problemOidcFailed => 'Seu provedor de login recusou o acesso.';

  @override
  String get problemOidcNotAllowed => 'Sua conta não pode entrar desta forma.';

  @override
  String get problemOidcTaken =>
      'Este login já está vinculado a outra conta do Photolib.';

  @override
  String get problemOidcUnknown =>
      'Este servidor não oferece mais esta forma de entrar.';

  @override
  String get problemPasskeysOff =>
      'As chaves de acesso só funcionam quando o servidor tem seu endereço público.';

  @override
  String get problemPinned =>
      'Isso está definido no arquivo de configuração e não pode ser alterado aqui.';

  @override
  String get problemPolicyOff => 'Isso está desativado neste servidor.';

  @override
  String get problemQuota => 'Seu armazenamento no servidor está cheio.';

  @override
  String get problemRestoreKey =>
      'Um backup só pode ser restaurado após fazer login, não com uma chave de API.';

  @override
  String get problemRootDiffers =>
      'Esta pasta não contém os arquivos desta biblioteca';

  @override
  String get problemRootNotAllowed =>
      'Esta pasta não está sob as external_roots da configuração do servidor';

  @override
  String get problemRootOverlaps =>
      'Esta pasta contém outra biblioteca ou os dados do próprio servidor, ou está dentro deles';

  @override
  String get problemScanning => 'Esta biblioteca já está sendo analisada';

  @override
  String get problemSecondFactor =>
      'Esta conta precisa de um segundo fator, como um código de autenticação ou uma chave de acesso, que esta versão do Photolib ainda não consegue fornecer.';

  @override
  String get problemSetupDone => 'Este servidor já tem um administrador.';

  @override
  String get problemSetupExpired => 'Isso demorou demais.';

  @override
  String get problemSetupToken => 'Este token de configuração está errado.';

  @override
  String get problemSignedOut => 'Você saiu do servidor.';

  @override
  String get problemStepUp =>
      'Esta alteração precisa primeiro da sua senha ou de um código.';

  @override
  String get problemStorage =>
      'O servidor não alcança o próprio armazenamento.';

  @override
  String get problemTooMany => 'Muitas tentativas em pouco tempo.';

  @override
  String get problemUnexpected => 'Algo inesperado deu errado.';

  @override
  String get problemUnreachable => 'O servidor não responde.';

  @override
  String get problemUploadDamaged =>
      'O arquivo mudou ou foi danificado no caminho.';

  @override
  String get problemUploadExpired =>
      'O servidor não tem mais este envio: envios incompletos expiram após um dia.';

  @override
  String get problemWebhookLimit =>
      'Sua conta já tem tantos webhooks quanto pode ter.';

  @override
  String get problemWebhooksOff =>
      'Os webhooks estão desativados neste servidor.';

  @override
  String get recoveryCode => 'Código de recuperação';

  @override
  String get recoveryCodeAbout =>
      'Abre o armazenamento do Photolib neste dispositivo se o chaveiro perder a chave dele';

  @override
  String get recoveryCodeEnter => 'Inserir código de recuperação';

  @override
  String get recoveryCreate => 'Criar código de recuperação';

  @override
  String get recoveryLater => 'Mais tarde';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString alterações existem só neste dispositivo. Um código de recuperação as traz de volta se o chaveiro perder a chave do Photolib.',
      many:
          '$countString alterações existem só neste dispositivo. Um código de recuperação as traz de volta se o chaveiro perder a chave do Photolib.',
      one:
          '$countString alteração existe só neste dispositivo. Um código de recuperação a traz de volta se o chaveiro perder a chave do Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Anote estas 24 palavras e guarde-as em local seguro: elas abrem o armazenamento do Photolib neste dispositivo sem a chave do chaveiro. Elas substituem qualquer código anterior.';

  @override
  String get recoveryUnlock => 'Desbloquear';

  @override
  String get recoveryWrong =>
      'Esse não é o código de recuperação deste armazenamento';

  @override
  String get renameFind => 'Localizar';

  @override
  String get renamePattern => 'Novo nome';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Longo demais: um nome tem no máximo 255 bytes',
      'invalid': 'Nome de arquivo inválido',
      'duplicate': 'Dado também a outro arquivo',
      'exists': 'Outro arquivo desta pasta tem este nome',
      'other': 'Não é possível renomear',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Substituir por';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Arquivos renomeados: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Mostrar no Finder',
      'windows': 'Mostrar no Explorador',
      'other': 'Mostrar na pasta',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Câmera';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString itens',
      many: '$countString de itens',
      one: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Datas';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Pesquise na sua biblioteca';

  @override
  String get searchFavourites => 'Favoritos';

  @override
  String get searchFolder => 'Pasta';

  @override
  String get searchHint => 'Nome do arquivo ou da pasta';

  @override
  String get searchMotionPhotos => 'Fotos com movimento';

  @override
  String get searchNothing => 'Nenhum resultado';

  @override
  String get searchPanoramas => 'Panoramas';

  @override
  String get searchPhotos => 'Fotos';

  @override
  String get searchScreenshots => 'Capturas de tela';

  @override
  String get searchVideo => 'Vídeo';

  @override
  String get searchVideos => 'Vídeos';

  @override
  String get securityAddPasskey => 'Adicionar chave de acesso';

  @override
  String get securityCode => 'Código';

  @override
  String get securityCodesHelp =>
      'Guarde estes códigos em um lugar seguro. Cada um funciona uma vez no lugar do seu segundo fator, e eles só são mostrados agora.';

  @override
  String securityCodesLeft(int count) {
    return 'Não usados: $count';
  }

  @override
  String get securityNewCodes => 'Novos códigos';

  @override
  String get securityPasskeyNotAdded =>
      'Nenhuma chave de acesso foi adicionada.';

  @override
  String get securityRecoveryCodes => 'Códigos de recuperação';

  @override
  String get securityRemovePasskey => 'Remover chave de acesso';

  @override
  String get securitySetUp => 'Configurar';

  @override
  String get securityStepUpBody =>
      'Digite sua senha, um código do seu app autenticador ou um código de recuperação para alterar seus segundos fatores.';

  @override
  String get securityStepUpTitle => 'Confirme que é você';

  @override
  String get securityTitle => 'Segundos fatores';

  @override
  String get securityTotp => 'App autenticador';

  @override
  String get securityTotpHelp =>
      'Adicione esta chave ao seu app autenticador e digite o código que ele mostrar.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Ativado',
      'other': 'Desativado',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Desativar';

  @override
  String get securityWrongCode => 'Esse código está errado.';

  @override
  String get securityWrongProof => 'Senha ou código incorretos.';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get selectionClear => 'Limpar seleção';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selecionados',
      many: '$countString de itens selecionados',
      one: '$countString selecionado',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Mostrar selecionados';

  @override
  String get serverAccount => 'E-mail ou nome de usuário';

  @override
  String get serverAdd => 'Adicionar um servidor';

  @override
  String get serverAddressInvalid => 'Digite endereços como photos.example.org';

  @override
  String get serverAddresses => 'Endereços';

  @override
  String get serverAddressesHelp =>
      'Um por linha: o servidor na sua rede, na internet ou por uma VPN. O app usa o mais rápido que responder. Ou cole o link para definir a senha que você recebeu.';

  @override
  String get serverCa => 'Certificado da CA privada (PEM)';

  @override
  String get serverCaChoose => 'Escolher um arquivo de certificado';

  @override
  String serverCertificateBody(String host) {
    return '$host apresenta um certificado em que este dispositivo não confia. Confie nele só se esta impressão digital SHA-256 for a do seu servidor:';
  }

  @override
  String get serverCertificateTitle => 'Confiar neste certificado?';

  @override
  String get serverConfirm => 'Confirmar';

  @override
  String get serverConnect => 'Conectar';

  @override
  String get serverCreateAdmin => 'Criar administrador';

  @override
  String get serverEnded =>
      'O servidor encerrou esta sessão. Faça login de novo.';

  @override
  String get serverHandleHelp =>
      'Letras minúsculas, números, pontos, hifens e sublinhados; nunca muda.';

  @override
  String get serverHeaders => 'Cabeçalhos personalizados';

  @override
  String get serverHeadersHelp =>
      'Um por linha, como Name: value; enviados só por HTTPS';

  @override
  String get serverHeadersInvalid => 'Escreva cada cabeçalho como Name: value';

  @override
  String get serverIdentity => 'Certificado de cliente (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Escolher um certificado de cliente';

  @override
  String get serverIdentityInvalid =>
      'Isto não é um certificado (PKCS#12) ou sua senha está errada.';

  @override
  String get serverIdentityPassword => 'Senha do certificado de cliente';

  @override
  String get serverLoading => 'Lendo o servidor salvo neste dispositivo';

  @override
  String get serverNearby => 'Servidores nesta rede';

  @override
  String get serverNeedsHttps =>
      'Este servidor precisa de um endereço HTTPS: fora da sua rede local, o Photolib não inicia sessão por HTTP simples.';

  @override
  String get serverNoSignIn =>
      'Este servidor não oferece nenhum login compatível com esta versão do Photolib.';

  @override
  String get serverOffline =>
      'O servidor não responde. Você continua conectado.';

  @override
  String get serverPasskeyFailed =>
      'Nenhuma chave de acesso foi usada. Tente de novo ou use um código.';

  @override
  String get serverPasskeyRequired =>
      'Este servidor exige uma chave de acesso, que esta versão do Photolib ainda não consegue usar.';

  @override
  String get serverPassword => 'Senha';

  @override
  String get serverPasswordAgain => 'Repita a senha';

  @override
  String get serverPasswordSetupInvalid =>
      'Este token de definição de senha está errado, já foi usado ou expirou. Peça um novo.';

  @override
  String get serverPasswordSetupToken => 'Token de definição de senha';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Do seu administrador, ou impresso por photolibd admin password-setup no servidor.';

  @override
  String get serverPasswordsDiffer => 'As senhas não coincidem.';

  @override
  String get serverPrivateLibrariesBody =>
      'Uma nova senha não as abre. Reabra-as com seu kit de recuperação, uma chave de acesso ou um dispositivo que ainda esteja conectado.';

  @override
  String get serverPrivateLibrariesGo => 'Definir a senha';

  @override
  String get serverPrivateLibrariesTitle =>
      'Suas bibliotecas privadas continuam bloqueadas';

  @override
  String get serverProxy => 'Proxy HTTP, como host:port';

  @override
  String get serverProxyInvalid => 'Digite o proxy como host:port';

  @override
  String get serverRecoveryCode => 'Código de recuperação';

  @override
  String get serverRemove => 'Remover este servidor';

  @override
  String get serverRequired => 'Obrigatório';

  @override
  String get serverSecondFactor =>
      'O segundo fator desta conta é uma chave de acesso, que esta versão do Photolib ainda não consegue usar.';

  @override
  String get serverSecondFactorCode =>
      'Esta conta também precisa de um código do seu app autenticador ou de um código de recuperação.';

  @override
  String get serverSecondFactorTitle => 'Confirme que é você';

  @override
  String get serverSecondFactorWrong =>
      'Isso não funcionou. Depois de cinco tentativas, entre novamente.';

  @override
  String get serverSetPassword => 'Definir senha';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Para $handle em $server';
  }

  @override
  String get serverSetPasswordOpen => 'Definir uma senha';

  @override
  String get serverSetPasswordTitle => 'Defina sua senha';

  @override
  String get serverSetUp => 'Configurar um novo servidor';

  @override
  String get serverSetupLinkElsewhere =>
      'Para usar este link, saia primeiro deste servidor, ou remova-o se o link for de outro.';

  @override
  String get serverSetupTitle => 'Configurar o servidor';

  @override
  String get serverSetupToken => 'Token de configuração';

  @override
  String get serverSetupTokenHelp =>
      'O photolibd o escreve no log enquanto o servidor não tem administrador; cada inicialização escreve um novo.';

  @override
  String get serverSignIn => 'Fazer login';

  @override
  String get serverSignOut => 'Sair';

  @override
  String serverSignedInAs(String account) {
    return 'Conectado como $account';
  }

  @override
  String get serverSignedOut => 'Desconectado';

  @override
  String get serverSwitch => 'Trocar de conta';

  @override
  String get serverTotpCode => 'Código do seu app autenticador';

  @override
  String get serverTrust => 'Confiar';

  @override
  String get serverUnreadable =>
      'Não é possível ler o servidor salvo neste dispositivo';

  @override
  String get serverUsePasskey => 'Usar uma chave de acesso';

  @override
  String get serverUseRecoveryCode => 'Usar um código de recuperação';

  @override
  String get settingsBackground => 'Atrás de imagens transparentes';

  @override
  String get settingsDateFormat => 'Formato de data';

  @override
  String get settingsDefaultTab => 'Pastas e álbuns abrem em';

  @override
  String get settingsFolders => 'Pastas';

  @override
  String get settingsIndexing => 'Indexação neste dispositivo';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLibrary => 'Biblioteca';

  @override
  String get settingsServer => 'Servidor';

  @override
  String get settingsStart => 'Tela inicial';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps':
          'Toque na borda esquerda ou direita para o item anterior ou seguinte',
      'oneFingerZoom': 'Toque duas vezes e arraste para fazer zoom com um dedo',
      'swipes': 'Deslize para cima ou para baixo no lado esquerdo de um vídeo para o brilho e no direito para o volume',
      'maxBrightness': 'Brilho máximo ao visualizar',
      'autoRotate': 'Girar conforme a orientação de cada foto ou vídeo',
      'mixAudio': 'Reproduzir vídeos sobre outro áudio em vez de pausá-lo',
      'autoplay': 'Reproduzir vídeos ao abrir',
      'loop': 'Repetir vídeos',
      'autoNext': 'Ir para o próximo item quando um vídeo terminar',
      'resume': 'Retomar vídeos de onde pararam',
      'other': 'Reproduzir imagens animadas na grade',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Por quanto tempo o Photolib guarda itens na lixeira';

  @override
  String get settingsViewerBar => 'Botões da barra do visualizador';

  @override
  String get settingsViewing => 'Visualização';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString fotos e vídeos compartilhados aguardam até que o Photolib possa adicioná-los à sua fototeca. Itens não salvos são apagados após 7 dias.',
      many:
          '$countString de fotos e vídeos compartilhados aguardam até que o Photolib possa adicioná-los à sua fototeca. Itens não salvos são apagados após 7 dias.',
      one:
          '$countString foto ou vídeo compartilhado aguarda até que o Photolib possa adicioná-lo à sua fototeca. Itens não salvos são apagados após 7 dias.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Grande demais para compartilhar de uma vez: selecione menos itens';

  @override
  String shareTooMany(int count) {
    return 'Itens demais para compartilhar de uma vez: selecione no máximo $count';
  }

  @override
  String get shortcutsTitle => 'Atalhos do teclado';

  @override
  String get slideshow => 'Apresentação de slides';

  @override
  String get slideshowLoop => 'Repetir';

  @override
  String get slideshowOptions => 'Opções da apresentação';

  @override
  String get slideshowSeconds => 'Segundos por item';

  @override
  String get slideshowShuffle => 'Ordem aleatória';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Decrescente',
      'other': 'Crescente',
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
  String get sourceHideOthers => 'Ocultar todo o resto aqui';

  @override
  String get sourceLost => 'Sem acesso';

  @override
  String get sourcePartly => 'Mostrado em parte';

  @override
  String sourceShow(String name) {
    return 'Mostrar $name';
  }

  @override
  String get sourceShowEverything => 'Mostrar tudo aqui';

  @override
  String get sourceShowOnly => 'Mostrar só isto';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Linha do tempo',
      'folders': 'Pastas e álbuns',
      'favourites': 'Favoritos',
      'other': 'Linha do tempo',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Manter uma pessoa off-line';

  @override
  String get storageBudget => 'Limite de armazenamento';

  @override
  String get storageClear => 'Remover cópias off-line';

  @override
  String get storageClearAction => 'Remover';

  @override
  String storageClearBody(String size) {
    return 'Isto remove $size mantidos neste dispositivo e deixa de manter álbuns, buscas e fotos off-line. Sua biblioteca no servidor não é alterada.';
  }

  @override
  String get storageKeepLibrary => 'Manter a biblioteca inteira';

  @override
  String get storageKeepOriginals => 'Manter também os originais';

  @override
  String get storageNoPeople => 'Nenhuma pessoa tem nome ainda.';

  @override
  String get storageNoPins =>
      'Nada está fixado. Fixe um álbum, uma busca ou uma foto para mantê-lo off-line.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Álbum',
      'search': 'Busca',
      'person': 'Pessoa',
      'library': 'Biblioteca inteira',
      'asset': 'Foto',
      'other': 'Fixado',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Não cabe no limite: faltam $size';
  }

  @override
  String get storagePinNothing =>
      'Nada para baixar: as fotos já estão neste dispositivo';

  @override
  String get storagePinPaused =>
      'Em espera: esta predefinição não mantém nada off-line';

  @override
  String get storagePinPlanning => 'Procurando o que manter…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Baixando: $haveString de $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Disponível off-line ($size)';
  }

  @override
  String get storagePinWaiting => 'Será baixado quando houver conexão';

  @override
  String get storagePins => 'Mantido off-line';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Só o catálogo',
      'spaceSaver': 'Economia de espaço',
      'travel': 'Álbuns escolhidos off-line',
      'everything': 'Tudo',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Não mantém nada; as fotos carregam do seu servidor ao abrir.',
      'spaceSaver': 'Mantém prévias de toda a biblioteca, das mais novas às mais antigas, dentro do limite.',
      'travel': 'Mantém só o que você fixa: álbuns, buscas e fotos.',
      'everything': 'Mantém os originais de toda a biblioteca, dos mais novos aos mais antigos, dentro do limite.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'O que este dispositivo mantém';

  @override
  String get storageSubtitle => 'Cópias off-line e limite de armazenamento';

  @override
  String get storageTitle => 'Armazenamento';

  @override
  String storageUsed(String used, String budget) {
    return '$used de $budget usados';
  }

  @override
  String get storageWebNote =>
      'Um navegador mantém só prévias e as apaga ao sair da conta.';

  @override
  String get storeNoKeyring =>
      'O Photolib guarda a chave do armazenamento local no chaveiro do sistema, que não respondeu. Instale e desbloqueie o gnome-keyring, o KWallet ou o KeePassXC com o Secret Service ativado e tente de novo.';

  @override
  String get storeNoKeystore =>
      'O Photolib não conseguiu acessar o chaveiro deste dispositivo, que guarda a chave do armazenamento local.';

  @override
  String get storeRebuilt =>
      'O chaveiro deste dispositivo não tinha mais a chave do armazenamento local do Photolib, por isso o armazenamento foi recriado. As configurações e o que só existia neste dispositivo foram perdidos; as bibliotecas sincronizam de novo e as miniaturas voltam.';

  @override
  String get storeRecoveryNeeded =>
      'O chaveiro deste dispositivo não tem mais a chave do armazenamento local do Photolib. Insira o código de recuperação ou redefina o armazenamento e perca o que só existe neste dispositivo.';

  @override
  String get storeReset => 'Redefinir armazenamento';

  @override
  String get storeResetBody =>
      'O que só existe neste dispositivo será perdido; as bibliotecas sincronizam de novo e as miniaturas voltam.';

  @override
  String get storeUnavailable =>
      'O armazenamento deste dispositivo não está disponível: as configurações e as coleções não são mantidas';

  @override
  String get tabCollections => 'Coleções';

  @override
  String get tabLibrary => 'Biblioteca';

  @override
  String get tabSearch => 'Pesquisar';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get timelineBenchmark => 'Teste de desempenho da linha do tempo';

  @override
  String get timelineBenchmarkCopy => 'Copiar os resultados';

  @override
  String get timelineCannotPlay => 'Não é possível reproduzir neste navegador';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position de $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position de $count, sem pré-visualização';
  }

  @override
  String get timelineExcluded => 'Numa pasta excluída';

  @override
  String get timelineScrubber => 'Rolar por data';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Data desconhecida';

  @override
  String timelineWeek(String date) {
    return 'Semana de $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Adicionar $action à barra';
  }

  @override
  String toolbarDown(String action) {
    return 'Mover $action para baixo';
  }

  @override
  String get toolbarInBar => 'Na barra';

  @override
  String get toolbarInMenu => 'No menu ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Remover $action da barra';
  }

  @override
  String get toolbarReset => 'Restaurar padrão';

  @override
  String toolbarUp(String action) {
    return 'Mover $action para cima';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Mover para cá',
      'other': 'Copiar para cá',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Já existe um arquivo ou pasta com este nome',
      'changed': 'A cópia não correspondia ao original e foi removida',
      'cancelled': 'Cancelado',
      'invalid': 'Nome de pasta inválido',
      'other': 'Falhou',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Recentes';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Excluir $countString itens para sempre? Isso não pode ser desfeito.',
      many:
          'Excluir $countString de itens para sempre? Isso não pode ser desfeito.',
      one: 'Excluir $countString item para sempre? Isso não pode ser desfeito.',
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
      other: 'Faltam $daysString dias',
      many: 'Faltam $daysString de dias',
      one: 'Falta $daysString dia',
      zero: 'Será excluído hoje',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'A lixeira está vazia';

  @override
  String get trashEmptyAll => 'Esvaziar a lixeira';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString dias';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString itens movidos para a lixeira',
      many: '$countString de itens movidos para a lixeira',
      one: '$countString item movido para a lixeira',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Remover da lista';

  @override
  String trashRetention(int days) {
    return 'O Photolib exclui para sempre o que guarda na lixeira depois de $days dias; cada item mostra o tempo que lhe resta.';
  }

  @override
  String get trashTitle => 'Lixeira';

  @override
  String get undo => 'Desfazer';

  @override
  String get uploadAction => 'Enviar fotos e vídeos';

  @override
  String get uploadClear => 'Limpar';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString de $totalString enviados';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Falhas: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString itens arquivados',
      many: '$countString de itens arquivados',
      one: '$countString item arquivado',
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
      other: '$countString itens ocultos',
      many: '$countString de itens ocultos',
      one: '$countString item oculto',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Preto',
      'white': 'Branco',
      'other': 'Xadrez',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Este vídeo não pode ser reproduzido neste dispositivo';

  @override
  String get viewerCaptions => 'Legendas';

  @override
  String get viewerCompass => 'Bloqueio da bússola';

  @override
  String get viewerCopy => 'Copiar';

  @override
  String get viewerCopyText => 'Copiar texto';

  @override
  String get viewerCustomize => 'Personalizar barra de ferramentas…';

  @override
  String get viewerDial =>
      'Direção. Clique para olhar para a frente. Arraste para olhar ao redor, role ou faça pinça para zoom, clique duas vezes para redefinir';

  @override
  String get viewerFilmstrip => 'Tira de miniaturas';

  @override
  String get viewerFirst => 'Primeiro';

  @override
  String get viewerFisheye => 'Olho de peixe';

  @override
  String get viewerGyroscope => 'Mover para olhar em volta';

  @override
  String get viewerHdr => 'Mostrar em HDR';

  @override
  String get viewerInfo => 'Informações';

  @override
  String get viewerInfoLoading => 'Carregando as informações deste item';

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
  String get viewerLenses => 'Escolher uma lente';

  @override
  String get viewerMap => 'Mapa';

  @override
  String get viewerMotion => 'Reproduzir movimento';

  @override
  String get viewerMotionDenied =>
      'Este navegador não permitiu o acesso aos sensores de movimento';

  @override
  String get viewerMotionMissing =>
      'Este dispositivo não tem giroscópio para olhar em volta';

  @override
  String get viewerMute => 'Silenciar';

  @override
  String get viewerNext => 'Próximo';

  @override
  String get viewerNextFrame => 'Próximo quadro';

  @override
  String get viewerPause => 'Pausar';

  @override
  String get viewerPlanet => 'Pequeno planeta';

  @override
  String get viewerPlay => 'Reproduzir';

  @override
  String get viewerPrevious => 'Anterior';

  @override
  String get viewerPreviousFrame => 'Quadro anterior';

  @override
  String get viewerRotate => 'Girar';

  @override
  String get viewerSdr => 'Mostrar em SDR';

  @override
  String get viewerSeek => 'Posição';

  @override
  String get viewerSetAs => 'Definir como';

  @override
  String get viewerShare => 'Compartilhar';

  @override
  String get viewerSpeed => 'Velocidade de reprodução';

  @override
  String get viewerSphere =>
      'Visualização em 360°. Arraste para olhar em volta, faça pinça para ampliar';

  @override
  String get viewerText => 'Texto nesta foto';

  @override
  String get viewerTextCopied => 'Texto copiado';

  @override
  String get viewerTextNone => 'Nenhum texto encontrado nesta foto';

  @override
  String get viewerTextUnread => 'O texto desta foto ainda não foi lido';

  @override
  String get viewerUnmute => 'Ativar som';

  @override
  String get viewerZoomIn => 'Aumentar zoom';

  @override
  String get viewerZoomOut => 'Diminuir zoom';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Cartão SD',
      'other': 'Interno',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Aumentar zoom';

  @override
  String get zoomOut => 'Diminuir zoom';
}
