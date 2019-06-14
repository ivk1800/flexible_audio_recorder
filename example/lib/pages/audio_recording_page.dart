import 'package:flexible_audio_recorder/flexible_audio_recorder.dart';
import 'package:flutter/material.dart';

class AudioRecordingPage extends StatefulWidget {
  @override
  _AudioRecordingPageState createState() => _AudioRecordingPageState();
}

class _AudioRecordingPageState extends State<AudioRecordingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flexible_audio_recorder'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('isRecording'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'isRecording',
                    await FlexibleAudioRecorder.isRecording
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'isRecording', error);
                    }));
              },
            ),
            RaisedButton(
              child: Text('hasAudioPermission'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'hasAudioPermission',
                    await FlexibleAudioRecorder.hasAudioPermission
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'hasAudioPermission', error);
                    }));
              },
            ),
            RaisedButton(
              child: Text('requestAudioPermission'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'requestAudioPermission',
                    await FlexibleAudioRecorder.requestAudioPermission()
                        .catchError((dynamic error) {
                      showMessageAlert(
                          context, 'requestAudioPermission', error);
                    }));
              },
            ),
            RaisedButton(
              child: Text('startRecording'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'startRecording',
                    await FlexibleAudioRecorder.startRecording()
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'startRecording', error);
                    }));
              },
            ),
            RaisedButton(
              child: Text('stopRecording'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'stopRecording',
                    await FlexibleAudioRecorder.stopRecording()
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'stopRecording', error);
                    }));
              },
            ),
          ],
        ),
      ),
    );
  }

  void showMessageAlert(BuildContext context, String title, dynamic content) {
    if (content == null) {
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content.toString()),
            actions: [
              new FlatButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
