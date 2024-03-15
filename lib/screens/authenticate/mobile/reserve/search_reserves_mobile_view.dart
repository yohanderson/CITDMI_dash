import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../bloc/dates_state_bloc.dart';
import 'reserve_mobile_view.dart';

class SearchReservesMobileView extends StatefulWidget {

  const SearchReservesMobileView({Key? key,})
      : super(key: key);

  @override
  State<SearchReservesMobileView> createState() => SearchReservesMobileViewState();
}

class SearchReservesMobileViewState extends State<SearchReservesMobileView> {
  final TextEditingController _searchcontroller = TextEditingController();
  int _numReservesToShow = 10;
  bool _isSearchButtonPressed = false;
  bool calendarMenu = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = null;
    _searchcontroller.addListener(() {
      setState(() {});
    });
  }

  void _onSearchButtonPressed() {
    setState(() {
      _isSearchButtonPressed = true;
    });
  }

  void _onViewMoreButtonPressed() {
    setState(() {
      _numReservesToShow += 10;
    });
  }

  late DateTime? _selectedDay;

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  Widget _calendarMenu() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: true,
        todayDecoration: BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          calendarMenu = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectionDatesBlocs = Provider.of<ConnectionDatesBlocs>(context);
    List<Map<String, dynamic>> reserves = connectionDatesBlocs.reserves.value;
    var filteredReserves =
    List<Map<String, dynamic>>.from(reserves);

    filteredReserves.sort((a, b) {
      try {
        final timestampA = a['createdat'].replaceAll('\u202F', ' ');
        final dateTimeA = DateFormat('MMM d, yyyy h:mm a').parse(timestampA);
        final timestampB = b['createdat'].replaceAll('\u202F', ' ');
        final dateTimeB = DateFormat('MMM d, yyyy h:mm a').parse(timestampB);
        return dateTimeB.compareTo(dateTimeA);
      } catch (e) {
        if (kDebugMode) {
          print('Error al analizar las fechas: $e');
        }
        return 0;
      }
    });

    if (_searchcontroller.text.isNotEmpty && !_isSearchButtonPressed) {
      filteredReserves = filteredReserves.take(5).toList();
    }

    if (_isSearchButtonPressed) {
      filteredReserves =
          filteredReserves.take(_numReservesToShow).toList();
    }

    if (_searchcontroller.text.isNotEmpty) {
      filteredReserves.retainWhere((reserve) => reserve['name']
          .toLowerCase()
          .startsWith(_searchcontroller.text.toLowerCase()));
    }

    var selectedDay = _selectedDay;
    if (selectedDay != null) {
      final selectedDateTime =
      DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      filteredReserves.retainWhere((reserve) {
        final reserveDateTime =
        DateFormat('MMM d, yyyy h:mm a').parse(reserve['datetime']);
        return reserveDateTime.year == selectedDateTime.year &&
            reserveDateTime.month == selectedDateTime.month &&
            reserveDateTime.day == selectedDateTime.day;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black87,
          ),
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Align(
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _searchcontroller,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  minLines: 1,
                                  cursorColor: Colors.white,
                                  cursorHeight: 15,
                                  decoration: const InputDecoration(
                                    labelText: 'Busqueda',
                                    labelStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.only(top: 0),
                                    border: InputBorder.none,
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                                onPressed: _onSearchButtonPressed,
                                icon: const Icon(Icons.search_rounded,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 15, top: 10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (calendarMenu == false) {
                            calendarMenu = true;
                          } else {
                            calendarMenu = false;
                          }
                        });
                      },
                      child: const SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            Text(
                              'Fecha',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_searchcontroller.text.isEmpty && !_isSearchButtonPressed)
                        Container()
                      else ...[
                        for (int index = 0;
                        index <
                            filteredReserves.length +
                                (_isSearchButtonPressed ? 1 : 0);
                        index++)
                          if (index == filteredReserves.length) ...[
                            if (filteredReserves.length >= 10) ...[
                              TextButton(
                                onPressed: _onViewMoreButtonPressed,
                                child: const Text('Ver más'),
                              ),
                            ] else ...[
                              const SizedBox.shrink(),
                            ]
                          ] else ...[
                            Builder(builder: (context) {
                              final reserve = filteredReserves[index];
                              Color containerColor;
                              String state = reserve['state'].toString();

                              switch (state) {
                                case 'Expiró':
                                  containerColor = Colors.orange;
                                  break;
                                case 'Atendido':
                                  containerColor = Colors.blue;
                                  break;
                                case 'Cancelado':
                                  containerColor = Colors.red;
                                  break;
                                default:
                                  containerColor = Colors.green[300]!;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                                child: Container(
                                  height: 80,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 2.0,
                                          offset: Offset(0.2, 0.2))
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReserveMobileView(
                                              reserve: reserve),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, top: 15, bottom: 5),
                                              child: Text(
                                                '${reserve['name']} '
                                                    '${reserve['lastName']}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    color: containerColor,
                                                    borderRadius:
                                                    BorderRadius.circular(50)),

                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${reserve['equipmentType']}',
                                                    style: const TextStyle(),
                                                  ),
                                                  Text('${reserve['fallaType']}',
                                                    style: const TextStyle(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Text(
                                                      '${reserve['createdAt']}',
                                                      style: const TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 160,
            right: 30,
            child: calendarMenu == true
                ? Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 1.5,
                        offset: Offset(0.2, 0.2))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 13),
                          child: Text(
                            'Seleccionar dia',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(right: 20, top: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedDay = null;
                                calendarMenu = false;
                              });
                            },
                            child: Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  'Todo',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _calendarMenu(),
                  ],
                ))
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
