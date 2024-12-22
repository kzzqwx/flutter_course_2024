import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

void main() async {
  // Инициализация Hive
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

class MainScreen extends StatelessWidget {
  final List<Map<String, String>> meditationSounds = [
    {'title': 'Relaxing Rain', 'file': 'audio/rainfall.mp3'},
    {'title': 'Ocean Waves', 'file': 'audio/oceanwaves.mp3'},
    {'title': 'Forest Ambience', 'file': 'audio/forest.m4a'},
    {'title': 'Wind Chimes', 'file': 'audio/windchimes.m4a'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Sounds'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: meditationSounds.length,
        itemBuilder: (context, index) {
          final sound = meditationSounds[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(sound['title']!),
              subtitle: Text('Duration: ${sound['duration']}'),
              trailing: Icon(Icons.play_arrow, color: Colors.green),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                  title: sound['title']!,
                  audioFile: sound['file']!,
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
            MaterialPageRoute(builder: (context) => BlocProvider(
              create: (_) => SelectedDayCubit(),
              child: HabitTrackerScreen(),
            )),
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.audioFile));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: IconButton(
          iconSize: 80,
          icon: Icon(
            _isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: Colors.green,
          ),
          onPressed: _playPauseAudio,
        ),
      ),
    );
  }
}

// Cubit для управления состоянием календаря
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

// Экран трекера привычек
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
