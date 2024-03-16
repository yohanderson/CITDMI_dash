import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../reserve_desktop_view.dart';
import '../reserves_desktop_view.dart';

class ListReservesDesktop extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;

  const ListReservesDesktop({super.key, required this.dates});

  @override
  State<ListReservesDesktop> createState() => _ListReservesDesktopState();
}

class _ListReservesDesktopState extends State<ListReservesDesktop> {
  String selectedState = 'Todo';

  bool menuStatesBool = false;

  List<Map<String, dynamic>> statesMenu = ReservesDesktopState.statesMenu;
  @override
  Widget build(BuildContext context) {

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

    ReservesDesktopState reservesDesktopState =
        Provider.of<ReservesDesktopState>(context);

    final formatter = DateFormat('MMM d, yyyy h:mm a', 'es_Es');

    return ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: widget.dates,
        builder: (context, value, child) {
          final reserves = value;

          return Container(
            height: 610,
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
                      padding: const EdgeInsets.only(
                          top: 15, left: 30, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'historial',
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color),
                          ),
                          InkWell(
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
                        ],
                      ),
                    ),
                    value.isNotEmpty
                        ? () {
                            final filteredReserves = reserves
                                .where((reserve) =>
                                    selectedState == 'Todo' ||
                                    reserve['state'] == selectedState)
                                .toList();

                            if (filteredReserves.isEmpty) {
                              return const Center(child: Text('No hay reservas en este estado'));
                            }

                            return SizedBox(
                              height: 550,
                              child: ListView.builder(
                                itemCount: filteredReserves.length,
                                itemBuilder: (context, index) {
                                  final reserve = filteredReserves[index];
                                  final state = reserve['state'].toString();
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
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
                                            blurRadius: 3,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          reservesDesktopState.changeValue(
                                            ReserveDesktopView(
                                              reserve: reserve,
                                              dates: widget.dates,
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
                                                    formatter.format(DateTime
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
                                },
                              ),
                            );
                          }()
                        : Center( child: Text('No hay reservas disponibles',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color
                    ),)),
                  ],
                ),
                Positioned(
                  top: 50,
                  right: 30,
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
        });
  }
}
