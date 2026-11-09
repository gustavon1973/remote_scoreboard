import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

/// Tipos de esportes disponíveis
enum TipoEsporte {
  beachTennis,
  futebol,
  basquete,
  volei,
  tenisDeMesa,
  judo,
  karate,
  geral;

  IconData get icone => switch (this) {
        TipoEsporte.beachTennis => Icons.sports_tennis,
        TipoEsporte.futebol => Icons.sports_soccer,
        TipoEsporte.basquete => Icons.sports_basketball,
        TipoEsporte.volei => Icons.sports_volleyball,
        TipoEsporte.tenisDeMesa => Icons.sports_cricket,
        TipoEsporte.judo => Icons.sports_kabaddi,
        TipoEsporte.karate => Icons.sports_martial_arts,
        TipoEsporte.geral => Icons.scoreboard,
      };

  String nome(AppLocalizations loc) => switch (this) {
        TipoEsporte.beachTennis => loc.esporteBeachTennis,
        TipoEsporte.futebol => loc.esporteFutebol,
        TipoEsporte.basquete => loc.esporteBasquete,
        TipoEsporte.volei => loc.esporteVolei,
        TipoEsporte.tenisDeMesa => loc.esporteTenisDeMesa,
        TipoEsporte.judo => loc.esporteJudo,
        TipoEsporte.karate => loc.esporteKarate,
        TipoEsporte.geral => loc.esporteGeral,
      };
}

// ==========================================
// 1. FUTEBOL
// ==========================================
class _SnapFutebol {
  final int golsA, golsB;
  final int amA, amB, vmA, vmB, fA, fB;
  final int periodo, tempoSegundos;
  _SnapFutebol(PlacarFutebol p)
      : golsA = p.golsA,
        golsB = p.golsB,
        amA = p.cartoesAmarelosA,
        amB = p.cartoesAmarelosB,
        vmA = p.cartoesVermelhosA,
        vmB = p.cartoesVermelhosB,
        fA = p.faltasA,
        fB = p.faltasB,
        periodo = p.periodo,
        tempoSegundos = p.tempoSegundos;
}

class PlacarFutebol {
  int golsA = 0, golsB = 0;
  int cartoesAmarelosA = 0, cartoesAmarelosB = 0;
  int cartoesVermelhosA = 0, cartoesVermelhosB = 0;
  int faltasA = 0, faltasB = 0;
  int periodo = 1; // 1: 1T, 2: INT, 3: 2T, 4: PR1, 5: PR2, 6: PEN
  int tempoSegundos = 0;
  bool tempoRodando = false;
  final List<_SnapFutebol> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  void ponto(int lado) => gol(lado);

  void gol(int lado) {
    _salvar();
    if (lado == 0) {
      golsA++;
    } else {
      golsB++;
    }
  }

  void amarelo(int lado) {
    _salvar();
    if (lado == 0) {
      cartoesAmarelosA++;
    } else {
      cartoesAmarelosB++;
    }
  }

  void vermelho(int lado) {
    _salvar();
    if (lado == 0) {
      cartoesVermelhosA++;
    } else {
      cartoesVermelhosB++;
    }
  }

  void falta(int lado) {
    _salvar();
    if (lado == 0) {
      faltasA++;
    } else {
      faltasB++;
    }
  }

  void proximoPeriodo() {
    _salvar();
    if (periodo < 6) {
      periodo++;
      if (periodo == 2 || periodo == 6) tempoRodando = false;
    } else {
      periodo = 1;
    }
  }

  String textoPeriodo(AppLocalizations loc) => switch (periodo) {
        1 => loc.primeiroTempo,
        2 => loc.intervalo,
        3 => loc.segundoTempo,
        4 => '${loc.prorrogacao} 1',
        5 => '${loc.prorrogacao} 2',
        6 => loc.penaltis,
        _ => '',
      };

  void tick() {
    if (tempoRodando) tempoSegundos++;
  }

  void resetTempo() {
    _salvar();
    tempoSegundos = 0;
    tempoRodando = false;
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    golsA = s.golsA;
    golsB = s.golsB;
    cartoesAmarelosA = s.amA;
    cartoesAmarelosB = s.amB;
    cartoesVermelhosA = s.vmA;
    cartoesVermelhosB = s.vmB;
    faltasA = s.fA;
    faltasB = s.fB;
    periodo = s.periodo;
    tempoSegundos = s.tempoSegundos;
  }

