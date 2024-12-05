import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' show parse;
import 'package:fluent_reader_lite/utils/global.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  String currentText = '';

  Future<void> init() async {
    await flutterTts.setLanguage(Global.globalModel.ttsLanguage);
    await flutterTts.setSpeechRate(Global.globalModel.ttsSpeed);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      isPlaying = false;
    });
  }

  String _cleanHtmlContent(String htmlContent) {
    if (htmlContent == null) return '';
    var document = parse(htmlContent);
    String text = document.body.text;
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> speak(String htmlContent) async {
    if (!Global.globalModel.ttsEnabled) return;
    
    if (isPlaying) {
      await stop();
    }

    currentText = _cleanHtmlContent(htmlContent);
    if (currentText.isEmpty) return;

    isPlaying = true;
    await flutterTts.speak(currentText);
  }

  Future<void> stop() async {
    isPlaying = false;
    await flutterTts.stop();
  }

  Future<void> pause() async {
    isPlaying = false;
    await flutterTts.pause();
  }

  Future<void> resume() async {
    if (!isPlaying && currentText.isNotEmpty) {
      isPlaying = true;
      await flutterTts.speak(currentText);
    }
  }

  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await flutterTts.getLanguages;
      return List<String>.from(languages);
    } catch (e) {
      print('Failed to get languages: $e');
      return ['zh-CN', 'en-US'];
    }
  }
} 