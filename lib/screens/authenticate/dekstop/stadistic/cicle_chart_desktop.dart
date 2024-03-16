import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import '../reserves/reserves_desktop_view.dart';

class  CircleChartDesktop extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;
  const  CircleChartDesktop({super.key, required this.dates});

  @override
  State<CircleChartDesktop> createState() => CircleChartDesktopState();
}

class CircleChartDesktopState extends State<CircleChartDesktop> {

  List<Map<String, dynamic>> statesMenu = ReservesDesktopState.statesMenu;


  late List<int> stateCounts;

  @override
  void initState() {
    super.initState();
    stateCounts = List.filled(statesMenu.length, 0);
    _updateCountsDates();
    widget.dates.addListener(_updateCountsDates);
    yearsList = generateYearList();
    monthsList = generateMonthList();
    weekList = generateWeekList();
    totalCounts = 0;
  }


  // Actualiza los conteos para todos los datos
  void _updateCountsDates() {
    updateCounts(null, null);
  }

  // Actualiza los conteos para los datos en un rango de fechas
  void updateCounts(DateTime? start, DateTime? end) {
    final List<Map<String, dynamic>> data = widget.dates.value;

    // Filtra los datos por el rango de fechas si se proporcionan
    final filteredData = data.where((item) {
      DateTime itemDate = DateTime.parse(item['date_time']);
      if (start != null && itemDate.isBefore(start)) return false;
      if (end != null && itemDate.isAfter(end)) return false;
      return true;
    }).toList();

    totalCounts = filteredData.length;

    // Resetea los conteos antes de contar
    for (var item in statesMenu) {
      item['count'] = 0;
    }

    // Cuenta los estados en los datos filtrados
    for (var item in filteredData) {
      for (var state in statesMenu) {
        if (item['state'] == state['state']) {
          state['count']++;
        }
      }
    }
    setState(() {});
  }

  // Genera las secciones del gráfico de pastel
  List<PieChartSectionData> showingSections() {
    // Calcula el total de todos los conteos de estado
    int total = statesMenu.map((state) => state['count']).reduce((a, b) => a + b);

    // Si no hay datos, retorna una sección en blanco
    if (total == 0) {
      final isTouched = 0 == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;

      return [
        PieChartSectionData(
          color: Colors.white,
          value: 100,
          title: '0%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize ,
              fontWeight: FontWeight.w900,

          ),
        )
      ];
    }

    // Genera una sección para cada estado
    return List.generate(statesMenu.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;

      // Calcula el porcentaje para este estado
      final percentage = (statesMenu[i]['count'] / total * 100).toDouble();

      final percentageInt = percentage.truncateToDouble() == percentage
          ? percentage.truncate().toString()
          : percentage.toStringAsFixed(1);

      // Crea la sección del gráfico de pastel
      return PieChartSectionData(
        gradient: statesMenu[i]['gradient'],
        value: percentage,
        title: '$percentageInt%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,

        ),
      );
    });
  }

  int touchedIndex = -1;

  late List<int> yearsList;
  late List<DateTime> monthsList;
  late List<DateTime> weekList;
  late int totalCounts;


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
        focusDateWeek.value = weekList.first;
      }
    });
  }

  void navigateWeekBack() {
    setState(() {
      final datesEnd = weekList.last.add(const Duration(days: 1));
      if (datesEnd.year >= 2010) {
        weekList = List<DateTime>.generate(7, (i) => datesEnd.add(Duration(days: i)));
        focusDateWeek.value = weekList.last;
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

      focusDateMoth.value = monthsList.first;
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
      focusDateMoth.value = monthsList.first;
    });
  }

  final ValueNotifier<DateTime> focusDateWeek =
  ValueNotifier<DateTime>(DateTime.now());

  final ValueNotifier<DateTime> focusDateMoth =
  ValueNotifier<DateTime>(DateTime.now());


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: widget.dates,
        builder: (context, value, child) {
        return Container(
          width: 550,
          height: 460,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius:20,
                offset: const Offset(10, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Selecciona una fecha',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 78,
                  width: 550,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: Container(
                          width: 510,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(20)
                          ),
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
                                    var formatter = DateFormat('E d', 'es_ES');
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
                                                    date.year == DateTime.now().year ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
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
                      ),
                      Positioned(
                        left: 50,
                        child: ValueListenableBuilder<DateTime>(
                          valueListenable: focusDateWeek,
                          builder: (context, dates, child) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 5),
                                child: Text(
                                  DateFormat('MMMM yyyy', 'es_ES').format(dates),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 170,
                        child: InkWell(
                          onTap: () {
                            updateCounts(null, null);
                          },
                          child: Container(
                            height: 30,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient:  LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).hintColor,
                                  Theme.of(context).colorScheme.onPrimary
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text('Todo',
                                style: TextStyle(
                                    fontSize: 15,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 50,
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
                              borderRadius: BorderRadius.circular(8),
                              gradient:  LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).hintColor,
                                  Theme.of(context).colorScheme.onPrimary
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text('Semana',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                ),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 270,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_circle_left),
                            onPressed: navigateMonthBack,
                          ),
                          SizedBox(
                            width: 120,
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: monthsList.length,
                              itemBuilder: (context, index) {
                                var formatter = DateFormat('MMM', 'es_ES');
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
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            color: date.month == DateTime.now().month &&
                                                date.year == DateTime.now().year ?  Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
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
                          ValueListenableBuilder<DateTime>(
                            valueListenable: focusDateMoth,
                            builder: (context, fecha, child) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 25),
                                child: Text(
                                  DateFormat('yyyy', 'es_ES').format(fecha),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 230,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_circle_left),
                            onPressed: navigateYearBack,
                          ),
                          SizedBox(
                            width: 150,
                            height: 30,
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
                                    width: 50,
                                    child: Center(
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            color: year == DateTime.now().year ?  Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                        ),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 19,left: 40, bottom: 19),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                }
                              });
                            },

                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 50,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: 33,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text('Total',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                                ),
                              ),
                              Container(
                                height: 25,
                                width: 27,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).hintColor,
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Center(
                                  child: Text('$totalCounts',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).textTheme.bodyLarge?.color
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 40,top: 20),
                          child: SizedBox(
                            height: 120,
                            width: 200,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: statesMenu.map((state) {
                                return SizedBox(
                                  height: 70,
                                  width: 80,
                                  child: Indicator(
                                    counts: state['count'],
                                    gradient: state['gradient'],
                                    text: state['state'] == 'Reserva agendada'  ? 'Agendada' :state['state'],
                                    isSquare: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.gradient,
    required this.text,
    required this.isSquare,
    this.size = 40, required this.counts,
  });
  final Gradient gradient;
  final String text;
  final bool isSquare;
  final double size;
  final int counts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text('$counts',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25
          ),)),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}