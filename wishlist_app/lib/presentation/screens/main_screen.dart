import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist_app/presentation/screens/habit_tracker_screen.dart';
import 'package:wishlist_app/presentation/screens/player_screen.dart';
import 'package:wishlist_app/presentation/blocs/selected_day_cubit.dart';
import 'package:wishlist_app/core/utils/theme.dart';

import '../../data/sources/meditation_days_source.dart';
import '../../domain/usecases/get_meditation_days.dart';
import '../../domain/usecases/toggle_completion.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, String>> meditationSounds = [
    {'title': 'Relaxing Rain', 'path': 'audio/rainfall.mp3', 'duration': '5 min 30 sec'},
    {'title': 'Ocean Waves', 'path': 'audio/oceanwaves.mp3', 'duration': '9 min 59 sec'},
    {'title': 'Forest Ambience', 'path': 'audio/forest.m4a', 'duration': '15 min 00 sec'},
    {'title': 'Test', 'path': 'audio/test.m4a', 'duration': '0 min 08 sec'},
    {'title': 'Wind Chimes', 'path': 'audio/windchimes.m4a', 'duration': '20 min 00 sec'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meditation Sounds',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.appBarBackground,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: ListView.builder(
          itemCount: meditationSounds.length,
          itemBuilder: (context, index) {
            final sound = meditationSounds[index];
            return Card(
              color: Colors.white,
              shadowColor: AppColors.appBarBackground,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  sound['title']!,
                  style: const TextStyle(
                    color: AppColors.iconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Duration: ${sound['duration']}',
                  style: const TextStyle(
                    color: Color(0xFF6E6E6E),
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.play_arrow,
                  color: AppColors.appBarBackground,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        title: sound['title']!,
                        audioFile: sound['path']!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
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
