// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get titulo => '';

  @override
  String get time1Padrao => 'NOSOTROS';

  @override
  String get time2Padrao => 'ELLOS';

  @override
  String get editarNomes => 'Editar Nombres';

  @override
  String get nomeTime1 => 'Equipo 1';

  @override
  String get nomeTime2 => 'Equipo 2';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get salvar => 'Guardar';

  @override
  String get botaoDesfazer => 'Deshacer';

  @override
  String get botaoNovoJogo => 'Nuevo juego';

  @override
  String saqueRotulo(String time) {
    return 'Saque: $time';
  }

  @override
  String get sacando => 'SACANDO';

  @override
  String get telaCheia => 'Pantalla completa';

  @override
  String get sairTelaCheia => 'Salir de pantalla completa';

  @override
  String get voz => 'Voz';

  @override
  String get tema => 'Tema';

  @override
  String get idioma => 'Idioma';

  @override
  String get nomes => 'Nombres';

  @override
  String get games => 'JUEGOS';

  @override
  String get set => 'SET';

  @override
  String get sets => 'SETS';

  @override
  String get tieBreak => 'TIE-BREAK';

  @override
  String vitoria(String nome) {
    return 'Victoria: $nome';
  }

  @override
  String vitoriaBanner(String nome) {
    return 'VICTORIA $nome';
  }

  @override
  String narracaoSaque(String time) {
    return 'Saque de $time.';
  }

  @override
  String narracaoFimDeJogo(String nome, String sets) {
    return 'Fin del juego. Victoria de $nome. $sets';
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
    return 'Juego para $nome. $nome1 $game1, $nome2 $game2. $saque';
  }

  @override
  String narracaoTieBreak(String nome, String saque) {
    return 'Juego para $nome. Seis iguales. Tie-break. $saque';
  }

  @override
  String narracaoDesfeito(String frase) {
    return 'Deshecho. $frase';
  }

  @override
  String vantagem(String time) {
    return 'Ventaja $time';
  }

  @override
  String get pontoDeOuro => 'Ponto de oro';

  @override
  String get iguais => 'Iguales';

  @override
  String placarPontos(String ponto1, String ponto2) {
    return '$ponto1 a $ponto2';
  }

  @override
  String get selecionarPlacar => 'Seleccionar Marcador';

  @override
  String get esporteBeachTennis => 'Beach Tennis / Tenis';

  @override
  String get esporteFutebol => 'Fútbol';

  @override
  String get esporteBasquete => 'Baloncesto';

  @override
  String get esporteVolei => 'Voleibol';

  @override
  String get esporteJudo => 'Judo';

  @override
  String get esporteKarate => 'Kárate';

  @override
  String get esporteTenisDeMesa => 'Tenis de Mesa';

  @override
  String get esporteGeral => 'Marcador General';

  @override
  String get periodo => 'P';

  @override
  String get tempo => 'Tiempo';

  @override
  String get gols => 'GOLES';

  @override
  String get pontos => 'PUNTOS';

  @override
  String get faltas => 'FALTAS';

  @override
  String get cartaoAmarelo => 'Amarilla';

  @override
  String get cartaoVermelho => 'Roja';

  @override
  String get primeiroTempo => '1er T';

  @override
  String get segundoTempo => '2do T';

  @override
  String get intervalo => 'Descanso';

  @override
  String get prorrogacao => 'Prórroga';

  @override
  String get penaltis => 'Penaltis';

  @override
  String get quarto1 => '1er C';

  @override
  String get quarto2 => '2do C';

  @override
  String get quarto3 => '3er C';

  @override
  String get quarto4 => '4to C';

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
  String get zerar => 'Reiniciar';

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
    return '¡Gol de $time! $nome1 $gols1, $nome2 $gols2.';
  }

  @override
  String narracaoCesta(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return '¡Canasta de $time! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoPonto(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  ) {
    return '¡Punto de $time! $nome1 $pontos1, $nome2 $pontos2.';
  }

  @override
  String narracaoVoleiSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return '¡Set para $nome! Sets: $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoTenisDeMesaSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  ) {
    return '¡Set para $nome! Sets: $nome1 $sets1, $nome2 $sets2.';
  }

  @override
  String narracaoJudoIppon(String time) {
    return '¡Ippon para $time! ¡Victoria de $time!';
  }

  @override
  String narracaoJudoWazaari(String time) {
    return '¡Waza-ari para $time!';
  }

  @override
  String narracaoJudoShido(String time) {
    return 'Shido para $time.';
  }
}
