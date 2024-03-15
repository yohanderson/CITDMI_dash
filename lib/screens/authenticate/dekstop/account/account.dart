import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/auth/provider_auth.dart';

class AccountDash extends StatefulWidget {
  const AccountDash({super.key});

  @override
  State<AccountDash> createState() => _AccountDashState();
}

class _AccountDashState extends State<AccountDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 6.0,
              colors: <Color>[
                Color(0xFF031542),
                Color(0xFF060c28),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 40),
            child: Row(
              children: [
                SizedBox(
                  height: 105,
                  width: 105,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 105,
                            width: 105,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFF8e5cff),
                                  Color(0xFFca4cfd),
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
                            height: 100,
                            width: 100,
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
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final authTokenProvider = Provider.of<AuthTokenProvider>(context, listen: false);
                authTokenProvider.setAuthenticated(false);
              },
              child: const Text('Cerra sesion'),
            ),
          ),
        ],
      ),
    );
  }
}
