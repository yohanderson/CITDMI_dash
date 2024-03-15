import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BarChartDesktop extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;

  const BarChartDesktop({Key? key, required this.dates}) : super(key: key);

  @override
  BarChartDesktopState createState() => BarChartDesktopState();
}

class BarChartDesktopState extends State<BarChartDesktop> {

  //dates
  late List<DateTime> datesFocus;
  List<FlSpot> spots = [];
  late double slideRange;
  late bool slideRangePermission;

  @override
  void initState() {
    super.initState();
    datesFocus = generateWeekList();
    slideRangePermission = false;
    widget.dates.addListener(_updateCountsDates);
    _updateCountsDates();
  }

  void _updateCountsDates() {
    final List<Map<String, dynamic>> data = widget.dates.value;
    final Map<String, int> countsPerDate = {};
    final List<double> countsPerDay = List.filled(7, 0.0);

    for (var item in data) {
      final String date = item['date_time'].split('T')[0];
      final int count = countsPerDate[date] ?? 0;
      countsPerDate[date] = count + 1;
    }

    for (var i = 0; i < datesFocus.length; i++) {
      final DateTime date = datesFocus[i];
      final String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final int count = countsPerDate[dateString] ?? 0;
      countsPerDay[i] = count.toDouble();
    }

    double highestCount = countsPerDay.reduce(max);

    if (slideRangePermission == false) {
      if (highestCount <= 10) {
        _currentSliderValue = 0;
      } else if (highestCount > 10) {
        _currentSliderValue = 20;
      } else if (highestCount > 100) {
        _currentSliderValue = 40;
      } else if (highestCount > 1000) {
        _currentSliderValue = 60;
      } else if (highestCount > 10000) {
        _currentSliderValue = 80;
      } else if (highestCount > 100000) {
        _currentSliderValue = 100;
      }
    }
    else {
      if (highestCount <= 10) {
        _currentSliderValue = 0;
      } else if (highestCount > 10) {
        _currentSliderValue = 20;
      } else if (highestCount > 100) {
        _currentSliderValue = 40;
      } else if (highestCount > 1000) {
        _currentSliderValue = 60;
      } else if (highestCount > 10000) {
        _currentSliderValue = 80;
      } else if (highestCount > 100000) {
        _currentSliderValue = 100;
      }
      if (slideRange > _currentSliderValue) {
        _currentSliderValue = slideRange;
      }
    }

    // Calcula el factor de escala en función del valor actual del slider
    double scaleFactor;
    if (_currentSliderValue == 0) {
      scaleFactor = 1;
    }
    else if (_currentSliderValue == 20) {
      scaleFactor = 10;
    } else if (_currentSliderValue == 40) {
      scaleFactor = 100;
    } else if (_currentSliderValue == 60) {
      scaleFactor = 1000;
    } else if (_currentSliderValue == 80) {
      scaleFactor = 10000;
    } else {
      scaleFactor = 100000;
    }

    // Escala los valores de las reservas antes de asignarlos a spots
    for (var i = 0; i < countsPerDay.length; i++) {
      countsPerDay[i] /= scaleFactor;
    }

    spots = countsPerDay.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    setState(() {
      spots = spots;
      _currentSliderValue = _currentSliderValue;
    });
  }

  // text focus
  final ValueNotifier<DateTime> focusDate =
  ValueNotifier<DateTime>(DateTime.now());

  // zoom chart
  double _currentSliderValue = 0;


  // row days control

