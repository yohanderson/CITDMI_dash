import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';
import 'edit_product_tablet.dart';

class ProductTablet extends StatefulWidget {
  final Map<String, dynamic> producto;
  const ProductTablet({Key? key, required this.producto}) : super(key: key);

  @override
  State<ProductTablet> createState() => _ProductTabletState();
}

class _ProductTabletState extends State<ProductTablet> {
  int _selectedColorIndex = 0;
  int _selectedImageIndex = 0;

  late Map<String, dynamic> productView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productView = widget.producto;
  }


  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable:
        Provider.of<ConnectionDatesBlocs>(context).products,
        builder: (context, value, child) {

          productView = value.firstWhere((producto) => producto['id'] == widget.producto['id']);

          return Scaffold(
          body: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back,color: Colors.black87, size: 25,)),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProductTablet(producto: producto),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 50,
                        child: Text(productView['nombre'],
                        style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 50,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 130,
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 400,
                              child: Image.network(
                                productView['coloresconfotos'][_selectedColorIndex]['fotos'][_selectedImageIndex],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < productView['coloresconfotos'][_selectedColorIndex]['fotos'].length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedImageIndex = i;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color:
                                            i == _selectedImageIndex ? Colors.white : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                        child: Text(productView['descripcion'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        ),
                                    ),
                                  ),
                                  if (productView['promocion'] == null) ...[
                                    // Muestra solo el precio normal
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                              .format(productView['precio']),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ]
                                  else ...[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, top: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                              .format(productView['precio']),
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 25,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        Text(NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits:
                                        0).format(productView['promocion']),
                                          style:
                                          const TextStyle(color: Colors.white, fontSize: 50, fontWeight:
                                          FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20, top: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Elegir color',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                      ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productView['coloresconfotos']?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedColorIndex = index;
                                                    _selectedImageIndex = 0;
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Color(productView['coloresconfotos'][index]['color']),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

