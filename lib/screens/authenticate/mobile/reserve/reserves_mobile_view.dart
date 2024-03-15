import 'package:web_dash/screens/authenticate/mobile/reserve/reserve_mobile_view.dart';
import 'package:web_dash/screens/authenticate/mobile/reserve/search_reserves_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../bloc/dates_state_bloc.dart';
import 'day_reserves_mobile_view.dart';


class ReservesMobileView extends StatefulWidget {

  const ReservesMobileView({Key? key,}) : super(key: key);

  @override
  State<ReservesMobileView> createState() => ReservesMobileViewState();
}

class ReservesMobileViewState extends State<ReservesMobileView> {


  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();


  List<Map<String, dynamic>> statesMenu = [
    {'state': 'Cita agendada', 'color': Colors.green},
    {'state': 'Expiró', 'color': Colors.orange},
    {'state': 'Cancelado', 'color': Colors.red},
    {'state': 'Atendido', 'color': Colors.blue}
  ];

  String selectedState = 'Todo';

  @override
  Widget build(BuildContext context) {

    final formatter = DateFormat('MMM d, yyyy h:mm a');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {},
        ),
        title: const Center(
          child: Text(
            'Dash',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchReservesMobileView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 225,
                  decoration: const BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: Provider.of<ConnectionDatesBlocs>(context).reserves,
                  builder: (context, value, child) {
                    if (value == null) {
                      return const Column(
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    } else if (value.isEmpty)
                    {
                      return const Column(
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Center(
                            child: Text('No hay citas disponibles',
                              style: TextStyle(
                                  fontSize: 25
                              ),),
                          ),
                        ],
                      );
                    }
                    else {
                      final reserves = value;
                      final numReserves = value
                          .where((reserve) => reserve['state'] == 'Reserva agendada')
                          .length;
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'Calendario',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$numReserves Reservas pendientes',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.show_chart,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 3.0,
                                      offset: Offset(0.2, 0.2))
                                ],
                              ),
                              child: Builder(builder: (context) {
                                return TableCalendar(
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
                                          .parse(reserve['datetime'])
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DayReserveMobileView(
                                              selectedDay: selectedDay,
                                            ),
                                      ),
                                    );
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
                                  calendarBuilders: CalendarBuilders(
                                    singleMarkerBuilder:
                                        (context, date, event) {
                                      if (date.isBefore(DateTime.now())) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange[400],
                                              shape: BoxShape.circle),
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  calendarStyle: CalendarStyle(
                                    todayDecoration: BoxDecoration(
                                        color: Colors.lightBlue[400],
                                        shape: BoxShape.circle),
                                    selectedDecoration: BoxDecoration(
                                        color: Colors.green[400],
                                        shape: BoxShape.circle),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 10, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'historial',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    showMenu(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                        details.globalPosition.dx,
                                        details.globalPosition.dy + 20,
                                        details.globalPosition.dx,
                                        details.globalPosition.dy,
                                      ),
                                      items: [
                                        PopupMenuItem(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    selectedState = 'Todo';
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      const Text('Todo'),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(left: 5),
                                                        child: Container(
                                                          height: 10,
                                                          width: 10,
                                                          decoration:
                                                          const BoxDecoration(
                                                              color: Colors
                                                                  .black87,
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children:
                                                statesMenu.map((state) {
                                                  String stateText =
                                                  state['state'];
                                                  Color stateColor =
                                                  state['color'];
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Navigator.pop(context);
                                                        selectedState =
                                                            stateText;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                      ),
                                                      child: Center(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              stateText,
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                                decoration:
                                                                BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                  stateColor,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  child: const Icon(Icons.menu_open_rounded),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: value != null && value.isNotEmpty
                                ? () {
                              final filteredReserves = reserves
                                  .where((reserve) =>
                              selectedState == 'Todo' ||
                                  reserve['state'] ==
                                      selectedState)
                                  .toList();

                              if (filteredReserves.isEmpty) {
                                return const Text(
                                    'No hay reservas en este estado');
                              }

                              return ListView.builder(
                                itemCount: filteredReserves.length,
                                itemBuilder: (context, index) {
                                  final reserve =
                                  filteredReserves[index];
                                  final state =
                                  reserve['state'].toString();
                                  Color containerColor;

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
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 30,
                                        right: 30),
                                    child: Container(
                                      height: 80,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(6),
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
                                              builder: (context) =>
                                                  ReserveMobileView(
                                                      reserve:
                                                      reserve),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 15,
                                                      top: 15,
                                                      bottom: 5),
                                                  child: Text(
                                                    '${reserve['name']} '
                                                        '${reserve['lastname']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      right: 15),
                                                  child: Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                        color:
                                                        containerColor,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            50)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(left: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        '${reserve['equipmenttype']}',
                                                        style:
                                                        const TextStyle(),
                                                      ),
                                                      Text(
                                                        '${reserve['fallatype']}',
                                                        style:
                                                        const TextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            right:
                                                            8.0),
                                                        child: Text(
                                                          formatter.format(
                                                              DateTime.parse(
                                                                  reserve[
                                                                  'createdat'])),
                                                          style:
                                                          const TextStyle(),
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
                                },
                              );
                            }()
                                : const Text('No hay reservas disponibles'),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
