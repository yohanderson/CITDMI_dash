import 'package:web_dash/screens/authenticate/mobile/reserve/reserve_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';

class DayReserveMobileView extends StatefulWidget {
  final DateTime selectedDay;
  const DayReserveMobileView(
      {Key? key,
        required this.selectedDay})
      : super(key: key);

  @override
  State<DayReserveMobileView> createState() => DayReserveMobileViewState();
}

class DayReserveMobileViewState extends State<DayReserveMobileView> {
  bool menuStates = false;

  List<Map<String, dynamic>> statesMenu = [
    {'state': 'Cita agendada', 'color': Colors.green},
    {'state': 'Expiró', 'color': Colors.orange},
    {'state': 'Cancelado', 'color': Colors.red},
    {'state': 'Atendido', 'color': Colors.blue}
  ];

  String selectedState = 'Todo';

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
                menuStates = false;
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
                    menuStates = false;
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


    return Scaffold(
      body: Stack(
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
                height: 50,
              ),
              const Text(
                'Citas',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (menuStates == false) {
                          menuStates = true;
                        } else {
                          menuStates = false;
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: Provider.of<ConnectionDatesBlocs>(context).reserves,
                    builder: (context, value, child){
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
                      } else if (value.isEmpty) {
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
                      } else {
                        final reserves = value;
                        final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
                        final selectedDate = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day);

                        final citasDelDiaSeleccionado = reserves.where((reserve) {
                          final citaDateTime = formatter.parse(reserve['datetime']).toLocal();
                          return citaDateTime.year == selectedDate.year &&
                              citaDateTime.month == selectedDate.month &&
                              citaDateTime.day == selectedDate.day;
                        }).toList();

                        citasDelDiaSeleccionado.sort((a, b) {
                          final citaADateTime = formatter.parse(a['datetime']).toLocal();
                          final citaBDateTime = formatter.parse(b['datetime']).toLocal();
                          return citaBDateTime.compareTo(citaADateTime);
                        });

                        final filteredAppointments = citasDelDiaSeleccionado
                            .where((appointment) =>
                        selectedState == 'Todo' ||
                            appointment['state'] == selectedState)
                            .toList();

                        if (filteredAppointments.isEmpty) {
                          return const Column(
                            children: [
                              SizedBox(
                                height: 110,
                              ),
                              Text(
                                'No hay citas con este estado',
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              ...filteredAppointments.map((reserve) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Builder(builder: (context) {
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
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 5),
                                      child: Container(
                                        height: 100,
                                        width: 350,
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
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ReserveMobileView(
                                                    reserve: reserve
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 15, top: 5, bottom: 5),
                                                    child: Text(
                                                      '${reserve['name']} '
                                                          '${reserve['lastname']}',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${reserve['equipmenttype']}',
                                                          style: const TextStyle(),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              top: 3, bottom: 5),
                                                          child: Text(
                                                            '${reserve['fallatype']}',
                                                            style: const TextStyle(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(right: 15),
                                                    child: Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                          color: containerColor,
                                                          borderRadius:
                                                          BorderRadius.circular(50)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(right: 10),
                                                    child: Text(
                                                      formatter.format(DateTime.parse(reserve['createdat'])),
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
                                );
                              }).toList(),
                              const SizedBox(height: 15,)
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 115,
            right: 20,
            child: menuStates == true
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
      ),
    );
  }
}
