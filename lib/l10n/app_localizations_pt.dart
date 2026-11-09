// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get titulo => '';

  @override
  String get time1Padrao => 'NÓS';

  @override
  String get time2Padrao => 'ELES';

  @override
  String get editarNomes => 'Editar Nomes';

  @override
  String get nomeTime1 => 'Time 1';

  @override
  String get nomeTime2 => 'Time 2';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get salvar => 'Salvar';

  @override
  String get botaoDesfazer => 'Desfazer';

  @override
  String get botaoNovoJogo => 'Novo jogo';

  @override
  String saqueRotulo(String time) {
    return 'Saque: $time';
  }

  @override
  String get sacando => 'SACANDO';

  @override
  String get telaCheia => 'Tela cheia';

  @override
  String get sairTelaCheia => 'Sair da tela cheia';

  @override
  String get voz => 'Voz';

  @override
  String get tema => 'Tema';

  @override
  String get idioma => 'Idioma';

  @override
  String get nomes => 'Nomes';

  @override
  String get games => 'GAMES';

  @override
  String get set => 'S';

  @override
  String get sets => 'SETS';

  @override
  String get tieBreak => 'TIE-BREAK';

  @override
  String vitoria(String nome) {
    return 'Vitória: $nome';
  }

  @override
  String vitoriaBanner(String nome) {
    return 'VITÓRIA $nome';
  }

  @override
  String narracaoSaque(String time) {
    return 'Saque de $time.';
  }

  @override
  String narracaoFimDeJogo(String nome, String sets) {
    return 'Fim de jogo. Vitória de $nome. $sets';
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
    return 'Set para $nome. $nome1 $set1, $nome2 $set2. Sets: $nome1 $setsGanhos1, $nome2 $setsGanhos2. $saque';
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
    return 'Game para $nome. $nome1 $game1, $nome2 $game2. $saque';
  }

  @override
  String narracaoTieBreak(String nome, String saque) {
    return 'Game para $nome. Seis a seis. Tie-break. $saque';
  }

  @override
  String narracaoDesfeito(String frase) {
    return 'Desfeito. $frase';
  }

  @override
  String vantagem(String time) {
    return 'Vantagem $time';
  }

  @override
  String get pontoDeOuro => 'Ponto de ouro';

  @override
  String get iguais => 'Iguais';

  @override
  String placarPontos(String ponto1, String ponto2) {
    return '$ponto1 a $ponto2';
  }

  @override
  String get selecionarPlacar => 'Selecionar Placar';

  @override
  String get esporteBeachTennis => 'Beach Tennis / Tênis';

  @override
  String get esporteFutebol => 'Futebol';

  @override
  String get esporteBasquete => 'Basquete';

  @override
  String get esporteVolei => 'Vôlei';

  @override
  String get esporteJudo => 'Judô';

  @override
  String get esporteKarate => 'Karatê';

  @override
  String get esporteTenisDeMesa => 'Tênis de Mesa';

  @override
  String get esporteGeral => 'Placar Geral';

  @override
  String get periodo => 'P';

  @override
  String get tempo => 'Tempo';

  @override
  String get gols => 'GOLS';

  @override
  String get pontos => 'PONTOS';

  @override
  String get faltas => 'FALTAS';

  @override
  String get cartaoAmarelo => 'Amarelo';

  @override
  String get cartaoVermelho => 'Vermelho';

  @override
  String get primeiroTempo => '1º T';

  @override
  String get segundoTempo => '2º Tempo';

  @override
  String get intervalo => 'Intervalo';

  @override
  String get prorrogacao => 'Prorrogação';

  @override
  String get penaltis => 'Pênaltis';

  @override
  String get quarto1 => '1º Q';

  @override
  String get quarto2 => '2º Q';

  @override
  String get quarto3 => '3º Q';

  @override
  String get quarto4 => '4º Q';

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
  String get iniciar => 'Iniciar';

  @override
  String get pausar => 'Pausar';

  @override
  String get zerar => 'Zerar';

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
    return 'Gol de $time! $nome1 $gols1, $nome2 $gols2.';
  }

  @override
  String narracaoCesta(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return 'Cesta de $time! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoPonto(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return 'Ponto de $time! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoVoleiSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return 'Set para $nome! Sets: $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoTenisDeMesaSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return 'Set para $nome! Sets: $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoJudoIppon(String time) {
    return 'Ippon para $time! Vitória de $time!';
  }

  @override
  String narracaoJudoWazaari(String time) {
    return 'Waza-ari para $time!';
  }

  @override
  String narracaoJudoShido(String time) {
    return 'Shido para $time.';
  }
}
