/// Motor do placar (tênis/padel). Sem dependência de UI. lado: 0 = Nós, 1 = Eles.
class _Snap {
  final int pa, pb, ga, gb, sacador, inicioTb;
  final bool tiebreak;
  final int? vencedor;
  final List<List<int>> sets;
  _Snap(Placar p)
      : pa = p.pa, pb = p.pb, ga = p.ga, gb = p.gb,
        sacador = p.sacador, inicioTb = p._inicioTb,
        tiebreak = p.tiebreak, vencedor = p.vencedor,
        sets = p.sets.map((s) => List<int>.of(s)).toList();
}

class Placar {
  Placar({this.pontoDeOuro = false, this.setsParaVencer = 2, int sacadorInicial = 0})
      : sacador = sacadorInicial;

  final bool pontoDeOuro;
  final int setsParaVencer;

  int pa = 0, pb = 0; // pontos do game (no tie-break: pontos reais)
  int ga = 0, gb = 0; // games do set atual
  List<List<int>> sets = []; // sets concluídos: [gamesNós, gamesEles]
  bool tiebreak = false;
  int sacador;
  int _inicioTb = 0;
  int? vencedor;
  final List<_Snap> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  int setsGanhos(int lado) =>
      sets.where((s) => s[lado] > s[1 - lado]).length;

  void ponto(int lado) {
    if (vencedor != null) return;
    _pilha.add(_Snap(this));
    if (lado == 0) { pa++; } else { pb++; }
    tiebreak ? _aposPontoTiebreak() : _aposPontoNormal();
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    pa = s.pa; pb = s.pb; ga = s.ga; gb = s.gb;
    sacador = s.sacador; _inicioTb = s.inicioTb;
    tiebreak = s.tiebreak; vencedor = s.vencedor;
    sets = s.sets;
  }

  void _aposPontoNormal() {
    final fim = pontoDeOuro
        ? (pa == 4 || pb == 4)
        : ((pa >= 4 || pb >= 4) && (pa - pb).abs() >= 2);
    if (fim) _fimDoGame(pa > pb ? 0 : 1);
  }

  void _aposPontoTiebreak() {
    if ((pa >= 7 || pb >= 7) && (pa - pb).abs() >= 2) {
      _fimDoGame(pa > pb ? 0 : 1);
    } else {
      sacador = (_inicioTb + (pa + pb + 1) ~/ 2) % 2; // troca após 1º ponto, depois a cada 2
    }
  }

  void _fimDoGame(int lado) {
    if (lado == 0) { ga++; } else { gb++; }
    pa = 0; pb = 0;
    final eraTb = tiebreak;
    tiebreak = false;
    final g = lado == 0 ? ga : gb;
    final o = lado == 0 ? gb : ga;
    if ((g >= 6 && g - o >= 2) || g == 7) {
      sacador = eraTb ? 1 - _inicioTb : 1 - sacador;
      _fimDoSet(lado);
      return;
    }
    sacador = 1 - sacador;
    if (ga == 6 && gb == 6) {
      tiebreak = true;
      _inicioTb = sacador;
    }
  }

  void _fimDoSet(int lado) {
    sets.add([ga, gb]);
    ga = 0; gb = 0;
    if (setsGanhos(lado) >= setsParaVencer) vencedor = lado;
  }

  /// Texto do placar do game para exibir.
  String textoPonto(int lado) {
    if (tiebreak) return '${lado == 0 ? pa : pb}';
    final m = lado == 0 ? pa : pb;
    final o = lado == 0 ? pb : pa;
    if (m >= 3 && o >= 3) {
      if (pontoDeOuro || m == o) return '40';
      return m > o ? 'AD' : '40';
    }
    return const ['0', '15', '30', '40'][m];
  }
}
