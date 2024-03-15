import 'package:web_dash/screens/authenticate/dekstop/store/shop_desktop_panel.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

// mobile
import 'package:web_dash/screens/authenticate/mobile/reserve/reserves_mobile_view.dart';
import 'package:web_dash/screens/authenticate/mobile/reserve/search_reserves_mobile_view.dart';
import 'package:web_dash/screens/authenticate/mobile/store/shop_mobile.dart';

//tablet
import 'package:web_dash/screens/authenticate/tablet/reserves/reserves_tablet_view.dart';
import 'package:web_dash/screens/authenticate/tablet/reserves/search_tablet_desktop_view.dart';
import 'package:web_dash/screens/authenticate/tablet/store/shop_tablet.dart';

//desktop
import 'package:web_dash/screens/authenticate/dekstop/panel_desktop.dart';
import 'package:web_dash/screens/authenticate/dekstop/account/account.dart';
import 'package:web_dash/screens/authenticate/dekstop/reserves/reserves_desktop_view.dart';


class Trips extends StatefulWidget {
  final ValueNotifier<bool> darkMode;
  const Trips({super.key, required this.darkMode});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  bool navigatorBar = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //mobile
  final List<Widget> pagesIndex300 = [
    const ReservesMobileView(),
    const ShopMobileView(),
    const SearchReservesMobileView(),
  ];

