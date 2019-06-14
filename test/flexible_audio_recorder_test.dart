import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flexible_audio_recorder/flexible_audio_recorder.dart';

void main() {
  const MethodChannel channel = MethodChannel('flexible_audio_recorder');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlexibleAudioRecorder.platformVersion, '42');
  });
}
