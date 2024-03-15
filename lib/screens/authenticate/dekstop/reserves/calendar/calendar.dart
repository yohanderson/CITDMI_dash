import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../day_reserve_desktop_view.dart';
import '../reserves_desktop_view.dart';

class Calendar extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;

  const Calendar({super.key, required this.dates});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {

    ReservesDesktopState reservesDesktopState = Provider.of<ReservesDesktopState>(context);

    return ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: widget.dates,
        builder: (context, value, child) {

          final reserves = value;

        return Container(
          height: 400,
          width: 550,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius:20,
                offset: const Offset(10, 8),
              ),
            ],
          ),
          child: TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2040, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              final formatter =
              DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
              final formattedDay =
              DateTime(day.year, day.month, day.day);

              final hasReserve = reserves
                  .any((reserve) {
                final fechaReserve = formatter
                    .parse(reserve['date_time'])
                    .toLocal();
                final formattedDate = DateTime(
                    fechaReserve.year,
                    fechaReserve.month,
                    fechaReserve.day);
                return formattedDate
                    .isAtSameMomentAs(formattedDay);
              });

              return hasReserve;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              reservesDesktopState.clearHistory();
              reservesDesktopState.changeValue(DayReserveDesktopView(selectedDay: selectedDay, dates: widget.dates,));
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                  color: Colors.green[400],
                  shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: Colors.lightBlue[400],
                  shape: BoxShape.circle),
              todayTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              outsideTextStyle: const TextStyle(
                color: Colors.grey,
              ),
              defaultTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.blue[400],
              ),


            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Theme.of(context).hintColor,
              ),
              weekendStyle: TextStyle(
                color: Colors.blue[400],
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 25, fontWeight: FontWeight.w500),
              leftChevronIcon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor, size: 25),
              rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Theme.of(context).hintColor, size: 25),
            ),
          ),
        );
      }
    );
  }
}
