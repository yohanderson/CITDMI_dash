import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../bloc/dates_state_bloc.dart';

class ChangePassword extends StatefulWidget {
  final ValueNotifier<String> selectedAuth;

  const ChangePassword({Key? key, required this.selectedAuth})
      : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // page control change

  final int _pageIndex = 0;
  late PageController _changePasswordController;

  @override
  void initState() {
    super.initState();
    _changePasswordController = PageController(initialPage: _pageIndex);
    _focusNode.addListener(_onFocusChange);
  }

  // search email

  final emailController = TextEditingController();
  var email = '';
  int? userId;

  // account generated code password

  var account = '';

  // into to code

  final formKeyVerify = GlobalKey<FormState>();

  late Timer _timer;
  int _start = 300;

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) => setState(() {
        if (_start < 1) {
          timer.cancel();
        } else {
          _start = _start - 1;
        }
      }),
    );
  }




  final codeController = TextEditingController();

  // change to password
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  bool passwordSecurity = false;

  final formKeyChange = GlobalKey<FormState>();

  final userPasswordController = TextEditingController();
  final userPasswordConfirmController = TextEditingController();

  bool isPasswordValid = false;

  var character = Colors.grey[400];
  var capital = Colors.grey[400];
  var letter = Colors.grey[400];
  var number = Colors.grey[400];
  var length = Colors.grey[400];

  final StreamController<String> textValidateStream =
  StreamController<String>();
  final FocusNode _focusNode = FocusNode();

  late final String password;

  void validatePassword(String password) {
    // Verificar mayúsculas, números, caracteres especiales y letras
    capital = password.contains(RegExp(r'[A-Z]')) ? Colors.green : Colors.red;
    number = password.contains(RegExp(r'[0-9]')) ? Colors.green : Colors.red;
    character = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
        ? Colors.green
        : Colors.red;
    letter = password.contains(RegExp(r'[a-zA-Z]')) ? Colors.green : Colors.red;
    length = password.length >= 8 ? Colors.green : Colors.red;

    // Verificar si todos los requisitos están en verde
    if (capital == Colors.green &&
        number == Colors.green &&
        character == Colors.green &&
        letter == Colors.green &&
        length == Colors.green) {
      isPasswordValid = true;
    } else {
      isPasswordValid = false;
    }

    setState(() {});
  }

  void _onFocusChange() {
    setState(() {
      passwordSecurity = _focusNode.hasFocus;
    });
  }

  bool _isLoadingPassword = false;

  @override
  Widget build(BuildContext context) {

    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        width: 300,
        child: PageView(
          controller: _changePasswordController,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  const Text(
                      'Ingresa tu correo electrónico o número de celular para buscar tu cuenta.'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      autofillHints: const [AutofillHints.email],
                      style: TextStyle(
                          color: Theme.of(context)
                              .inputDecorationTheme
                              .hintStyle
                              ?.color),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
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
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Por favor ingrese un correo electrónico válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          backgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => widget.selectedAuth.value = 'login',
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Buscar',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        onPressed: () async {
                          final url = Uri.parse('http:$ipPort/get_email');

                          var headers = {
                            'Content-Type': 'application/json; charset=UTF-8'
                          };

                          var body = jsonEncode({
                            'email': emailController.text,
                          });

                          try {
                            var response = await http.post(url,
                                headers: headers, body: body);
                            if (response.statusCode == 200) {
                              Map<String, dynamic> user =
                              json.decode(response.body);
                              String name = user['name'];
                              String surname = user['surname'];

                              setState(() {
                                account = '$name $surname';
                                userId = user['userId'];
                                email = emailController.text;
                              });

                              _changePasswordController.jumpToPage(
                                  _changePasswordController.page!.toInt() + 1);
                            }
                            else if (response.statusCode == 401) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: const Text('Error'),
                                    content: const Text('Usuario no encontrado'),
                                    actions: [
                                      ElevatedButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
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
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error al realizar la solicitud: $e');
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child:
                    Text('Te enviaremos un código a tu correo electrónico'),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          email,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      'Cuenta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(account),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text('Usuario de CIDTMI'),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        account = '';
                        userId = null;
                      });
                      emailController.clear();
                      _changePasswordController.jumpToPage(
                          _changePasswordController.page!.toInt() - 1);
                    },
                    child: const Text(
                      '¿No eres tu?',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            backgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () => widget.selectedAuth.value = 'login',
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Continuar',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onPressed: () async {

                            final url = Uri.parse('http:$ipPort/generate_password_code_client');
                            var headers = {
                              'Content-Type': 'application/json; charset=UTF-8'
                            };

                            var body = jsonEncode({
                              'userId': userId,
                              'email': email,
                            });

                            try {
                              var response = await http.post(url,
                                  headers: headers, body: body);
                              if (response.statusCode == 200) {
                                startTimer();
                                _changePasswordController.jumpToPage(
                                    _changePasswordController.page!.toInt() + 1);
                              }
                              else if (response.statusCode == 400) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: const Text('Error'),
                                      content: const Text('tenemos un problema, vuelva a intentarlo mas tarde'),
                                      actions: [
                                        ElevatedButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
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
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print('Error al realizar la solicitud: $e');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Ingresa el código de seguridad',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Comprueba si recibiste un correo electrónico con tu código de 6 dígitos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: 300,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey),
                        top: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 3),
                              child: Text('Enviamos el código a:'),
                            ),
                            Text(
                              email,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(_start > 0 ? 'Tiempo restante: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}' : 'Tiempo agotado',
                      style: TextStyle(
                        fontSize: 25,
                        color: _start > 0 ? Colors.grey : Colors.orange,
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 300,
                      child: Form(
                        key: formKeyVerify,
                        child: TextFormField(
                          autofillHints: const [AutofillHints.password],
                          style: TextStyle(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle
                                  ?.color),
                          controller: codeController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa el código',
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa algún texto';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {

                      final url = Uri.parse('http:$ipPort/generate_password_code_client');
                      var headers = {
                        'Content-Type': 'application/json; charset=UTF-8'
                      };

                      var body = jsonEncode({
                        'userId': userId,
                        'email': email,
                      });

                      try {
                        var response = await http.post(url,
                            headers: headers, body: body);
                        if (response.statusCode == 200) {

                          setState(() {
                            _start = 300;
                          });
                          startTimer();
                        }
                        else if (response.statusCode == 400) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text('Error'),
                                content: const Text('tenemos un problema, vuelva a intentarlo mas tarde'),
                                actions: [
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
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
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error al realizar la solicitud: $e');
                        }
                      }
                    },
                    child: const Text(
                      '¿No recibiste el código?',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            backgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () => widget.selectedAuth.value = 'login',
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Continuar',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onPressed: () async {

                            final url = Uri.parse('http:$ipPort/verify_password_code_client');
                            var headers = {
                              'Content-Type': 'application/json; charset=UTF-8'
                            };

                            var body = jsonEncode({
                              'code': codeController.text,
                              'userId': userId,
                            });

                            try {
                              var response = await http.post(url,
                                  headers: headers, body: body);
                              if (response.statusCode == 200) {
                                _timer.cancel();
                                _changePasswordController.jumpToPage(
                                    _changePasswordController.page!.toInt() + 1);
                              }
                              else if (response.statusCode == 400) {
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
                                      content: const Text('codigo incorrecto, vuelve a intentarlo'),
                                      actions: [
                                        ElevatedButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
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
                                            color: Colors.orange
                                        ),),
                                      content: const Text('codigo Expirado, vuelve a intentarlo'),
                                      actions: [
                                        ElevatedButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
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
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print('Error al realizar la solicitud: $e');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 10),
                  child: Text('Crea una nueva contraseña',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                ),
                Form(
                  key: formKeyChange,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          focusNode: _focusNode,
                          obscureText: _obscurePassword,
                          controller: userPasswordController,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle
                                  ?.color),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          onChanged: (value) {
                            validatePassword(value);
                          },
                          validator: (value) {
                            if (isPasswordValid) {
                              return null;
                            } else {
                              return 'La contraseña no cumple con los requisitos';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
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
                        ),
                      ),
                      StreamBuilder<String>(
                        stream: textValidateStream.stream,
                        builder: (context, snapshot) {
                          if (passwordSecurity == true) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: 300,
                                height: 135,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        'La contraseña debe tener al menos un:',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '-  Caracter (@/#%)',
                                      style: TextStyle(
                                        color: character,
                                      ),
                                    ),
                                    Text(
                                      '-  Mayúscula (MM)',
                                      style: TextStyle(
                                        color: capital,
                                      ),
                                    ),
                                    Text(
                                      '-  Letra (abc)',
                                      style: TextStyle(
                                        color: letter,
                                      ),
                                    ),
                                    Text(
                                      '-  Número (1234)',
                                      style: TextStyle(
                                        color: number,
                                      ),
                                    ),
                                    Text(
                                      '-  Minimo (8) caracteres',
                                      style: TextStyle(
                                        color: length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(); // No muestra nada si la condición no se cumple
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            obscureText: _obscurePasswordConfirm,
                            controller: userPasswordConfirmController,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle
                                    ?.color),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            onChanged: (value) {
                              validatePassword(value);
                            },
                            validator: (value) {
                              if (userPasswordConfirmController.text ==
                                  userPasswordController.text) {
                                return null;
                              } else {
                                return 'La contraseña no cumple con los requisitos';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Confirmar contraseña ',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePasswordConfirm
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePasswordConfirm =
                                    !_obscurePasswordConfirm;
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
                    onPressed:  _isLoadingPassword
                        ? null
                        :  () async {

                      setState(() {
                        _isLoadingPassword = true;
                      });

                      if(_isLoadingPassword == false) {
                        final url = Uri.parse('http:$ipPort/update_password_client');
                        var headers = {
                          'Content-Type': 'application/json; charset=UTF-8'
                        };

                        var body = jsonEncode({
                          'userId': userId,
                          'password': userPasswordController.text,
                          'email': email,
                        });

                        try {
                          var response = await http.post(url,
                              headers: headers, body: body);
                          if (response.statusCode == 200) {

                            setState(() {
                              _isLoadingPassword = false;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Row(
                                    children: [
                                      const Text('Exito',
                                        style: TextStyle(
                                            color: Colors.blue
                                        ),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Icon(Icons.verified, color: Colors.green.shade300,),
                                      )
                                    ],
                                  ),
                                  content: const Text('La contraseña a sido actualizada correctamente'),
                                  actions: [
                                    ElevatedButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        widget.selectedAuth.value = 'login';
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
                          }
                          else if (response.statusCode == 400) {

                            setState(() {
                              _isLoadingPassword = false;
                            });

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
                                  content: const Text('codigo incorrecto, vuelve a intentarlo'),
                                  actions: [
                                    ElevatedButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
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
                          }
                          else if (response.statusCode == 401) {

                            setState(() {
                              _isLoadingPassword = false;
                            });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: const Text('Error',
                                    style: TextStyle(
                                        color: Colors.orange
                                    ),),
                                  content: const Text('codigo Expirado, vuelve a intentarlo'),
                                  actions: [
                                    ElevatedButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
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
                          }
                        } catch (e) {
                          setState(() {
                            _isLoadingPassword = false;
                          });
                          if (kDebugMode) {
                            print('Error al realizar la solicitud: $e');
                          }
                        }
                      }
                    },
                    child: _isLoadingPassword
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 65),
                      child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          )),
                    ) : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Cambiar contraseña',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
