import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
