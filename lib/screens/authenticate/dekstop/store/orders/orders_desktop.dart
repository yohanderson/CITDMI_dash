import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../bloc/dates_state_bloc.dart';
import 'order_dekstop.dart';

class OrdersDesktop extends StatefulWidget {
  const OrdersDesktop({super.key});

  @override
  State<OrdersDesktop> createState() => _OrdersDesktopState();
}

class _OrdersDesktopState extends State<OrdersDesktop> {
  @override
  void initState() {
    super.initState();
    _selectedDay = null;
  }

  String _getDateString(String created_at) {
    final dateTime = DateFormat('d/M/yyyy H:m').parse(created_at);
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Hoy';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Ayer';
    } else {
      return DateFormat('d/M/yyyy').format(dateTime);
    }
  }

  int numOrders = 0;
  late DateTime? _selectedDay;
  bool CalendarMenu = false;

  List<Map<String, dynamic>> statesMenu = [
    {'state': 'Nueva orden', 'color': Colors.green},
    {'state': 'Retrasado', 'color': Colors.orange},
    {'state': 'Cancelado', 'color': Colors.red},
    {'state': 'Pedido Realizado', 'color': Colors.blue}
  ];

  String selectedState = 'Todo';
  bool MenuStates = false;

  Widget _menuStates() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedState = 'Todo';
                MenuStates = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  const Text('Todo'),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          color: Colors.black87, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: statesMenu.map((state) {
              String stateText = state['state'];
              Color stateColor = state['color'];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedState = stateText;
                    MenuStates = false;
                  });
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          stateText,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: stateColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 365,
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
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: Provider.of<ConnectionDatesBlocs>(context).orders,
          builder: (context, value, child) {
            final orders = value;

            Widget _CalendarMenu() {
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
                ),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  final ordersForSelectedDay = orders.where((order) {
                    final orderDate = DateTime.parse(order['created_at']);
                    return isSameDay(orderDate, selectedDay);
                  }).toList();

                  if (ordersForSelectedDay.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No tienes órdenes para este día'),
                      ),
                    );
                  } else {
                    setState(() {
                      _selectedDay = selectedDay;
                      CalendarMenu = false;
                    });
                  }
                },
              );
            }

            final formatter = DateFormat('MMM d, yyyy h:mm a');

            final ordersToShow = orders.where((order) {
              final orderDate = DateTime.parse(order['created_at']);
              final orderState = order['state'];
              return (selectedState == 'Todo' && _selectedDay == null) ||
                  (selectedState == orderState && _selectedDay == null) ||
                  (isSameDay(orderDate, _selectedDay) &&
                      (selectedState == 'Todo' || selectedState == orderState));
            }).toList();

            final ordersByDate = <String, List<Map<String, dynamic>>>{};
            for (final order in ordersToShow) {
              final date = formatter.format(DateTime.parse(order['created_at']));
              if (!ordersByDate.containsKey(date)) {
                ordersByDate[date] = [];
              }
              ordersByDate[date]?.add(order);
            }

            final filteredOrders = orders.where((order) {
              final orderDate = DateTime.parse(order['created_at']);
              final orderState = order['state'];
              return (selectedState == 'Todo' && _selectedDay == null) ||
                  (selectedState == orderState && _selectedDay == null) ||
                  (isSameDay(orderDate, _selectedDay) &&
                      (selectedState == 'Todo' || selectedState == orderState));
            }).toList();

            if (filteredOrders.isEmpty) {
              return Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Ordenes',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('No hay ordenes disponibles',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),),
                  const Spacer(),
                ],
              ));
            }

            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Ordenes',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (MenuStates == false) {
                                  MenuStates = true;
                                } else {
                                  MenuStates = false;
                                }
                              });
                            },
                            child: const SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  Text(
                                    'Estados',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.remove_red_eye_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, bottom: 20, top: 20),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (CalendarMenu == false) {
                                  CalendarMenu = true;
                                } else {
                                  CalendarMenu = false;
                                }
                              });
                            },
                            child: const SizedBox(
                              width: 100,
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
                            if (value == null) ...[
                              const Column(
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
                              ),
                            ]
                            else if (value.isEmpty) ...[
                              const Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                  ),
                                  Center(
                                    child: Text(
                                      'No hay ordenes disponibles',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                            else ...[
                                for (final entry in ordersByDate.entries)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(right: 35),
                                            child: Text(
                                              entry.key,
                                              style: const TextStyle(
                                                  color: Colors.grey, fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      for (final order in entry.value)
                                        Builder(builder: (context) {
                                          Color containerColor;
                                          String state = order['state'].toString();
                        
                                          switch (state) {
                                            case 'Retrasado':
                                              containerColor = Colors.orange;
                                              break;
                                            case 'Pedido Realizado':
                                              containerColor = Colors.blue;
                                              break;
                                            case 'Cancelado':
                                              containerColor = Colors.red;
                                              break;
                                            default:
                                              containerColor = Colors.green[300]!;
                                          }
                                          final timestamp = order['created_at'];
                                          final dateTime = DateTime.parse(timestamp);
                        
                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20, top: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderDesktop(order: order),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: Container(
                                                      height: 90,
                                                      width: 350,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                        boxShadow: const <BoxShadow>[
                                                          BoxShadow(
                                                              color: Colors.black54,
                                                              blurRadius: 2.0,
                                                              offset:
                                                              Offset(0.2, 0.2))
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    '${order['name']} ${order['last_name']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          'País: ${order['country']}'),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top: 2),
                                                                        child: Text(
                                                                            'Región: ${order['region']}'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10,
                                                                  top: 5,
                                                                  bottom: 5),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: 10,
                                                                    width: 10,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color:
                                                                        containerColor),
                                                                  ),
                                                                  Text(
                                                                      '${DateFormat.yMMMd().add_jm().format(dateTime)}'),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 25,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 140,
                  right: 30,
                  child: CalendarMenu == true
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 13),
                                    child: Text(
                                      'Seleccionar dia',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, top: 10),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedDay = null;
                                          CalendarMenu = false;
                                        });
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Todo',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _CalendarMenu(),
                            ],
                          ))
                      : const SizedBox(),
                ),
                Positioned(
                  top: 140,
                  left: 25,
                  child: MenuStates == true
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                  offset: Offset(0.2, 0.2))
                            ],
                          ),
                          child: _menuStates())
                      : const SizedBox(),
                ),
              ],
            );
          }),
    );
  }
}
