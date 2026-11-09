import 'package:flutter_tts/flutter_tts.dart';

class Narrador {
  final FlutterTts _tts = FlutterTts();
  bool ativo = true;
  String linguaAtual = 'pt-BR';

  /// Retorna mensagem de erro, ou null se tudo certo.
  Future<String?> iniciar([String codigo = 'pt-BR']) async {
    try {
      linguaAtual = codigo;
      final ok = await _tts.isLanguageAvailable(codigo);
      if (ok != true && ok != 1) {
        // Tenta apenas o código de 2 letras se não achar o regional
        final base = codigo.split('-').first;
        final okBase = await _tts.isLanguageAvailable(base);
        if (okBase == true || okBase == 1) {
          linguaAtual = base;
          await _tts.setLanguage(base);
          await _tts.setSpeechRate(0.5);
          return null;
        }
        return 'Voz $codigo não instalada. Verifique as configurações de TTS.';
      }
      await _tts.setLanguage(codigo);
      await _tts.setSpeechRate(0.5);
      return null;
    } catch (e) {
      return 'Erro ao iniciar a voz: $e';
    }
  }

  Future<String?> setLingua(String codigo) async {
    try {
      linguaAtual = codigo;
      final ok = await _tts.isLanguageAvailable(codigo);
      if (ok != true && ok != 1) {
        final base = codigo.split('-').first;
        final okBase = await _tts.isLanguageAvailable(base);
        if (okBase == true || okBase == 1) {
          linguaAtual = base;
          await _tts.setLanguage(base);
          return null;
        }
        await _tts.setLanguage(codigo);
        return 'Voz $codigo pode não estar instalada no dispositivo.';
      }
      await _tts.setLanguage(codigo);
      return null;
    } catch (e) {
      return 'Erro ao trocar voz: $e';
    }
  }

  /// Interrompe a fala anterior e fala a nova. Retorna erro ou null.
  Future<String?> falar(String texto) async {
    if (!ativo) return null;
    try {
      await _tts.stop();
      await _tts.speak(texto);
      return null;
    } catch (e) {
      return 'Erro na voz: $e';
    }
  }
}
