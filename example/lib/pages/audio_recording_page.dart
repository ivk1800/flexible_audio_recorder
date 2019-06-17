import 'package:flexible_audio_recorder/flexible_audio_recorder.dart';
import 'package:flexible_audio_recorder_example/pages/player_page.dart';
import 'package:flexible_audio_recorder_example/pages/setup_android_config_page.dart';
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
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                Text('startRecording'),
                _buildRecordIndicator(),
              ]),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'startRecording',
                    await FlexibleAudioRecorder.startRecording()
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'startRecording', error);
                    }));
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text('stopRecording'),
              onPressed: () async {
                await FlexibleAudioRecorder.stopRecording()
                    .catchError((dynamic error) {
                  showMessageAlert(context, 'stopRecording', error);
                }).then((String path) {
                  if (path == null) {
                    return;
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AudioPlayerPage(filePath: path,);
                      }));
                });
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text('getAndroidConfig'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'getAndroidConfig',
                    await FlexibleAudioRecorder.getAndroidConfig()
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'getAndroidConfig', error);
                    }));
              },
            ),
            RaisedButton(
              child: Text('setAndroidConfig'),
              onPressed: () async {
                showMessageAlert(
                    context,
                    'setAndroidConfig',
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return SetupAndroidConfigPage();
                        }))
                        .catchError((dynamic error) {
                      showMessageAlert(context, 'getAndroidConfig', error);
                    }));
              },
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<bool> _buildRecordIndicator() {
    return FutureBuilder(
            future: FlexibleAudioRecorder.isRecording,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              bool isRecording = snapshot.data ?? false;

              if (isRecording) {
                return SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox(width: 1, height: 1,);

            },);
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
