import 'package:flutter/material.dart';


class MenuCategories extends StatefulWidget {
  const MenuCategories(
      {super.key,
        required this.idPadre,
        required this.categories,
        required this.categoriesAll,
        required this.onCategorySelectedMenu,
        required this.onCategorySelected,
        required this.offCategorySelectedMenu,
        required this.selectedMenuList, required this.selectedAll});

  final int? idPadre;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> categoriesAll;
  final Function(int?, int?) onCategorySelectedMenu;
  final Function(int?) offCategorySelectedMenu;
  final Function(int?, bool) onCategorySelected;
  final List<int?> selectedMenuList;
  final Function() selectedAll;


  @override
  State<MenuCategories> createState() => _MenuCategoriesState();
}

class _MenuCategoriesState extends State<MenuCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      width: 150,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          widget.idPadre == null
              ? SizedBox(
              height: 53,
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Categoria Principal',
                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),),
                  TextButton(
                      onPressed: () {
                          widget.selectedAll();
                      },
                      child: Text('Todo')),
                ],
              )))
              : SizedBox(
            height: 40,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          widget
                              .offCategorySelectedMenu(widget.idPadre);
                        });
                      },
                      icon: const Icon(Icons.chevron_left_outlined),
                    ),
                  ),
                  Text(widget.categoriesAll.firstWhere((categorie) =>
                  categorie['id_categorie'] == widget.idPadre)['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 280,
            width: 150,
            child: ListView.builder(
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                final categorie = widget.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.onCategorySelected(categorie['id_categorie'], false);
                          });
                        },
                        child: Text(categorie['name']),
                      ),
                      widget.categoriesAll.any((c) => c['id_padre'] == categorie['id_categorie']) &&
                          !widget.selectedMenuList.contains(categorie['id'])
                          ? SizedBox(
                        height: 30,
                        width: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              widget.onCategorySelectedMenu(
                                  categorie['id_categorie'], widget.idPadre);
                            });
                          },
                          icon: const Icon(Icons.chevron_right_outlined),
                        ),
                      )
                          : const SizedBox(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}