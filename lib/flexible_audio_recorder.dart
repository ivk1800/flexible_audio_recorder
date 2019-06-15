import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  static Future<void> setAndroidConfig(
      {@required int audioChannels,
      @required AndroidAudioEncoder audioEncoder,
      @required int audioEncodingBitRate,
      @required AndroidAudioSource audioSource,
      @required AndroidOutputFormat outputFormat,
      @required int audioSamplingRate,}) async {
    Map map = {
      'audioChannels': audioChannels,
      'audioEncoder': audioEncoder.index,
      'audioEncodingBitRate': audioEncodingBitRate,
      'audioSource': audioSource.index,
      'outputFormat': outputFormat.index,
      'audioSamplingRate': audioSamplingRate,
    };

    final bool result = await _channel.invokeMethod('setConfig', map);
    return result;
  }

  static Future<AndroidConfiguration> getAndroidConfig() async {
    final Map result = await _channel.invokeMethod('getConfig');
    return AndroidConfiguration.fromMap(result);
  }
}

class AndroidConfiguration {
  final int audioChannels;
  final AndroidAudioEncoder audioEncoder;
  final int audioEncodingBitRate;
  final AndroidAudioSource audioSource;
  final AndroidOutputFormat outputFormat;
  final int audioSamplingRate;

  const AndroidConfiguration(
      {@required this.audioChannels,
      @required this.audioEncoder,
      @required this.audioEncodingBitRate,
      @required this.audioSource,
      @required this.outputFormat,
      @required this.audioSamplingRate,
      });

  factory AndroidConfiguration.fromMap(Map map) {
    if (map == null) {
      return null;
    }

    return AndroidConfiguration(
      audioChannels: map['audioChannels'],
      audioEncoder: AndroidAudioEncoder.values[map['audioEncoder']],
      audioEncodingBitRate: map['audioEncodingBitRate'],
      audioSource: AndroidAudioSource.values[map['audioSource']],
      outputFormat: AndroidOutputFormat.values[map['outputFormat']],
      audioSamplingRate: map['audioSamplingRate'],
    );
  }

  @override
  String toString() {
    return {
      'audioChannels': audioChannels,
      'audioEncoder': audioEncoder,
      'audioEncodingBitRate': audioEncodingBitRate,
      'audioSource': audioSource,
      'outputFormat': outputFormat,
      'audioSamplingRate': audioSamplingRate,
    }.toString();
  }
}

enum AndroidAudioEncoder {
  DEFAULT,
  AMR_NB,
  AMR_WB,
  AAC,
  HE_AAC,
  AAC_ELD,
  VORBIS
}

enum AndroidAudioSource {
  DEFAULT,
  MIC,
  VOICE_UPLINK,
  VOICE_DOWNLINK,
  VOICE_CALL,
  CAMCORDER,
  VOICE_RECOGNITION,
  VOICE_COMMUNICATION,
  REMOTE_SUBMIX,
  UNPROCESSED
}

enum AndroidOutputFormat {
  DEFAULT,
  THREE_GPP,
  MPEG_4,
  RAW_AMR,
  AMR_NB,
  AMR_WB,
  AAC_ADIF,
  AAC_ADTS,
  OUTPUT_FORMAT_RTP_AV,
  MPEG_2_TS,
  WEBM
}