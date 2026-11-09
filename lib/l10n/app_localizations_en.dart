// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titulo => '';

  @override
  String get time1Padrao => 'US';

  @override
  String get time2Padrao => 'THEM';

  @override
  String get editarNomes => 'Edit Names';

  @override
  String get nomeTime1 => 'Team 1';

  @override
  String get nomeTime2 => 'Team 2';

  @override
  String get cancelar => 'Cancel';

  @override
  String get salvar => 'Save';

  @override
  String get botaoDesfazer => 'Undo';

  @override
  String get botaoNovoJogo => 'New game';

  @override
  String saqueRotulo(String time) {
    return 'Serve: $time';
  }

  @override
  String get sacando => 'SERVING';

  @override
  String get telaCheia => 'Fullscreen';

  @override
  String get sairTelaCheia => 'Exit fullscreen';

  @override
  String get voz => 'Voice';

  @override
  String get tema => 'Theme';

  @override
  String get idioma => 'Language';

  @override
  String get nomes => 'Names';

  @override
  String get games => 'GAMES';

  @override
  String get set => 'SET';

  @override
  String get sets => 'SETS';

  @override
  String get tieBreak => 'TIE-BREAK';

  @override
  String vitoria(String nome) {
    return 'Victory: $nome';
  }

  @override
  String vitoriaBanner(String nome) {
    return 'VICTORY $nome';
  }

  @override
  String narracaoSaque(String time) {
    return 'Serve by $time.';
  }

  @override
  String narracaoFimDeJogo(String nome, String sets) {
    return 'Game over. Victory for $nome. $sets';
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
    return 'Set for $nome. $nome1 $set1, $nome2 $set2. Sets: $nome1 $setsGanhos1, $nome2 $setsGanhos2. $saque';
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
    return 'Game for $nome. $nome1 $game1, $nome2 $game2. $saque';
  }

  @override
  String narracaoTieBreak(String nome, String saque) {
    return 'Game for $nome. Six all. Tie-break. $saque';
  }

  @override
  String narracaoDesfeito(String frase) {
    return 'Undone. $frase';
  }

  @override
  String vantagem(String time) {
    return 'Advantage $time';
  }

  @override
  String get pontoDeOuro => 'Golden point';

  @override
  String get iguais => 'Deuce';

  @override
  String placarPontos(String ponto1, String ponto2) {
    return '$ponto1 - $ponto2';
  }

  @override
  String get selecionarPlacar => 'Select Scoreboard';

  @override
  String get esporteBeachTennis => 'Beach Tennis / Tennis';

  @override
  String get esporteFutebol => 'Soccer / Football';

  @override
  String get esporteBasquete => 'Basketball';

  @override
  String get esporteVolei => 'Volleyball';

  @override
  String get esporteJudo => 'Judo';

  @override
  String get esporteKarate => 'Karate';

  @override
  String get esporteTenisDeMesa => 'Table Tennis';

  @override
  String get esporteGeral => 'General Scoreboard';

  @override
  String get periodo => 'P';

  @override
  String get tempo => 'Time';

  @override
  String get gols => 'GOALS';

  @override
  String get pontos => 'POINTS';

  @override
  String get faltas => 'FOULS';

  @override
  String get cartaoAmarelo => 'Yellow';

  @override
  String get cartaoVermelho => 'Red';

  @override
  String get primeiroTempo => '1st';

  @override
  String get segundoTempo => '2nd ';

  @override
  String get intervalo => 'Halftime';

  @override
  String get prorrogacao => 'Overtime';

  @override
  String get penaltis => 'Penalties';

  @override
  String get quarto1 => '1st Q';

  @override
  String get quarto2 => '2nd Q';

  @override
  String get quarto3 => '3rd Q';

  @override
  String get quarto4 => '4th Q';

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
  String get iniciar => 'Start';

  @override
  String get pausar => 'Pause';

  @override
  String get zerar => 'Reset';

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
    return 'Goal for $time! $nome1 $gols1, $nome2 $gols2.';
  }

  @override
  String narracaoCesta(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return 'Basket for $time! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoPonto(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return 'Point for $time! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoVoleiSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return 'Set for $nome! Sets: $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoTenisDeMesaSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return 'Set for $nome! Sets: $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoJudoIppon(String time) {
    return 'Ippon for $time! Victory for $time!';
  }

  @override
  String narracaoJudoWazaari(String time) {
    return 'Waza-ari for $time!';
  }

  @override
  String narracaoJudoShido(String time) {
    return 'Shido for $time.';
  }
}
