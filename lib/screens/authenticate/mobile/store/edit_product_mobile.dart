import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';

class EditProductMobile extends StatefulWidget {
  final Map<String, dynamic> producto;

  const EditProductMobile({Key? key, required this.producto}) : super(key: key);

  @override
  EditProductMobileState createState() => EditProductMobileState();
}

class EditProductMobileState extends State<EditProductMobile> {

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _promocionController = TextEditingController();

  int? _categoriaSeleccionada;
  List<Map<String, dynamic>> _colores = [];

  bool _isLoading = false;

  late Map<String, dynamic> productView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productView = widget.producto;
  }


  void _seleccionarFoto(int colorIndex) async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    for (final pickedFile in pickedFiles) {
      final localFile = File(pickedFile.path);
      setState(() {
        _colores[colorIndex]['fotos'].add(localFile);
      });
    }
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable:
          Provider.of<ConnectionDatesBlocs>(context).categories,
          builder: (context, value, child) {
            final categorias = value.firstWhere((categoria) => categoria['id'] == widget.producto['id_categoria']);

            final categoria = categorias['nombre'];

            return Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text(
                          'Categoría seleccionada',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '$categoria',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable:
                  Provider.of<ConnectionDatesBlocs>(context).products,
                  builder: (context, value, child) {

                  productView = value.firstWhere((producto) => producto['id'] == widget.producto['id']);

                  _nombreController.text = productView['nombre'];
                  _descripcionController.text = productView['descripcion'];
                  _precioController.text = productView['precio'].toString();
                  _promocionController.text = (productView['promocion'] ?? 'no hay promocion').toString();
                  _categoriaSeleccionada = productView['id_categoria'];
                  _colores = (productView['coloresconfotos'] as List<dynamic>)
                      .map((color) => Map<String, dynamic>.from(color))
                      .toList();

                  return Form(
                      key: _formKey,
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int colorIndex = 0; colorIndex < _colores.length; colorIndex++)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 180,
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only( bottom: 5),
                                                child: Text('eliminar \n producto',
                                                  textAlign: TextAlign.center,),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only( bottom: 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    // Actualiza coloresconfotos en la base de datos
                                                    var url = Uri.parse('http:$ipPort/delete_product_color_fotos');
                                                    var headers = {'Content-Type': 'application/json; charset=UTF-8'};
                                                    var body = jsonEncode({
                                                      'id': productView['id'],
                                                      'colorIndex': colorIndex,
                                                    });
                                                    http.patch(url, headers: headers, body: body);

                                                    List<dynamic> dynamicUrls = _colores[colorIndex]['fotos'];
                                                    for (var url in dynamicUrls) {
                                                      final storageRef = FirebaseStorage.instance.refFromURL(url);
                                                      await storageRef.delete();
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: const Icon(Icons.delete,size: 15,),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(top: 10,bottom: 5),
                                                child: Text('Agregar \n color',
                                                  textAlign: TextAlign.center,),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        content: SingleChildScrollView(
                                                          child: BlockPicker(
                                                            pickerColor: Colors.white,
                                                            onColorChanged: (color) {
                                                              setState(() {
                                                                _colores[colorIndex]['color'] = color.value;
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 15, left: 15),
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.grey),
                                                      color: Color(_colores[colorIndex]['color']),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for (int i = 0; i < _colores[colorIndex]['fotos'].length; i++)
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 15),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: _colores[colorIndex]['fotos'][i] is File
                                                              ? Image.file(
                                                            _colores[colorIndex]['fotos'][i],
                                                            height: 150,
                                                            width: 150,
                                                            fit: BoxFit.cover,
                                                          )
                                                              : Image.network(
                                                            _colores[colorIndex]['fotos'][i],
                                                            height: 150,
                                                            width: 150,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              final url = _colores[colorIndex]['fotos'][i];
                                                              final storageRef = FirebaseStorage.instance.refFromURL(url);
                                                              await storageRef.delete();
                                                              setState(() {
                                                                _colores[colorIndex]['fotos'].removeAt(i);
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[300],
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: const Icon(Icons.close, size: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                  height: 150,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () => _seleccionarFoto(colorIndex),
                                                    icon:
                                                    const Icon(Icons.add_photo_alternate, color: Color(0xff616161)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _colores.add({
                                              'color': Colors.white.value,
                                              'fotos': [],
                                            });
                                          });
                                        },
                                        icon:
                                        const Icon(Icons.add_photo_alternate, color: Color(0xff616161)),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text('Agregar producto',
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                                child: TextFormField(
                                  controller: _nombreController,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                                child: TextFormField(
                                  controller: _descripcionController,
                                  decoration: InputDecoration(
                                    labelText: 'Descripción',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                child: TextFormField(
                                  controller: _precioController,
                                  decoration: InputDecoration(
                                    labelText: 'Precio',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                child: TextFormField(
                                  controller: _promocionController,
                                  decoration: InputDecoration(
                                    labelText: 'Promocion',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          for (int colorIndex = 0; colorIndex < _colores.length; colorIndex++) {
                                            List<String> fotosUrls = [];
                                            for (int imageIndex = 0; imageIndex < _colores[colorIndex]['fotos'].length; imageIndex++) {
                                              var foto = _colores[colorIndex]['fotos'][imageIndex];
                                              if (foto is File) {
                                                final localFile = foto;
                                                final fileName = basename(localFile.path);
                                                String ruta = 'categorias';
                                                ruta += '/${productView['ruta']}/$fileName';
                                                final storageRef = FirebaseStorage.instance.ref().child(ruta);
                                                final uploadTask = storageRef.putFile(localFile);
                                                await uploadTask.whenComplete(() {});
                                                final downloadUrl = await storageRef.getDownloadURL();
                                                fotosUrls.add(downloadUrl);
                                              } else if (foto is String) {
                                                fotosUrls.add(foto);
                                              }
                                            }
                                            _colores[colorIndex]['fotos'] = fotosUrls;
                                          }
                                          var url = Uri.parse('http:$ipPort/update_product');

                                          var headers = {'Content-Type': 'application/json; charset=UTF-8'};

                                          var body = jsonEncode({
                                            'id': productView['id'],
                                            'nombre': _nombreController.text,
                                            'descripcion': _descripcionController.text,
                                            'precio': int.parse(_precioController.text),
                                            'promocion': int.parse(_promocionController.text),
                                            'categoria': _categoriaSeleccionada,
                                            'coloresConFotos': _colores,
                                          });

                                          if (_formKey.currentState!.validate()) {

                                            var response = await http.post(url, headers: headers, body: body);

                                            if (response.statusCode == 200) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                            else if (response.statusCode == 500) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    title: Center(child: Column(
                                                      children: [
                                                        Text(response.body),
                                                      ],
                                                    )),
                                                    actions: [
                                                      ElevatedButton(
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: Colors.blue,
                                                          backgroundColor: Colors.blue[100],
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Cerrar',
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Todos los campos son obligatorios'),
                                              ),
                                            );
                                          }
                                        },
                                        child: _isLoading ? const CircularProgressIndicator() : const Text('Actualizar'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                ),
                                                title: const Text('¿Seguro que quieres eliminar etse producto?'),
                                                content: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                                      child: const Text('Sí'),
                                                      onPressed: ()async {

                                                        for (int colorIndex = 0; colorIndex < _colores.length; colorIndex++) {
                                                          for (int i = 0; i < _colores[colorIndex]['fotos'].length; i++) {
                                                            final url = _colores[colorIndex]['fotos'][i];
                                                            final storageRef = FirebaseStorage.instance.refFromURL(url);
                                                            await storageRef.delete();
                                                          }
                                                        }

                                                        final response = await http.delete(
                                                          Uri.parse(
                                                              'http:$ipPort//192.168.1.106:5000/delete_product'),
                                                          body: {
                                                            'id': productView['id'].toString(),
                                                          },
                                                        );


                                                        if (response.statusCode == 200) {
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
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
                                                                    'Error al eliminar producto'),
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
                                        child: const Text('Eliminar'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                }
              ),
            ],
          );
        }
      ),
    );
  }
}
