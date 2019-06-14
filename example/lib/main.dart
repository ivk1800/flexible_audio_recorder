import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'pages/audio_recording_page.dart';

void main() => runApp(MaterialApp(
      home: AudioRecordingPage(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
    ));

