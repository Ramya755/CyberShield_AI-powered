import 'package:flutter/foundation.dart';

import 'models/prediction_result.dart';
import 'tflite_service.dart';
import 'tokenizer_service.dart';

class PredictionService {
  final TfliteService _tfliteService;
  final TokenizerService _tokenizerService;

  bool _initialized = false;
  bool _ready = false;
  String? _lastError;

  PredictionService({
    TfliteService? tfliteService,
    TokenizerService? tokenizerService,
  })  : _tfliteService = tfliteService ?? TfliteService(),
        _tokenizerService = tokenizerService ?? TokenizerService();

  bool get isReady => _ready;
  String? get lastError => _lastError;

  Future<void> initialize() async {
    if (_initialized && _ready) return;

    try {
      _lastError = null;

      await _tokenizerService.initialize();
      await _tfliteService.initialize();

      _ready = true;
      _initialized = true;

      debugPrint('[PredictionService] Flutter TFLite prediction pipeline ready.');
    } catch (e) {
      _ready = false;
      _initialized = false;
      _lastError = e.toString();
      debugPrint('[PredictionService] Initialization failed: $e');
    }
  }

  Future<PredictionResult> predict(String message) async {
    final content = message.trim();

    if (content.isEmpty) {
      throw ArgumentError('Message cannot be empty.');
    }

    if (!_ready) {
      await initialize();
    }

    if (!_ready) {
      debugPrint('[PredictionService] Model not ready. Returning safe result.');
      return PredictionResult.safe();
    }

    try {
      final tokens = _tokenizerService.textToInputVector(
  content,
  maxLen: _tfliteService.inputSequenceLength,
);

debugPrint('[PredictionService] Tokens generated: ${tokens.take(10).toList()}');

final probability = await _tfliteService.runInference(tokens);

debugPrint('[PredictionService] Model probability: $probability');

final result = PredictionResult.fromProbability(probability);

debugPrint(
  '[PredictionService] Final Result -> '
  'RiskScore=${result.riskScore}, '
  'IsScam=${result.isScam}',
);

return result;
    } catch (e) {
      _lastError = e.toString();
      debugPrint('[PredictionService] Prediction failed: $e');
      return PredictionResult.safe();
    }
  }

  void dispose() {
    _tfliteService.dispose();
    _initialized = false;
    _ready = false;
  }
}