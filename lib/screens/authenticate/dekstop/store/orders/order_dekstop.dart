import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../../bloc/dates_state_bloc.dart';


class OrderDesktop extends StatefulWidget {
  final Map<String, dynamic> order;
  const OrderDesktop({super.key, required this.order});

  @override
  State<OrderDesktop> createState() => _OrderDesktopState();
}

class _OrderDesktopState extends State<OrderDesktop> {

  late final String phoneNumber;

  late Map<String, dynamic> orderView;

  @override
  void initState() {
    super.initState();
    orderView = widget.order;
    phoneNumber = widget.order['phone_number'];
  }


  void openWhatsapp(BuildContext context, String phoneNumber) async {
    String message = "Hola, somos MundoCell tu pedido fue realizado con exito, para cualquier informacion por este medio, que tenga un muy buen dia.";
    String whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }


  void makePhoneCall(String phoneNumber) async {
    Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
    }
  }

  void sendTextMessage(String phoneNumber) async {
    Uri url = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disculpe hubo un error')),
      );
    }
  }

  List<Map<String, dynamic>> states = [
    {'state': 'Nueva orden', 'color': Colors.green},
    {'state': 'Retrasado', 'color': Colors.orange},
    {'state': 'Cancelado', 'color': Colors.red},
    {'state': 'Pedido Realizado', 'color': Colors.blue}
  ];

  String state = '';

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
          ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable:
              Provider.of<ConnectionDatesBlocs>(context).orders,
              builder: (context, value, child) {

                orderView = value.firstWhere((order) => order['order_id'] == widget.order['order_id']);

                state = orderView['state'].toString();

                Color containerColor;

                final timestamp = orderView['created_at'];
                final dateTime = DateTime.parse(timestamp);;

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

                return Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Orden',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
                    child: Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only( bottom: 10),
                                        child: Text('${orderView['name']} ${orderView['last_name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Empresa:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['name_enterprise']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('País:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['country']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Región:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['region']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Dirección:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['address']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Dirección 2:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['address_two']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Población:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['population']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Código Postal:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['code_postal']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Población:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['population']}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          children: [
                                            const Text('Teléfono:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            Text(' ${orderView['phone_number']}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, right: 5),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: containerColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, top: 3),
                                child: SizedBox(
                                  width: 250,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Notas: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${orderView['notes']}',
                                          textAlign: TextAlign.justify,
                                          maxLines: null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () => sendTextMessage(phoneNumber),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  onPressed: () => makePhoneCall(phoneNumber),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chat),
                                  onPressed: () => openWhatsapp(context, phoneNumber),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  title: const Text('¿Seguro que quieres hacer este cambio?'),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                        child: const Text('Sí'),
                                        onPressed: () async {
                                          final response = await http.post(
                                            Uri.parse(
                                                'http:$ipPort/update_state_order'),
                                            body: {
                                              'id': orderView['order_id']
                                                  .toString(),
                                              'estado': stateText
                                            },
                                          );

                                          if (response.statusCode == 200) {
                                            Navigator.pop(context);
                                          } else {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                                  ),
                                                  title: const Text('Error al cambiar el estado'),
                                                  content: SizedBox(
                                                    width: 60,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                                      child: const Text('ok',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                        ),),
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
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
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
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: stateColor,),
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
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Spacer(),
                        const Text('Fecha del pedido:',
                          style: TextStyle(
                            fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        Text(' ${DateFormat.yMMMd().add_jm().format(dateTime)}',
                        style: const TextStyle(
                          fontSize: 20
                        ),),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
