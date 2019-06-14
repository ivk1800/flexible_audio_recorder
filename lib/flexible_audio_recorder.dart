import 'dart:async';

import 'package:flutter/services.dart';

class FlexibleAudioRecorder {
  static const MethodChannel _channel =
      const MethodChannel('flexible_audio_recorder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get hasAudioPermission async {
    final bool result = await _channel.invokeMethod('hasAudioPermission');
    return result;
  }

  static Future<bool> get isRecording async {
    final bool result = await _channel.invokeMethod('isRecording');
    return result;
  }

  static Future<String> startRecording({String filePath}) async {
    final String result =
        await _channel.invokeMethod('startRecording', {'filePath': filePath});
    return result;
  }

  static Future<String> stopRecording() async {
    final String result = await _channel.invokeMethod('stopRecording');
    return result;
  }

  static Future<bool> requestAudioPermission() async {
    final bool result = await _channel.invokeMethod('requestAudioPermission');
    return result;
  }
}
