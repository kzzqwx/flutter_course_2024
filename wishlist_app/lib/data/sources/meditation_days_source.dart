import 'package:hive/hive.dart';
import '../models/meditation_day.dart';

class MeditationDaysSource {
  final Box _box = Hive.box('meditationDays');

  List<MeditationDay> loadMeditationDays() {
    return _box.toMap().entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final isCompleted = entry.value as bool;
      return MeditationDay(date: date, isCompleted: isCompleted);
    }).toList();
  }

  void saveMeditationDay(MeditationDay day) {
    _box.put(day.date.toIso8601String(), day.isCompleted);
  }

  void deleteMeditationDay(DateTime date) {
    _box.delete(date.toIso8601String());
  }
}
