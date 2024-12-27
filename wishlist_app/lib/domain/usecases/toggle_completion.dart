import '../../data/models/meditation_day.dart';
import '../entities/meditation_day_entity.dart';
import '../../data/sources/meditation_days_source.dart';

class ToggleCompletionUseCase {
  final MeditationDaysSource source;

  ToggleCompletionUseCase(this.source);

  void execute(MeditationDayEntity day) {
    final updatedDay = MeditationDayEntity(
      date: day.date,
      isCompleted: !day.isCompleted,
    );
    source.saveMeditationDay(
      MeditationDay(
        date: updatedDay.date,
        isCompleted: updatedDay.isCompleted,
      ),
    );
  }
}
