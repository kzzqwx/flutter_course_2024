import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'dart:async';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('meditationDays');
  runApp(MeditationApp());
}

class MeditationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, String>> meditationSounds = [
    {'title': 'Relaxing Rain', 'path': 'audio/rainfall.mp3', 'duration': '5 min 30 sec'},
    {'title': 'Ocean Waves', 'path': 'audio/oceanwaves.mp3', 'duration': '9 min 59 sec'},
    {'title': 'Forest Ambience', 'path': 'audio/forest.m4a', 'duration': '15 min 00 sec'},
    {'title': 'test', 'path': 'audio/test.mp3', 'duration': '0 min 02 sec'},
    {'title': 'Wind Chimes', 'path': 'audio/windchimes.m4a', 'duration': '20 min 00 sec'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Sounds'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
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
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: meditationSounds.length,
        itemBuilder: (context, index) {
          final sound = meditationSounds[index];
          final duration = sound['duration']!;
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(sound['title']!),
              subtitle: Text('Duration: $duration'),
              trailing: Icon(Icons.play_arrow, color: Colors.green),
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
        child: Icon(Icons.track_changes),
        tooltip: 'Go to Habit Tracker',
      ),
    );
  }
}

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
  bool _isPlaying = false;
  late Timer _timer;
  int _elapsedTime = 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _timer.cancel();
    } else {
      await _audioPlayer.play(audioplayers.AssetSource(widget.audioFile));
      _startTimer();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _startTimer() {
    _elapsedTime = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_elapsedTime),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            IconButton(
              iconSize: 80,
              icon: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: Colors.green,
              ),
              onPressed: _playPauseAudio,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedDayCubit extends Cubit<Map<DateTime, bool>> {
  final Box _hiveBox;

  SelectedDayCubit() : _hiveBox = Hive.box('meditationDays'), super({}) {
    _loadFromHive();
  }

  void _loadFromHive() {
    final storedData = Map<DateTime, bool>.from(
      (_hiveBox.toMap().map((key, value) => MapEntry(DateTime.parse(key), value))),
    );
    emit(storedData);
  }

  void toggleCompletion(DateTime day) {
    final updatedDays = Map<DateTime, bool>.from(state);
    if (updatedDays[day] == true) {
      updatedDays.remove(day);
      _hiveBox.delete(day.toIso8601String());
    } else {
      updatedDays[day] = true;
      _hiveBox.put(day.toIso8601String(), true);
    }
    emit(updatedDays);
  }

  int countMeditationDaysInMonth(DateTime focusedMonth) {
    return state.keys
        .where((date) =>
    date.year == focusedMonth.year && date.month == focusedMonth.month)
        .length;
  }
}

class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocBuilder<SelectedDayCubit, Map<DateTime, bool>>(
            builder: (context, completedDays) {
              final cubit = context.read<SelectedDayCubit>();
              final meditationCount =
              cubit.countMeditationDaysInMonth(_focusedDay);
              final monthName = _monthName(_focusedDay.month);

              return Column(
                children: [
                  Text(
                    'You have meditated $meditationCount days in $monthName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => completedDays[day] == true,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      cubit.toggleCompletion(selectedDay);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.green[300],
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
