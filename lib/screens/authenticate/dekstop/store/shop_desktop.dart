import 'package:web_dash/screens/authenticate/dekstop/store/edit_product_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/new_product_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/product_desktop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';
import 'menu_categories.dart';

class ShopDesktopView extends StatefulWidget {
  const ShopDesktopView({super.key});

  @override
  State<ShopDesktopView> createState() => _ShopDesktopViewState();
}

class _ShopDesktopViewState extends State<ShopDesktopView> {
  //section products list

  List<String> titleProducts = [
    'Fotos',
    'Producto',
    'Categoria',
    'Precio',
    'Cantidad',
    'Opciones'
  ];

  //menu
  int? categorySelected;

  @override
  void initState() {
    super.initState();
    categorySelected = null;
  }

  bool menuCategories = false;

  void updateCategorieSelected(int? newCategory, bool newState) {
    setState(() {
      categorySelected = newCategory;
      selectedCategoriesMenu = [null];
      menuCategories = newState;
    });
  }

  void selectedAllMenu() {
    setState(() {
      categorySelected = null;
      menuCategories = false;
    });
  }

  List<int?> selectedCategoriesMenu = [null];

  void updateSelectedCategoriesMenu(int? newCategory, int? parentCategory) {
    setState(() {
      int index = selectedCategoriesMenu.indexOf(parentCategory);
      if (index != -1) {
        // Si la categoría padre está en la lista, elimina todos los elementos a la derecha
        selectedCategoriesMenu = selectedCategoriesMenu.sublist(0, index + 1);
      }
      // Luego agrega la nueva categoría
      selectedCategoriesMenu.add(newCategory);
    });
  }

  void removeSelectedCategoriesMenu(int? newCategory) {
    setState(() {
      int? index = selectedCategoriesMenu.indexOf(newCategory);
      if (index != -1) {
        // Si el id está en la lista, elimina todos los elementos a la derecha
        selectedCategoriesMenu = selectedCategoriesMenu.sublist(0, index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 750,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            spreadRadius: 0.2,
            blurRadius: 20,
            offset: const Offset(10, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Productos',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  width: 190,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10),
                                ),
                                    content: const NewProductDesktop(),
                                  ));
                        },
                        child: Container(
                          height: 30,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient:  LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.onPrimary,
                                Theme.of(context).hintColor
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                                size: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  'Agregar producto',

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (menuCategories == false) {
                              menuCategories = true;
                            } else {
                              menuCategories = false;
                            }
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient:  LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).hintColor,
                                Theme.of(context).colorScheme.onPrimary
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable:
                    Provider.of<ConnectionDatesBlocs>(context).categories,
                builder: (context, categoriesValue, child) {
                  final categories = categoriesValue;
                  if(categoriesValue.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay productos disponible',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 0;
                                  i < titleProducts.length;
                                  i++) ...[
                                    SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: Text(
                                        titleProducts[i],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            ValueListenableBuilder<List<Map<String, dynamic>>>(
                              valueListenable:
                              Provider.of<ConnectionDatesBlocs>(context)
                                  .products,
                              builder: (context, value, child) {
                                final products = value;

                                if(value.isEmpty){
                                  return Expanded(
                                    child: Center(
                                      child: Text('Aun no se a agregado ningun producto',
                                        style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Expanded(
                                    child: ListView.builder(
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          final product = products[index];
                                          if (categorySelected == null || product['id_category_product'] == categorySelected) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    height: 40,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      child: SizedBox(
                                                        height: 30,
                                                        width: 40,
                                                        child: Image.network(
                                                          product['mdcp'][0]['colors'][0]['photos'][0]['url'],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      product['name'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      categories.firstWhere(
                                                              (category) =>
                                                          category[
                                                          'id_category'] ==
                                                              product[
                                                              'id_category_product'])[
                                                      'name'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      NumberFormat.simpleCurrency(
                                                          locale: 'en_US',
                                                          decimalDigits: 0)
                                                          .format(
                                                          product['price_unit']),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      product['quantity'].toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) => AlertDialog(
                                                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(
                                                                        10),
                                                                  ),
                                                                  content: EditProductDesktop(product: product),
                                                                ));
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              gradient:  LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [
                                                                  Theme.of(context).hintColor,
                                                                  Theme.of(context).colorScheme.onPrimary
                                                                ],
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons.edit,
                                                              color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) => AlertDialog(
                                                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(
                                                                       10),
                                                                  ),
                                                                  content: ProductDesktop(product: product),
                                                                ));
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              gradient:  LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomLeft,
                                                                colors: [
                                                                  Theme.of(context).colorScheme.onPrimary,
                                                                  Theme.of(context).hintColor
                                                                ],
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons.remove_red_eye,
                                                              color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child: Text(
                                                  'No hay productos con esta categoria'
                                              ),
                                            );
                                          }
                                        }
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        menuCategories == true
                            ? Container(
                          height: 345,
                          width: 750,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor
                              )
                          ),
                          child: categories.isEmpty
                              ? const Center(
                            child: Text('Aun no hay categorias'),
                          )
                              : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedCategoriesMenu.length,
                            itemBuilder: (context, index) {
                              final selectedCategory =
                              selectedCategoriesMenu[index];
                              return MenuCategories(
                                idFather: selectedCategory,
                                categories: categories
                                    .where((category) =>
                                category['id_padre'] ==
                                    selectedCategory)
                                    .toList(),
                                categoriesAll: categories,
                                onCategorySelectedMenu:
                                updateSelectedCategoriesMenu,
                                onCategorySelected:
                                updateCategorieSelected,
                                offCategorySelectedMenu:
                                removeSelectedCategoriesMenu,
                                selectedMenuList:
                                selectedCategoriesMenu,
                                selectedAll: selectedAllMenu,
                              );
                            },
                          ),
                        )
                            : const SizedBox(),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
