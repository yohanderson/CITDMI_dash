import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../bloc/dates_state_bloc.dart';

class ReserveTabletView extends StatefulWidget {
  final Map<String, dynamic> reserve;

  const ReserveTabletView({
    Key? key,
    required this.reserve,
  }) : super(key: key);

  @override
  ReserveTabletViewState createState() => ReserveTabletViewState();
}

class ReserveTabletViewState extends State<ReserveTabletView> {
  List<Map<String, dynamic>> states = [
    {'state': 'Cita agendada', 'color': Colors.green},
    {'state': 'Expiró', 'color': Colors.orange},
    {'state': 'Cancelado', 'color': Colors.red},
    {'state': 'Atendido', 'color': Colors.blue}
  ];

  String state = '';
  late final String phoneNumber;

  late Map<String, dynamic> reserveView;

  @override
  void initState() {
    super.initState();
    reserveView = widget.reserve;
    phoneNumber = reserveView['phonenumber'];
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

    final formatter = DateFormat('MMM d, yyyy h:mm a');

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
          ),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable:
              Provider.of<ConnectionDatesBlocs>(context).reserves,
              builder: (context, value, child) {

                reserveView = value.firstWhere((reserve) => reserve['reserveid'] == widget.reserve['reserveid']);

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
                    const SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'reserva agendada',
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
                                  '${reserveView['datetime']}',
                                  style: const TextStyle(color: Colors.white),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
                      child: Container(
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
                                          '${reserveView['lastname']}',
                                      style: const TextStyle(
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
                                                  child: const Icon(Icons.phone)),
                                            ),
                                            Text(
                                                'Teléfono: ${reserveView['phonenumber']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(right: 5),
                                              child: Icon(Icons.phone_android),
                                            ),
                                            Text(
                                                'Tipo de equipo: ${reserveView['equipmenttype']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(right: 5),
                                              child: Icon(Icons.build),
                                            ),
                                            Text(
                                                'Falla: ${reserveView['fallatype']}'),
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
                        children: states.map((state) {
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
                                                'reserve_id': reserveView['reserveid']
                                                    .toString(),
                                                'estado': stateText
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
                              height: 45,
                              width: 80,
                              decoration: BoxDecoration(
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
                                  DateTime.parse(reserveView['createdat'])),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
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
                                            'id': reserveView['reserveid']
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
                        child: const Text(
                          'Eliminar cita',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
              }
          ),
        ],
      ),
    );
  }
}
