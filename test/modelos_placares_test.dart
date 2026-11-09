import 'package:flutter_test/flutter_test.dart';
import 'package:placar_overlay/modelos_placares.dart';

void main() {
  group('PlacarFutebol', () {
    test('gol e desfazer', () {
      final p = PlacarFutebol();
      p.gol(0);
      expect(p.golsA, 1);
      expect(p.golsB, 0);
      expect(p.podeDesfazer, true);
      p.desfazer();
      expect(p.golsA, 0);
      expect(p.podeDesfazer, false);
    });

    test('cartoes e faltas', () {
      final p = PlacarFutebol();
      p.amarelo(0);
      p.vermelho(1);
      p.falta(0);
      expect(p.cartoesAmarelosA, 1);
      expect(p.cartoesVermelhosB, 1);
      expect(p.faltasA, 1);
    });
  });

  group('PlacarBasquete', () {
    test('pontos 1, 2 e 3 e quartos', () {
      final p = PlacarBasquete();
      p.adicionarPontos(0, 3);
      p.adicionarPontos(1, 2);
      expect(p.pontosA, 3);
      expect(p.pontosB, 2);
      p.proximoQuarto();
      expect(p.quarto, 2);
      p.desfazer();
      expect(p.quarto, 1);
    });
  });

  group('PlacarVolei', () {
    test('set normal ate 25 e tiebreak', () {
      final p = PlacarVolei(setsParaVencer: 2);
      for (var i = 0; i < 25; i++) {
        p.ponto(0);
      }
      expect(p.setsA, 1);
      expect(p.pontosA, 0);
      for (var i = 0; i < 25; i++) {
        p.ponto(0);
      }
      expect(p.setsA, 2);
      expect(p.vencedor, 0);
    });
  });

  group('PlacarJudo', () {
    test('ippon encerra', () {
      final p = PlacarJudo();
      p.marcarIppon(0);
      expect(p.ipponA, 1);
      expect(p.vencedor, 0);
    });

    test('2 wazaari da vitoria', () {
      final p = PlacarJudo();
      p.marcarWazaari(1);
      expect(p.wazaariB, 1);
      expect(p.vencedor, null);
      p.marcarWazaari(1);
      expect(p.wazaariB, 2);
      expect(p.ipponB, 1);
      expect(p.vencedor, 1);
    });

    test('3 shidos desclassifica', () {
      final p = PlacarJudo();
      p.marcarShido(0);
      p.marcarShido(0);
      p.marcarShido(0);
      expect(p.shidoA, 3);
      expect(p.vencedor, 1);
    });
  });

  group('PlacarTenisDeMesa', () {
    test('alternancia de saque a cada 2 pontos e set com 11', () {
      final p = PlacarTenisDeMesa(setsParaVencer: 2);
      expect(p.sacador, 0);
      p.ponto(0); // 1-0
      expect(p.sacador, 0);
      p.ponto(0); // 2-0 -> total 2, troca para 1
      expect(p.sacador, 1);
      p.ponto(1); // 2-1
      expect(p.sacador, 1);
      p.ponto(1); // 2-2 -> total 4, troca para 0
      expect(p.sacador, 0);

      // Levar ate 11-2
      for (var i = 0; i < 9; i++) {
        p.ponto(0);
      }
      expect(p.setsA, 1);
      expect(p.pontosA, 0);
      expect(p.historicoSets, [[11, 2]]);
    });

    test('vantagem a partir de 10-10 troca saque a cada 1 ponto', () {
      final p = PlacarTenisDeMesa();
      for (var i = 0; i < 10; i++) {
        p.ponto(0);
        p.ponto(1);
      }
      // 10-10
      expect(p.pontosA, 10);
      expect(p.pontosB, 10);
      final s = p.sacador;
      p.ponto(0); // 11-10 -> precisa trocar a cada 1 ponto
      expect(p.sacador, 1 - s);
      p.ponto(1); // 11-11
      expect(p.sacador, s);
      p.ponto(0); // 12-11
      p.ponto(0); // 13-11 -> fim do set
      expect(p.setsA, 1);
    });
  });

  group('PlacarKarate', () {
    test('diferenca de 8 pontos da vitoria', () {
      final p = PlacarKarate();
      p.marcarIppon(0); // 3
      p.marcarIppon(0); // 6
      p.marcarWazaari(0); // 8
      expect(p.pontosA, 8);
      expect(p.vencedor, 0);
    });
  });

  group('PlacarGeral', () {
    test('adicionar e subtrair', () {
      final p = PlacarGeral();
      p.adicionar(0, 5);
      p.subtrair(0, 2);
      expect(p.pontosA, 3);
    });
  });
}
