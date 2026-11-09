import 'package:flutter_test/flutter_test.dart';
import 'package:placar_overlay/placar.dart';

void pts(Placar p, int lado, int n) {
  for (var i = 0; i < n; i++) { p.ponto(lado); }
}

void main() {
  test('4 pontos ganham o game e o saque troca', () {
    final p = Placar();
    pts(p, 0, 4);
    expect(p.ga, 1);
    expect(p.pa, 0);
    expect(p.sacador, 1);
  });

  test('vantagem', () {
    final p = Placar();
    pts(p, 0, 3); pts(p, 1, 3);
    p.ponto(0);
    expect(p.textoPonto(0), 'AD');
    expect(p.textoPonto(1), '40');
    p.ponto(1);
    expect(p.textoPonto(0), '40');
    pts(p, 0, 2);
    expect(p.ga, 1);
  });

  test('ponto de ouro', () {
    final p = Placar(pontoDeOuro: true);
    pts(p, 0, 3); pts(p, 1, 3);
    p.ponto(1);
    expect(p.gb, 1);
  });

  test('set 6-0 e partida em 2 sets', () {
    final p = Placar();
    pts(p, 0, 24);
    expect(p.sets, [[6, 0]]);
    pts(p, 0, 24);
    expect(p.vencedor, 0);
  });

  test('tie-break 7-6', () {
    final p = Placar();
    for (var i = 0; i < 6; i++) { pts(p, 0, 4); pts(p, 1, 4); }
    expect(p.tiebreak, true);
    pts(p, 0, 7);
    expect(p.sets, [[7, 6]]);
    expect(p.tiebreak, false);
  });

  test('desfazer', () {
    final p = Placar();
    p.ponto(0);
    p.desfazer();
    expect(p.pa, 0);
    expect(p.podeDesfazer, false);
  });
}
