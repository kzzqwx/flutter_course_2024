import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wishlist_app/blocs/selected_day.dart';

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
        title: const Text(
          'Habit Tracker',
          style: TextStyle(
            color: Color(0xFF2E2E2E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFA8D5BA),
        iconTheme: const IconThemeData(color: Color(0xFF2E2E2E)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF4E6), Color(0xFFE8F5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            BlocBuilder<SelectedDayCubit, Map<DateTime, bool>>(
              builder: (context, completedDays) {
                final cubit = context.read<SelectedDayCubit>();
                final meditationCount =
                cubit.countMeditationDaysInMonth(_focusedDay);
                final monthName = _monthName(_focusedDay.month);

                String meditationMessage;
                if (meditationCount == 0) {
                  meditationMessage = 'You have not meditated this month';
                } else if (meditationCount == 1) {
                  meditationMessage = 'You have meditated $meditationCount day in $monthName';
                } else {
                  meditationMessage = 'You have meditated $meditationCount days in $monthName';
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8A2C8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      meditationMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) =>
                  context.read<SelectedDayCubit>().state[day] == true,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    context.read<SelectedDayCubit>().toggleCompletion(selectedDay);
                  },
                  calendarStyle: const CalendarStyle(
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
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Color(0xFF2E2E2E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
