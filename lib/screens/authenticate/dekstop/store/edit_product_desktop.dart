import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';
import '../structure/snack_bar_messange.dart';
import '../structure/text_formating.dart';

class EditProductDesktop extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductDesktop({super.key, required this.product});

  @override
  EditProductDesktopState createState() => EditProductDesktopState();
}

class EditProductDesktopState extends State<EditProductDesktop> {
  SnackBarMessaging snackBarMessaging = SnackBarMessaging();

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final formKeyInputCategorie = GlobalKey<FormState>();
  final formKeyInputModel = GlobalKey<FormState>();
  final formKeyInputBrand = GlobalKey<FormState>();

  final name = TextEditingController();
  final description = TextEditingController();
  final priceUnit = TextEditingController();
  final priceWholesale = TextEditingController();
  final priceCost = TextEditingController();
  final promotion = TextEditingController();
  final discount = TextEditingController();
  final offer = TextEditingController();
  final quantity = TextEditingController();
  final supplier = TextEditingController();
  final brandInput = TextEditingController();
  int? brandSelect;
  var brandName = '';
  final timeAcquisition = TextEditingController();
  final iva = TextEditingController();

  int? categorieSelect;
  List<Map<String, dynamic>> mdcpInitial = [];
  List<Map<String, dynamic>> mdcp = [];

  final model = TextEditingController();

  late Map<String, dynamic> productView;

  late List<TextEditingController> height;
  late List<TextEditingController> width;
  late List<TextEditingController> depth;
  late List<TextEditingController> weight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productView = widget.product;
    name.text = productView['name'];
    description.text = productView['description'];
    priceUnit.text = productView['price_unit'].toString();
    priceWholesale.text = (productView['price_wholesale'] ?? '').toString();
    priceCost.text = productView['price_cost'].toString();
    promotion.text = (productView['promotion'] ?? '');
    discount.text = (productView['discount'] ?? '').toString();
    offer.text = (productView['offer'] ?? '').toString();
    quantity.text = productView['quantity'].toString();
    supplier.text = productView['supplier'];
    brandSelect = productView['id_brand'];
    categorieSelect = productView['id_categorie_product'];
    // timeAcquisition.text = ;
    iva.text = productView['iva'].toString();
    mdcpInitial = List<Map<String, dynamic>>.from(
        productView['mdcp'].map((item) => item as Map<String, dynamic>));
    String jsonColorWithPhoto = jsonEncode(mdcpInitial);
    mdcp = List<Map<String, dynamic>>.from(jsonDecode(jsonColorWithPhoto)
        .map((item) => item as Map<String, dynamic>));

    height = [];
    width = [];
    depth = [];
    weight = [];

    // Primero, agregamos los TextEditingController a las listas
    for (int i = 0; i < mdcp.length; i++) {
      height.add(TextEditingController());
      width.add(TextEditingController());
      depth.add(TextEditingController());
      weight.add(TextEditingController());
    }

