import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:web_dash/screens/not_authenticate/login/register.dart';
import '../../../bloc/auth/auth_user.dart';
import '../../../bloc/auth/provider_auth.dart';
import '../../../bloc/dates_state_bloc.dart';
import 'change_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final ValueNotifier<String> selectedAuth = ValueNotifier('login');

  final GetUserTGoogle getUserTGoogle = GetUserTGoogle();

  bool _obscureTextLogin = true;

  final formKeyLogin = GlobalKey<FormState>();

  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();

  bool _isLoadingGoogle = false;
  bool _isLoadingLogin = false;

  @override
  Widget build(BuildContext context) {
    ConnectionDatesBlocs connectionDatesBlocs = Provider.of<ConnectionDatesBlocs>(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4)
              ),
            ),
            ValueListenableBuilder<String>(
                valueListenable: selectedAuth,
                builder: (context, value, child) {
                return Center(
                  child: Container(
                    height: 500,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: value == 'login'
                              ? const Text(
                                'Iniciar sesión',
                                style: TextStyle(fontWeight: FontWeight.w900,
                                fontSize: 30),
                              )
                              : value == 'register'
                              ? Text(
                                'Registrarse',
                                style: TextStyle(fontWeight: FontWeight.w900,
                                    fontSize: 30),
                              )
                              : Text(
                                'Recupera tu cuenta',
                                style: TextStyle(fontWeight: FontWeight.w900,
                                    fontSize: 30),
                              ),
                        ),
                        Expanded(child: value == 'login' ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Form(
                                key: formKeyLogin,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        width: 300,
                                        child: TextFormField(
                                          autofillHints: const [AutofillHints.email],
                                          style: TextStyle(
                                              color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                          ],
                                          controller: userEmailController,
                                          decoration: InputDecoration(
                                            hintText: 'Email',
                                            prefixIcon: const Icon(Icons.email,),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Por favor ingrese su correo electrónico';
                                            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                              return 'Por favor ingrese un correo electrónico válido';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        width: 300,
                                        child: TextFormField(
                                          autofillHints: const [AutofillHints.password],
                                          style: TextStyle(
                                              color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                                          ),
                                          obscureText: _obscureTextLogin,
                                          controller: userPasswordController,
                                          decoration: InputDecoration(
                                            hintText: 'Contraseña',
                                            prefixIcon: const Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureTextLogin ? Icons.visibility : Icons.visibility_off,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureTextLogin = !_obscureTextLogin;
                                                });
                                              },
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    InkWell(
                                      onTap: () => selectedAuth.value = 'password',
                                      child: const Text('olvido su contraseña',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            decorationColor: Colors.blue,
                                            decoration: TextDecoration.underline,
                                            height: 1
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: _isLoadingLogin
                                      ? null
                                      : () async {


                                    if (_isLoadingLogin == false ) {

                                      setState(() {
                                        _isLoadingLogin = true;
                                      });

                                      final authTokenProvider =
                                      Provider.of<AuthTokenProvider>(context, listen: false);

                                      String route = '/login_user_client';

                                      var url = Uri.parse('$connection$route');

                                      var headers = {'Content-Type': 'application/json; charset=UTF-8'};

                                      var body = jsonEncode({
                                        'email': userEmailController.text,
                                        'password': userPasswordController.text,
                                      });

                                      try {
                                        var response = await http.post(url, headers: headers, body: body);

                                        if (response.statusCode == 200) {


                                          var token = jsonDecode(response.body)['token'];

                                          Map<String, dynamic> userMap = jsonDecode(response.body);

                                          // Elimina el token del mapa
                                          userMap.remove('token');

                                          // Actualiza el valor de account
                                          connectionDatesBlocs.account.value = [userMap];

                                          authTokenProvider.setToken(token);

                                          authTokenProvider.setAuthenticated(true);

                                          setState(() {
                                            _isLoadingLogin = false;
                                          });

                                          Navigator.pop(context);
                                        }
                                        else if (response.statusCode == 401) {
                                          if (response.body == 'Usuario no encontrado') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  title: const Text('Error',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    ),),
                                                  content: const Text('Usuario no encontrado'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: TextButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cerrar',
                                                        style: TextStyle(
                                                            color: Theme.of(context).textTheme.bodyLarge?.color
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            setState(() {
                                              _isLoadingLogin = false;
                                            });

                                          } else if (response.body == 'Contraseña incorrecta') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  title: const Text('Error',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    ),),
                                                  content: const Text('contraseña incorrrecta'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: TextButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cerrar',
                                                        style: TextStyle(
                                                            color: Theme.of(context).textTheme.bodyLarge?.color
                                                        ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            setState(() {
                                              _isLoadingLogin = false;
                                            });
                                          }
                                        }
                                        else if (response.statusCode == 429) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                title: const Text('Error',
                                                  style: TextStyle(
                                                      color: Colors.red
                                                  ),),
                                                content: const Text('Usted a excedido el numero de intentos por hoy'),
                                                actions: [
                                                  ElevatedButton(
                                                    style: TextButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cerrar',
                                                      style: TextStyle(
                                                          color: Theme.of(context).textTheme.bodyLarge?.color
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          setState(() {
                                            _isLoadingLogin = false;
                                          });
                                        }
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print('Error al realizar la solicitud: $e');
                                        }
                                      }
                                    }
                                  },
                                  child: _isLoadingLogin
                                      ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 43),
                                    child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        )),
                                  )
                                      :  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Text('Iniciar Sesion',
                                      style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                          fontWeight: FontWeight.w500
                                      ),),
                                  ),
                                ),
                              ), //boton de inicio de sesion
                              const Padding(
                                padding: EdgeInsets.only(top:25, bottom: 10),
                                child: Text('Inicia sesion usando',
                                ),
                              ),
                              SizedBox(
                                width: 235,
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: _isLoadingGoogle
                                      ? null
                                      : () async {


                                    if(  _isLoadingGoogle == false) {

                                      setState(() {
                                        _isLoadingGoogle = true;
                                      });

                                      final authTokenProvider =
                                      Provider.of<AuthTokenProvider>(context, listen: false);

                                      String route = '/login_user_token_google';
                                      final Map<String, dynamic>? googleData =
                                      await getUserTGoogle.signInWithGoogle();

                                      if (googleData != null) {
                                        final String? googleIdToken = googleData['googleIdToken'];
                                        final String? email = googleData['email'];

                                        if (googleIdToken != null && email != null) {
                                          final Uri url = Uri.parse('$connection$route'); // url backend
                                          final Map<String, String> headers = {
                                            'Content-Type': 'application/json; charset=UTF-8'
                                          };

                                          final String body = jsonEncode({
                                            'google_token': googleIdToken,
                                            'email': email,
                                          });

                                          final http.Response response =
                                          await http.post(url, headers: headers, body: body);

                                          if (response.statusCode == 200) {
                                            var token = jsonDecode(response.body)['token'];

                                            authTokenProvider.setToken(token);

                                            authTokenProvider.setAuthenticated(true);

                                            setState(() {
                                              _isLoadingGoogle = false;
                                            });

                                            Navigator.pop(context);

                                          } else if (response.statusCode == 401) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  title: const Text('Error',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    ),),
                                                  content: const Center(child: Text('Usuario no encontrado')),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: TextButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cerrar',
                                                        style: TextStyle(
                                                            color: Theme.of(context).textTheme.bodyLarge?.color
                                                        ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            setState(() {
                                              _isLoadingGoogle = false;
                                            });

                                          } else if (response.statusCode == 500) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  title: const Center(child: Text('Error desconocido',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    ),)),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: TextButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cerrar',
                                                        style: TextStyle(
                                                            color: Theme.of(context).textTheme.bodyLarge?.color
                                                        ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            setState(() {
                                              _isLoadingGoogle = false;
                                            });
                                          }
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: _isLoadingGoogle
                                      ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 80),
                                    child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        )),
                                  ) :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Iniciar sesion con Google',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Image(
                                          height: 20,
                                          width: 20,
                                          image: NetworkImage('assets/img/google.png'),),
                                      )
                                    ],
                                  ),
                                ),
                              ), //boton de inicio con google
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.only( bottom: 3),
                                child: Text('Aun no tienes cuenta',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only( bottom: 10),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () => selectedAuth.value = 'register',
                                  child: const Text('Registrarse',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600
                                    ),),),
                              ),
                            ],
                          ),
                        ) : value == 'register'
                            ? RegisterUser(selectedAuth: selectedAuth) : ChangePassword(selectedAuth: selectedAuth),)
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
}