  List<DateTime> generateWeekList() {
    DateTime now = DateTime.now();
    int todayWeekday = now.weekday;

    DateTime startOfWeek = now.subtract(Duration(days: todayWeekday - 1));

    return List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  void navigateLeft() {
    setState(() {
      final datesStart = datesFocus.first.subtract(const Duration(days: 7));
      datesFocus = List<DateTime>.generate(7, (i) => datesStart.add(Duration(days: i)));
      focusDate.value = datesFocus.first;
      slideRangePermission = false;
    });
    _updateCountsDates();
  }

  void navigateRight() {
    setState(() {
      final datesEnd = datesFocus.last.add(const Duration(days: 1));
      datesFocus = List<DateTime>.generate(7, (i) => datesEnd .add(Duration(days: i)));
      focusDate.value = datesFocus.last;
      slideRangePermission = false;
    });
    _updateCountsDates();
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: widget.dates,
      builder: (context, value, child) {

        // container chart

        Widget leftTitleWidgets(double value, TitleMeta meta) {
          TextStyle style = TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          );
          String text;
          switch (value.toInt()) {
            case 1:
              if (_currentSliderValue == 0) {
                text = '1';
              } else if (_currentSliderValue == 20) {
                text = '10';
              } else if (_currentSliderValue == 40) {
                text = '100';
              } else if (_currentSliderValue == 60) {
                text = '1k';
              } else if (_currentSliderValue == 80) {
                text = '10k';
              } else {
                text = '100k';
              }
              break;
            case 4:
              if (_currentSliderValue == 0) {
                text = '4';
              } else if (_currentSliderValue == 20) {
                text = '40';
              } else if (_currentSliderValue == 40) {
                text = '400';
              } else if (_currentSliderValue == 60) {
                text = '4k';
              } else if (_currentSliderValue == 80) {
                text = '40k';
              } else {
                text = '400k';
              }
              break;
            case 7:
              if (_currentSliderValue == 0) {
                text = '7';
              } else if (_currentSliderValue == 20) {
                text = '70';
              } else if (_currentSliderValue == 40) {
                text = '700';
              } else if (_currentSliderValue == 60) {
                text = '7k';
              } else if (_currentSliderValue == 80) {
                text = '70k';
              } else {
                text = '700k';
              }
              break;
            case 10:
              if (_currentSliderValue == 0) {
                text = '10';
              } else if (_currentSliderValue == 20) {
                text = '100';
              } else if (_currentSliderValue == 40) {
                text = '1k';
              } else if (_currentSliderValue == 60) {
                text = '10k';
              } else if (_currentSliderValue == 80) {
                text = '100k';
              } else {
                text = '1M';
              }
              break;
            default:
              return const SizedBox();
          }

          return Text(text, style: style, textAlign: TextAlign.left);
        }

        Widget getTitles(double value, TitleMeta meta) {
          Widget text;
          if (value < datesFocus.length) {
            DateTime date = datesFocus[value.toInt()];
            text = date.day == DateTime.now().day &&
                date.month == DateTime.now().month &&
                date.year == DateTime.now().year ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).textTheme.bodyMedium?.color
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 1, left: 10,right: 10),
                  child: Text(DateFormat('MMM d').format(date), style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ) ,
                  ),
                ),),
            )
                :
            Padding(
              padding: const EdgeInsets.only(top: 11),
              child: Text(DateFormat('E d').format(date), style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),),
            );
          } else {
            text = const Text('',);
          }
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: text,
          );
        }

        List<BarChartGroupData> barGroups(List<FlSpot> spots) {
          return List.generate(spots.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  width: 15,
                  gradient: LinearGradient(
                    colors: [Theme.of(context).textTheme.bodyLarge?.color ?? Colors.blue, Theme.of(context).hintColor]
                        .map((color) => color)
                        .toList(),
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ), toY: spots[i].y,
                ),
              ],
              showingTooltipIndicators: [0],
            );
          });
        }

        BarChartData mainData() {
          return BarChartData(
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: EdgeInsets.zero,
                tooltipMargin: 8,
                getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                    ) {
                  return BarTooltipItem(
                    rod.toY.toStringAsFixed(1),
                    TextStyle(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: getTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 30,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: barGroups(spots),
            gridData: const FlGridData(show: false),
            alignment: BarChartAlignment.spaceAround,
            maxY: 10,
          );

        }


        return Container(
          width: 550,
          height: 390,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  width: 350,
                  height: 55,
                  child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 100,
                    divisions: 5,
                    label: '${_currentSliderValue.round()}%',
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                    onChangeEnd: (double value) {
                      slideRangePermission = true;
                      slideRange = value;
                      _updateCountsDates();
                    },
                    activeColor: Theme.of(context).textTheme.bodyMedium?.color,
                    inactiveColor: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40 ,right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      height: 300,
                      child: BarChart(
                        mainData(),
                      ),
                    ),
                    SizedBox(
                      width: 450,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_circle_left),
                              onPressed: navigateLeft,
                            ),
                          ),
                          ValueListenableBuilder<DateTime>(
                            valueListenable: focusDate,
                            builder: (context, fecha, child) {
                              return Text(
                                DateFormat('MMMM yyyy').format(fecha),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_circle_right),
                            onPressed: navigateRight,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    widget.dates.removeListener(_updateCountsDates);
    super.dispose();
  }
}