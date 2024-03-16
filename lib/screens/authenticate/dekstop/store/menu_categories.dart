import 'package:flutter/material.dart';


class MenuCategories extends StatefulWidget {
  const MenuCategories(
      {super.key,
        required this.idFather,
        required this.categories,
        required this.categoriesAll,
        required this.onCategorySelectedMenu,
        required this.onCategorySelected,
        required this.offCategorySelectedMenu,
        required this.selectedMenuList, required this.selectedAll});

  final int? idFather;
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
          right: BorderSide(width: 1, color: Theme.of(context).primaryColor),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          widget.idFather == null
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
                      child: Text('Todo',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color
                      ),)),
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
                              .offCategorySelectedMenu(widget.idFather);
                        });
                      },
                      icon: const Icon(Icons.chevron_left_outlined),
                    ),
                  ),
                  Text(widget.categoriesAll.firstWhere((category) =>
                  category['id_category'] == widget.idFather)['name'],
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
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
                final category = widget.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.onCategorySelected(category['id_category'], false);
                          });
                        },
                        child: Text(category['name'],
                        style:  TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color
                        ),),
                      ),
                      widget.categoriesAll.any((c) => c['id_padre'] == category['id_category']) &&
                          !widget.selectedMenuList.contains(category['id_category'])
                          ? SizedBox(
                        height: 30,
                        width: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              widget.onCategorySelectedMenu(category['id_category'], widget.idFather);
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