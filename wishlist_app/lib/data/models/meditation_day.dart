class MeditationDay {
  final DateTime date;
  final bool isCompleted;

  MeditationDay({required this.date, required this.isCompleted});

  factory MeditationDay.fromJson(Map<String, dynamic> json) {
    return MeditationDay(
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}