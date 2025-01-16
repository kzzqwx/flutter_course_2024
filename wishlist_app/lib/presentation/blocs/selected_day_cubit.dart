import 'package:bloc/bloc.dart';
import '../../data/models/meditation_day.dart';
import '../../data/sources/meditation_days_source.dart';

class SelectedDayCubit extends Cubit<Map<DateTime, bool>> {
  final MeditationDaysSource _meditationDaysSource;

  SelectedDayCubit(this._meditationDaysSource) : super({}) {
    _loadFromSource();
  }

  void _loadFromSource() {
    final storedData = Map<DateTime, bool>.from(
      (_meditationDaysSource.loadMeditationDays()).fold({}, (acc, day) {
        acc[day.date] = day.isCompleted;
        return acc;
      }),
    );
    emit(storedData);
  }

  void toggleCompletion(DateTime day) {
    final updatedDays = Map<DateTime, bool>.from(state);

    if (updatedDays[day] == true) {
      updatedDays.remove(day);
      _meditationDaysSource.deleteMeditationDay(day);
    } else {
      updatedDays[day] = true;
      _meditationDaysSource.saveMeditationDay(MeditationDay(date: day, isCompleted: true));
    }

    emit(updatedDays);
  }

  int countMeditationDaysInMonth(DateTime focusedMonth) {
    return state.keys.where((date) => date.year == focusedMonth.year && date.month == focusedMonth.month).length;
  }
}
