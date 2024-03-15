import 'package:web_dash/screens/authenticate/dekstop/reserves/reserves_desktop_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../../bloc/dates_state_bloc.dart';

class ReserveDesktopView extends StatefulWidget {
  final ValueListenable<List<Map<String, dynamic>>> dates;
  final Map<String, dynamic> reserve;

  const ReserveDesktopView({
    Key? key,
    required this.reserve, required this.dates,
  }) : super(key: key);

  @override
  ReserveDesktopViewState createState() => ReserveDesktopViewState();
}

class ReserveDesktopViewState extends State<ReserveDesktopView> {

  List<Map<String, dynamic>> statesMenu = ReservesDesktopState.statesMenu;


  String state = '';
  late final String phoneNumber;

  late Map<String, dynamic> reserveView;

  @override
  void initState() {
    super.initState();
    reserveView = widget.reserve;
    phoneNumber = reserveView['phone_number'];
  }

  void openWhatsapp(BuildContext context, String phoneNumber) async {
    String message =
        "Hola, somos MundoCell tu cita fue programada con exito, para cualquier informacion por este medio, que tenga un muy buen dia.";
    String whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    ReservesDesktopState reservesDesktopState = Provider.of<ReservesDesktopState>(context);

    final formatter = DateFormat('MMM d, yyyy h:mm a', 'es_ES');

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
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: widget.dates,
          builder: (context, value, child) {

            reserveView = value.firstWhere((reserve) => reserve['reserve_id'] == widget.reserve['reserve_id']);

            state = reserveView['state'].toString();

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

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(onPressed: ()  {
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reserva agendada',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Para el dia',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formatter.format(
                                    DateTime.parse(reserveView['date_time'])),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: containerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0.2,
                          blurRadius:20,
                          offset: const Offset(10, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 15, bottom: 5),
                                child: Text(
                                  '${reserveView['name']} '
                                      '${reserveView['last_name']}',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 5),
                                          child: InkWell(
                                              onTap: () => openWhatsapp(
                                                  context, phoneNumber),
                                              child: Icon(Icons.phone, color: Theme.of(context).textTheme.bodyLarge?.color,)),
                                        ),
                                        Text(
                                            'Teléfono: ${reserveView['phone_number']}',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Icon(Icons.phone_android, color: Theme.of(context).textTheme.bodyLarge?.color),
                                        ),
                                        Text(
                                            'Tipo de equipo: ${reserveView['equipment_type']}',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Icon(Icons.build, color: Theme.of(context).textTheme.bodyLarge?.color,),
                                        ),
                                        Text(
                                            'Falla: ${reserveView['falla_type']}',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: statesMenu.map((state) {
                      String stateText = state['state'];
                      Color stateColor = state['color'];
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                title: const Text(
                                    '¿Seguro que quieres hacer este cambio?'),
                                content: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue),
                                      child: const Text('Sí',
                                        style: TextStyle(
                                            color: Colors.white
                                        ),),
                                      onPressed: () async {
                                        final response = await http.post(
                                          Uri.parse(
                                              'http:$ipPort/update_state_reserve'),
                                          body: {
                                            'reserve_id': reserveView['reserve_id']
                                                .toString(),
                                            'state': stateText
                                          },
                                        );

                                        if (response.statusCode == 200) {
                                          Navigator.pop(context);
                                        }
                                        else {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape:
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            5))),
                                                title: const Text(
                                                    'Error al cambiar el estado'),
                                                content: SizedBox(
                                                  width: 60,
                                                  child: ElevatedButton(
                                                    style:
                                                    ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blue),
                                                    child: const Text(
                                                      'ok',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                              color: stateColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              stateText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Esta cita fue agendada el dia',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formatter.format(
                              DateTime.parse(reserveView['created_at'])),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            title:
                            const Text('¿Seguro que quieres eliminar esta cita?'),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: Text('Sí'),
                                  onPressed: () async {
                                    final response = await http.delete(
                                      Uri.parse(
                                          'http:$ipPort/delete_reserve'),
                                      body: {
                                        'reserve_id': reserveView['reserve_id']
                                            .toString()
                                      },
                                    );
                                    if (response.statusCode == 200) {
                                      Navigator.pop(context);
                                    }
                                    else {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            title: const Text(
                                                'Error al cambiar el estado'),
                                            content: SizedBox(
                                              width: 60,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue),
                                                child: const Text(
                                                  'ok',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black),
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 30,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient:  LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).hintColor
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text('Eliminar',
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}
