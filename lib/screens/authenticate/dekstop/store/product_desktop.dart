import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';

class ProductDesktop extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDesktop({super.key, required this.product});

  @override
  State<ProductDesktop> createState() => ProductDesktopState();
}

class ProductDesktopState extends State<ProductDesktop> {
  int _selectedColorIndex = 0;
  int _selectedImageIndex = 0;
  int _modelSelect = 0;

  late Map<String, dynamic> productView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productView = widget.product;
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 600,
      width: 750,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable:
          Provider.of<ConnectionDatesBlocs>(context).products,
          builder: (context, value, child) {

            productView = value.firstWhere((producto) => producto['product_id'] == widget.product['product_id']);

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back,color: Colors.black87, size: 25,)),
                      Text(productView['name'],
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 50,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                      ),
                    ],
                  ),
                  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: SizedBox(
                                    height: 300,
                                    child: Image.network(
                                      productView['mdcp'][_modelSelect]['colors'][_selectedColorIndex]['photos'][_selectedImageIndex]['url'],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0; i < productView['mdcp'][_modelSelect]['colors'][_selectedColorIndex]['photos'].length; i++)
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                            height: 15,
                                            width: 15,
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Elegie un color',
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
                                      height: 30,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productView['mdcp']?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _modelSelect = index;
                                                });
                                              },
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                                  child: Text(productView['mdcp'][index]['model']),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
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
                                      height: 30,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productView['mdcp'][_modelSelect]['colors']?.length ?? 0,
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
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Color(productView['mdcp'][_modelSelect]['colors'][index]['color']),
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
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, top: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(productView['description'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                if (productView['promotion'] == null) ...[
                                  // Muestra solo el precio normal
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5, left: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        NumberFormat.simpleCurrency(locale: 'en-CLP', decimalDigits: 0)
                                            .format(productView['price_unit']),
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
                                            .format(productView['price_unit']),
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
                                      0).format(productView['promotion']),
                                        style:
                                        const TextStyle(color: Colors.white, fontSize: 50, fontWeight:
                                        FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}

