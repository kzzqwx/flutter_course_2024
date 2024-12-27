import '../entities/meditation_day_entity.dart';
import '../../data/sources/meditation_days_source.dart';

class GetMeditationDaysUseCase {
  final MeditationDaysSource source;

  GetMeditationDaysUseCase(this.source);

  List<MeditationDayEntity> execute() {
    final meditationDays = source.loadMeditationDays();

    return meditationDays
        .map((day) => MeditationDayEntity(
      date: day.date,
      isCompleted: day.isCompleted,
    ))
        .toList();
  }
}


