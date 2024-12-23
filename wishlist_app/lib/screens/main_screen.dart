import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist_app/screens/habit_tracker.dart';
import 'package:wishlist_app/screens/player.dart';
import 'package:wishlist_app/blocs/selected_day.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, String>> meditationSounds = [
    {'title': 'Relaxing Rain', 'path': 'audio/rainfall.mp3', 'duration': '5 min 30 sec'},
    {'title': 'Ocean Waves', 'path': 'audio/oceanwaves.mp3', 'duration': '9 min 59 sec'},
    {'title': 'Forest Ambience', 'path': 'audio/forest.m4a', 'duration': '15 min 00 sec'},
    {'title': 'test', 'path': 'audio/test.m4a', 'duration': '0 min 08 sec'},
    {'title': 'Wind Chimes', 'path': 'audio/windchimes.m4a', 'duration': '20 min 00 sec'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meditation Sounds',
          style: TextStyle(
            color: Color(0xFF2E2E2E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA8D5BA),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF4E6), Color(0xFFE8F5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: meditationSounds.length,
          itemBuilder: (context, index) {
            final sound = meditationSounds[index];
            return Card(
              color: const Color(0xFFFFFFFF),
              shadowColor: const Color(0xFFA8D5BA),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  sound['title']!,
                  style: const TextStyle(
                    color: Color(0xFF2E2E2E),
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
                  color: Color(0xFFA8D5BA),
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