import 'package:web_dash/screens/authenticate/dekstop/stadistic/lineal_chart_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/orders/orders_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/store/shop_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/dates_state_bloc.dart';

class ShopDekstopPanel extends StatefulWidget {
  const ShopDekstopPanel({super.key});

  @override
  State<ShopDekstopPanel> createState() => _ShopDekstopPanelState();
}

class _ShopDekstopPanelState extends State<ShopDekstopPanel> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable:
        Provider.of<ConnectionDatesBlocs>(context).products,
        builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  LinealChartDesktop(dates: Provider.of<ConnectionDatesBlocs>(context).orders, dateChart: 'createat', dotChart: false,)

                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    ShopDesktopView(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: OrdersDesktop(),
                    ),
                  ],
                ),
              )

            ],
          ),
        );
      }
    );
  }
}
