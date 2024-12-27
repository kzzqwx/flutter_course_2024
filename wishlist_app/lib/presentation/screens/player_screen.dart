import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:wishlist_app/core/utils/time_format.dart';
import 'package:wishlist_app/presentation/screens/habit_tracker_screen.dart';
import 'package:wishlist_app/presentation/blocs/selected_day_cubit.dart';
import 'package:wishlist_app/core/utils/theme.dart';

import '../../data/sources/meditation_days_source.dart';
import '../../domain/usecases/get_meditation_days.dart';
import '../../domain/usecases/toggle_completion.dart';

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
  final audioplayers.AudioPlayer _bellPlayer = audioplayers.AudioPlayer();
  bool _isPlaying = false;
  bool _isFinished = false;
  late Timer _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) => _onAudioComplete());
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
        title: Text(
          widget.title,
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.appBarBackground,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: Center(
          child: _isFinished
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have finished meditating',
                style: AppTextStyles.finishedText,
              ),
              const Icon(
                Icons.check_circle,
                color: AppColors.meditationBox,
                size: 80,
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatTime(_elapsedTime),
                style: AppTextStyles.timerText,
              ),
              const SizedBox(height: 20),
              IconButton(
                iconSize: 80,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: AppColors.meditationBox,
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
                  create: (_) => SelectedDayCubit(MeditationDaysSource()),
                child: HabitTrackerScreen(),
              ),
            ),
          );
        },
        backgroundColor: AppColors.meditationBox,
        child: const Icon(
          Icons.track_changes,
          color: Colors.white,
        ),
      ),
    );
  }
}
