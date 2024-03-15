import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/auth/auth_user.dart';
import '../../../bloc/dates_state_bloc.dart';


class RegisterUser extends StatefulWidget {
  final ValueNotifier<String> selectedAuth;
  const RegisterUser({super.key, required this.selectedAuth});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  final String connection = 'http:$ipPort';

  bool passwordSecurity = false;

  bool _obscureTextRegister = true;
  bool _obscureTextRegisterConfirm= true;

  bool recuerdame = false;

  bool isPasswordValid = false;

  var character = Colors.grey[400];
  var capital= Colors.grey[400];
  var letter = Colors.grey[400];
  var number = Colors.grey[400];
  var length = Colors.grey[400];

  final StreamController<String> textValidateStream = StreamController<String>();
  final FocusNode _focusNode = FocusNode();

  late final String password;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }


  void validatePassword(String password) {
    // Verificar mayúsculas, números, caracteres especiales y letras
    capital = password.contains(RegExp(r'[A-Z]')) ? Colors.green : Colors.red;
    number = password.contains(RegExp(r'[0-9]')) ? Colors.green : Colors.red;
    character = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? Colors.green : Colors.red;
    letter = password.contains(RegExp(r'[a-zA-Z]')) ? Colors.green : Colors.red;
    length = password.length >= 8 ? Colors.green : Colors.red;

    // Verificar si todos los requisitos están en verde
    if (capital == Colors.green && number == Colors.green && character == Colors.green && letter == Colors.green && length == Colors.green) {
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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  final GetUserTGoogle getUserTGoogle = GetUserTGoogle();

  final formKeyCreate = GlobalKey<FormState>();

  final userUserNamedController = TextEditingController();
  final userNameController = TextEditingController();
  final userSurnameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userPasswordConfirmController = TextEditingController();

  bool _isLoadingGoogle = false;
  bool _isLoadingRegister = false;


  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKeyCreate,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                        ),
                        onChanged: (value) {
                          userUserNamedController.value = TextEditingValue(
                            text: value[0].toUpperCase() + value.substring(1),
                            selection: userUserNamedController.selection,
                          );
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                          FilteringTextInputFormatter.allow(RegExp(r'^\S{0,}\b')),
                        ],
                        controller: userUserNamedController,
                        decoration: InputDecoration(
                          hintText: 'Nombre de usuario',
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo es obligatorio';
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
                        style: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                        ),
                        onChanged: (value) {
                          userNameController.value = TextEditingValue(
                            text: value[0].toUpperCase() + value.substring(1),
                            selection: userNameController.selection,
                          );
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                          FilteringTextInputFormatter.allow(RegExp(r'^\S{0,}\b')),
                        ],
                        controller: userNameController,
                        decoration: InputDecoration(
                          hintText: 'Nombre',
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo es obligatorio';
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
                        style: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                        ),
                        onChanged: (value) {
                          userSurnameController.value = TextEditingValue(
                            text: value[0].toUpperCase() + value.substring(1),
                            selection: userSurnameController.selection,
                          );
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                          FilteringTextInputFormatter.allow(RegExp(r'^\S{0,}\b')),
                        ],
                        controller: userSurnameController,
                        decoration: InputDecoration(
                          hintText: 'Apellido',
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo es obligatorio';
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
                        controller: userEmailController,
                        style: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(
                              Icons.email
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
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      focusNode: _focusNode,
                      obscureText: _obscureTextRegister,
                      controller: userPasswordController,
                      style: TextStyle(
                          color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                      ),
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
                            _obscureTextRegister ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextRegister = !_obscureTextRegister;
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text('La contraseña debe tener al menos un:',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                    ),),
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
                        obscureText: _obscureTextRegisterConfirm,
                        controller: userPasswordConfirmController,
                        style: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.hintStyle?.color
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        onChanged: (value) {
                          validatePassword(value);
                        },
                        validator: (value) {
                          if (userPasswordConfirmController.text == userPasswordController.text) {
                            return null;
                          } else {
                            return 'La contraseña no coincide';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirmar contraseña ',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextRegisterConfirm ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureTextRegisterConfirm = !_obscureTextRegisterConfirm;
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
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _isLoadingRegister
                    ? null
                    :  () async {

                  if(_isLoadingRegister == false) {

                    setState(() {
                      _isLoadingRegister = true;
                    });

                    String route = '/create_user_client';

                    var url = Uri.parse('$connection$route');

                    var headers = {'Content-Type': 'application/json; charset=UTF-8'};

                    var body = jsonEncode({
                      'user_name': userUserNamedController.text,
                      'name': userNameController.text,
                      'surname': userSurnameController.text,
                      'email': userEmailController.text,
                      'password': userPasswordController.text,
                    });

                    bool isValid = formKeyCreate.currentState!.validate();

                    if (isValid) {
                      var response = await http.post(url, headers: headers, body: body);

                      if (response.statusCode == 401) {
                        userUserNamedController.clear();
                        userNameController.clear();
                        userSurnameController.clear();
                        userEmailController.clear();
                        userPasswordController.clear();
                        userPasswordConfirmController.clear();

                        setState(() {
                          _isLoadingRegister = false;
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
                              content: const Text('Este usuario ya está registrado.'),
                              actions: [
                                TextButton(
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
                      }
                      else if (response.statusCode == 400) {
                        userUserNamedController.clear();
                        userNameController.clear();
                        userSurnameController.clear();
                        userEmailController.clear();
                        userPasswordController.clear();
                        userPasswordConfirmController.clear();

                        setState(() {
                          _isLoadingRegister = false;
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: const Center(
                                child: Text('Error',
                                  style: TextStyle(
                                      color: Colors.red
                                  ),),
                              ),
                              content: Text('${response.body} \n vuelve a intentarlo'),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Volver',
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color
                                    ),),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else if (response.statusCode == 200) {
                        final email = userEmailController.text;

                        userUserNamedController.clear();
                        userNameController.clear();
                        userSurnameController.clear();
                        userEmailController.clear();
                        userPasswordController.clear();
                        userPasswordConfirmController.clear();

                        setState(() {
                          _isLoadingRegister = false;
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Registro con EXITO! ',
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(Icons.verified,color: Colors.green.shade300,),
                                ],
                              ),
                              content: SizedBox(
                                width: 300,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Se ha enviado un correo electrónico de verificación a tu dirección de correo electrónico. ',
                                      ),
                                      TextSpan(
                                        text: email, // La variable email que deseas resaltar
                                        style: const TextStyle(
                                          color: Colors.blue, // Color azul para la palabra "email"
                                          decoration: TextDecoration.underline,
                                          height: 1,// Subrayado
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' Por favor, verifica tu correo electrónico y haz clic en el enlace de verificación para activar tu cuenta.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    widget.selectedAuth.value = 'login';
                                  },
                                  child: Text('volver',
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),),
                                ),
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final correo = email;

                                    if (await canLaunch(correo)) {
                                      await launch(correo);
                                    } else {
                                      throw 'No se pudo abrir el correo electrónico';
                                    }
                                  },
                                  child: Text('CONFIRMAR CORREO',
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
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
                            content: const Text('Uno o más campos no son válidos.'),
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
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),),
                              ),
                            ],
                          );
                        },
                      );

                      setState(() {
                        _isLoadingRegister = false;
                      });
                    }
                  }
                },
                child: _isLoadingRegister
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      )),
                ) : Text('Registrarse',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),),
              ),
            ), // boton registrar
            const Padding(
              padding: EdgeInsets.only(top:30, bottom: 10),
              child: Text('Registrate usando',
              ),
            ),
            SizedBox(
              width: 235,
              height: 35,
              child: ElevatedButton(
                onPressed: _isLoadingGoogle
                    ? null
                    : () async {

                  if ( _isLoadingGoogle == false) {

                    setState(() {
                      _isLoadingGoogle = true;
                    });

                    String route = '/create_user_client_token_google';

                    final Map<String, dynamic>? googleData =
                    await getUserTGoogle.signInWithGoogle();

                    if (googleData != null) {
                      final String? googleIdToken = googleData['googleIdToken'];
                      final String? email = googleData['email'];
                      final String? firstName = googleData['firstName'];

                      if (googleIdToken != null && email != null && firstName != null) {
                        final Uri url = Uri.parse('$connection$route'); // url backend

                        final Map<String, String> headers = {
                          'Content-Type': 'application/json; charset=UTF-8'
                        };

                        final String body = jsonEncode({
                          'google_token': googleIdToken,
                          'user_name': firstName,
                          'email': email,
                        });

                        final http.Response response =
                        await http.post(url, headers: headers, body: body);

                        if (response.statusCode == 401) {
                          userNameController.clear();
                          userEmailController.clear();
                          userPasswordController.clear();
                          userPasswordConfirmController.clear();

                          setState(() {
                            _isLoadingGoogle = false;
                          });

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Center(
                                  child: Text('Error',
                                    style: TextStyle(
                                        color: Colors.red
                                    ),),
                                ),
                                content: const Text('Este usuario ya está registrado.'),
                                actions: [
                                  TextButton(
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
                        } else {

                          setState(() {
                            _isLoadingGoogle = false;
                          });

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Center(child: Text(response.body)),
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
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Registrate con Google',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image(
                        height: 20,
                        width: 20,
                        image: AssetImage('assets/img/google.png'),),
                    )
                  ],
                ),
              ),
            ), //boton google
            const Padding(
              padding: EdgeInsets.only(top:40, bottom: 5),
              child: Text('Ya tienes cuenta',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( bottom: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: ()  => widget.selectedAuth.value = 'login',
                child: const Text('Inicia Sesion',
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
