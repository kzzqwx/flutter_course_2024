import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppColors {
  static const appBarBackground = Color(0xFFA8D5BA);
  static const iconColor = Color(0xFF2E2E2E);
  static const mainGradient = LinearGradient(
    colors: [Color(0xFFFFF4E6), Color(0xFFE8F5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const meditationBox = Color(0xFFC8A2C8);
}

class AppTextStyles {
  static const appBarTitle = TextStyle(
    color: Color(0xFF2E2E2E),
    fontWeight: FontWeight.bold,
  );
  static const meditationMessage = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle finishedText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF52AA75),
  );

  static const TextStyle timerText = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Color(0xFF6E6E6E),
  );
}

class AppCalendarStyles {
  static var calendarStyle = const CalendarStyle(
    todayDecoration: BoxDecoration(
      color: Color(0xFF52AA75),
      shape: BoxShape.circle,
    ),
    markerDecoration: BoxDecoration(
      color: Color(0xFFA8D5BA),
      shape: BoxShape.circle,
    ),
    selectedDecoration: BoxDecoration(
      color: Color(0xFFC8A2C8),
      shape: BoxShape.circle,
    ),
    outsideDaysVisible: false,
    defaultTextStyle: TextStyle(color: Color(0xFF2E2E2E)),
    todayTextStyle: TextStyle(color: Colors.white),
  );

  static const headerStyle = HeaderStyle(
    formatButtonVisible: false,
    titleCentered: true,
    titleTextStyle: TextStyle(
      color: Color(0xFF2E2E2E),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey),
    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey),
  );
}
