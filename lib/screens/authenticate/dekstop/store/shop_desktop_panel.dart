import 'package:web_dash/screens/authenticate/dekstop/stadistic/lineal_chart_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/orders/orders_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/shop_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';

class ShopDekstopPanel extends StatefulWidget {
  const ShopDekstopPanel({super.key});

  @override
  State<ShopDekstopPanel> createState() => ShopDekstopPanelState();
}

class ShopDekstopPanelState extends State<ShopDekstopPanel> {


  //
  late ValueNotifier<Widget> currentViewListShop;
  List<Widget> history = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Widget initialWidget = const OrdersDesktop();
    currentViewListShop = ValueNotifier<Widget>(initialWidget);
    history.add(initialWidget); // Añade el widget inicial al historial
  }

  void changeValue(Widget newValue) {
    history.add(currentViewListShop.value);
    currentViewListShop.value = newValue;
  }

  void goBack() {
    if (history.isNotEmpty) {
      currentViewListShop.value =
          history.removeLast(); // Retrocede al último widget del historial
    }
  }

  void clearHistory() {
    if (history.isNotEmpty) {
      Widget initialWidget = history.first; // Guarda el widget inicial
      history.clear(); // Limpia el historial
      history.add(initialWidget); // Añade el widget inicial al historial
      currentViewListShop.value = initialWidget; // Actualiza currentViewList.value
    }
  }
  @override
  Widget build(BuildContext context) {
    return Provider<ShopDekstopPanelState>.value(
      value: this,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable:
          Provider.of<ConnectionDatesBlocs>(context).products,
          builder: (context, value, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      LinealChartDesktop(dates: Provider.of<ConnectionDatesBlocs>(context).orders, dateChart: 'createat', dotChart: false,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:ValueListenableBuilder<Widget>(
                            valueListenable: currentViewListShop,
                            builder: (context, value, child) {
                              return currentViewListShop.value;
                            }),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        ShopDesktopView(),
                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
