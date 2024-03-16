import 'package:web_dash/screens/authenticate/dekstop/reserves/reserves_desktop_view.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/shop_desktop.dart';
import 'package:flutter/material.dart';

import 'chat/chat_reserve.dart';
import 'structure/structure_panel_button_selected_desktop.dart';


class PanelDesktop extends StatefulWidget {
  const PanelDesktop({super.key});

  @override
  State<PanelDesktop> createState() => _PanelDesktopState();
}

class _PanelDesktopState extends State<PanelDesktop> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 20, top: 25),
                  child: Text('Sistema de reservas',
                    style: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 900,
                  child: Wrap(
                    spacing: 25,
                    runSpacing: 25,
                    children: [
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {},
                        icon: Icons.bar_chart_outlined,
                        text: 'Estadisticas',
                      ), // estadisticas
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatReserve()));
                        },
                        icon: Icons.chat,
                        text: 'Chat',
                      ), // chat
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReservesDesktop(),
                            ),
                          );
                        },
                        icon: Icons.list_alt,
                        text: 'Reservas',
                      ), // reserve
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDesktopView(),
                            ),
                          );
                        },
                        icon: Icons.add_circle_outline_outlined,
                        text: 'Agregar \n Nuevo producto',
                      ), // agregar producto
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDesktopView(),
                            ),
                          );
                        },
                        icon: Icons.shopify,
                        text: 'Productos',
                      ), // productos
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {},
                        icon: Icons.list_alt,
                        text: 'Ordenes',
                      ), // ordenes
                      StructurePanelButtonSelectedDesktop(
                        onTap: () {
                        },
                        icon: Icons.inventory,
                        text: 'Inventario',
                      ), // inventario
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
