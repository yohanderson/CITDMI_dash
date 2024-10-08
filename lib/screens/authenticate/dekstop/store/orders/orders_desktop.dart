import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../bloc/dates_state_bloc.dart';
import '../shop_desktop_panel.dart';
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
  bool calendarMenuActive = false;

  List<Map<String, dynamic>> statesMenu = [
    {'state': 'Nueva orden', 'color': Colors.green},
    {'state': 'Retrasado', 'color': Colors.orange},
    {'state': 'Cancelado', 'color': Colors.red},
    {'state': 'Pedido Realizado', 'color': Colors.blue}
  ];

  String selectedState = 'Todo';
  bool menuStatesActive = false;

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
                menuStatesActive = false;
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
                    menuStatesActive = false;
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

    ShopDekstopPanelState shopDekstopPanelState =  Provider.of<ShopDekstopPanelState>(context);

    return Container(
      height: 390,
      width: 550,
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
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: Provider.of<ConnectionDatesBlocs>(context).orders,
          builder: (context, value, child) {
            final orders = value;

            Widget calendarMenu() {
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
                      calendarMenuActive = false;
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
              return Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Ordenes',
                    style: TextStyle(
                        fontSize: 30,
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Ordenes',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (menuStatesActive == false) {
                                    menuStatesActive = true;
                                  } else {
                                    menuStatesActive = false;
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    const Text(
                                      'Estados',
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.remove_red_eye_sharp,
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15,),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (calendarMenuActive == false) {
                                    calendarMenuActive = true;
                                  } else {
                                    calendarMenuActive = false;
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    const Text(
                                      'Fecha',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(right: 35),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 15),
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
                                                    shopDekstopPanelState.changeValue(
                                                            OrderDesktop(order: order)
                                                    );


                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 5),
                                                    child: Container(
                                                      height: 90,
                                                      width: 370,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                                                            spreadRadius: 0.2,
                                                            blurRadius:20,
                                                            offset: const Offset(10, 8),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(10),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '${order['name']} ${order['last_name']}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                                Container(
                                                                  height: 10,
                                                                  width: 10,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color:
                                                                      containerColor),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
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
                                                                Text(
                                                                    DateFormat.yMMMd().add_jm().format(dateTime)),
                                                              ],
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
                  top: 100,
                  right: 12,
                  child: calendarMenuActive == true
                      ? Container(
                          width: 340,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                  blurRadius: 1.5,
                                  offset: const Offset(0.2, 0.2))
                            ],
                          ),
                          child: SingleChildScrollView(
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
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20, top: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedDay = null;
                                            calendarMenuActive = false;
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
                                calendarMenu(),
                              ],
                            ),
                          ))
                      : const SizedBox(),
                ),
                Positioned(
                  top: 100,
                  left: 12,
                  child: menuStatesActive == true
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                  blurRadius: 2.0,
                                  offset: const Offset(0.2, 0.2))
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
