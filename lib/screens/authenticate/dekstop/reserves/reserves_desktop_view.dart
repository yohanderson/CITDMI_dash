import 'dart:math';
import 'package:web_dash/screens/authenticate/dekstop/reserves/calendar/calendar.dart';
import 'package:web_dash/screens/authenticate/dekstop/reserves/reserve_desktop_view.dart';
import 'package:web_dash/screens/authenticate/dekstop/reserves/search_reserves_desktop_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../bloc/dates_state_bloc.dart';
import '../stadistic/cicle_chart_desktop.dart';
import '../stadistic/lineal_chart_desktop.dart';
import 'calendar/list_reserve.dart';

class ReservesDesktop extends StatefulWidget {
  const ReservesDesktop({
    super.key,
  });

  @override
  State<ReservesDesktop> createState() => ReservesDesktopState();
}

class ReservesDesktopState extends State<ReservesDesktop> {
  final ValueNotifier<List<Map<String, dynamic>>> filteredReservesNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<bool> isFocused =  ValueNotifier<bool> (false);

  final ScrollController _scrollController = ScrollController();
  bool _showIcon = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _showIcon = _scrollController.position.extentAfter != 0;
    });
  }

  static List<Map<String, dynamic>> statesMenu = [
    {
      'state': 'Reserva agendada',
      'gradient': LinearGradient(
        colors: [Colors.green[200]!, Colors.green[900]!],
        stops: [0.1, 0.9],
      ),
      'count': 0
    },
    {
      'state': 'Expiró',
      'gradient': const LinearGradient(
        colors: [Colors.red, Colors.orange],
        stops: [0.1, 0.9],
      ),
      'count': 0
    },
    {
      'state': 'Cancelado',
      'gradient': const LinearGradient(
        colors: [Colors.yellow, Colors.red],
        stops: [0.1, 0.9],
      ),
      'count': 0
    },
    {
      'state': 'Atendido',
      'gradient': const LinearGradient(
        colors: [Colors.cyan, Colors.blue],
        stops: [0.1, 0.9],
      ),
      'count': 0
    }
  ];


  late ValueNotifier<Widget> currentViewList;
  List<Widget> history = []; // Para mantener un historial de widgets

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Widget initialWidget = ListReservesDesktop(
        dates: Provider.of<ConnectionDatesBlocs>(context).reserves);
    currentViewList = ValueNotifier<Widget>(initialWidget);
    history.add(initialWidget); // Añade el widget inicial al historial
  }

  void changeValue(Widget newValue) {
    history.add(currentViewList.value);
    currentViewList.value = newValue;
  }

  void goBack() {
    if (history.isNotEmpty) {
      currentViewList.value =
          history.removeLast(); // Retrocede al último widget del historial
    }
  }

  void clearHistory() {
    if (history.isNotEmpty) {
      Widget initialWidget = history.first; // Guarda el widget inicial
      history.clear(); // Limpia el historial
      history.add(initialWidget); // Añade el widget inicial al historial
      currentViewList.value = initialWidget; // Actualiza currentViewList.value
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }
  @override
  Widget build(BuildContext context) {

    final formatter = DateFormat('MMM d, yyyy h:mm a', 'es_ES');



    return Provider<ReservesDesktopState>.value(
      value: this,
      child: Scaffold(
        body: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable:
                Provider.of<ConnectionDatesBlocs>(context).reserves,
            builder: (context, value, child) {
              final numReserves = value
                  .where((reserve) => reserve['state'] == 'Reserva agendada')
                  .length;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  width: 550,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0.2,
                                        blurRadius: 20,
                                        offset: const Offset(10, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    child: Text(
                                      'Panel de control Reservas',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: SizedBox(
                                  width: 550,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 240,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 0.2,
                                              blurRadius: 10,
                                              offset: const Offset(10, 8),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.green[100]),
                                                child: const Icon(
                                                  Icons.list_alt,
                                                  color: Colors.green,
                                                  size: 35,
                                                )),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Reservas pendientes',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '$numReserves',
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset: Offset(0.5, 1),
                                                        blurRadius: 5.0,
                                                        color: Colors.black26,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 90,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 0.2,
                                              blurRadius: 10,
                                              offset: const Offset(10, 8),
                                            ),
                                          ],
                                        ),
                                        child: ValueListenableBuilder<
                                                List<Map<String, dynamic>>>(
                                            valueListenable: Provider.of<
                                                        ConnectionDatesBlocs>(
                                                    context)
                                                .client,
                                            builder: (context, value, child) {
                                              final numAccountsClients =
                                                  value.length;

                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                      height: 55,
                                                      width: 55,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color),
                                                      child: Icon(
                                                        Icons
                                                            .account_box_rounded,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        size: 35,
                                                      )),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'lista de Clientes',
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        '$numAccountsClients',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              LinealChartDesktop(
                                dates:
                                    Provider.of<ConnectionDatesBlocs>(context)
                                        .reserves, dateChart: 'date_time', dotChart: true,
                              ),
                              SizedBox(
                                height: 540,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: SearchReservesDesktopView(
                                            filteredReservesNotifier:
                                                filteredReservesNotifier,
                                            dates: Provider.of<
                                                        ConnectionDatesBlocs>(
                                                    context)
                                                .reserves, isFocused: isFocused,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20),
                                          child: Calendar(
                                            dates: Provider.of<
                                                        ConnectionDatesBlocs>(
                                                    context)
                                                .reserves,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 70,
                                      child: ValueListenableBuilder<bool>(
                                          valueListenable: isFocused,
                                          builder: (context, value, child) {

                                            if(value) {
                                              return ValueListenableBuilder<
                                                  List<Map<String, dynamic>>>(
                                                  valueListenable:
                                                  filteredReservesNotifier,
                                                  builder: (context, value, child) {

                                                    double containerHeight;
                                                    String message = 'No hay reservas con este nombre';
                                                    int maxItems = 10;

                                                    if (value.isEmpty) {
                                                      containerHeight = 100;
                                                    } else if (value.length == 1) {
                                                      containerHeight = 100;
                                                      maxItems = 1;
                                                    } else if (value.length == 2) {
                                                      containerHeight = 190;
                                                      maxItems = 2;
                                                    } else {
                                                      containerHeight = 280;
                                                      maxItems = min(10, value.length);
                                                    }

                                                    return value.isEmpty ?
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 25),
                                                      child: Container(
                                                        height: containerHeight,
                                                        width: 500,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: Theme.of(context).hintColor
                                                        ),
                                                        child: Center(
                                                          child: Container(
                                                            height: 80,
                                                            width: 480,
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).primaryColor,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  6),
                                                              boxShadow: const <BoxShadow>[
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black54,
                                                                    blurRadius:
                                                                    2.0,
                                                                    offset:
                                                                    Offset(0.2, 0.2))
                                                              ],
                                                            ),
                                                            child: Center(
                                                              child: Text(message,
                                                                style: TextStyle(
                                                                    color: Theme.of(context).textTheme.bodyLarge?.color
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ) :
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 25),
                                                      child: Container(
                                                        height: containerHeight,
                                                        width: 500,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            SizedBox(
                                                              height: containerHeight,
                                                              width: 500,
                                                              child: SingleChildScrollView(
                                                                controller: _scrollController,
                                                                child: Column(
                                                                  children: [
                                                                    for (int index = 0; index < value.length; index++)
                                                                      Builder(builder:
                                                                          (context) {
                                                                        final reserve =
                                                                        value[
                                                                        index];
                                                                        Color
                                                                        containerColor;
                                                                        String state = reserve[
                                                                        'state']
                                                                            .toString();

                                                                        switch (state) {
                                                                          case 'Expiró':
                                                                            containerColor =
                                                                                Colors
                                                                                    .orange;
                                                                            break;
                                                                          case 'Atendido':
                                                                            containerColor =
                                                                                Colors
                                                                                    .blue;
                                                                            break;
                                                                          case 'Cancelado':
                                                                            containerColor =
                                                                                Colors
                                                                                    .red;
                                                                            break;
                                                                          default:
                                                                            containerColor =
                                                                            Colors.green[
                                                                            300]!;
                                                                        }
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 10),
                                                                          child:
                                                                          Container(
                                                                            height: 80,
                                                                            width: 480,
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              color: Theme.of(context).primaryColor,
                                                                              borderRadius:
                                                                              BorderRadius.circular(
                                                                                  6),
                                                                              boxShadow: const <BoxShadow>[
                                                                                BoxShadow(
                                                                                    color: Colors
                                                                                        .black54,
                                                                                    blurRadius:
                                                                                    2.0,
                                                                                    offset:
                                                                                    Offset(0.2, 0.2))
                                                                              ],
                                                                            ),
                                                                            child:
                                                                            InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                    changeValue(ReserveDesktopView(
                                                                                      reserve: reserve,
                                                                                      dates: Provider.of<ConnectionDatesBlocs>(context, listen: false).reserves,
                                                                                    ),);
                                                                                  },
                                                                              child:
                                                                              Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                                                                                        child: Text(
                                                                                          '${reserve['name']} '
                                                                                              '${reserve['last_name']}',
                                                                                          style: TextStyle(color: Theme.of(context)
                                                                                              .textTheme
                                                                                              .bodyLarge
                                                                                              ?.color,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(right: 15),
                                                                                        child: Container(
                                                                                          height: 10,
                                                                                          width: 10,
                                                                                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(50)),
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
                                                                                            Text(
                                                                                              '${reserve['equipment_type']}',
                                                                                              style: TextStyle(
                                                                                                color: Theme.of(context)
                                                                                                    .textTheme
                                                                                                    .bodyLarge
                                                                                                    ?.color,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              '${reserve['falla_type']}',
                                                                                              style: TextStyle(
                                                                                                color: Theme.of(context)
                                                                                                    .textTheme
                                                                                                    .bodyLarge
                                                                                                    ?.color,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(right: 8.0),
                                                                                              child: Text(
                                                                                                formatter.format(DateTime
                                                                                                    .parse(reserve[
                                                                                                'created_at'])),
                                                                                                style: TextStyle(
                                                                                                  color: Theme.of(context)
                                                                                                      .textTheme
                                                                                                      .bodyLarge
                                                                                                      ?.color,
                                                                                                ),
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
                                                                      }),
                                                                    const SizedBox(height: 10,)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            maxItems > 4 && _showIcon ? Positioned(
                                                                bottom: 10,
                                                                right: 10,
                                                                child: Icon(Icons.arrow_circle_down_outlined, color: Theme.of(context).textTheme.bodyLarge?.color,)) : const SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              return const SizedBox();
                                            }
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                CircleChartDesktop(
                                  dates: Provider.of<ConnectionDatesBlocs>(
                                          context)
                                      .reserves,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ValueListenableBuilder<Widget>(
                                      valueListenable: currentViewList,
                                      builder: (context, value, child) {
                                        return currentViewList.value;
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
