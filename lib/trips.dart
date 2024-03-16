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
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 15),
      child: Container(
        width:  80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(3, 3),
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
                            Theme.of(context).hintColor,
                            Theme.of(context).colorScheme.onPrimary
                          ],
                        )
                    ),
                    child: Icon(Icons.stacked_bar_chart, color: Theme.of(context).textTheme.bodyMedium?.color,))
                    : SizedBox(
                  height: 35,
                  child: Icon(
                    Icons.stacked_bar_chart,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
                            Theme.of(context).hintColor,
                            Theme.of(context).colorScheme.onPrimary
                          ],
                        )
                    ),
                    child: Icon(Icons.villa, color: Theme.of(context).textTheme.bodyMedium?.color,))
                    : SizedBox(
                  height: 35,
                  child: Icon(
                    Icons.villa,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
                          Theme.of(context).hintColor,
                          Theme.of(context).colorScheme.onPrimary
                        ],
                      )
                  ),child: Icon(Icons.local_taxi, color: Theme.of(context).textTheme.bodyMedium?.color,))
                  : SizedBox(
                height: 35,
                child: Icon(
                  Icons.local_taxi,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            const Spacer(),
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
        width:  80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountDash()));
                },
                child: SizedBox(
                  height: 55,
                  width: 55,
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
                              gradient:  LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).hintColor,
                                  Theme.of(context).colorScheme.onPrimary
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
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child:  Image.network('assets/img/creax.jpg'),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Theme.of(context).hintColor,
                            Theme.of(context).colorScheme.onPrimary
                          ],
                        )
                    ),
                    child: Icon(Icons.stacked_bar_chart, color: Theme.of(context).textTheme.bodyMedium?.color,))
                    : SizedBox(
                  height: 35,
                  child: Icon(
                    Icons.stacked_bar_chart,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
                            Theme.of(context).hintColor,
                            Theme.of(context).colorScheme.onPrimary
                          ],
                        )
                    ),
                    child: Icon(Icons.villa, color: Theme.of(context).textTheme.bodyMedium?.color,))
                    : SizedBox(
                  height: 35,
                  child: Icon(
                    Icons.villa,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
                          Theme.of(context).hintColor,
                          Theme.of(context).colorScheme.onPrimary
                        ],
                      )
                  ),child: Icon(Icons.local_taxi, color: Theme.of(context).textTheme.bodyMedium?.color,))
                  : SizedBox(
                height: 35,
                child: Icon(
                  Icons.local_taxi,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
              child: ValueListenableBuilder<bool>(
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
                        width: 50,
                        height: 22,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2,2),
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                      blurRadius: 3,
                                    ),
                                    BoxShadow(
                                        offset: const Offset(1,1),
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 3,
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
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(-2,-2),
                                            color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
                    ) : InkWell(
                      onTap: () {
                        setState(() {
                          widget.darkMode.value = false;
                        });
                      },
                      child: SizedBox(
                        width: 50,
                        height: 22,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2,2),
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                      blurRadius: 5,
                                    ),
                                    BoxShadow(
                                        offset: const Offset(-2,-2),
                                        color: Colors.white.withOpacity(0.7),
                                        blurRadius: 4,
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
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary,
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
                    );
                  }
              ),
            ),
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
