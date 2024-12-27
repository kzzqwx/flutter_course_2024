import 'package:bloc/bloc.dart';
import '../../data/models/meditation_day.dart';
import '../../domain/usecases/toggle_completion.dart';
import '../../domain/usecases/get_meditation_days.dart';
import '../../domain/entities/meditation_day_entity.dart';
import '../../data/sources/meditation_days_source.dart';

class SelectedDayCubit extends Cubit<Map<DateTime, bool>> {
  final MeditationDaysSource _meditationDaysSource;

  SelectedDayCubit(this._meditationDaysSource) : super({}) {
    _loadFromSource();
  }

  // Загружаем данные из MeditationDaysSource
  void _loadFromSource() {
    final storedData = Map<DateTime, bool>.from(
      (_meditationDaysSource.loadMeditationDays()).fold({}, (acc, day) {
        acc[day.date] = day.isCompleted;
        return acc;
      }),
    );
    emit(storedData);
  }

  // Метод для переключения завершенности дня
  void toggleCompletion(DateTime day) {
    final updatedDays = Map<DateTime, bool>.from(state);

    if (updatedDays[day] == true) {
      updatedDays.remove(day); // Если день завершен, удаляем
      _meditationDaysSource.deleteMeditationDay(day); // Удаляем из source
    } else {
      updatedDays[day] = true; // Если день не завершен, добавляем
      _meditationDaysSource.saveMeditationDay(MeditationDay(date: day, isCompleted: true)); // Сохраняем в source
    }

    emit(updatedDays); // Эмитируем обновленное состояние
  }

  // Подсчет дней медитации в выбранном месяце
  int countMeditationDaysInMonth(DateTime focusedMonth) {
    return state.keys
        .where((date) => date.year == focusedMonth.year && date.month == focusedMonth.month)
        .length;
  }
}