  Widget buildNavigationBar300() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        topLeft: Radius.circular(25),
      )),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          backgroundColor: Colors.black87,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: _selectedIndex == 0
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications,
                            color: Colors.black87),
                      )
                    : const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )),
            BottomNavigationBarItem(
                label: '',
                icon: _selectedIndex == 1
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Icon(Icons.shopping_bag_rounded,
                                color: Colors.black87)),
                      )
                    : const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                      )),
            BottomNavigationBarItem(
                label: '',
                icon: _selectedIndex == 2
                    ? Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.build,
                          color: Colors.black87,
                        )),
                      )
                    : const Icon(
                        Icons.build,
                        color: Colors.white,
                      )),
          ],
        ),
      ),
    );
  }

  //tablet
  final List<Widget> pagesIndex600 = [
    const ReservesTabletView(),
    const ShopTabletView(),
    const SearchReservesTabletView(),
  ];

  Widget buildNavigationBar600() {
    return Container(
      width: navigatorBar == false ? 80 : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary,
          boxShadow: [
      BoxShadow(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      spreadRadius: 0.2,
      blurRadius:20,
      offset: const Offset(10, 8),
    ),
    ],
      ),
      child: Expanded(
        child: Column(
          children: [
            if (navigatorBar == false) ...[
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: _selectedIndex == 0
                      ? Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFF8e5cff),
                              Color(0xFFca4cfd),
                            ],
                          ),
                      ),
                      child: const Icon(Icons.villa, color: Color(0xFF031542)))
                      : const SizedBox(
                    height: 35,
                    child: Icon(
                      Icons.villa,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: _selectedIndex == 1
                      ? Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFF8e5cff),
                              Color(0xFFca4cfd),
                            ],
                          )
                      ),
                      child: const Icon(Icons.shopify_outlined, color: Color(0xFF031542)))
                      : const SizedBox(
                    height: 35,
                    child: Icon(
                      Icons.shopify_outlined,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
              InkWell(
                child: _selectedIndex == 2
                    ? Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFF8e5cff),
                            Color(0xFFca4cfd),
                          ],
                        )
                    ),child: const Icon(Icons.local_taxi, color: Color(0xFF031542)))
                    : const SizedBox(
                  height: 35,
                  child: Icon(
                    Icons.local_taxi,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorBar = true;
                    });
                  },
                ),
              ),
            ] else ...[
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: _selectedIndex == 0
                      ? Container(
                    height: 35,
                    width: 150,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFF8e5cff),
                          Color(0xFFca4cfd),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons
                              .villa, color: Color(0xFF031542),),
                        ),
                        Text(
                          'Alojamientos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF031542),),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(
                    height: 35,
                    width: 150,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons.villa,
                              color: Colors.white),
                        ),
                        Text(
                          'Alojamientos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: _selectedIndex == 1
                      ? Container(
                    height: 35,
                    width: 150,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFF8e5cff),
                          Color(0xFFca4cfd),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons
                              .shopify_outlined, color: Color(0xFF031542),),
                        ),
                        Text(
                          'Tienda',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF031542),),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(
                    height: 35,
                    width: 150,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons.shopify_outlined,
                              color: Colors.white),
                        ),
                        Text(
                          'Tienda',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: _selectedIndex == 2
                    ? Container(
                  height: 35,
                  width: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFF8e5cff),
                        Color(0xFFca4cfd),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Icon(Icons
                            .local_taxi, color: Color(0xFF031542),),
                      ),
                      Text(
                        'MotoCab',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF031542),),
                      ),
                    ],
                  ),
                )
                    : const SizedBox(
                  height: 35,
                  width: 150,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Icon(Icons.local_taxi,
                            color: Colors.white),
                      ),
                      Text(
                        'MotoCab',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorBar = false;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  //desktop
  final List<Widget> pagesIndex900 = [
    const ShopDekstopPanel(),
    const ReservesDesktop(),
    const PanelDesktop(),
  ];

  Widget buildNavigationBar900() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 15),
      child: Container(
        width: navigatorBar == false ? 80 : 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              spreadRadius: 0.2,
              blurRadius:20,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountDash()));
              },
              icon: SizedBox(
                height: 65,
                width: 65,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Theme.of(context).primaryColor,
                                Theme.of(context).hintColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage('assets/img/creax.jpg')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
                valueListenable: widget.darkMode,
                builder: (context, value, child) {
                  var darkMode = value;
                return darkMode == false ?
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.darkMode.value = true;
                    });
                  },
                  child: SizedBox(
                    width: 60,
                    height: 25,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2,2),
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                ),
                                BoxShadow(
                                    offset: Offset(-2,-2),
                                    color: Color(0xFF031542).withOpacity(0.7),
                                    blurRadius: 4,
                                    inset: true
                                ),
                              ]
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                color: Color(0xFF031542),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(2,2),
                                      color: Colors.white.withOpacity(0.7),
                                      blurRadius: 3,
                                      inset: true
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : InkWell(
                  onTap: () {
                    setState(() {
                      widget.darkMode.value = false;
                    });
                  },
                  child: SizedBox(
                    width: 60,
                    height: 25,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF031542),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2,2),
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                ),
                                BoxShadow(
                                    offset: const Offset(1,1),
                                    color: Colors.white.withOpacity(0.7),
                                    blurRadius: 5,
                                    inset: true
                                ),

                              ]
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(-2,-2),
                                        color: Color(0xFF031542).withOpacity(0.7),
                                        blurRadius: 5,
                                        inset: true
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            if (navigatorBar == false) ...[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: _selectedIndex == 0
                      ? Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                         gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Theme.of(context).primaryColor,
                              Theme.of(context).hintColor,
                            ],
                          )
                      ),
                      child: Icon(Icons.stacked_bar_chart, color: Theme.of(context).textTheme.bodyLarge?.color,))
                  : SizedBox(
                    height: 35,
                    child: Icon(
                      Icons.stacked_bar_chart,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  child: _selectedIndex == 1
                      ? Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Theme.of(context).primaryColor,
                              Theme.of(context).hintColor,
                            ],
                          )
                      ),
                      child: Icon(Icons.villa, color: Theme.of(context).textTheme.bodyLarge?.color,))
                      : SizedBox(
                    height: 35,
                        child: Icon(
                                            Icons.villa,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                          ),
                      ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
              InkWell(
                child: _selectedIndex == 2
                    ? Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Theme.of(context).primaryColor,
                            Theme.of(context).hintColor,
                          ],
                        )
                    ),child: Icon(Icons.local_taxi, color: Theme.of(context).textTheme.bodyLarge?.color,))
                    : SizedBox(
                  height: 35,
                      child: Icon(
                                        Icons.local_taxi,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                    ),
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorBar = true;
                    });
                  },
                ),
              ),
            ]
            else ...[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: _selectedIndex == 0
                      ? Container(
                    height: 35,
                    width: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Theme.of(context).primaryColor,
                          Theme.of(context).hintColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons
                              .stacked_bar_chart, color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                        Text(
                          'Estadisticas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                      ],
                    ),
                  )
                      : SizedBox(
                    height: 35,
                    width: 130,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons.send_time_extension,
                              color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                        Text(
                          'Estadisticas',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: _selectedIndex == 1
                      ? Container(
                    height: 35,
                    width: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Theme.of(context).primaryColor,
                          Theme.of(context).hintColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons
                              .shopify_outlined, color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                        Text(
                          'Tienda',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                      ],
                    ),
                  )
                      : SizedBox(
                    height: 35,
                    width: 130,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Icon(Icons.shopify_outlined,
                              color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                        Text(
                          'Tienda',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: _selectedIndex == 2
                    ? Container(
                  height: 35,
                  width: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Theme.of(context).primaryColor,
                        Theme.of(context).hintColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Icon(Icons
                            .local_taxi, color: Theme.of(context).textTheme.bodyLarge?.color,),
                      ),
                      Text(
                        'MotoCab',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,),
                      ),
                    ],
                  ),
                )
                    : SizedBox(
                  height: 35,
                  width: 130,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Icon(Icons.local_taxi,
                            color: Theme.of(context).textTheme.bodyLarge?.color,),
                      ),
                      Text(
                        'MotoCab',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    size: 15,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorBar = false;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: SafeArea(
              child: pagesIndex300[_selectedIndex],
            ),
            bottomNavigationBar: buildNavigationBar300(),
          );
        }
        else if (constraints.maxWidth < 600) {
          return Scaffold(
            body: Row(
              children: [
                buildNavigationBar600(),
                Expanded(
                  child: pagesIndex600[_selectedIndex],
                )
              ],
            ),
          );
        }
        else {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                Row(
                  children: [
                    buildNavigationBar900(),
                    Expanded(
                      child: pagesIndex900[_selectedIndex],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
