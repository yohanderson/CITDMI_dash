import 'package:web_dash/screens/authenticate/dekstop/reserves/reserve_desktop_view.dart';
import 'package:web_dash/screens/authenticate/dekstop/reserves/reserves_desktop_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayReserveDesktopView extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;
  final DateTime selectedDay;
  const DayReserveDesktopView(
      {Key? key,
      required this.selectedDay, required this.dates})
      : super(key: key);

  @override
  State<DayReserveDesktopView> createState() => DayReserveDesktopViewState();
}

class DayReserveDesktopViewState extends State<DayReserveDesktopView> {

  bool menuStatesBool = false;

  String selectedState = 'Todo';

  List<Map<String, dynamic>> statesMenu = ReservesDesktopState.statesMenu;


  @override
  Widget build(BuildContext context) {

    ReservesDesktopState reservesDesktopState =
    Provider.of<ReservesDesktopState>(context);

    Widget menuStates() {
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
                  menuStatesBool = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Text('Todo',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color, shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 0.2,
                              blurRadius:20,
                              offset: const Offset(10, 8),
                            ),
                          ],
                        ),
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
                      menuStatesBool = false;
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
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color,
                            ),
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

    return Container(
      height: 620,
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
      child: Stack(
        children: [
          Column(
            children: [
             Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: ()  {
                      reservesDesktopState.goBack();
                    },
                      icon: Container(
                      height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).textTheme.bodyLarge?.color
                        ),
                        child: const Center(child: Padding(
                          padding: EdgeInsets.only(right: 3),
                          child: Icon(Icons.arrow_back_ios_rounded),
                        ))),
                    ),
                    Text(
                      'Citas',
                      style: TextStyle(
                          fontSize: 35,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (menuStatesBool == false) {
                          menuStatesBool = true;
                        } else {
                          menuStatesBool = false;
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
                    valueListenable: widget.dates,
                    builder: (context, value, child){

                      final reserves = value;
                      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ' , 'es_ES');
                      final selectedDate = DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day);

                      final citasDelDiaSeleccionado = reserves.where((reserve) {
                        final citaDateTime = formatter.parse(reserve['date_time']).toLocal();
                        return citaDateTime.year == selectedDate.year &&
                            citaDateTime.month == selectedDate.month &&
                            citaDateTime.day == selectedDate.day;
                      }).toList();

                      citasDelDiaSeleccionado.sort((a, b) {
                        final citaADateTime = formatter.parse(a['date_time']).toLocal();
                        final citaBDateTime = formatter.parse(b['date_time']).toLocal();
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
                            ...filteredAppointments.map((reserve) {
                              return Builder(builder: (context) {
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
                                  case 'Reserva agendada':
                                    containerColor = Colors.green[300]!;
                                    break;
                                  default:
                                    containerColor = Colors.green[300]!;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 30, right: 30),
                                  child: Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 0.2,
                                          blurRadius: 20,
                                          offset: const Offset(10, 8),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        reservesDesktopState.changeValue(ReserveDesktopView(
                                          reserve: reserve, dates: widget.dates,
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
                                                      '${reserve['last_name']}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,),
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
                                                      '${reserve['equipment_type']}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 3, bottom: 5),
                                                      child: Text(
                                                        '${reserve['falla_type']}',
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
                                                  formatter.format(DateTime.parse(reserve['created_at']),),
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }).toList(),
                            const SizedBox(height: 15,)
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 120,
            right: 20,
            child: menuStatesBool == true
                ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme.surface,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0.2,
                      blurRadius:20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: menuStates())
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
