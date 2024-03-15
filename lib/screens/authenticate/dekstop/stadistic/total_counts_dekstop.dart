import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalCountsDesktop extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;
  const TotalCountsDesktop({super.key, required this.dates});

  @override
  State<TotalCountsDesktop> createState() => _TotalCountsDesktopState();
}

class _TotalCountsDesktopState extends State<TotalCountsDesktop> {

  late List<int> yearsList;
  late List<DateTime> monthsList;
  late List<DateTime> weekList;
  late int totalCounts;

  @override
  void initState() {
    super.initState();
    yearsList = generateYearList();
    monthsList = generateMonthList();
    weekList = generateWeekList();
    totalCounts = 0;
  }

  List<int> generateYearList() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    return [currentYear - 1, currentYear, currentYear + 1];
  }

  List<DateTime> generateMonthList() {
    DateTime now = DateTime.now();
    return [
      DateTime(now.year, now.month - 1),
      DateTime(now.year, now.month),
      DateTime(now.year, now.month + 1)
    ];
  }

  List<DateTime> generateWeekList() {
    DateTime now = DateTime.now();
    int todayWeekday = now.weekday;

    DateTime startOfWeek = now.subtract(Duration(days: todayWeekday - 1));

    return List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }


  void navigateWeekNext() {
    setState(() {
      final datesStart = weekList.first.subtract(const Duration(days: 7));
      if (datesStart.year <= 2035) {
        weekList = List<DateTime>.generate(7, (i) => datesStart.add(Duration(days: i)));
        focusDate.value = weekList.first;
      }
    });
  }

  void navigateWeekBack() {
    setState(() {
      final datesEnd = weekList.last.add(const Duration(days: 1));
      if (datesEnd.year >= 2010) {
        weekList = List<DateTime>.generate(7, (i) => datesEnd.add(Duration(days: i)));
        focusDate.value = weekList.last;
      }
    });
  }

  void navigateYearNext() {
    setState(() {
      final nextYear = yearsList.last + 1;
      if (nextYear + 2 <= 2035) {
        yearsList = [nextYear, nextYear + 1, nextYear + 2];
      }
    });
  }

  void navigateYearBack() {
    setState(() {
      final prevYear = yearsList.first - 1;
      if (prevYear - 2 >= 2010) {
        yearsList = [prevYear - 2, prevYear - 1, prevYear];
      }
    });
  }

  void navigateMonthNext() {
    setState(() {
      final nextMonth = monthsList.last.month + 1;
      final nextYear = nextMonth > 12 ? monthsList.last.year + 1 : monthsList.last.year;
      monthsList = [
        DateTime(nextYear, nextMonth % 12 == 0 ? 12 : nextMonth % 12),
        DateTime(nextYear, (nextMonth + 1) % 12 == 0 ? 12 : (nextMonth + 1) % 12),
        DateTime(nextYear, (nextMonth + 2) % 12 == 0 ? 12 : (nextMonth + 2) % 12)
      ];
    });
  }

  void navigateMonthBack() {
    setState(() {
      final prevMonth = monthsList.first.month - 1;
      final prevYear = prevMonth < 1 ? monthsList.first.year - 1 : monthsList.first.year;
      monthsList = [
        DateTime(prevYear, (prevMonth - 2) <= 0 ? 12 + (prevMonth - 2) : (prevMonth - 2)),
        DateTime(prevYear, (prevMonth - 1) <= 0 ? 12 + (prevMonth - 1) : (prevMonth - 1)),
        DateTime(prevYear, prevMonth <= 0 ? 12 + prevMonth : prevMonth)
      ];
    });
  }

  void updateCounts(DateTime start, DateTime end) {
    final List<Map<String, dynamic>> data = widget.dates.value;

    setState(() {
      totalCounts = data.where((item) {
        DateTime itemDate = DateTime.parse(item['datetime']);
        return itemDate.isAfter(start) && itemDate.isBefore(end);
      }).length;
    });

  }






  final ValueNotifier<DateTime> focusDate =
  ValueNotifier<DateTime>(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: widget.dates,
        builder: (context, value, child) {
        return Container(
          height: 300,
          width: 550,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius: 10,
                offset: const Offset(10, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 550,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:40),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  10),
                              color: Colors.orange.shade100
                          ),
                          child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Colors.deepOrange,
                                    Colors.orangeAccent.shade100,
                                  ],
                                ).createShader(bounds);
                              },child: const Icon( Icons.calendar_month, size: 40, weight: 900,)),),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Selecciona una fecha',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ValueListenableBuilder<DateTime>(
                                  valueListenable: focusDate,
                                  builder: (context, fecha, child) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text(
                                        DateFormat('MMMM yyyy').format(fecha),
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      DateTime start = weekList[0];
                                      DateTime end = weekList[6];
                                      updateCounts(start, end);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient:  LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(context).hintColor,
                                            Theme.of(context).primaryColor
                                          ],
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Center(
                                          child: Text('Semana',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white
                                            ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_left),
                      onPressed: navigateWeekNext,
                    ),
                    SizedBox(
                      width: 420,
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: weekList.length,
                        itemBuilder: (context, index) {
                          var formatter = DateFormat('E d');
                          String formattedDate = formatter.format(weekList[index]);

                          DateTime date = weekList[index];

                          return InkWell(
                            onTap: () {
                              DateTime selectedDate = date;
                              DateTime start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                              DateTime end = DateTime(selectedDate.year, selectedDate.month, selectedDate.day).add(const Duration(days: 1));
                              updateCounts(start, end);
                            },
                            child: SizedBox(
                              width: 60,
                              child: Center(
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                      color: date.day == DateTime.now().day &&
                                          date.month == DateTime.now().month &&
                                          date.year == DateTime.now().year ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_right),
                      onPressed: navigateWeekBack,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_circle_left),
                              onPressed: navigateMonthBack,
                            ),
                            SizedBox(
                              width: 180,
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: monthsList.length,
                                itemBuilder: (context, index) {
                                  var formatter = DateFormat('MMM');
                                  String formattedDate = formatter.format(monthsList[index]);

                                  DateTime date = monthsList[index];

                                  return InkWell(
                                    onTap: () {
                                      DateTime selectedMonth = monthsList[index];
                                      DateTime start = DateTime(selectedMonth.year, selectedMonth.month, 1); // Comienza al inicio del mes seleccionado
                                      DateTime end = DateTime(selectedMonth.year, selectedMonth.month + 1, 1); // Termina al inicio del mes siguiente
                                      updateCounts(start, end);
                                    },
                                    child: SizedBox(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(
                                              color: date.month == DateTime.now().month &&
                                                  date.year == DateTime.now().year ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_circle_right),
                              onPressed: navigateMonthNext,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_circle_left),
                              onPressed: navigateYearBack,
                            ),
                            SizedBox(
                              width: 180,
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: yearsList.length,
                                itemBuilder: (context, index) {
                                  String formattedDate = yearsList[index].toString();
                                  int year = yearsList[index];

                                  return InkWell(
                                    onTap: () {
                                      int selectedYear = yearsList[index];
                                      DateTime start = DateTime(selectedYear, 1, 1);
                                      DateTime end = DateTime(selectedYear + 1, 1, 1);
                                      updateCounts(start, end);
                                    },
                                    child: SizedBox(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(
                                              color: year == DateTime.now().year ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_circle_right),
                              onPressed: navigateYearNext,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total de reservas \n semanal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('$totalCounts',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}
