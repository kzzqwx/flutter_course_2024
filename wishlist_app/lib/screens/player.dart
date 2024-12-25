import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:wishlist_app/utils/time_format.dart';
import 'package:wishlist_app/screens/habit_tracker.dart';
import 'package:wishlist_app/blocs/selected_day.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String audioFile;

  const PlayerScreen({Key? key, required this.title, required this.audioFile})
      : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioplayers.AudioPlayer _audioPlayer = audioplayers.AudioPlayer();
  final audioplayers.AudioPlayer _bellPlayer = audioplayers.AudioPlayer(); // Для звукового сигнала
  bool _isPlaying = false;
  bool _isFinished = false;
  late Timer _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) async {
      _onAudioComplete();
    });
  }

  Future<void> _onAudioComplete() async {
    _timer.cancel();
    setState(() {
      _isFinished = true;
      _isPlaying = false;
    });
    await _bellPlayer.play(audioplayers.AssetSource('audio/bell.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _bellPlayer.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _timer.cancel();
    } else {
      if (_elapsedTime == 0) {
        await _audioPlayer.play(audioplayers.AssetSource(widget.audioFile));
      } else {
        await _audioPlayer.resume();
      }
      _startTimer();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }


  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFA8D5BA),

      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF4E6), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isFinished
              ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have finished meditating',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF52AA75),

                ),
              ),
              Icon(
                Icons.check_circle,
                color: Color(0xFFC8A2C8),
                size: 80,
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatTime(_elapsedTime),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6E6E6E),
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                iconSize: 80,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: const Color(0xFFC8A2C8),
                ),
                onPressed: _playPauseAudio,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => SelectedDayCubit(),
                child: HabitTrackerScreen(),
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFC8A2C8),
        child: const Icon(
          Icons.track_changes,
          color: Colors.white,
        ),
      ),
    );
  }
}
