import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class SoundRecorderScreen extends StatefulWidget {
  const SoundRecorderScreen({super.key});

  @override
  State<SoundRecorderScreen> createState() => _SoundRecorderScreenState();
}

class _SoundRecorderScreenState extends State<SoundRecorderScreen> {
  late AudioRecorder _audioRecorder;
  late AudioPlayer _audioPlayer;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _path;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/my_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _path = path;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _path = path;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _playRecording() async {
    try {
      if (_path != null) {
        Source urlSource = DeviceFileSource(_path!);
        await _audioPlayer.play(urlSource);
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording)
              const Text(
                'Recording...',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_path != null && !_isRecording)
              const Text(
                'Recording Saved',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  heroTag: 'record',
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  backgroundColor: _isRecording ? Colors.red : Colors.redAccent,
                  child: Icon(_isRecording ? Icons.stop : Icons.mic),
                ),
                const SizedBox(width: 20),
                if (_path != null && !_isRecording)
                  FloatingActionButton.large(
                    heroTag: 'play',
                    onPressed: _isPlaying ? _stopPlayback : _playRecording,
                    backgroundColor: Colors.blue,
                    child: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
