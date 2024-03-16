import 'package:web_dash/screens/not_authenticate/login/login.dart';
import 'package:web_dash/trips.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc/auth/provider_auth.dart';
import 'bloc/dates_state_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'notifications/push_notifications.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  initializeDateFormatting().then((_) => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionDatesBlocs>(
          create: (context) => ConnectionDatesBlocs(),
        ),
        ChangeNotifierProvider<AuthTokenProvider>(
          create: (context) => AuthTokenProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  ),);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}



class MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
  }

  void requestNotificationPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Usuario aceptó las notificaciones');
      PushNotifications.initializeApp();
    } else {
      print('Usuario no aceptó las notificaciones');
      // No inicializamos FCM
    }
  }

  final ValueNotifier<bool> darkMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final authTokenProvider = Provider.of<AuthTokenProvider>(context);

    return ValueListenableBuilder<bool>(
        valueListenable: darkMode,
        builder: (context, value, child) {
          var darkModeTheme = value;

        return MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: darkModeTheme == false ? ThemeData(
            primaryColor:  const Color(0xFF8e5cff),
            hintColor:  const Color(0xFFea80fc),
            secondaryHeaderColor: Colors.purple,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.purple.shade800),
              bodyLarge: const TextStyle(color: Color(0xFF8e5cff),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color(0xFF8e5cff);
                    }
                    return const Color(0xFF031542);
                  },
                ),
              ),
            ),
            sliderTheme: const SliderThemeData(
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            colorScheme: ColorScheme(
              background: Colors.deepPurpleAccent.shade100.withOpacity(0.15),
              brightness: Brightness.light,
              primary: Colors.white,
              onPrimary: const Color(0xFFe3d0ff),
              secondary: const Color(0xFFca4cfd),
              onSecondary: const Color(0xFFffcffa).withOpacity(0.8),
              onError: Colors.blue,
              onBackground: const Color(0xFF8e5cff),
              onSurface: Colors.purple.shade800,
              surface: Colors.white,
              error: Colors.red,
            ),
            iconTheme: const IconThemeData(
              color: Color(0xFF8e5cff)
            ),
          ) :
          ThemeData(
            primaryColor:  const Color(0xFF8e5cff),
            hintColor:  Colors.grey.shade200,
            secondaryHeaderColor: const Color(0xFF031542),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.grey.shade800),
              bodyMedium: const TextStyle(color: Colors.purple,),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color(0xFF8e5cff);
                    }
                    return const Color(0xFF031542);
                  },
                ),
              ),
            ),
            sliderTheme: const SliderThemeData(
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            colorScheme: const ColorScheme(
              background: Color(0xFF232323),
              brightness: Brightness.dark,
              primary: Color(0xFF989ba8),
              onPrimary: Color(0xFFe3d0ff),
              secondary: Color(0xFFca4cfd),
              onSecondary: Colors.purple,
              onError: Colors.blue,
              onBackground: Color(0xFF8e5cff),
              onSurface: Colors.black,
              surface: Color(0xFF031542),
              error: Colors.red,
            ),
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
          ),
          home: authTokenProvider.isAuthenticated ? Trips(darkMode: darkMode,) : Trips(darkMode: darkMode,) ,
        );
      }
    );
  }
}







