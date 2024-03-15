import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';

class NewProductTablet extends StatefulWidget {
  const NewProductTablet({super.key});

  @override
  _NewProductTabletState createState() => _NewProductTabletState();
}

class _NewProductTabletState extends State<NewProductTablet> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _promocionController = TextEditingController();

  List<Map<String, dynamic>> _colores = [];
  bool _isLoading = false;

  final formKeyInputCategorie = GlobalKey<FormState>();
  final List<int?> stack = [null];


  final int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
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
            final categories = value
                .where((categoria) => categoria['id_padre'] == stack.last)
                .toList();

            var categoriaSeleccionada = value.firstWhere(
              (categoria) => categoria['id'] == stack.last,
              orElse: () => {'nombre': 'Ninguno'},
            );

            String buscarNombrePorId(
                int id, List<Map<String, dynamic>> categories) {
              var categoria =
                  categories.firstWhere((categoria) => categoria['id'] == id);
              return categoria['nombre'];
            }



            return PageView(
              controller: _pageController,
              children: <Widget>[
                Stack(
                  children: [
                    Column(
                      children: [
                        if (stack.last == null) ...[
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
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Elige categoria',
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final TextEditingController categorieInput =
                                      TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Crear nueva categoría'),
                                        content: SizedBox(
                                          height: 60,
                                          width: 200,
                                          child: Form(
                                            key: formKeyInputCategorie,
                                            child: TextFormField(
                                              controller: categorieInput,
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Nombre de la categoría',
                                              ),
                                              inputFormatters: [
                                                MyCustomFormatter()
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Por favor, introduce el nombre de la categoría';
                                                } else if (categories.any(
                                                    (categoria) =>
                                                        categoria['nombre']
                                                                .toLowerCase() ==
                                                            value
                                                                .toLowerCase() &&
                                                        categoria['id_padre'] ==
                                                            null)) {
                                                  return 'Esta categoría ya existe';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Enviar'),
                                            onPressed: () async {
                                              if (formKeyInputCategorie
                                                  .currentState!
                                                  .validate()) {
                                                final response =
                                                    await http.post(
                                                  Uri.parse(
                                                      'http:$ipPort/create_categorie'),
                                                  body: {
                                                    'categorie':
                                                        categorieInput.text
                                                  },
                                                );
                                                if (response.statusCode ==
                                                    200) {
                                                  print(
                                                      'Categoría creada con éxito');
                                                } else {
                                                  print(
                                                      'Error al crear la categoría');
                                                }
                                                Navigator.of(context).pop();
                                              } else {
                                                categorieInput.clear();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Agregar nueva categoría'),
                              )),
                        ] else ...[
                          const SizedBox(
                            height: 80,
                          ),
                          Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    setState(() {
                                      stack.removeLast();
                                    });
                                  },
                                ),
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Sub-categorías',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                final TextEditingController subCategorieInput =
                                    TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Crear nueva subcategoría'),
                                      content: SizedBox(
                                        height: 60,
                                        width: 200,
                                        child: Form(
                                          key: formKeyInputCategorie,
                                          child: TextFormField(
                                            controller: subCategorieInput,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Nombre de la subcategoría',
                                            ),
                                            inputFormatters: [
                                              MyCustomFormatter()
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Por favor, introduce el nombre de la subcategoría';
                                              } else if (categories.any(
                                                  (subcategoria) =>
                                                      subcategoria['nombre']
                                                              .toLowerCase() ==
                                                          value.toLowerCase() &&
                                                      subcategoria[
                                                              'id_padre'] ==
                                                          stack.last)) {
                                                return 'Esta subcategoría ya existe';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Enviar'),
                                          onPressed: () async {
                                            if (formKeyInputCategorie
                                                .currentState!
                                                .validate()) {
                                              final response = await http.post(
                                                Uri.parse(
                                                    'http:$ipPort:5000/create_categorie'),
                                                body: {
                                                  'categorie':
                                                      subCategorieInput.text,
                                                  'id_padre':
                                                      stack.last.toString(),
                                                },
                                              );
                                              if (response.statusCode == 200) {
                                                print(
                                                    'Subcategoría creada con éxito');
                                              } else {
                                                print(
                                                    'Error al crear la subcategoría');
                                              }
                                              Navigator.of(context).pop();
                                            } else {
                                              subCategorieInput.clear();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Agregar nueva subcategoría'),
                            ),
                          ),
                        ],
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                categories.isEmpty ? 1 : categories.length,
                            itemBuilder: (context, index) {
                              if (categories.isEmpty) {
                                return const Center(
                                    child: Text(
                                  'No hay categorias',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ));
                              } else {
                                return ListTile(
                                  title: Text(categories[index]['nombre']),
                                  onTap: () {
                                    setState(() {
                                      stack.add(categories[index]['id']);
                                      categoriaSeleccionada = categories[index];
                                    });
                                  },
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            title: const Text(
                                                '¿Seguro que quieres eliminar esta cita?'),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                  child: Text(
                                                    'Sí',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    final response =
                                                        await http.post(
                                                      Uri.parse(
                                                          'http:$ipPort/delete_categorie'),
                                                      body: {
                                                        'id': categories[index]
                                                                ['id']
                                                            .toString(),
                                                      },
                                                    );

                                                    if (response.statusCode ==
                                                        200) {
                                                      Navigator.pop(context);
                                                    } else {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                            title: const Text(
                                                                'Error al cambiar el estado'),
                                                            content: SizedBox(
                                                              width: 60,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.blue),
                                                                child:
                                                                    const Text(
                                                                  'ok',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black),
                                                  child: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
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
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        right: 20,
                        bottom: 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: stack.last == null
                                ? Colors.purple[100]
                                : Colors.purple[800],
                          ),
                          onPressed: () {
                            if (stack.last != null) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: const Text('Siguiente'),
                        ))
                  ],
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
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
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
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
                                      '${categoriaSeleccionada['nombre']}',
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
                        for (int colorIndex = 0;
                            colorIndex < _colores.length;
                            colorIndex++)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: SizedBox(
                                        height: 170,
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                'eliminar \n producto',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _colores.removeAt(colorIndex);
                                                  });
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 5),
                                              child: Text(
                                                'Agregar \n color',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                Color _color = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child: BlockPicker(
                                                          pickerColor: Colors.white,
                                                          onColorChanged: (color) {
                                                            setState(() {
                                                              _colores[colorIndex]
                                                                      ['color'] =
                                                                  color.value;
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
                                                padding: const EdgeInsets.only(
                                                    right: 15, left: 15),
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    color: Color(
                                                        _colores[colorIndex]
                                                            ['color']),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    for (int i = 0;
                                        i < _colores[colorIndex]['fotos'].length;
                                        i++)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.file(
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
                                                onTap: () {
                                                  setState(() {
                                                    _colores[colorIndex]['fotos']
                                                        .removeAt(i);
                                                  });
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 15,
                                                  ),
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
                                        onPressed: () =>
                                            _seleccionarFoto(colorIndex),
                                        icon: const Icon(
                                            Icons.add_photo_alternate,
                                            color: Color(0xff616161)),
                                      ),
                                    ),
                                  ],
                                ),
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
                                  icon: const Icon(Icons.add_photo_alternate,
                                      color: Color(0xff616161)),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Agregar producto',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, right: 15),
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
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, right: 15),
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: _isLoading ? null : () async {

                              setState(() {
                                _isLoading = true;
                              });

                              String rutaOne = '';

                              for (int colorIndex = 0; colorIndex < _colores.length; colorIndex++) {
                                List<String> fotosUrls = [];
                                for (int imageIndex = 0; imageIndex < _colores[colorIndex]['fotos'].length; imageIndex++) {
                                  final localFile = _colores[colorIndex]['fotos'][imageIndex];
                                  final fileName = basename(localFile.path);
                                  String ruta = 'categorias';
                                  for (int? id in stack) {
                                    if (id != null) {
                                      ruta += '/${buscarNombrePorId(id, value)}';
                                    }
                                  }
                                  rutaOne = '$ruta/${_nombreController.text}';
                                  ruta += '/${_nombreController.text}/$fileName';
                                  final storageRef = FirebaseStorage.instance.ref().child(ruta);
                                  final uploadTask = storageRef.putFile(localFile);
                                  await uploadTask.whenComplete(() {});
                                  final downloadUrl = await storageRef.getDownloadURL();
                                  fotosUrls.add(downloadUrl);
                                }
                                _colores[colorIndex]['fotos'] = fotosUrls;
                              }

                              var url = Uri.parse('http:$ipPort/create_product');

                              var headers = {
                                'Content-Type':
                                    'application/json; charset=UTF-8'
                              };


                              var body = jsonEncode({
                                'nombre': _nombreController.text,
                                'descripcion': _descripcionController.text,
                                'precio': int.parse(_precioController.text),
                                'promocion': _promocionController.text,
                                'categoria': categoriaSeleccionada['id'],
                                'ruta': rutaOne.toString(),
                                'coloresConFotos': _colores,
                              });

                              if (_formKey.currentState!.validate()) {
                                var response = await http.post(url,
                                    headers: headers, body: body);

                                if (response.statusCode == 200) {
                                  _nombreController.clear();
                                  _descripcionController.clear();
                                  _precioController.clear();
                                  _promocionController.clear();
                                  setState(() {
                                    _colores.clear();
                                    _isLoading = false;
                                  });
                                } else if (response.statusCode == 500)
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        title: Center(
                                            child: Column(
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cerrar',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Todos los campos son obligatorios'),
                                  ),
                                );
                              }
                            },
                            child:_isLoading ? const CircularProgressIndicator() : const Text('Crear'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class MyCustomFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    String newText = newValue.text;
    newText = newText[0].toUpperCase() + newText.substring(1);
    newText = newText.replaceAll(RegExp('[^a-zA-ZáéíóúÁÉÍÓÚ]'), '');
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