    for (int i = 0; i < mdcp.length; i++) {
      height[i].text = mdcp[i]['dimensions']['height'];
      width[i].text = mdcp[i]['dimensions']['width'];
      depth[i].text = mdcp[i]['dimensions']['depth'];
      weight[i].text = mdcp[i]['dimensions']['weight'];
    }
  }

  @override
  Widget build(BuildContext context) {
    void selectPhoto(int colorIndex, int modelIndex) async {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
      for (final pickedFile in pickedFiles) {
        final Uint8List bytes = await pickedFile.readAsBytes();

        // Verificar si los primeros 4 bytes corresponden a la cabecera de un archivo PNG
        if (bytes.length < 4 ||
            bytes[0] != 0x89 ||
            bytes[1] != 0x50 ||
            bytes[2] != 0x4E ||
            bytes[3] != 0x47) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Formato de archivo no válido'),
                content: const Text(
                    'Por favor, selecciona solo imágenes en formato PNG.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            mdcp[modelIndex]['colors'][colorIndex]['photos'].add({
              'bytes': bytes,
              'name': basename(pickedFile.path),
              'type': 'memory',
            });
          });
        }
      }
    }

    return SizedBox(
      height: 600,
      width: 600,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable:
              Provider.of<ConnectionDatesBlocs>(context).categories,
          builder: (context, value, child) {
            final categories = value.firstWhere((categorie) =>
                categorie['id_categorie'] ==
                widget.product['id_categoria_product']);

            final categorie = categories['name'];

            return Column(
              children: [
                const SizedBox(
                  height: 20,
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
                              '$categorie',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Form(
                  key: formKey,
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int modelIndex = 0;
                              modelIndex < mdcp.length;
                              modelIndex++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            mdcp.removeAt(modelIndex);
                                          });
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, right: 5),
                                        child: Text(
                                          'Modelo: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(
                                        mdcp[modelIndex]['model'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 600,
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 15),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            controller: height[modelIndex],
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              labelText: 'Altura',
                                              suffixText: 'H',
                                              suffixStyle: const TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 15),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            controller: width[modelIndex],
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              labelText: 'Ancho',
                                              suffixText: 'W',
                                              suffixStyle: const TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 15),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            controller: depth[modelIndex],
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              labelText: 'Profundida',
                                              suffixText: 'D',
                                              suffixStyle: const TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 15),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*')),
                                            ],
                                            controller: weight[modelIndex],
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              labelText: 'Peso',
                                              suffixText: 'Kg',
                                              suffixStyle: const TextStyle(
                                                  color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // dimensiones
                                for (int colorIndex = 0;
                                    colorIndex <
                                        mdcp[modelIndex]['colors'].length;
                                    colorIndex++)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: SizedBox(
                                                height: 170,
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 5),
                                                      child: Text(
                                                        'eliminar \n producto',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            mdcp[modelIndex]
                                                                    ['colors']
                                                                .removeAt(
                                                                    colorIndex);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[300],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
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
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              content:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    BlockPicker(
                                                                  pickerColor:
                                                                      Colors
                                                                          .white,
                                                                  onColorChanged:
                                                                      (color) {
                                                                    setState(
                                                                        () {
                                                                      mdcp[modelIndex]['colors'][colorIndex]
                                                                              [
                                                                              'color'] =
                                                                          color
                                                                              .value;
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15,
                                                                left: 15),
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                            color: Color(mdcp[
                                                                            modelIndex]
                                                                        [
                                                                        'colors']
                                                                    [colorIndex]
                                                                ['color']),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            for (int photoIndex = 0;
                                                photoIndex <
                                                    mdcp[modelIndex]['colors']
                                                                [colorIndex]
                                                            ['photos']
                                                        .length;
                                                photoIndex++)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: mdcp[modelIndex]['colors']
                                                                          [
                                                                          colorIndex]
                                                                      ['photos']
                                                                  [
                                                                  photoIndex]['type'] ==
                                                              'memory'
                                                          ? Image.memory(
                                                              mdcp[modelIndex][
                                                                              'colors']
                                                                          [
                                                                          colorIndex]
                                                                      ['photos']
                                                                  [
                                                                  photoIndex]['bytes'],
                                                              height: 150,
                                                              width: 150,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              mdcp[modelIndex][
                                                                              'colors']
                                                                          [
                                                                          colorIndex]
                                                                      ['photos']
                                                                  [
                                                                  photoIndex]['url'],
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
                                                            mdcp[modelIndex][
                                                                            'colors']
                                                                        [
                                                                        colorIndex]
                                                                    ['photos']
                                                                .removeAt(
                                                                    photoIndex);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[300],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: IconButton(
                                                onPressed: () => selectPhoto(
                                                    colorIndex, modelIndex),
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
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 10),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              mdcp[modelIndex]['colors'].add({
                                                'color': Colors.white.value,
                                                'photos': []
                                              });
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.add_photo_alternate,
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
                              ],
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Crea un nuevo modelo'),
                                        content: SizedBox(
                                          height: 60,
                                          width: 200,
                                          child: Form(
                                            key: formKeyInputModel,
                                            child: TextFormField(
                                              inputFormatters: [
                                                CapitalizeFirstLetterTextFormatter()
                                              ],
                                              controller: model,
                                              decoration: InputDecoration(
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                labelText: 'Modelo',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Este campo es obligatorio';
                                                } else if (mdcp.any((map) =>
                                                    map['model']
                                                        .trim()
                                                        .toLowerCase() ==
                                                    value
                                                        .trim()
                                                        .toLowerCase())) {
                                                  return 'El modelo ya existe en la lista';
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
                                            child: const Text('Agregar'),
                                            onPressed: () async {
                                              if (formKeyInputModel
                                                  .currentState!
                                                  .validate()) {
                                                setState(() {
                                                  mdcp.add({
                                                    'model': model.text,
                                                    'dimensions': {
                                                      'height': '',
                                                      'width': '',
                                                      'depth': '',
                                                      'weight': ''
                                                    },
                                                    'colors': [
                                                      {
                                                        'color':
                                                            Colors.white.value,
                                                        'photos': []
                                                      }
                                                    ]
                                                  });

                                                  height.add(
                                                      TextEditingController());
                                                  width.add(
                                                      TextEditingController());
                                                  depth.add(
                                                      TextEditingController());
                                                  weight.add(
                                                      TextEditingController());

                                                  model.clear();
                                                  Navigator.pop(context);
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: mdcp.isEmpty
                                    ? Text('Agregar modelo')
                                    : Text('Agregar Nuevo modelo'),
                              ),
                            ),
                          ), // boton agregar
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, right: 15),
                            child: TextFormField(
                              inputFormatters: [
                                CapitalizeFirstLetterTextFormatter()
                              ],
                              controller: name,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Nombre',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Debes agregar un nombre';
                                }
                                return null;
                              },
                            ),
                          ), // nombre
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, right: 15),
                            child: TextFormField(
                              inputFormatters: [
                                CapitalizeFirstLetterTextFormatter()
                              ],
                              controller: description,
                              decoration: InputDecoration(
                                labelText: 'Descripción',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Necesita agregar una descripcion';
                                }
                                return null;
                              },
                              minLines: 5,
                              maxLines: null,
                            ),
                          ), // descripcion
                          SizedBox(
                            width: 600,
                            height: 80,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      controller: priceUnit,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Precio unitario',
                                        suffixText: '\$',
                                        suffixStyle: const TextStyle(
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Desbes agregar un precio por unidad';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ), // precio unitario
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        controller: priceWholesale,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'precio al mayor',
                                          suffixText: '\$',
                                          suffixStyle: const TextStyle(
                                              color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null; // No hay error si el valor está vacío
                                          } else if (double.parse(value) >
                                              double.parse(priceUnit.text)) {
                                            return 'Debes agregar un precio por unidad menor o igual al precio unitario';
                                          }
                                          return null;
                                        }),
                                  ),
                                ), // precio al mayor
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        controller: priceCost,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'Costo del producto',
                                          suffixText: '\$',
                                          suffixStyle: const TextStyle(
                                              color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null; // No hay error si el valor está vacío
                                          } else if ((priceUnit
                                                      .text.isNotEmpty &&
                                                  double.parse(value) >
                                                      double.parse(
                                                          priceUnit.text)) ||
                                              (priceWholesale.text.isNotEmpty &&
                                                  double.parse(value) >
                                                      double.parse(
                                                          priceWholesale
                                                              .text))) {
                                            return 'Debes agregar un precio por unidad menor al precio unitario y menor al precio al por mayor';
                                          }
                                          return null;
                                        }),
                                  ),
                                ), // costo producto
                              ],
                            ),
                          ), // precios
                          SizedBox(
                            width: 600,
                            height: 80,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: quantity,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Cantidad de productos',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Desbes agregar la cantidad de productos';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ), // cantidad de producto
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      controller: discount,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'descuento',
                                        suffixText: '%',
                                        suffixStyle: const TextStyle(
                                            color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isNotEmpty &&
                                            double.parse(value) > 100) {
                                          return 'El descuento no puede ser mayor al 100%';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ), // descuento
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        controller: offer,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'Oferta',
                                          suffixText: '\$',
                                          suffixStyle: const TextStyle(
                                              color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null; // No hay error si el valor está vacío
                                          } else if (double.parse(value) >
                                              double.parse(priceUnit.text)) {
                                            return 'Debes agregar un precio por unidad menor o igual al precio unitario';
                                          }
                                          return null;
                                        }),
                                  ),
                                ), // oferta
                              ],
                            ),
                          ), // rebajas
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              inputFormatters: [
                                CapitalizeFirstLetterTextFormatter()
                              ],
                              controller: promotion,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Promocion',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ), // promocion
                          SizedBox(
                            width: 600,
                            height: 240,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 15, right: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.deepPurple,
                                            width: 1,
                                          )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ValueListenableBuilder<
                                              List<Map<String, dynamic>>>(
                                            valueListenable: Provider.of<
                                                        ConnectionDatesBlocs>(
                                                    context)
                                                .brands,
                                            builder: (context, value, child) {
                                              final brands = value;

                                              Widget widget = Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Container(
                                                  height: 40,
                                                  width: double.infinity,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Colors.deepPurple,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        child: Text(
                                                          'Marcas',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 8),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Crear nueva marca'),
                                                                  content:
                                                                      SizedBox(
                                                                    height: 60,
                                                                    width: 200,
                                                                    child: Form(
                                                                      key:
                                                                          formKeyInputBrand,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            brandInput,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          labelText:
                                                                              'Nombre de la marca',
                                                                        ),
                                                                        inputFormatters: [
                                                                          MyCustomFormatter()
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return 'Por favor, introduce el nombre de la marca';
                                                                          } else if (brands.any((brand) =>
                                                                              brand['name'].toLowerCase() ==
                                                                              value.toLowerCase())) {
                                                                            return 'Esta marca ya existe';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Cancelar'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Enviar'),
                                                                      onPressed:
                                                                          () async {
                                                                        if (formKeyInputBrand
                                                                            .currentState!
                                                                            .validate()) {
                                                                          final response =
                                                                              await http.post(
                                                                            Uri.parse('http:$ipPort/created_brand'),
                                                                            body: {
                                                                              'brand': brandInput.text
                                                                            },
                                                                          );
                                                                          if (response.statusCode ==
                                                                              200) {
                                                                            print('marca creada con éxito');
                                                                          } else {
                                                                            print('Error al crear la marca');
                                                                          }
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        } else {
                                                                          brandInput
                                                                              .clear();
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Text(
                                                                  'Agregar marca'),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3),
                                                                child: Icon(Icons
                                                                    .add_circle_outline),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );

                                              if (value.isEmpty) {
                                                return Column(
                                                  children: [
                                                    widget,
                                                    const Center(
                                                      child: Text(
                                                          'No hay marcas disponibles'),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  children: [
                                                    widget,
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                bottom: 5),
                                                        child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                brandSelect =
                                                                    null;
                                                              });
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.05),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3)),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            15),
                                                                child: Text(
                                                                    'Ninguno'),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 110,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            brands.length,
                                                        itemBuilder: (context,
                                                            int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        setState(
                                                                            () {
                                                                          brandSelect =
                                                                              brands[index]['id_brand'];
                                                                          brandName = brands[index]['name'];
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Theme.of(context).primaryColor.withOpacity(0.05),
                                                                            borderRadius: BorderRadius.circular(3)),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 5,
                                                                              horizontal: 15),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(brands[index]['name'].toString()),
                                                                              brandSelect == brands[index]['id_brand']
                                                                                  ? const Padding(
                                                                                      padding: EdgeInsets.only(left: 5),
                                                                                      child: Icon(
                                                                                        Icons.check_circle,
                                                                                        color: Colors.green,
                                                                                        size: 18,
                                                                                      ),
                                                                                    )
                                                                                  : const SizedBox(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      IconButton(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 18,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            shape:
                                                                                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                            title:
                                                                                const Text('¿Seguro que quieres eliminar esta marca?'),
                                                                            content:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                                                                  child: const Text(
                                                                                    'Sí',
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    final response = await http.post(
                                                                                      Uri.parse('http:$ipPort/delete_brand'),
                                                                                      body: {
                                                                                        'id_brand': brands[index]['id_brand'].toString()
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
                                                                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                                            title: const Text('Error al eliminar marca'),
                                                                                            content: SizedBox(
                                                                                              width: 60,
                                                                                              child: ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                                                                                child: const Text(
                                                                                                  'ok',
                                                                                                  style: TextStyle(color: Colors.white),
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
                                                                                  child: const Text(
                                                                                    'No',
                                                                                    style: TextStyle(color: Colors.white),
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
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ), // marca
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        child: TextFormField(
                                          inputFormatters: [
                                            CapitalizeFirstLetterTextFormatter()
                                          ],
                                          controller: supplier,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText: 'Proveedor',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Desbes agregar un proveedor';
                                            }
                                            return null;
                                          },
                                        ),
                                      ), // proveedor
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 15),
                                        child: TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*')),
                                          ],
                                          controller: iva,
                                          decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              labelText: 'Iva',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              suffixText: '%',
                                              suffixStyle: const TextStyle(
                                                  color: Colors.black)),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ), // iva
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 10),
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            // elimina datos no deseados o vacios

                                            // Itera sobre mdcp de atrás hacia adelante
                                            for (int modelIndex = mdcp.length - 1; modelIndex >= 0; modelIndex--) {
                                              // Itera sobre los colores de atrás hacia adelante
                                              for (int colorIndex = mdcp[modelIndex]['colors'].length - 1; colorIndex >= 0; colorIndex--) {
                                                // Si no hay fotos, elimina el índice de colors
                                                if (mdcp[modelIndex]['colors'][colorIndex]['photos'].isEmpty) {
                                                  mdcp[modelIndex]['colors'].removeAt(colorIndex);
                                                }
                                              }
                                              // Si no hay colores, elimina el índice de mdcp
                                              if (mdcp[modelIndex]['colors'].isEmpty) {
                                                mdcp.removeAt(modelIndex);
                                              }
                                            }


                                            // Obtiene las URLs iniciales
                                            List<String> initialUrls = [];
                                            for (int modelIndex = 0; modelIndex <  mdcpInitial.length; modelIndex++) {
                                              for (int colorIndex = 0; colorIndex <  mdcpInitial[modelIndex]['colors'].length; colorIndex++) {
                                                for (int photoIndex = 0; photoIndex <  mdcpInitial[modelIndex]['colors'][colorIndex]['photos'].length; photoIndex++) {
                                                  Map<String, dynamic> photo =  mdcpInitial[modelIndex]['colors'][colorIndex]['photos'][photoIndex];
                                                  if (photo['type'] == 'url') {
                                                    initialUrls.add(photo['url']);
                                                  }
                                                }
                                              }
                                            }


                                      // Obtiene las nuevas URLs
                                      List<String> newUrls = [];
                                      for (int modelIndex = 0; modelIndex < mdcp.length; modelIndex++) {
                                        for (int colorIndex = 0; colorIndex < mdcp[modelIndex]['colors'].length; colorIndex++) {
                                          for (int photoIndex = 0; photoIndex < mdcp[modelIndex]['colors'][colorIndex]['photos'].length; photoIndex++) {
                                            Map<String, dynamic> photo = mdcp[modelIndex]['colors'][colorIndex]['photos'][photoIndex];
                                            if (photo['type'] == 'url') {
                                              newUrls.add(photo['url']);
                                            }
                                          }
                                        }
                                      }

                                      // Borra las fotos en Firebase que no están en la nueva lista
                                      for (var url in initialUrls) {
                                        if (!newUrls.contains(url)) {
                                          final storageRef = FirebaseStorage.instance.refFromURL(url);
                                          await storageRef.delete();
                                        }
                                      }

                                      String route = '';

                                            // subir fotos a firebase y agregar datos a la lista
                                            for (int modelIndex = 0; modelIndex < mdcp.length; modelIndex++) {
                                              mdcp[modelIndex]['dimensions']['height'] = height[modelIndex].text;
                                              mdcp[modelIndex]['dimensions']['width'] = width[modelIndex].text;
                                              mdcp[modelIndex]['dimensions']['depth'] = depth[modelIndex].text;
                                              mdcp[modelIndex]['dimensions']['weight'] = weight[modelIndex].text;

                                              for (int colorIndex = 0; colorIndex < mdcp[modelIndex]['colors'].length; colorIndex++)  {
                                                for (int photoIndex = 0; photoIndex < mdcp[modelIndex]['colors'][colorIndex]['photos'].length; photoIndex++) {
                                                  var photo = mdcp[modelIndex]['colors'][colorIndex]['photos'][photoIndex];
                                                  if (photo['type'] == 'memory') {
                                                    final bytes = photo['bytes'];
                                                    final fileName = photo['name'];
                                                    route += '/${productView['route']}/$fileName';
                                                    final storageRef = FirebaseStorage.instance.ref().child(route);
                                                    final uploadTask = storageRef.putData(bytes);
                                                    await uploadTask.whenComplete(() {});
                                                    final downloadUrl = await storageRef.getDownloadURL();
                                                    mdcp[modelIndex]['colors'][colorIndex]['photos'][photoIndex] = {
                                                      'url': downloadUrl,
                                                      'type': 'url',
                                                    };
                                                  }
                                                }
                                              }
                                            }


                                            var url = Uri.parse(
                                                'http:$ipPort/update_product');
                                            var headers = {
                                              'Content-Type':
                                                  'application/json; charset=UTF-8'
                                            };
                                            var body = jsonEncode({
                                              'product_id': productView['product_id'],
                                              'name': name.text,
                                              'description': description.text,
                                              'price_unit': priceUnit.text,
                                              'price_wholesale':  priceWholesale.text.isEmpty ? null : priceWholesale.text,
                                              'price_cost': priceCost.text,
                                              'promotion': promotion.text.isEmpty ? null : promotion.text ,
                                              'discount': discount.text.isEmpty ? null : discount.text,
                                              'offer': offer.text.isEmpty ? null : offer.text,
                                              'quantity': quantity.text,
                                              'supplier': supplier.text,
                                              'brand': brandName,
                                              'iva': iva.text,
                                              'mdcp': mdcp,
                                            });

                                            if (formKey.currentState!
                                                .validate()) {
                                              var response = await http.post(
                                                  url,
                                                  headers: headers,
                                                  body: body);
                                              if (response.statusCode == 200) {
                                                snackBarMessaging.showOverlay(context, 'Producto actualizado con exito', Colors.green);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              } else if (response.statusCode ==
                                                  500) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      title: Center(
                                                          child: Column(
                                                        children: [
                                                          Text(response.body),
                                                        ],
                                                      )),
                                                      actions: [
                                                        ElevatedButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.blue,
                                                            backgroundColor:
                                                                Colors
                                                                    .blue[100],
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Cerrar',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            } else {
                                              snackBarMessaging.showOverlay(context, 'Todos los campos son obligatorios', Colors.red);
                                            }
                                          },
                                    child: isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text('Actualizar'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 10),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            title: const Text(
                                                '¿Seguro que quieres eliminar este producto?'),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                  child: const Text('Sí'),
                                                  onPressed: () async {
                                                    for (int modelIndex = 0;
                                                        modelIndex <
                                                            mdcp.length;
                                                        modelIndex++) {
                                                      for (int colorIndex = 0;
                                                          colorIndex <
                                                              mdcp[modelIndex]
                                                                      ['colors']
                                                                  .length;
                                                          colorIndex++) {
                                                        for (int photoIndex = 0;
                                                            photoIndex <
                                                                mdcp[modelIndex]['colors']
                                                                            [
                                                                            colorIndex]
                                                                        [
                                                                        'photos']
                                                                    .length;
                                                            photoIndex++) {
                                                          final url = mdcp[modelIndex]
                                                                          [
                                                                          'colors']
                                                                      [
                                                                      colorIndex]
                                                                  ['photos'][
                                                              photoIndex]['url'];
                                                          final storageRef =
                                                              FirebaseStorage
                                                                  .instance
                                                                  .refFromURL(
                                                                      url);
                                                          await storageRef
                                                              .delete();
                                                        }
                                                      }
                                                    }

                                                    final response =
                                                        await http.delete(
                                                      Uri.parse(
                                                          'http:$ipPort/delete_product'),
                                                      body: {
                                                        'product_id':
                                                            productView[
                                                                    'product_id']
                                                                .toString(),
                                                      },
                                                    );

                                                    if (response.statusCode ==
                                                        200) {
                                                      Navigator.pop(context);
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
                                                                'Error al eliminar producto'),
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
                ),
              ],
            );
          }),
    );
  }
}