  void reiniciar() {
    _pilha.clear();
    golsA = 0;
    golsB = 0;
    cartoesAmarelosA = 0;
    cartoesAmarelosB = 0;
    cartoesVermelhosA = 0;
    cartoesVermelhosB = 0;
    faltasA = 0;
    faltasB = 0;
    periodo = 1;
    tempoSegundos = 0;
    tempoRodando = false;
  }

  void _salvar() => _pilha.add(_SnapFutebol(this));
}

// ==========================================
// 2. BASQUETE
// ==========================================
class _SnapBasquete {
  final int pontosA, pontosB, faltasA, faltasB, quarto, tempoSegundos;
  _SnapBasquete(PlacarBasquete p)
      : pontosA = p.pontosA,
        pontosB = p.pontosB,
        faltasA = p.faltasA,
        faltasB = p.faltasB,
        quarto = p.quarto,
        tempoSegundos = p.tempoSegundos;
}

class PlacarBasquete {
  int pontosA = 0, pontosB = 0;
  int faltasA = 0, faltasB = 0;
  int quarto = 1; // 1: 1Q, 2: 2Q, 3: INT, 4: 3Q, 5: 4Q, 6: OT
  int tempoSegundos = 600; // 10:00 (oficial FIBA)
  bool tempoRodando = false;
  final List<_SnapBasquete> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  void ponto(int lado) => adicionarPontos(lado, 2);

  void adicionarPontos(int lado, int qtd) {
    _salvar();
    if (lado == 0) {
      pontosA += qtd;
    } else {
      pontosB += qtd;
    }
  }

  void removerPonto(int lado) {
    _salvar();
    if (lado == 0) {
      if (pontosA > 0) pontosA--;
    } else {
      if (pontosB > 0) pontosB--;
    }
  }

  void adicionarFalta(int lado) {
    _salvar();
    if (lado == 0) {
      faltasA++;
    } else {
      faltasB++;
    }
  }

  void proximoQuarto() {
    _salvar();
    if (quarto < 6) {
      quarto++;
    } else {
      quarto = 1;
    }
    faltasA = 0;
    faltasB = 0;
    tempoSegundos = quarto == 6 ? 300 : 600; // 5 min OT ou 10 min normal
    tempoRodando = false;
  }

  String textoQuarto(AppLocalizations loc) => switch (quarto) {
        1 => loc.quarto1,
        2 => loc.quarto2,
        3 => loc.intervalo,
        4 => loc.quarto3,
        5 => loc.quarto4,
        6 => 'OT',
        _ => '',
      };

  void tick() {
    if (tempoRodando && tempoSegundos > 0) {
      tempoSegundos--;
      if (tempoSegundos == 0) tempoRodando = false;
    }
  }

  void resetTempo([int minutos = 10]) {
    _salvar();
    tempoSegundos = minutos * 60;
    tempoRodando = false;
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    pontosA = s.pontosA;
    pontosB = s.pontosB;
    faltasA = s.faltasA;
    faltasB = s.faltasB;
    quarto = s.quarto;
    tempoSegundos = s.tempoSegundos;
  }

  void reiniciar() {
    _pilha.clear();
    pontosA = 0;
    pontosB = 0;
    faltasA = 0;
    faltasB = 0;
    quarto = 1;
    tempoSegundos = 600;
    tempoRodando = false;
  }

  void _salvar() => _pilha.add(_SnapBasquete(this));
}

// ==========================================
// 3. VÔLEI
// ==========================================
class _SnapVolei {
  final int pontosA, pontosB, setsA, setsB, sacador;
  final int? vencedor;
  final List<List<int>> historicoSets;
  _SnapVolei(PlacarVolei p)
      : pontosA = p.pontosA,
        pontosB = p.pontosB,
        setsA = p.setsA,
        setsB = p.setsB,
        sacador = p.sacador,
        vencedor = p.vencedor,
        historicoSets = p.historicoSets.map((s) => List<int>.of(s)).toList();
}

