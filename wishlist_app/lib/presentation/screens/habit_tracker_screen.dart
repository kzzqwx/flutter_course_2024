import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wishlist_app/presentation/screens/player_screen.dart';
import 'package:wishlist_app/presentation/blocs/selected_day_cubit.dart';
import 'package:wishlist_app/core/utils/theme.dart';
import 'package:wishlist_app/core/utils/date_util.dart';

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
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: Column(
          children: [
            BlocBuilder<SelectedDayCubit, Map<DateTime, bool>>(
              builder: (context, completedDays) {
                final cubit = context.read<SelectedDayCubit>();
                final meditationCount =
                cubit.countMeditationDaysInMonth(_focusedDay);
                final monthName = getMonthName(_focusedDay.month);

                String meditationMessage;
                if (meditationCount == 0) {
                  meditationMessage = 'You have not meditated this month';
                } else if (meditationCount == 1) {
                  meditationMessage =
                  'You have meditated $meditationCount day in $monthName';
                } else {
                  meditationMessage =
                  'You have meditated $meditationCount days in $monthName';
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.meditationBox,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      meditationMessage,
                      style: AppTextStyles.meditationMessage,
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
                    if (selectedDay.isAfter(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You cannot mark future dates as meditated"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    context.read<SelectedDayCubit>().toggleCompletion(selectedDay);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: AppCalendarStyles.calendarStyle,
                  headerStyle: AppCalendarStyles.headerStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}