import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'modelos_placares.dart';
import 'narrador.dart';
import 'placar.dart';

/// Tema global: sistema -> claro -> escuro.
final ValueNotifier<ThemeMode> temaNotifier = ValueNotifier(ThemeMode.system);

/// Idioma global: pt, en, es, fr.
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('pt'));

void main() => runApp(const OctoApp());

class OctoApp extends StatelessWidget {
  const OctoApp({super.key});

  ThemeData _tema(Brightness b) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3F51B5),
      brightness: b,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          b == Brightness.dark ? const Color(0xFF0E1116) : const Color(0xFFF4F6FA),
      fontFamily: null,
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: temaNotifier,
        builder: (_, modo, child) => ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (_, locale, child2) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.titulo,
            themeMode: modo,
            theme: _tema(Brightness.light),
            darkTheme: _tema(Brightness.dark),
            home: const PlacarPage(),
          ),
        ),
      );
}

class PlacarPage extends StatefulWidget {
  const PlacarPage({super.key});
  @override
  State<PlacarPage> createState() => _PlacarPageState();
}

class _PlacarPageState extends State<PlacarPage> {
  static const _canal = EventChannel('octo/controle');
  
  // Esporte selecionado
  TipoEsporte esporteAtual = TipoEsporte.beachTennis;

  // Instâncias dos modelos de placares
  Placar p = Placar();
  final PlacarFutebol pFutebol = PlacarFutebol();
  final PlacarBasquete pBasquete = PlacarBasquete();
  final PlacarVolei pVolei = PlacarVolei();
  final PlacarTenisDeMesa pTenisDeMesa = PlacarTenisDeMesa();
  final PlacarJudo pJudo = PlacarJudo();
  final PlacarKarate pKarate = PlacarKarate();
  final PlacarGeral pGeral = PlacarGeral();

  final narrador = Narrador();
  StreamSubscription? _sub;
  Timer? _timerLoop;

  String? _customNomeNos;
  String? _customNomeEles;
  String log = 'Aguardando o controle…';
  String? erro;
  bool _cheia = false;