class PlacarVolei {
  PlacarVolei({this.setsParaVencer = 3});

  final int setsParaVencer; // 3 = melhor de 5, 2 = melhor de 3
  int pontosA = 0, pontosB = 0;
  int setsA = 0, setsB = 0;
  int sacador = 0; // 0 ou 1
  int? vencedor;
  List<List<int>> historicoSets = [];
  final List<_SnapVolei> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;
  bool get isTieBreak => (setsA + setsB) == (setsParaVencer * 2 - 2);

  void ponto(int lado) {
    if (vencedor != null) return;
    _salvar();
    if (lado == 0) {
      pontosA++;
    } else {
      pontosB++;
    }
    sacador = lado;

    final limite = isTieBreak ? 15 : 25;
    final pG = lado == 0 ? pontosA : pontosB;
    final pP = lado == 0 ? pontosB : pontosA;

    if (pG >= limite && (pG - pP) >= 2) {
      historicoSets.add([pontosA, pontosB]);
      if (lado == 0) {
        setsA++;
      } else {
        setsB++;
      }
      pontosA = 0;
      pontosB = 0;
      if ((lado == 0 ? setsA : setsB) >= setsParaVencer) {
        vencedor = lado;
      }
    }
  }

  void trocarSaque() {
    _salvar();
    sacador = 1 - sacador;
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    pontosA = s.pontosA;
    pontosB = s.pontosB;
    setsA = s.setsA;
    setsB = s.setsB;
    sacador = s.sacador;
    vencedor = s.vencedor;
    historicoSets = s.historicoSets;
  }

  void reiniciar() {
    _pilha.clear();
    pontosA = 0;
    pontosB = 0;
    setsA = 0;
    setsB = 0;
    sacador = 0;
    vencedor = null;
    historicoSets.clear();
  }

  void _salvar() => _pilha.add(_SnapVolei(this));
}

// ==========================================
// 4. TÊNIS DE MESA
// ==========================================
class _SnapTenisDeMesa {
  final int pontosA, pontosB, setsA, setsB, sacador, sacadorInicialDoSet;
  final int? vencedor;
  final List<List<int>> historicoSets;
  _SnapTenisDeMesa(PlacarTenisDeMesa p)
      : pontosA = p.pontosA,
        pontosB = p.pontosB,
        setsA = p.setsA,
        setsB = p.setsB,
        sacador = p.sacador,
        sacadorInicialDoSet = p.sacadorInicialDoSet,
        vencedor = p.vencedor,
        historicoSets = p.historicoSets.map((s) => List<int>.of(s)).toList();
}

class PlacarTenisDeMesa {
  PlacarTenisDeMesa({this.setsParaVencer = 3});

  final int setsParaVencer; // geralmente melhor de 5 (3 sets)
  int pontosA = 0, pontosB = 0;
  int setsA = 0, setsB = 0;
  int sacador = 0;
  int sacadorInicialDoSet = 0;
  int? vencedor;
  List<List<int>> historicoSets = [];
  final List<_SnapTenisDeMesa> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  void ponto(int lado) {
    if (vencedor != null) return;
    _salvar();
    if (lado == 0) {
      pontosA++;
    } else {
      pontosB++;
    }

    final totalPontos = pontosA + pontosB;
    // Até 10-10 (total < 20), alterna a cada 2 pontos
    // A partir de 10-10, alterna a cada 1 ponto
    if (pontosA >= 10 && pontosB >= 10) {
      sacador = (sacadorInicialDoSet + totalPontos) % 2;
    } else {
      sacador = (sacadorInicialDoSet + (totalPontos ~/ 2)) % 2;
    }

    final pG = lado == 0 ? pontosA : pontosB;
    final pP = lado == 0 ? pontosB : pontosA;
    if (pG >= 11 && (pG - pP) >= 2) {
      historicoSets.add([pontosA, pontosB]);
      if (lado == 0) {
        setsA++;
      } else {
        setsB++;
      }
      pontosA = 0;
      pontosB = 0;
      sacadorInicialDoSet = 1 - sacadorInicialDoSet;
      sacador = sacadorInicialDoSet;
      if ((lado == 0 ? setsA : setsB) >= setsParaVencer) {
        vencedor = lado;
      }
    }
  }

