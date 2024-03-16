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
      {super.key,
      required this.selectedDay, required this.dates});

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
                    const Text('Todo',
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                             shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                Gradient stateColor = state['gradient'];
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: stateColor,
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
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                          color: Theme.of(context).colorScheme.onPrimary
                        ),
                        child: const Center(child: Padding(
                          padding: EdgeInsets.only(right: 3),
                          child: Icon(Icons.arrow_back_ios_rounded),
                        ))),
                    ),
                    const Text(
                      'Citas',
                      style: TextStyle(
                          fontSize: 35,
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
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          const Text(
                            'Estados',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: widget.dates,
                    builder: (context, value, child){

                      final reserves = value;
                      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ' , 'es_ES');
                      final formatterView = DateFormat('MMM d, yyyy h:mm a', 'es_Es');
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
                                String state = reserve['state'].toString();
                                Gradient containerColor;

                                switch (state) {
                                  case 'Expiró':
                                    containerColor =
                                    statesMenu[1]['gradient'];
                                    break;
                                  case 'Atendido':
                                    containerColor =
                                    statesMenu[2]['gradient'];
                                    break;
                                  case 'Cancelado':
                                    containerColor =
                                    statesMenu[3]['gradient'];
                                    break;
                                  default:
                                    containerColor =
                                    statesMenu[0]['gradient'];
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 30, right: 30),
                                  child: Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 15, bottom: 5),
                                                child: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      '${reserve['name']} '
                                                          '${reserve['last_name']}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                      gradient: containerColor,
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${reserve['equipment_type']}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis
                                                      ),
                                                      Text(
                                                          '${reserve['falla_type']}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 10),
                                                child: Text(
                                                  formatterView.format(DateTime
                                                      .parse(reserve[
                                                  'created_at'])),
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
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
