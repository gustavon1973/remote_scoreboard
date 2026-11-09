// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get titulo => '';

  @override
  String get time1Padrao => 'NOUS';

  @override
  String get time2Padrao => 'EUX';

  @override
  String get editarNomes => 'Modifier les noms';

  @override
  String get nomeTime1 => 'Équipe 1';

  @override
  String get nomeTime2 => 'Équipe 2';

  @override
  String get cancelar => 'Annuler';

  @override
  String get salvar => 'Enregistrer';

  @override
  String get botaoDesfazer => 'Annuler';

  @override
  String get botaoNovoJogo => 'Nouveau jeu';

  @override
  String saqueRotulo(String time) {
    return 'Service : $time';
  }

  @override
  String get sacando => 'AU SERVICE';

  @override
  String get telaCheia => 'Plein écran';

  @override
  String get sairTelaCheia => 'Quitter le plein écran';

  @override
  String get voz => 'Voix';

  @override
  String get tema => 'Thème';

  @override
  String get idioma => 'Langue';

  @override
  String get nomes => 'Noms';

  @override
  String get games => 'JEUX';

  @override
  String get set => 'SET';

  @override
  String get sets => 'SETS';

  @override
  String get tieBreak => 'TIE-BREAK';

  @override
  String vitoria(String nome) {
    return 'Victoire : $nome';
  }

  @override
  String vitoriaBanner(String nome) {
    return 'VICTOIRE $nome';
  }

  @override
  String narracaoSaque(String time) {
    return 'Service de $time.';
  }

  @override
  String narracaoFimDeJogo(String nome, String sets) {
    return 'Fin du match. Victoire de $nome. $sets';
  }

  @override
  String narracaoSet(
    String nome,
    String nome1,
    int set1,
    String nome2,
    int set2,
    int setsGanhos1,
    int setsGanhos2,
    String saque,
  ) {
    return 'Set pour $nome. $nome1 $set1, $nome2 $set2. Sets : $nome1 $setsGanhos1, $nome2 $setsGanhos2. $saque';
  }

  @override
  String narracaoGame(
    String nome,
    String nome1,
    int game1,
    String nome2,
    int game2,
    String saque,
  ) {
    return 'Jeu pour $nome. $nome1 $game1, $nome2 $game2. $saque';
  }

  @override
  String narracaoTieBreak(String nome, String saque) {
    return 'Jeu pour $nome. Six partout. Tie-break. $saque';
  }

  @override
  String narracaoDesfeito(String frase) {
    return 'Annulé. $frase';
  }

  @override
  String vantagem(String time) {
    return 'Avantage $time';
  }

  @override
  String get pontoDeOuro => 'Point en or';

  @override
  String get iguais => 'Égalité';

  @override
  String placarPontos(String ponto1, String ponto2) {
    return '$ponto1 à $ponto2';
  }

  @override
  String get selecionarPlacar => 'Sélectionner le tableau';

  @override
  String get esporteBeachTennis => 'Beach Tennis / Tennis';

  @override
  String get esporteFutebol => 'Football';

  @override
  String get esporteBasquete => 'Basket-ball';

  @override
  String get esporteVolei => 'Volley-ball';

  @override
  String get esporteJudo => 'Judo';

  @override
  String get esporteKarate => 'Karaté';

  @override
  String get esporteTenisDeMesa => 'Tennis de table';

  @override
  String get esporteGeral => 'Tableau Général';

  @override
  String get periodo => 'P';

  @override
  String get tempo => 'Temps';

  @override
  String get gols => 'BUTS';

  @override
  String get pontos => 'POINTS';

  @override
  String get faltas => 'FAUTES';

  @override
  String get cartaoAmarelo => 'Jaune';

  @override
  String get cartaoVermelho => 'Rouge';

  @override
  String get primeiroTempo => '1ère';

  @override
  String get segundoTempo => '2ème';

  @override
  String get intervalo => 'Mi-temps';

  @override
  String get prorrogacao => 'Prolongation';

  @override
  String get penaltis => 'Tirs au but';

  @override
  String get quarto1 => '1er Q';

  @override
  String get quarto2 => '2ème Q';

  @override
  String get quarto3 => '3ème Q';

  @override
  String get quarto4 => '4ème Q';

  @override
  String get goldenScore => 'GOLDEN SCORE';

  @override
  String get osaekomi => 'Osaekomi';

  @override
  String get toketa => 'Toketa';

  @override
  String get shido => 'Shido';

  @override
  String get wazaari => 'Waza-ari';

  @override
  String get ippon => 'Ippon';

  @override
  String get yuko => 'Yuko';

  @override
  String get senshu => 'Senshu';

  @override
  String get iniciar => 'Démarrer';

  @override
  String get pausar => 'Pause';

  @override
  String get zerar => 'Réinitialiser';

  @override
  String get maisUm => '+1';

  @override
  String get maisDois => '+2';

  @override
  String get maisTres => '+3';

  @override
  String get menosUm => '-1';

  @override
  String narracaoGol(
    String time,
    String nome1,
    int gols1,
    String nome2,
    int gols2,
  ) {
    return 'But pour $time ! $nome1 $gols1, $nome2 $gols2.';
  }

  @override
  String narracaoCesta(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return 'Panier pour $time ! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoPonto(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return 'Point pour $time ! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoVoleiSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return 'Set pour $nome ! Sets : $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoTenisDeMesaSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return 'Set pour $nome ! Sets : $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoJudoIppon(String time) {
    return 'Ippon pour $time ! Victoire de $time !';
  }

  @override
  String narracaoJudoWazaari(String time) {
    return 'Waza-ari pour $time !';
  }

  @override
  String narracaoJudoShido(String time) {
    return 'Shido pour $time.';
  }
}
