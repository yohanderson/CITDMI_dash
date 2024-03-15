import 'package:web_dash/screens/authenticate/dekstop/store/orders/orders_desktop.dart';
import 'package:web_dash/screens/authenticate/mobile/store/product_mobile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';
import 'new_product_mobile.dart';
import 'orders/orders_mobile.dart';

class ShopMobileView extends StatefulWidget {
  const ShopMobileView({super.key});

  @override
  State<ShopMobileView> createState() => ShopMobileViewState();
}

class ShopMobileViewState extends State<ShopMobileView> {
  int? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    categoriaSeleccionada = null;
  }

  bool MenuCategories = false;

  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewProductMobile(),
                  ),
                );
              },
              child: Container(
                width: 150,
                height: 50,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.add,
                      ),
                      Text(
                        'Agregar Producto',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersDesktop(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications))
          ],
        ),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: Provider.of<ConnectionDatesBlocs>(context).categories,
            builder: (context, value, child) {

              final categorias = value;

              Widget _menuCategories() {
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
                            categoriaSeleccionada = null;
                            MenuCategories = false;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text('Todo'),
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (final categoria in categorias)
                              if (categoria['id_padre'] == null)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      categoriaSeleccionada = categoria['id'];
                                      print(categoria['id']);
                                      MenuCategories = false;
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
                                            categoria['nombre'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          ]),
                    ],
                  ),
                );
              }

              if (value.isEmpty) {
                return const Column(
                  children: [
                    SizedBox(
                      height: 300,
                    ),
                    Center(
                      child: Text('No hay productos disponibles',
                      style: TextStyle(
                        fontSize: 25,
                      ),),
                    ),
                  ],
                );
              }
              else {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 10, bottom: 30, top: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (MenuCategories == false) {
                                      MenuCategories = true;
                                    } else {
                                      MenuCategories = false;
                                    }
                                  });
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Categorias',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<List<Map<String, dynamic>>>(
                          valueListenable:
                          Provider.of<ConnectionDatesBlocs>(context).products,
                          builder: (context, value, child) {

                            if (value.isEmpty) {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                  ),
                                  Center(
                                    child: Text(
                                      'No hay productos disponibles',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              final productos = value;
                              return Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Wrap(
                                        spacing: 25,
                                        runSpacing: 25,
                                        children: [
                                          for (final producto in productos) ...[
                                            if (categoriaSeleccionada == null ||
                                                producto['id_categoria'] ==
                                                    categoriaSeleccionada)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15)),
                                                height: 200,
                                                width: 150,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProductMobile(
                                                          producto: producto,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: 130,
                                                            decoration:
                                                            const BoxDecoration(
                                                              color: Colors.black45,
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(
                                                                    15),
                                                                topRight:
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 70,
                                                            decoration:
                                                            const BoxDecoration(
                                                              color: Colors.black87,
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                                bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 40,
                                                          ),
                                                          Center(
                                                            child: SizedBox(
                                                              height: 90,
                                                              width: 120,
                                                              child: Align(
                                                                alignment:
                                                                Alignment.center,
                                                                child: Image.network(
                                                                  producto[
                                                                  'coloresconfotos']
                                                                  [0]['fotos'][0],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 15,
                                                                    left: 5,
                                                                    right: 40),
                                                                child: Text(
                                                                  producto['nombre'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5,
                                                                    left: 5),
                                                                child: Text(
                                                                  NumberFormat.simpleCurrency(
                                                                      locale:
                                                                      'en-CLP',
                                                                      decimalDigits:
                                                                      0)
                                                                      .format(producto[
                                                                  'precio']),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 18,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ]
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      top: 115,
                      left: 10,
                      child: MenuCategories == true
                          ? Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 1.5,
                                  offset: Offset(0.2, 0.2))
                            ],
                          ),
                          child: _menuCategories())
                          : SizedBox(),
                    ),
                  ],
                );
              }
            }),
      ],
    );
  }
}
