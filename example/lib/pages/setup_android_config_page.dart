import 'package:flexible_audio_recorder/flexible_audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class SetupAndroidConfigPage extends StatefulWidget {
  @override
  _SetupAndroidConfigPageState createState() => _SetupAndroidConfigPageState();
}

class _SetupAndroidConfigPageState extends State<SetupAndroidConfigPage> {
  TextEditingController _audioChannelsController;
  TextEditingController _audioEncodingBitRateController;

  AndroidAudioEncoder _audioEncoder = AndroidAudioEncoder.DEFAULT;
  AndroidAudioSource _audioSource = AndroidAudioSource.DEFAULT;
  AndroidOutputFormat _outputFormat = AndroidOutputFormat.DEFAULT;

  @override
  void initState() {
    super.initState();

    _audioChannelsController = TextEditingController();
    _audioEncodingBitRateController = TextEditingController();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    AndroidConfiguration config =
        await FlexibleAudioRecorder.getAndroidConfig();

    if (!mounted) return;

    setState(() {
      _audioChannelsController.text = config.audioChannels?.toString() ?? '';
      _audioEncodingBitRateController.text =
          config.audioEncodingBitRate?.toString() ?? '';

      _audioEncoder = config.audioEncoder;
      _audioSource = config.audioSource;
      _outputFormat = config.outputFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SetupAndroidConfig'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('audioChannels'),
            TextField(
              controller: _audioChannelsController,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(),
            ),
            Text('audioEncodingBitRate'),
            TextField(
              controller: _audioEncodingBitRateController,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(),
            ),
            Text('audioEncoder'),
            DropdownButton<AndroidAudioEncoder>(
              value: _audioEncoder,
              onChanged: (AndroidAudioEncoder newValue) {
                setState(() {
                  _audioEncoder = newValue;
                });
              },
              items: AndroidAudioEncoder.values
                  .map<DropdownMenuItem<AndroidAudioEncoder>>(
                      (AndroidAudioEncoder value) {
                return DropdownMenuItem<AndroidAudioEncoder>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            Text('audioSource'),
            DropdownButton<AndroidAudioSource>(
              value: _audioSource,
              onChanged: (AndroidAudioSource newValue) {
                setState(() {
                  _audioSource = newValue;
                });
              },
              items: AndroidAudioSource.values
                  .map<DropdownMenuItem<AndroidAudioSource>>(
                      (AndroidAudioSource value) {
                return DropdownMenuItem<AndroidAudioSource>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            Text('outputFormat'),
            DropdownButton<AndroidOutputFormat>(
              value: _outputFormat,
              onChanged: (AndroidOutputFormat newValue) {
                setState(() {
                  _outputFormat = newValue;
                });
              },
              items: AndroidOutputFormat.values
                  .map<DropdownMenuItem<AndroidOutputFormat>>(
                      (AndroidOutputFormat value) {
                return DropdownMenuItem<AndroidOutputFormat>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            RaisedButton(
              child: Text('save'),
              onPressed: () async {
                Navigator.pop(
                    context,
                    await FlexibleAudioRecorder.setAndroidConfig(
                      audioChannels: int.tryParse(_audioChannelsController.text),
                      audioEncoder: _audioEncoder,
                      audioEncodingBitRate:
                          int.tryParse(_audioEncodingBitRateController.text),
                      audioSource: _audioSource,
                      outputFormat: _outputFormat,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