  @override
  void initState() {
    super.initState();
    _sub = _canal.receiveBroadcastStream().listen(_evento,
        onError: (e) => setState(() => erro = 'Erro no canal do controle: $e'));
    final codigoTts = _ttsCodeForLocale(localeNotifier.value);
    narrador.iniciar(codigoTts).then((e) {
      if (e != null && mounted) setState(() => erro = e);
    });

    _timerLoop = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      bool atualiza = false;
      if (esporteAtual == TipoEsporte.futebol && pFutebol.tempoRodando) {
        pFutebol.tick();
        atualiza = true;
      } else if (esporteAtual == TipoEsporte.basquete && pBasquete.tempoRodando) {
        pBasquete.tick();
        atualiza = true;
      } else if (esporteAtual == TipoEsporte.judo && pJudo.tempoRodando) {
        pJudo.tick();
        atualiza = true;
      } else if (esporteAtual == TipoEsporte.karate && pKarate.tempoRodando) {
        pKarate.tick();
        atualiza = true;
      } else if (esporteAtual == TipoEsporte.geral && pGeral.tempoRodando) {
        pGeral.tick();
        atualiza = true;
      }
      if (atualiza) setState(() {});
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timerLoop?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  static String _ttsCodeForLocale(Locale loc) => switch (loc.languageCode) {
        'en' => 'en-US',
        'es' => 'es-ES',
        'fr' => 'fr-FR',
        _ => 'pt-BR',
      };

  void _mudarIdioma(Locale novaLocale) {
    localeNotifier.value = novaLocale;
    narrador.setLingua(_ttsCodeForLocale(novaLocale)).then((e) {
      if (e != null && mounted) setState(() => erro = e);
    });
  }

  String _nome(int i) {
    final loc = AppLocalizations.of(context);
    if (i == 0) {
      return _customNomeNos ?? loc?.time1Padrao ?? 'NÓS';
    }
    return _customNomeEles ?? loc?.time2Padrao ?? 'ELES';
  }

  bool get _podeDesfazer => switch (esporteAtual) {
        TipoEsporte.beachTennis => p.podeDesfazer,
        TipoEsporte.futebol => pFutebol.podeDesfazer,
        TipoEsporte.basquete => pBasquete.podeDesfazer,
        TipoEsporte.volei => pVolei.podeDesfazer,
        TipoEsporte.tenisDeMesa => pTenisDeMesa.podeDesfazer,
        TipoEsporte.judo => pJudo.podeDesfazer,
        TipoEsporte.karate => pKarate.podeDesfazer,
        TipoEsporte.geral => pGeral.podeDesfazer,
      };

  int? get _vencedorAtual => switch (esporteAtual) {
        TipoEsporte.beachTennis => p.vencedor,
        TipoEsporte.volei => pVolei.vencedor,
        TipoEsporte.tenisDeMesa => pTenisDeMesa.vencedor,
        TipoEsporte.judo => pJudo.vencedor,
        TipoEsporte.karate => pKarate.vencedor,
        _ => null,
      };

  // ---------- ações ----------
  void _editarNomes() {
    final loc = AppLocalizations.of(context)!;
    final t1 = TextEditingController(text: _nome(0));
    final t2 = TextEditingController(text: _nome(1));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.editarNomes),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: t1, decoration: InputDecoration(labelText: loc.nomeTime1)),
          TextField(controller: t2, decoration: InputDecoration(labelText: loc.nomeTime2)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.cancelar)),
          FilledButton(
            onPressed: () {
              setState(() {
                _customNomeNos = t1.text.trim().toUpperCase();
                _customNomeEles = t2.text.trim().toUpperCase();
              });
              Navigator.pop(context);
            },
            child: Text(loc.salvar),
          ),
        ],
      ),
    );
  }

  void _selecionarEsporte() {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.sports, color: Theme.of(context).colorScheme.primary, size: 26),
                    const SizedBox(width: 12),
                    Text(
                      loc.selecionarPlacar,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: TipoEsporte.values.map((esp) {
                    final selecionado = esp == esporteAtual;
                    final cs = Theme.of(context).colorScheme;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: selecionado
                            ? cs.primary
                            : cs.surfaceContainerHighest,
                        child: Icon(
                          esp.icone,
                          color: selecionado
                              ? cs.onPrimary
                              : cs.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        esp.nome(loc),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selecionado
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: selecionado ? cs.primary : null,
                        ),
                      ),
                      trailing: selecionado
                          ? Icon(Icons.check_circle, color: cs.primary)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        if (esporteAtual != esp) {
                          setState(() => esporteAtual = esp);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _marcar(int lado) {
    final loc = AppLocalizations.of(context)!;
    final nomeLado = lado == 0 ? _nome(0) : _nome(1);

    switch (esporteAtual) {
      case TipoEsporte.beachTennis:
        if (p.vencedor != null) return;
        final setsAntes = p.sets.length;
        final gamesAntes = p.ga + p.gb;
        setState(() => p.ponto(lado));
        HapticFeedback.lightImpact();
        _falar(_fraseAposBeachTennis(lado, setsAntes, gamesAntes));
      case TipoEsporte.futebol:
        setState(() => pFutebol.gol(lado));
        HapticFeedback.lightImpact();
        _falar(loc.narracaoGol(nomeLado, _nome(0), pFutebol.golsA, _nome(1), pFutebol.golsB));
      case TipoEsporte.basquete:
        setState(() => pBasquete.adicionarPontos(lado, 2));
        HapticFeedback.lightImpact();
        _falar(loc.narracaoCesta(nomeLado, _nome(0), pBasquete.pontosA, _nome(1), pBasquete.pontosB));
      case TipoEsporte.volei:
        if (pVolei.vencedor != null) return;
        final setsAntes = pVolei.setsA + pVolei.setsB;
        setState(() => pVolei.ponto(lado));
        HapticFeedback.lightImpact();
        if (pVolei.vencedor != null) {
          _falar(loc.narracaoFimDeJogo(nomeLado, '${pVolei.setsA}-${pVolei.setsB}'));
        } else if (pVolei.setsA + pVolei.setsB > setsAntes) {
          _falar(loc.narracaoVoleiSet(nomeLado, _nome(0), pVolei.setsA, _nome(1), pVolei.setsB));
        } else {
          _falar(loc.narracaoPonto(nomeLado, _nome(0), pVolei.pontosA, _nome(1), pVolei.pontosB));
        }
      case TipoEsporte.tenisDeMesa:
        if (pTenisDeMesa.vencedor != null) return;
        final setsAntes = pTenisDeMesa.setsA + pTenisDeMesa.setsB;
        setState(() => pTenisDeMesa.ponto(lado));
        HapticFeedback.lightImpact();
        if (pTenisDeMesa.vencedor != null) {
          _falar(loc.narracaoFimDeJogo(nomeLado, '${pTenisDeMesa.setsA}-${pTenisDeMesa.setsB}'));
        } else if (pTenisDeMesa.setsA + pTenisDeMesa.setsB > setsAntes) {
          _falar(loc.narracaoTenisDeMesaSet(nomeLado, _nome(0), pTenisDeMesa.setsA, _nome(1), pTenisDeMesa.setsB));
        } else {
          _falar(loc.narracaoPonto(nomeLado, _nome(0), pTenisDeMesa.pontosA, _nome(1), pTenisDeMesa.pontosB));
        }
      case TipoEsporte.judo:
        if (pJudo.vencedor != null) return;
        setState(() => pJudo.marcarWazaari(lado));
        HapticFeedback.lightImpact();
        if (pJudo.vencedor != null) {
          _falar(loc.narracaoJudoIppon(_nome(pJudo.vencedor!)));
        } else {
          _falar(loc.narracaoJudoWazaari(nomeLado));
        }
      case TipoEsporte.karate:
        if (pKarate.vencedor != null) return;
        setState(() => pKarate.marcarYuko(lado));
        HapticFeedback.lightImpact();
        if (pKarate.vencedor != null) {
          _falar(loc.narracaoFimDeJogo(_nome(pKarate.vencedor!), '${pKarate.pontosA}-${pKarate.pontosB}'));
        } else {
          _falar(loc.narracaoPonto(nomeLado, _nome(0), pKarate.pontosA, _nome(1), pKarate.pontosB));
        }
      case TipoEsporte.geral:
        setState(() => pGeral.adicionar(lado, 1));
        HapticFeedback.lightImpact();
        _falar(loc.narracaoPonto(nomeLado, _nome(0), pGeral.pontosA, _nome(1), pGeral.pontosB));
    }
  }

  void _desfazer() {
    if (!_podeDesfazer) return;
    setState(() {
      switch (esporteAtual) {
        case TipoEsporte.beachTennis:
          p.desfazer();
        case TipoEsporte.futebol:
          pFutebol.desfazer();
        case TipoEsporte.basquete:
          pBasquete.desfazer();
        case TipoEsporte.volei:
          pVolei.desfazer();
        case TipoEsporte.tenisDeMesa:
          pTenisDeMesa.desfazer();
        case TipoEsporte.judo:
          pJudo.desfazer();
        case TipoEsporte.karate:
          pKarate.desfazer();
        case TipoEsporte.geral:
          pGeral.desfazer();
      }
    });
    final loc = AppLocalizations.of(context)!;
    _falar(loc.narracaoDesfeito(''));
  }

  void _reiniciar() {
    setState(() {
      switch (esporteAtual) {
        case TipoEsporte.beachTennis:
          p = Placar();
        case TipoEsporte.futebol:
          pFutebol.reiniciar();
        case TipoEsporte.basquete:
          pBasquete.reiniciar();
        case TipoEsporte.volei:
          pVolei.reiniciar();
        case TipoEsporte.tenisDeMesa:
          pTenisDeMesa.reiniciar();
        case TipoEsporte.judo:
          pJudo.reiniciar();
        case TipoEsporte.karate:
          pKarate.reiniciar();
        case TipoEsporte.geral:
          pGeral.reiniciar();
      }
    });
  }

  Future<void> _falar(String texto) async {
    final e = await narrador.falar(texto);
    if (e != null && mounted) setState(() => erro = e);
  }

  void _ciclarTema() {
    final atual = temaNotifier.value;
    temaNotifier.value = switch (atual) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  // ---------- frases Beach Tennis ----------
  String _saqueBeachTennis() {
    final loc = AppLocalizations.of(context)!;
    final nome = p.sacador == 0 ? _nome(0).toLowerCase() : _nome(1).toLowerCase();
    return loc.narracaoSaque(nome);
  }

  String _fraseAposBeachTennis(int lado, int setsAntes, int gamesAntes) {
    final loc = AppLocalizations.of(context)!;
    final nome = lado == 0 ? _nome(0).toLowerCase() : _nome(1).toLowerCase();
    if (p.vencedor != null) {
      final s = p.sets.map((x) => loc.placarPontos('${x[0]}', '${x[1]}')).join(', ');
      return loc.narracaoFimDeJogo(nome, s);
    }
    if (p.sets.length > setsAntes) {
      final u = p.sets.last;
      return loc.narracaoSet(
        nome,
        _nome(0),
        u[0],
        _nome(1),
        u[1],
        p.setsGanhos(0),
        p.setsGanhos(1),
        _saqueBeachTennis(),
      );
    }
    if (p.ga + p.gb > gamesAntes) {
      return p.tiebreak
          ? loc.narracaoTieBreak(nome, _saqueBeachTennis())
          : loc.narracaoGame(nome, _nome(0), p.ga, _nome(1), p.gb, _saqueBeachTennis());
    }
    return _fraseAtualBeachTennis();
  }

  String _fraseAtualBeachTennis() {
    final loc = AppLocalizations.of(context)!;
    final s = p.sacador, r = 1 - s;
    if (p.tiebreak) {
      return loc.placarPontos('${s == 0 ? p.pa : p.pb}', '${s == 0 ? p.pb : p.pa}');
    }
    final a = p.textoPonto(0), b = p.textoPonto(1);
    if (a == 'AD') return loc.vantagem(_nome(0));
    if (b == 'AD') return loc.vantagem(_nome(1));
    if (a == '40' && b == '40') return p.pontoDeOuro ? loc.pontoDeOuro : loc.iguais;
    return loc.placarPontos(p.textoPonto(s), p.textoPonto(r));
  }

  // Mapeamento controle remoto
  void _evento(dynamic e) {
    final m = Map<String, dynamic>.from(e as Map);
    if (m['tipo'] == 'gesto') {
      final d = m['dir'] as String;
      setState(() => log = 'gesto: $d  dx=${m['dx']} dy=${m['dy']}');
      switch (d) {
        case 'direita':
          _marcar(0);
        case 'esquerda':
          _marcar(1);
        case 'toque':
        case 'cima':
        case 'baixo':
          _desfazer();
      }
    } else {
      setState(() => log = 'tecla: ${m['nome']} (${m['codigo']}) ${m['acao']}');
    }
  }

  // ---------- design ----------
  static const _tabular = [FontFeature.tabularFigures()];

  Color _cor(int i) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    if (i == 0) return escuro ? const Color(0xFF7FA6FF) : const Color(0xFF1F5EFF);
    return escuro ? const Color(0xFFFFA566) : const Color(0xFFE8590C);
  }

  IconData get _iconeTema => switch (temaNotifier.value) {
        ThemeMode.system => Icons.brightness_auto,
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
      };

  Widget _botaoIdioma() {
    final loc = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      tooltip: loc.idioma,
      icon: const Icon(Icons.language, size: 20),
      padding: const EdgeInsets.all(4),
      initialValue: localeNotifier.value,
      onSelected: _mudarIdioma,
      itemBuilder: (context) => const [
        PopupMenuItem(value: Locale('pt'), child: Text('🇧🇷 Português')),
        PopupMenuItem(value: Locale('en'), child: Text('🇺🇸 English')),
        PopupMenuItem(value: Locale('es'), child: Text('🇪🇸 Español')),
        PopupMenuItem(value: Locale('fr'), child: Text('🇫🇷 Français')),
      ],
    );
  }

  Widget _botaoAcao({
    required String tooltip,
    required IconData icone,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icone, size: 20),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
      onPressed: onPressed,
    );
  }

  String _formatarTempo(int segs) {
    final m = (segs ~/ 60).toString().padLeft(2, '0');
    final s = (segs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget? _badgeStatus(ColorScheme cs, AppLocalizations loc) {
    String? texto;
    Color corFundo = cs.tertiaryContainer;
    Color corTexto = cs.onTertiaryContainer;

    switch (esporteAtual) {
      case TipoEsporte.beachTennis:
        if (p.tiebreak) texto = loc.tieBreak;
      case TipoEsporte.futebol:
        texto = pFutebol.textoPeriodo(loc);
      case TipoEsporte.basquete:
        texto = pBasquete.textoQuarto(loc);
      case TipoEsporte.volei:
        texto = pVolei.isTieBreak ? loc.tieBreak : '${loc.set} ${pVolei.historicoSets.length + 1}';
      case TipoEsporte.tenisDeMesa:
        texto = '${loc.set} ${pTenisDeMesa.historicoSets.length + 1}';
      case TipoEsporte.judo:
        if (pJudo.goldenScore) {
          texto = loc.goldenScore;
          corFundo = Colors.amber.shade700;
          corTexto = Colors.white;
        } else if (pJudo.osaekomiAtivo) {
          texto = '${loc.osaekomi} ${pJudo.osaekomiSegundos}s';
          corFundo = Colors.red.shade700;
          corTexto = Colors.white;
        }
      case TipoEsporte.karate:
        if (pKarate.senshu != null) {
          texto = '${loc.senshu}: ${_nome(pKarate.senshu!)}';
        }
      case TipoEsporte.geral:
        texto = '${loc.periodo} ${pGeral.periodo}';
    }

    if (texto == null || texto.isEmpty) return null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: corFundo, borderRadius: BorderRadius.circular(20)),
      child: Text(
        texto,
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: corTexto),
      ),
    );
  }

  Widget _barraTopo() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final badge = _badgeStatus(cs, loc);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 4, 0),
      child: Row(children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _selecionarEsporte,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(esporteAtual.icone, color: cs.primary, size: 22),
                const SizedBox(width: 2),
                Icon(Icons.arrow_drop_down, color: cs.primary, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge != null) ...[
                const SizedBox(width: 6),
                badge,
              ],
            ],
          ),
        ),
        const Spacer(),
        _botaoAcao(
            tooltip: loc.nomes,
            icone: Icons.edit,
            onPressed: _editarNomes),
        _botaoIdioma(),
        _botaoAcao(
            tooltip: loc.telaCheia,
            icone: Icons.fullscreen,
            onPressed: _alternarCheia),
        _botaoAcao(
            tooltip: loc.voz,
            icone: narrador.ativo ? Icons.volume_up : Icons.volume_off,
            onPressed: () => setState(() => narrador.ativo = !narrador.ativo)),
        _botaoAcao(
            tooltip: loc.tema,
            icone: _iconeTema,
            onPressed: () => setState(_ciclarTema)),
      ]),
    );
  }

  // ---------- Placar Beach Tennis ----------
  Widget _celula(String texto,
      {bool destaque = false,
      Color? cor,
      bool games = false,
      bool solido = false}) {
    final cs = Theme.of(context).colorScheme;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final grande = games || solido;
    return Container(
      width: grande ? 44 : 38,
      height: 44,
      margin: const EdgeInsets.only(left: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: solido ? cor : (games ? cor?.withAlpha(46) : null),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(texto,
          style: TextStyle(
            fontSize: grande ? 26 : 18,
            fontWeight: (destaque || grande) ? FontWeight.w800 : FontWeight.w400,
            color: solido
                ? (escuro ? Colors.black : Colors.white)
                : games
                    ? cor
                    : cs.onSurface.withAlpha(destaque ? 255 : 128),
            fontFeatures: _tabular,
          )),
    );
  }

  Widget _linhaQuadro(int i) {
    final cor = _cor(i);
    final sacando = p.sacador == i && p.vencedor == null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(
            width: 24,
            child: sacando
                ? Icon(Icons.sports_tennis, size: 18, color: cor)
                : null),
        Container(
            width: 6,
            height: 24,
            decoration:
                BoxDecoration(color: cor, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 10),
        Expanded(
            child: Text(_nome(i),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        for (final s in p.sets) _celula('${s[i]}', destaque: s[i] > s[1 - i]),
        _celula('${i == 0 ? p.ga : p.gb}', cor: cor, games: true),
        _celula('${p.setsGanhos(i)}', cor: cor, solido: true),
      ]),
    );
  }

  Widget _quadroBeachTennis() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          const Expanded(child: SizedBox()),
          for (final t in [loc.games, loc.sets])
            SizedBox(
                width: 50,
                child: Text(t,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant))),
        ]),
        _linhaQuadro(0),
        Divider(height: 1, color: cs.outlineVariant.withAlpha(128)),
        _linhaQuadro(1),
      ]),
    );
  }

  // ---------- Painéis de Status dos outros esportes ----------
  Widget _painelFutebol() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Período
          InkWell(
            onTap: () => setState(pFutebol.proximoPeriodo),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(pFutebol.textoPeriodo(loc),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ),
          // Cronômetro
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatarTempo(pFutebol.tempoSegundos),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFeatures: _tabular,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(pFutebol.tempoRodando ? Icons.pause : Icons.play_arrow,
                    color: cs.primary),
                onPressed: () => setState(() => pFutebol.tempoRodando = !pFutebol.tempoRodando),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => setState(pFutebol.resetTempo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _painelBasquete() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quarto
          InkWell(
            onTap: () => setState(pBasquete.proximoQuarto),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(pBasquete.textoQuarto(loc),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ),
          // Cronômetro
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatarTempo(pBasquete.tempoSegundos),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFeatures: _tabular,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(pBasquete.tempoRodando ? Icons.pause : Icons.play_arrow,
                    color: cs.primary),
                onPressed: () => setState(() => pBasquete.tempoRodando = !pBasquete.tempoRodando),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => setState(pBasquete.resetTempo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _painelVolei() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final hist = pVolei.historicoSets.map((s) => '${s[0]}-${s[1]}').join('   ');
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${loc.sets}: ${pVolei.setsA} – ${pVolei.setsB}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          if (hist.isNotEmpty)
            Text(hist, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
            icon: const Icon(Icons.swap_horiz, size: 16),
            label: Text(loc.saqueRotulo(_nome(pVolei.sacador)),
                style: const TextStyle(fontSize: 11)),
            onPressed: () => setState(pVolei.trocarSaque),
          ),
        ],
      ),
    );
  }

  Widget _painelTenisDeMesa() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final hist = pTenisDeMesa.historicoSets.map((s) => '${s[0]}-${s[1]}').join('   ');
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${loc.sets}: ${pTenisDeMesa.setsA} – ${pTenisDeMesa.setsB}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          if (hist.isNotEmpty)
            Text(hist, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
            icon: const Icon(Icons.swap_horiz, size: 16),
            label: Text(loc.saqueRotulo(_nome(pTenisDeMesa.sacador)),
                style: const TextStyle(fontSize: 11)),
            onPressed: () => setState(pTenisDeMesa.trocarSaque),
          ),
        ],
      ),
    );
  }

  Widget _painelJudo() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatarTempo(pJudo.tempoSegundos),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFeatures: _tabular,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(pJudo.tempoRodando ? Icons.pause : Icons.play_arrow,
                    color: cs.primary),
                onPressed: () => setState(() => pJudo.tempoRodando = !pJudo.tempoRodando),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => setState(pJudo.resetTempo),
              ),
            ],
          ),
          if (pJudo.osaekomiAtivo)
            FilledButton.tonal(
              onPressed: () => setState(pJudo.toketa),
              child: Text(loc.toketa),
            )
          else
            OutlinedButton(
              onPressed: () => setState(pJudo.ativarGoldenScore),
              child: Text(loc.goldenScore, style: const TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _painelKarate() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatarTempo(pKarate.tempoSegundos),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFeatures: _tabular,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(pKarate.tempoRodando ? Icons.pause : Icons.play_arrow,
                    color: cs.primary),
                onPressed: () => setState(() => pKarate.tempoRodando = !pKarate.tempoRodando),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => setState(pKarate.resetTempo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _painelGeral() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(153),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => setState(pGeral.proximoPeriodo),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${loc.periodo} ${pGeral.periodo}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatarTempo(pGeral.tempoSegundos),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFeatures: _tabular,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(pGeral.tempoRodando ? Icons.pause : Icons.play_arrow,
                    color: cs.primary),
                onPressed: () => setState(() => pGeral.tempoRodando = !pGeral.tempoRodando),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => setState(pGeral.resetTempo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _painelStatus() => switch (esporteAtual) {
        TipoEsporte.beachTennis => _quadroBeachTennis(),
        TipoEsporte.futebol => _painelFutebol(),
        TipoEsporte.basquete => _painelBasquete(),
        TipoEsporte.volei => _painelVolei(),
        TipoEsporte.tenisDeMesa => _painelTenisDeMesa(),
        TipoEsporte.judo => _painelJudo(),
        TipoEsporte.karate => _painelKarate(),
        TipoEsporte.geral => _painelGeral(),
      };

  String _textoPontoCentral(int lado) => switch (esporteAtual) {
        TipoEsporte.beachTennis => p.textoPonto(lado),
        TipoEsporte.futebol => '${lado == 0 ? pFutebol.golsA : pFutebol.golsB}',
        TipoEsporte.basquete => '${lado == 0 ? pBasquete.pontosA : pBasquete.pontosB}',
        TipoEsporte.volei => '${lado == 0 ? pVolei.pontosA : pVolei.pontosB}',
        TipoEsporte.tenisDeMesa => '${lado == 0 ? pTenisDeMesa.pontosA : pTenisDeMesa.pontosB}',
        TipoEsporte.judo => (lado == 0 ? pJudo.ipponA : pJudo.ipponB) > 0
            ? 'IPPON'
            : 'W: ${lado == 0 ? pJudo.wazaariA : pJudo.wazaariB}',
        TipoEsporte.karate => '${lado == 0 ? pKarate.pontosA : pKarate.pontosB}',
        TipoEsporte.geral => '${lado == 0 ? pGeral.pontosA : pGeral.pontosB}',
      };

  Widget _botoesRapidos(int lado, {bool grande = false}) {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    Widget btn(String label, VoidCallback onTap,
            {Color? bg, Color? fg, double? minWidth}) =>
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: grande ? 4 : 2, vertical: grande ? 3 : 0),
          child: Material(
            color: bg ??
                (grande
                    ? cs.surfaceContainerHighest.withAlpha(210)
                    : cs.surfaceContainerHigh),
            borderRadius: BorderRadius.circular(grande ? 14 : 8),
            elevation: grande ? 2 : 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(grande ? 14 : 8),
              onTap: onTap,
              child: Container(
                constraints:
                    BoxConstraints(minWidth: minWidth ?? (grande ? 52 : 0)),
                padding: EdgeInsets.symmetric(
                    horizontal: grande ? 14 : 8, vertical: grande ? 9 : 4),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: grande ? 15 : 11,
                      fontWeight: FontWeight.w800,
                      color: fg ?? cs.onSurface),
                ),
              ),
            ),
          ),
        );

    switch (esporteAtual) {
      case TipoEsporte.futebol:
        final am = lado == 0 ? pFutebol.cartoesAmarelosA : pFutebol.cartoesAmarelosB;
        final vm = lado == 0 ? pFutebol.cartoesVermelhosA : pFutebol.cartoesVermelhosB;
        final fa = lado == 0 ? pFutebol.faltasA : pFutebol.faltasB;
        return Wrap(
          spacing: grande ? 8 : 4,
          runSpacing: grande ? 6 : 4,
          alignment: WrapAlignment.center,
          children: [
            btn('+ ${loc.gols}', () => _marcar(lado)),
            btn('🟨 $am', () => setState(() => pFutebol.amarelo(lado)),
                bg: Colors.amber.shade200, fg: Colors.brown.shade900),
            btn('🟥 $vm', () => setState(() => pFutebol.vermelho(lado)),
                bg: Colors.red.shade200, fg: Colors.red.shade900),
            btn('${loc.faltas}: $fa', () => setState(() => pFutebol.falta(lado))),
          ],
        );
      case TipoEsporte.basquete:
        final fa = lado == 0 ? pBasquete.faltasA : pBasquete.faltasB;
        return Wrap(
          spacing: grande ? 8 : 4,
          runSpacing: grande ? 6 : 4,
          alignment: WrapAlignment.center,
          children: [
            btn(loc.maisUm, () {
              setState(() => pBasquete.adicionarPontos(lado, 1));
              _falar(loc.narracaoCesta(_nome(lado), _nome(0), pBasquete.pontosA, _nome(1), pBasquete.pontosB));
            }),
            btn(loc.maisDois, () => _marcar(lado)),
            btn(loc.maisTres, () {
              setState(() => pBasquete.adicionarPontos(lado, 3));
              _falar(loc.narracaoCesta(_nome(lado), _nome(0), pBasquete.pontosA, _nome(1), pBasquete.pontosB));
            }),
            btn(loc.menosUm, () => setState(() => pBasquete.removerPonto(lado))),
            if (!grande)
              btn('${loc.faltas}: $fa', () => setState(() => pBasquete.adicionarFalta(lado))),
          ],
        );
      case TipoEsporte.judo:
        final shidos = lado == 0 ? pJudo.shidoA : pJudo.shidoB;
        return Wrap(
          spacing: grande ? 8 : 4,
          runSpacing: grande ? 6 : 4,
          alignment: WrapAlignment.center,
          children: [
            btn(loc.wazaari, () => _marcar(lado)),
            btn(loc.ippon, () {
              setState(() => pJudo.marcarIppon(lado));
              _falar(loc.narracaoJudoIppon(_nome(lado)));
            }),
            btn('${loc.shido}: $shidos', () {
              setState(() => pJudo.marcarShido(lado));
              _falar(loc.narracaoJudoShido(_nome(lado)));
            }, bg: Colors.amber.shade200, fg: Colors.brown.shade900),
            btn(loc.osaekomi, () => setState(() => pJudo.iniciarOsaekomi(lado))),
          ],
        );
      case TipoEsporte.karate:
        final chui = lado == 0 ? pKarate.chuiA : pKarate.chuiB;
        return Wrap(
          spacing: grande ? 8 : 4,
          runSpacing: grande ? 6 : 4,
          alignment: WrapAlignment.center,
          children: [
            btn('+1 ${loc.yuko}', () => _marcar(lado)),
            btn('+2 ${loc.wazaari}', () {
              setState(() => pKarate.marcarWazaari(lado));
              _falar(loc.narracaoPonto(_nome(lado), _nome(0), pKarate.pontosA, _nome(1), pKarate.pontosB));
            }),
            btn('+3 ${loc.ippon}', () {
              setState(() => pKarate.marcarIppon(lado));
              _falar(loc.narracaoPonto(_nome(lado), _nome(0), pKarate.pontosA, _nome(1), pKarate.pontosB));
            }),
            btn('${loc.faltas}: $chui', () => setState(() => pKarate.marcarFalta(lado))),
          ],
        );
      case TipoEsporte.geral:
        return Wrap(
          spacing: grande ? 8 : 4,
          runSpacing: grande ? 6 : 4,
          alignment: WrapAlignment.center,
          children: [
            btn(loc.maisUm, () => _marcar(lado)),
            btn(loc.maisDois, () => setState(() => pGeral.adicionar(lado, 2))),
            btn(loc.maisTres, () => setState(() => pGeral.adicionar(lado, 3))),
            btn(loc.menosUm, () => setState(() => pGeral.subtrair(lado, 1))),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _cartaoPonto(int i, {bool grande = false}) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final cor = _cor(i);
    final escuro = Theme.of(context).brightness == Brightness.dark;
    
    final sacando = (esporteAtual == TipoEsporte.beachTennis && p.sacador == i && p.vencedor == null) ||
        (esporteAtual == TipoEsporte.volei && pVolei.sacador == i && pVolei.vencedor == null) ||
        (esporteAtual == TipoEsporte.tenisDeMesa && pTenisDeMesa.sacador == i && pTenisDeMesa.vencedor == null);
    final venceu = _vencedorAtual == i;
    final texto = _textoPontoCentral(i);

    // Esportes que exibem botões de controle de pontos ou golpes mesmo em full screen
    final exibirBotoesEmFullScreen = switch (esporteAtual) {
      TipoEsporte.basquete ||
      TipoEsporte.geral ||
      TipoEsporte.judo ||
      TipoEsporte.karate =>
        true,
      _ => false,
    };

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(grande ? 6 : 8),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: cor.withAlpha(escuro ? (sacando ? 56 : 26) : (sacando ? 41 : 18)),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                  width: 3,
                  color: (sacando || venceu) ? cor : cor.withAlpha(31)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () => _marcar(i),
              child: Padding(
                padding: EdgeInsets.all(grande ? 10 : 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(_nome(i),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: grande ? 24 : 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: cor)),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: sacando ? 1 : 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: cor, borderRadius: BorderRadius.circular(20)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(esporteAtual.icone,
                                  size: 14, color: escuro ? Colors.black : Colors.white),
                              const SizedBox(width: 4),
                              Text(loc.sacando,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: escuro ? Colors.black : Colors.white)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            transitionBuilder: (c, a) =>
                                ScaleTransition(scale: a, child: FadeTransition(opacity: a, child: c)),
                            child: Text(
                              texto,
                              key: ValueKey('${esporteAtual.name}_${i}_$texto'),
                              style: TextStyle(
                                fontSize: grande ? 320 : 130,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                color: cs.onSurface,
                                fontFeatures: _tabular,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!grande || exibirBotoesEmFullScreen)
                      _botoesRapidos(i, grande: grande),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _banners() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final vencedor = _vencedorAtual;

    return Column(children: [
      if (erro != null)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
          decoration: BoxDecoration(
              color: cs.errorContainer, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Icon(Icons.error_outline, color: cs.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
                child: Text(erro!, style: TextStyle(color: cs.onErrorContainer))),
            IconButton(
                icon: Icon(Icons.close, color: cs.onErrorContainer),
                onPressed: () => setState(() => erro = null)),
          ]),
        ),
      if (vencedor != null)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
              color: _cor(vencedor), borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.emoji_events,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(loc.vitoria(_nome(vencedor)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white)),
            ),
          ]),
        ),
    ]);
  }

  Widget _acoes() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(log,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'monospace', fontSize: 11, color: cs.onSurfaceVariant)),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            FilledButton.tonalIcon(
                onPressed: _podeDesfazer ? _desfazer : null,
                icon: const Icon(Icons.undo),
                label: Text(loc.botaoDesfazer)),
            OutlinedButton.icon(
                onPressed: _reiniciar,
                icon: const Icon(Icons.restart_alt),
                label: Text(loc.botaoNovoJogo)),
            if (esporteAtual == TipoEsporte.beachTennis && !p.podeDesfazer)
              OutlinedButton.icon(
                  onPressed: () => setState(() => p.sacador = 1 - p.sacador),
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(loc.saqueRotulo(_nome(p.sacador)))),
          ],
        ),
      ]),
    );
  }

  // ---------- tela cheia ----------
  void _alternarCheia() {
    setState(() => _cheia = !_cheia);
    SystemChrome.setEnabledSystemUIMode(
        _cheia ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  Widget _blocoCentro(String rotulo, int a, int b) {
    final cs = Theme.of(context).colorScheme;
    TextStyle n(Color c, [double t = 38]) => TextStyle(
        fontSize: t,
        fontWeight: FontWeight.w800,
        color: c,
        fontFeatures: _tabular);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(rotulo,
          style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant)),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$a', style: n(_cor(0))),
        Text('  –  ', style: n(cs.onSurfaceVariant, 22)),
        Text('$b', style: n(_cor(1))),
      ]),
    ]);
  }

  Widget _centroFullScreen() {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final vencedor = _vencedorAtual;
    final status = vencedor != null ? loc.vitoriaBanner(_nome(vencedor)) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Informação do Esporte ou Placar Específico
        if (esporteAtual == TipoEsporte.beachTennis) ...[
          _blocoCentro(loc.games, p.ga, p.gb),
          const SizedBox(height: 8),
          _blocoCentro(loc.sets, p.setsGanhos(0), p.setsGanhos(1)),
        ] else if (esporteAtual == TipoEsporte.volei) ...[
          _blocoCentro(loc.sets, pVolei.setsA, pVolei.setsB),
        ] else if (esporteAtual == TipoEsporte.tenisDeMesa) ...[
          _blocoCentro(loc.sets, pTenisDeMesa.setsA, pTenisDeMesa.setsB),
        ] else ...[
          Text(esporteAtual.nome(loc),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: cs.primary)),
          const SizedBox(height: 4),
          // Cronômetro para os esportes com tempo
          if (esporteAtual == TipoEsporte.basquete) ...[
            Text(_formatarTempo(pBasquete.tempoSegundos),
                style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontFeatures: _tabular)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(pBasquete.tempoRodando ? Icons.pause : Icons.play_arrow,
                      color: cs.primary, size: 20),
                  onPressed: () => setState(() => pBasquete.tempoRodando = !pBasquete.tempoRodando),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: () => setState(pBasquete.resetTempo),
                ),
              ],
            ),
          ] else if (esporteAtual == TipoEsporte.futebol) ...[
            Text(_formatarTempo(pFutebol.tempoSegundos),
                style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontFeatures: _tabular)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(pFutebol.tempoRodando ? Icons.pause : Icons.play_arrow,
                      color: cs.primary, size: 20),
                  onPressed: () => setState(() => pFutebol.tempoRodando = !pFutebol.tempoRodando),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: () => setState(pFutebol.resetTempo),
                ),
              ],
            ),
          ] else if (esporteAtual == TipoEsporte.judo) ...[
            Text(_formatarTempo(pJudo.tempoSegundos),
                style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontFeatures: _tabular)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(pJudo.tempoRodando ? Icons.pause : Icons.play_arrow,
                      color: cs.primary, size: 20),
                  onPressed: () => setState(() => pJudo.tempoRodando = !pJudo.tempoRodando),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: () => setState(pJudo.resetTempo),
                ),
              ],
            ),
          ] else if (esporteAtual == TipoEsporte.karate) ...[
            Text(_formatarTempo(pKarate.tempoSegundos),
                style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontFeatures: _tabular)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(pKarate.tempoRodando ? Icons.pause : Icons.play_arrow,
                      color: cs.primary, size: 20),
                  onPressed: () => setState(() => pKarate.tempoRodando = !pKarate.tempoRodando),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: () => setState(pKarate.resetTempo),
                ),
              ],
            ),
          ] else if (esporteAtual == TipoEsporte.geral) ...[
            Text(_formatarTempo(pGeral.tempoSegundos),
                style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontFeatures: _tabular)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(pGeral.tempoRodando ? Icons.pause : Icons.play_arrow,
                      color: cs.primary, size: 20),
                  onPressed: () => setState(() => pGeral.tempoRodando = !pGeral.tempoRodando),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: () => setState(pGeral.resetTempo),
                ),
              ],
            ),
          ],
        ],

        if (status != null) ...[
          const SizedBox(height: 6),
          Text(status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.amber)),
        ],

        const SizedBox(height: 6),
        // Ações de controle
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          runSpacing: 2,
          children: [
            IconButton(
                tooltip: loc.selecionarPlacar,
                icon: Icon(esporteAtual.icone, color: cs.primary, size: 20),
                visualDensity: VisualDensity.compact,
                onPressed: _selecionarEsporte),
            _botaoIdioma(),
            IconButton(
                tooltip: loc.botaoDesfazer,
                icon: const Icon(Icons.undo, size: 20),
                visualDensity: VisualDensity.compact,
                onPressed: _podeDesfazer ? _desfazer : null),
            IconButton(
                tooltip: loc.sairTelaCheia,
                icon: const Icon(Icons.fullscreen_exit, size: 20),
                visualDensity: VisualDensity.compact,
                onPressed: _alternarCheia),
            IconButton(
                tooltip: loc.voz,
                icon: Icon(narrador.ativo ? Icons.volume_up : Icons.volume_off, size: 20),
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => narrador.ativo = !narrador.ativo)),
          ],
        ),
      ],
    );
  }

  Widget _telaCheia() {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(4),
        child: LayoutBuilder(builder: (context, c) {
          final paisagem = c.maxWidth > c.maxHeight;
          final centro = Container(
            width: paisagem ? 180 : null,
            height: paisagem ? null : 140,
            padding: const EdgeInsets.all(6),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _centroFullScreen(),
              ),
            ),
          );
          return Flex(
            direction: paisagem ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _cartaoPonto(0, grande: true),
              centro,
              _cartaoPonto(1, grande: true),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _cheia ? _telaCheia() : Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            final paisagem = c.maxWidth > c.maxHeight;
            if (paisagem) {
              return Row(children: [
                SizedBox(
                  width: 360,
                  child: Column(children: [
                    _barraTopo(),
                    _painelStatus(),
                    _banners(),
                    const Spacer(),
                    _acoes(),
                  ]),
                ),
                Expanded(
                    child: Row(children: [_cartaoPonto(0), _cartaoPonto(1)])),
              ]);
            }
            return Column(children: [
              _barraTopo(),
              _painelStatus(),
              _banners(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(children: [_cartaoPonto(0), _cartaoPonto(1)]),
              )),
              _acoes(),
            ]);
          }),
        ),
      );
}
