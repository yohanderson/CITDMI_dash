import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';
import 'dart:io';

class SettingsMobileView extends StatefulWidget {
  const SettingsMobileView({Key? key}) : super(key: key);

  @override
  State<SettingsMobileView> createState() => _SettingsMobileViewState();
}

class _SettingsMobileViewState extends State<SettingsMobileView> {




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: Provider.of<ConnectionDatesBlocs>(context)
              .reserves,
          builder: (context, value, child) {


            final reserves = value;

            final filteredReserves = reserves.where((reserve) {
              return reserve['state'] == 'Cita agendada';
            }).toList();

            String? currentReserveId;
            File? localFile;

            void _seleccionarFoto(String reserveId) async {
              try {
                final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    localFile = File(pickedFile.path);
                    currentReserveId = reserveId;
                    print('Imagen seleccionada: $localFile para la cita: $currentReserveId');
                  });
                }
              } catch (e) {
                print('Error al seleccionar la foto: $e');
              }
            }

            Widget ReserveImage(String reserveId, String imageBuild) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                width: 200,
                height: 150,
                child: (localFile != null && currentReserveId == reserveId)
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: localFile != null
                          ? Image.file(
                        localFile!,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        imageBuild,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: InkWell(
                          child: Icon(Icons.edit, color: Colors.white, size: 10),
                          onTap: () {
                            _seleccionarFoto(reserveId);
                            print('Construyendo: $reserveId');
                          },
                        ),
                      ),
                    ),
                  ],
                )
                    : IconButton(
                  onPressed: () {
                    _seleccionarFoto(reserveId);
                    print('Construyendo widget para la cita: $reserveId');
                  },
                  icon: const Icon(Icons.image),
                ),
              );
            }




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
            } else if (filteredReserves.isEmpty) {
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

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Text('Estado de Reparaciones',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                    ),
                    ...filteredReserves
                        .map((reserve) => Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        reserve['name'],
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      ReserveImage(
                                        reserve['appointmentid'].toString(),
                                        reserve['imagebuild'].toString(),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 15, right: 15),
                                  child: TextFormField(
                                    controller:
                                    reserve['descripcionController'],
                                    onChanged: (value) => setState(() =>
                                    reserve['informacion'] = value),
                                    decoration: InputDecoration(
                                        labelText: 'descripcion',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(8))),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(5))),
                                              title: const Text(
                                                  '¿Confirma si deseas agregar cambios  al estado de la reparacion?'),
                                              content: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        backgroundColor: Colors.blue),
                                                    child: const Text('Sí'),
                                                    onPressed: () {},
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        backgroundColor: Colors.black),
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text('enviar'),
                                      )),
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(5))),
                                              title: const Text(
                                                  '¿Confirma si deseas finalizar el estado de la reparacion?'),
                                              content: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        backgroundColor: Colors.blue),
                                                    child: const Text('Sí'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        backgroundColor: Colors.black),
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                      ),
                                      child: const Text('Finalizar')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                        .toList(),
                  ],
                ),
              ); }
          }
      ),
    );
  }
}
