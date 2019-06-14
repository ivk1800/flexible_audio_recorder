import 'dart:async';

import 'package:flutter/services.dart';

class FlexibleAudioRecorder {
  static const MethodChannel _channel =
      const MethodChannel('flexible_audio_recorder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