  void trocarSaque() {
    _salvar();
    sacador = 1 - sacador;
    sacadorInicialDoSet = sacador;
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    pontosA = s.pontosA;
    pontosB = s.pontosB;
    setsA = s.setsA;
    setsB = s.setsB;
    sacador = s.sacador;
    sacadorInicialDoSet = s.sacadorInicialDoSet;
    vencedor = s.vencedor;
    historicoSets = s.historicoSets;
  }

  void reiniciar() {
    _pilha.clear();
    pontosA = 0;
    pontosB = 0;
    setsA = 0;
    setsB = 0;
    sacador = 0;
    sacadorInicialDoSet = 0;
    vencedor = null;
    historicoSets.clear();
  }

  void _salvar() => _pilha.add(_SnapTenisDeMesa(this));
}

// ==========================================
// 4. JUDÔ
// ==========================================
class _SnapJudo {
  final int ipponA, ipponB, wazaariA, wazaariB, shidoA, shidoB;
  final int tempoSegundos, osaekomiSegundos;
  final bool goldenScore, osaekomiAtivo;
  final int? ladoOsaekomi, vencedor;
  _SnapJudo(PlacarJudo p)
      : ipponA = p.ipponA,
        ipponB = p.ipponB,
        wazaariA = p.wazaariA,
        wazaariB = p.wazaariB,
        shidoA = p.shidoA,
        shidoB = p.shidoB,
        tempoSegundos = p.tempoSegundos,
        osaekomiSegundos = p.osaekomiSegundos,
        goldenScore = p.goldenScore,
        osaekomiAtivo = p.osaekomiAtivo,
        ladoOsaekomi = p.ladoOsaekomi,
        vencedor = p.vencedor;
}

class PlacarJudo {
  int ipponA = 0, ipponB = 0;
  int wazaariA = 0, wazaariB = 0;
  int shidoA = 0, shidoB = 0;
  int tempoSegundos = 240; // 4:00 regressivo oficial
  bool tempoRodando = false;
  bool goldenScore = false;
  bool osaekomiAtivo = false;
  int? ladoOsaekomi;
  int osaekomiSegundos = 0;
  int? vencedor;
  final List<_SnapJudo> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  void ponto(int lado) => marcarWazaari(lado);

  void marcarIppon(int lado) {
    if (vencedor != null) return;
    _salvar();
    if (lado == 0) {
      ipponA = 1;
    } else {
      ipponB = 1;
    }
    vencedor = lado;
    tempoRodando = false;
    toketa();
  }

  void marcarWazaari(int lado) {
    if (vencedor != null) return;
    _salvar();
    if (lado == 0) {
      wazaariA++;
      if (wazaariA >= 2) {
        ipponA = 1;
        vencedor = 0;
        tempoRodando = false;
        toketa();
      }
    } else {
      wazaariB++;
      if (wazaariB >= 2) {
        ipponB = 1;
        vencedor = 1;
        tempoRodando = false;
        toketa();
      }
    }
    if (goldenScore && vencedor == null) {
      vencedor = lado;
      tempoRodando = false;
    }
  }

  void marcarShido(int lado) {
    if (vencedor != null) return;
    _salvar();
    if (lado == 0) {
      shidoA++;
      if (shidoA >= 3) {
        vencedor = 1; // Hansoku-make: vitória do adversário
        tempoRodando = false;
        toketa();
      }
    } else {
      shidoB++;
      if (shidoB >= 3) {
        vencedor = 0;
        tempoRodando = false;
        toketa();
      }
    }
    if (goldenScore && vencedor == null && (lado == 0 ? shidoA : shidoB) >= 3) {
      vencedor = 1 - lado;
      tempoRodando = false;
    }
  }

  void iniciarOsaekomi(int lado) {
    _salvar();
    osaekomiAtivo = true;
    ladoOsaekomi = lado;
    osaekomiSegundos = 0;
    tempoRodando = true;
  }

  void toketa() {
    osaekomiAtivo = false;
    ladoOsaekomi = null;
    osaekomiSegundos = 0;
  }

