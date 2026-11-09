import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @titulo.
  ///
  /// In pt, this message translates to:
  /// **''**
  String get titulo;

  /// No description provided for @time1Padrao.
  ///
  /// In pt, this message translates to:
  /// **'NÓS'**
  String get time1Padrao;

  /// No description provided for @time2Padrao.
  ///
  /// In pt, this message translates to:
  /// **'ELES'**
  String get time2Padrao;

  /// No description provided for @editarNomes.
  ///
  /// In pt, this message translates to:
  /// **'Editar Nomes'**
  String get editarNomes;

  /// No description provided for @nomeTime1.
  ///
  /// In pt, this message translates to:
  /// **'Time 1'**
  String get nomeTime1;

  /// No description provided for @nomeTime2.
  ///
  /// In pt, this message translates to:
  /// **'Time 2'**
  String get nomeTime2;

  /// No description provided for @cancelar.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @salvar.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get salvar;

  /// No description provided for @botaoDesfazer.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer'**
  String get botaoDesfazer;

  /// No description provided for @botaoNovoJogo.
  ///
  /// In pt, this message translates to:
  /// **'Novo jogo'**
  String get botaoNovoJogo;

  /// No description provided for @saqueRotulo.
  ///
  /// In pt, this message translates to:
  /// **'Saque: {time}'**
  String saqueRotulo(String time);

  /// No description provided for @sacando.
  ///
  /// In pt, this message translates to:
  /// **'SACANDO'**
  String get sacando;

  /// No description provided for @telaCheia.
  ///
  /// In pt, this message translates to:
  /// **'Tela cheia'**
  String get telaCheia;

  /// No description provided for @sairTelaCheia.
  ///
  /// In pt, this message translates to:
  /// **'Sair da tela cheia'**
  String get sairTelaCheia;

  /// No description provided for @voz.
  ///
  /// In pt, this message translates to:
  /// **'Voz'**
  String get voz;

  /// No description provided for @tema.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get tema;

  /// No description provided for @idioma.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @nomes.
  ///
  /// In pt, this message translates to:
  /// **'Nomes'**
  String get nomes;

  /// No description provided for @games.
  ///
  /// In pt, this message translates to:
  /// **'GAMES'**
  String get games;

  /// No description provided for @set.
  ///
  /// In pt, this message translates to:
  /// **'S'**
  String get set;

  /// No description provided for @sets.
  ///
  /// In pt, this message translates to:
  /// **'SETS'**
  String get sets;

  /// No description provided for @tieBreak.
  ///
  /// In pt, this message translates to:
  /// **'TIE-BREAK'**
  String get tieBreak;

  /// No description provided for @vitoria.
  ///
  /// In pt, this message translates to:
  /// **'Vitória: {nome}'**
  String vitoria(String nome);

  /// No description provided for @vitoriaBanner.
  ///
  /// In pt, this message translates to:
  /// **'VITÓRIA {nome}'**
  String vitoriaBanner(String nome);

  /// No description provided for @narracaoSaque.
  ///
  /// In pt, this message translates to:
  /// **'Saque de {time}.'**
  String narracaoSaque(String time);

  /// No description provided for @narracaoFimDeJogo.
  ///
  /// In pt, this message translates to:
  /// **'Fim de jogo. Vitória de {nome}. {sets}'**
  String narracaoFimDeJogo(String nome, String sets);

  /// No description provided for @narracaoSet.
  ///
  /// In pt, this message translates to:
  /// **'Set para {nome}. {nome1} {set1}, {nome2} {set2}. Sets: {nome1} {setsGanhos1}, {nome2} {setsGanhos2}. {saque}'**
  String narracaoSet(
    String nome,
    String nome1,
    int set1,
    String nome2,
    int set2,
    int setsGanhos1,
    int setsGanhos2,
    String saque,
  );

  /// No description provided for @narracaoGame.
  ///
  /// In pt, this message translates to:
  /// **'Game para {nome}. {nome1} {game1}, {nome2} {game2}. {saque}'**
  String narracaoGame(
    String nome,
    String nome1,
    int game1,
    String nome2,
    int game2,
    String saque,
  );

  /// No description provided for @narracaoTieBreak.
  ///
  /// In pt, this message translates to:
  /// **'Game para {nome}. Seis a seis. Tie-break. {saque}'**
  String narracaoTieBreak(String nome, String saque);

  /// No description provided for @narracaoDesfeito.
  ///
  /// In pt, this message translates to:
  /// **'Desfeito. {frase}'**
  String narracaoDesfeito(String frase);

  /// No description provided for @vantagem.
  ///
  /// In pt, this message translates to:
  /// **'Vantagem {time}'**
  String vantagem(String time);

  /// No description provided for @pontoDeOuro.
  ///
  /// In pt, this message translates to:
  /// **'Ponto de ouro'**
  String get pontoDeOuro;

  /// No description provided for @iguais.
  ///
  /// In pt, this message translates to:
  /// **'Iguais'**
  String get iguais;

  /// No description provided for @placarPontos.
  ///
  /// In pt, this message translates to:
  /// **'{ponto1} a {ponto2}'**
  String placarPontos(String ponto1, String ponto2);

  /// No description provided for @selecionarPlacar.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Placar'**
  String get selecionarPlacar;

  /// No description provided for @esporteBeachTennis.
  ///
  /// In pt, this message translates to:
  /// **'Beach Tennis / Tênis'**
  String get esporteBeachTennis;

  /// No description provided for @esporteFutebol.
  ///
  /// In pt, this message translates to:
  /// **'Futebol'**
  String get esporteFutebol;

  /// No description provided for @esporteBasquete.
  ///
  /// In pt, this message translates to:
  /// **'Basquete'**
  String get esporteBasquete;

  /// No description provided for @esporteVolei.
  ///
  /// In pt, this message translates to:
  /// **'Vôlei'**
  String get esporteVolei;

  /// No description provided for @esporteJudo.
  ///
  /// In pt, this message translates to:
  /// **'Judô'**
  String get esporteJudo;

  /// No description provided for @esporteKarate.
  ///
  /// In pt, this message translates to:
  /// **'Karatê'**
  String get esporteKarate;

  /// No description provided for @esporteTenisDeMesa.
  ///
  /// In pt, this message translates to:
  /// **'Tênis de Mesa'**
  String get esporteTenisDeMesa;

  /// No description provided for @esporteGeral.
  ///
  /// In pt, this message translates to:
  /// **'Placar Geral'**
  String get esporteGeral;

  /// No description provided for @periodo.
  ///
  /// In pt, this message translates to:
  /// **'P'**
  String get periodo;

  /// No description provided for @tempo.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get tempo;

  /// No description provided for @gols.
  ///
  /// In pt, this message translates to:
  /// **'GOLS'**
  String get gols;

  /// No description provided for @pontos.
  ///
  /// In pt, this message translates to:
  /// **'PONTOS'**
  String get pontos;

  /// No description provided for @faltas.
  ///
  /// In pt, this message translates to:
  /// **'FALTAS'**
  String get faltas;

  /// No description provided for @cartaoAmarelo.
  ///
  /// In pt, this message translates to:
  /// **'Amarelo'**
  String get cartaoAmarelo;

  /// No description provided for @cartaoVermelho.
  ///
  /// In pt, this message translates to:
  /// **'Vermelho'**
  String get cartaoVermelho;

  /// No description provided for @primeiroTempo.
  ///
  /// In pt, this message translates to:
  /// **'1º T'**
  String get primeiroTempo;

  /// No description provided for @segundoTempo.
  ///
  /// In pt, this message translates to:
  /// **'2º Tempo'**
  String get segundoTempo;

  /// No description provided for @intervalo.
  ///
  /// In pt, this message translates to:
  /// **'Intervalo'**
  String get intervalo;

  /// No description provided for @prorrogacao.
  ///
  /// In pt, this message translates to:
  /// **'Prorrogação'**
  String get prorrogacao;

  /// No description provided for @penaltis.
  ///
  /// In pt, this message translates to:
  /// **'Pênaltis'**
  String get penaltis;

  /// No description provided for @quarto1.
  ///
  /// In pt, this message translates to:
  /// **'1º Q'**
  String get quarto1;

  /// No description provided for @quarto2.
  ///
  /// In pt, this message translates to:
  /// **'2º Q'**
  String get quarto2;

  /// No description provided for @quarto3.
  ///
  /// In pt, this message translates to:
  /// **'3º Q'**
  String get quarto3;

  /// No description provided for @quarto4.
  ///
  /// In pt, this message translates to:
  /// **'4º Q'**
  String get quarto4;

  /// No description provided for @goldenScore.
  ///
  /// In pt, this message translates to:
  /// **'GOLDEN SCORE'**
  String get goldenScore;

  /// No description provided for @osaekomi.
  ///
  /// In pt, this message translates to:
  /// **'Osaekomi'**
  String get osaekomi;

  /// No description provided for @toketa.
  ///
  /// In pt, this message translates to:
  /// **'Toketa'**
  String get toketa;

  /// No description provided for @shido.
  ///
  /// In pt, this message translates to:
  /// **'Shido'**
  String get shido;

  /// No description provided for @wazaari.
  ///
  /// In pt, this message translates to:
  /// **'Waza-ari'**
  String get wazaari;

  /// No description provided for @ippon.
  ///
  /// In pt, this message translates to:
  /// **'Ippon'**
  String get ippon;

  /// No description provided for @yuko.
  ///
  /// In pt, this message translates to:
  /// **'Yuko'**
  String get yuko;

  /// No description provided for @senshu.
  ///
  /// In pt, this message translates to:
  /// **'Senshu'**
  String get senshu;

  /// No description provided for @iniciar.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar'**
  String get iniciar;

  /// No description provided for @pausar.
  ///
  /// In pt, this message translates to:
  /// **'Pausar'**
  String get pausar;

  /// No description provided for @zerar.
  ///
  /// In pt, this message translates to:
  /// **'Zerar'**
  String get zerar;

  /// No description provided for @maisUm.
  ///
  /// In pt, this message translates to:
  /// **'+1'**
  String get maisUm;

  /// No description provided for @maisDois.
  ///
  /// In pt, this message translates to:
  /// **'+2'**
  String get maisDois;

  /// No description provided for @maisTres.
  ///
  /// In pt, this message translates to:
  /// **'+3'**
  String get maisTres;

  /// No description provided for @menosUm.
  ///
  /// In pt, this message translates to:
  /// **'-1'**
  String get menosUm;

  /// No description provided for @narracaoGol.
  ///
  /// In pt, this message translates to:
  /// **'Gol de {time}! {nome1} {gols1}, {nome2} {gols2}.'**
  String narracaoGol(
    String time,
    String nome1,
    int gols1,
    String nome2,
    int gols2,
  );

  /// No description provided for @narracaoCesta.
  ///
  /// In pt, this message translates to:
  /// **'Cesta de {time}! {nome1} {pontos1}, {nome2} {pontos2}.'**
  String narracaoCesta(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  );

  /// No description provided for @narracaoPonto.
  ///
  /// In pt, this message translates to:
  /// **'Ponto de {time}! {nome1} {pontos1}, {nome2} {pontos2}.'**
  String narracaoPonto(
    String time,
    String nome1,
    int pontos1,
    String nome2,
    int pontos2,
  );

  /// No description provided for @narracaoVoleiSet.
  ///
  /// In pt, this message translates to:
  /// **'Set para {nome}! Sets: {nome1} {sets1}, {nome2} {sets2}.'**
  String narracaoVoleiSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  );

  /// No description provided for @narracaoTenisDeMesaSet.
  ///
  /// In pt, this message translates to:
  /// **'Set para {nome}! Sets: {nome1} {sets1}, {nome2} {sets2}.'**
  String narracaoTenisDeMesaSet(
    String nome,
    String nome1,
    int sets1,
    String nome2,
    int sets2,
  );

  /// No description provided for @narracaoJudoIppon.
  ///
  /// In pt, this message translates to:
  /// **'Ippon para {time}! Vitória de {time}!'**
  String narracaoJudoIppon(String time);

  /// No description provided for @narracaoJudoWazaari.
  ///
  /// In pt, this message translates to:
  /// **'Waza-ari para {time}!'**
  String narracaoJudoWazaari(String time);

  /// No description provided for @narracaoJudoShido.
  ///
  /// In pt, this message translates to:
  /// **'Shido para {time}.'**
  String narracaoJudoShido(String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
