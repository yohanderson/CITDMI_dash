import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../dates_state_bloc.dart';

const String connection = 'http:$ipPort';

class GetUserTGoogle {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
    "602987859242-9jv42ob5nouod40on7uh0unjvo331o05.apps.googleusercontent.com",
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signInSilently();

      if (googleSignInAccount == null) {
        // Si no hay una cuenta registrada, inicia sesión
        await _googleSignIn.signIn();
      }

      final GoogleSignInAuthentication? googleSignInAuth =
      await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth?.accessToken,
        idToken: googleSignInAuth?.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Obtiene el token de ID, el correo electrónico y el primer nombre
      final String? googleIdToken = googleSignInAuth?.idToken;
      final String? email = userCredential.user?.email;
      final String? firstName = userCredential.user?.displayName
          ?.split(' ')[0]; // Obtiene el primer nombre

      //  devolve estos valores como un mapa
      return {
        'googleIdToken': googleIdToken,
        'email': email,
        'firstName': firstName,
      };
    } catch (error) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Error desconocido'),
            content: const Text(
                'Ocurrió un error al iniciar sesión. Inténtalo de nuevo más tarde.'),
            actions: [
              ElevatedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color
                ),),
              ),
            ],
          );
        },
      );
      return null;
    }
  }
}