  void ativarGoldenScore() {
    _salvar();
    goldenScore = true;
    tempoSegundos = 0; // Conta para cima no golden score
    tempoRodando = false;
  }

  void tick() {
    if (tempoRodando) {
      if (!goldenScore && tempoSegundos > 0) {
        tempoSegundos--;
        if (tempoSegundos == 0) {
          tempoRodando = false;
          if (wazaariA != wazaariB) {
            vencedor = wazaariA > wazaariB ? 0 : 1;
          } else {
            ativarGoldenScore();
          }
        }
      } else if (goldenScore) {
        tempoSegundos++;
      }

      if (osaekomiAtivo && ladoOsaekomi != null) {
        osaekomiSegundos++;
        if (osaekomiSegundos == 10) {
          marcarWazaari(ladoOsaekomi!);
        } else if (osaekomiSegundos >= 20) {
          marcarIppon(ladoOsaekomi!);
        }
      }
    }
  }

  void resetTempo() {
    _salvar();
    tempoSegundos = 240;
    goldenScore = false;
    tempoRodando = false;
    toketa();
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    ipponA = s.ipponA;
    ipponB = s.ipponB;
    wazaariA = s.wazaariA;
    wazaariB = s.wazaariB;
    shidoA = s.shidoA;
    shidoB = s.shidoB;
    tempoSegundos = s.tempoSegundos;
    osaekomiSegundos = s.osaekomiSegundos;
    goldenScore = s.goldenScore;
    osaekomiAtivo = s.osaekomiAtivo;
    ladoOsaekomi = s.ladoOsaekomi;
    vencedor = s.vencedor;
  }

  void reiniciar() {
    _pilha.clear();
    ipponA = 0;
    ipponB = 0;
    wazaariA = 0;
    wazaariB = 0;
    shidoA = 0;
    shidoB = 0;
    tempoSegundos = 240;
    tempoRodando = false;
    goldenScore = false;
    osaekomiAtivo = false;
    ladoOsaekomi = null;
    osaekomiSegundos = 0;
    vencedor = null;
  }

  void _salvar() => _pilha.add(_SnapJudo(this));
}

// ==========================================
// 5. KARATÊ
// ==========================================
class _SnapKarate {
  final int pontosA, pontosB;
  final int ipponA, ipponB, wazaariA, wazaariB, yukoA, yukoB, chuiA, chuiB;
  final int? senshu, vencedor;
  final int tempoSegundos;
  _SnapKarate(PlacarKarate p)
      : pontosA = p.pontosA,
        pontosB = p.pontosB,
        ipponA = p.ipponA,
        ipponB = p.ipponB,
        wazaariA = p.wazaariA,
        wazaariB = p.wazaariB,
        yukoA = p.yukoA,
        yukoB = p.yukoB,
        chuiA = p.chuiA,
        chuiB = p.chuiB,
        senshu = p.senshu,
        vencedor = p.vencedor,
        tempoSegundos = p.tempoSegundos;
}

class PlacarKarate {
  int pontosA = 0, pontosB = 0;
  int ipponA = 0, ipponB = 0;
  int wazaariA = 0, wazaariB = 0;
  int yukoA = 0, yukoB = 0;
  int chuiA = 0, chuiB = 0;
  int? senshu; // 0 ou 1
  int? vencedor;
  int tempoSegundos = 180; // 3:00 oficial
  bool tempoRodando = false;
  final List<_SnapKarate> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  void ponto(int lado) => marcarYuko(lado);

  void marcarYuko(int lado) {
    if (vencedor != null) return;
    _salvar();
    senshu ??= lado;
    if (lado == 0) {
      yukoA++;
      pontosA += 1;
    } else {
      yukoB++;
      pontosB += 1;
    }
    _checarDiferenca8();
  }

  void marcarWazaari(int lado) {
    if (vencedor != null) return;
    _salvar();
    senshu ??= lado;
    if (lado == 0) {
      wazaariA++;
      pontosA += 2;
    } else {
      wazaariB++;
      pontosB += 2;
    }
    _checarDiferenca8();
  }

  void marcarIppon(int lado) {
    if (vencedor != null) return;
    _salvar();
    senshu ??= lado;
    if (lado == 0) {
      ipponA++;
      pontosA += 3;
    } else {
      ipponB++;
      pontosB += 3;
    }
    _checarDiferenca8();
  }

  void _checarDiferenca8() {
    if ((pontosA - pontosB).abs() >= 8) {
      vencedor = pontosA > pontosB ? 0 : 1;
      tempoRodando = false;
    }
  }

  void marcarFalta(int lado) {
    if (vencedor != null) return;
    _salvar();
    if (lado == 0) {
      chuiA++;
      if (chuiA >= 4) {
        vencedor = 1; // Hansoku: desclassificação
        tempoRodando = false;
      }
    } else {
      chuiB++;
      if (chuiB >= 4) {
        vencedor = 0;
        tempoRodando = false;
      }
    }
  }

  void toggleSenshu(int lado) {
    _salvar();
    senshu = senshu == lado ? null : lado;
  }

  void tick() {
    if (tempoRodando && tempoSegundos > 0) {
      tempoSegundos--;
      if (tempoSegundos == 0) {
        tempoRodando = false;
        if (pontosA != pontosB) {
          vencedor = pontosA > pontosB ? 0 : 1;
        } else if (senshu != null) {
          vencedor = senshu;
        }
      }
    }
  }

  void resetTempo([int segundos = 180]) {
    _salvar();
    tempoSegundos = segundos;
    tempoRodando = false;
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    pontosA = s.pontosA;
    pontosB = s.pontosB;
    ipponA = s.ipponA;
    ipponB = s.ipponB;
    wazaariA = s.wazaariA;
    wazaariB = s.wazaariB;
    yukoA = s.yukoA;
    yukoB = s.yukoB;
    chuiA = s.chuiA;
    chuiB = s.chuiB;
    senshu = s.senshu;
    vencedor = s.vencedor;
    tempoSegundos = s.tempoSegundos;
  }

  void reiniciar() {
    _pilha.clear();
    pontosA = 0;
    pontosB = 0;
    ipponA = 0;
    ipponB = 0;
    wazaariA = 0;
    wazaariB = 0;
    yukoA = 0;
    yukoB = 0;
    chuiA = 0;
    chuiB = 0;
    senshu = null;
    vencedor = null;
    tempoSegundos = 180;
    tempoRodando = false;
  }

  void _salvar() => _pilha.add(_SnapKarate(this));
}

// ==========================================
// 6. PLACAR GERAL
// ==========================================
class _SnapGeral {
  final int pontosA, pontosB, periodo, tempoSegundos;
  _SnapGeral(PlacarGeral p)
      : pontosA = p.pontosA,
        pontosB = p.pontosB,
        periodo = p.periodo,
        tempoSegundos = p.tempoSegundos;
}

class PlacarGeral {
  int pontosA = 0, pontosB = 0;
  int periodo = 1;
  int tempoSegundos = 0;
  bool tempoRodando = false;
  final List<_SnapGeral> _pilha = [];

  bool get podeDesfazer => _pilha.isNotEmpty;

  void ponto(int lado) => adicionar(lado, 1);

  void adicionar(int lado, int qtd) {
    _salvar();
    if (lado == 0) {
      pontosA += qtd;
    } else {
      pontosB += qtd;
    }
  }

  void subtrair(int lado, int qtd) {
    _salvar();
    if (lado == 0) {
      pontosA = (pontosA - qtd).clamp(0, 9999);
    } else {
      pontosB = (pontosB - qtd).clamp(0, 9999);
    }
  }

  void proximoPeriodo() {
    _salvar();
    periodo++;
  }

  void tick() {
    if (tempoRodando) tempoSegundos++;
  }

  void resetTempo() {
    _salvar();
    tempoSegundos = 0;
    tempoRodando = false;
  }

  void desfazer() {
    if (_pilha.isEmpty) return;
    final s = _pilha.removeLast();
    pontosA = s.pontosA;
    pontosB = s.pontosB;
    periodo = s.periodo;
    tempoSegundos = s.tempoSegundos;
  }

  void reiniciar() {
    _pilha.clear();
    pontosA = 0;
    pontosB = 0;
    periodo = 1;
    tempoSegundos = 0;
    tempoRodando = false;
  }

  void _salvar() => _pilha.add(_SnapGeral(this));
}
