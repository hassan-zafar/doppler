import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:dopplerv1/bottom_bar.dart';
import 'package:dopplerv1/database/user_local_data.dart';
import 'package:dopplerv1/provider/bottom_navigation_bar_provider.dart';
import 'package:dopplerv1/screens/landing_page.dart';
import 'package:dopplerv1/main_screen.dart';
import 'package:dopplerv1/screens/auth/login.dart';
import 'package:dopplerv1/screens/auth/sign_up.dart';
import 'screens/auth/forget_password.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Importance Notifications",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserLocalData.init();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        ChangeNotifierProvider<BottomNavigationBarProvider>.value(
          value: BottomNavigationBarProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Volt Arena',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blue,
          dividerTheme:
              const DividerThemeData(color: Colors.blue, thickness: 0.5),
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.red,
          ),
        ),
        home:
            // (UserLocalData.getUserUID == '')
            //     ? const
            LandingScreen(),
        // : MainScreens(),
        routes: {
          // '/': (ctx) => LandingPage(),
          // WebhookPaymentScreen.routeName: (ctx) =>
          //     WebhookPaymentScreen(),

          MainScreens.routeName: (ctx) => MainScreens(),

          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignupScreen.routeName: (ctx) => SignupScreen(),
          BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
          ForgetPassword.routeName: (ctx) => ForgetPassword(),
          LandingScreen.routeName: (ctx) => LandingScreen(),
        },
      ),
    );
  }
}

// import 'package:volt_arena/screens/home_screen.dart';
// import 'package:volt_arena/screens/introduction_auth_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: NavigationPage(),
//     );
//   }
// }

// class NavigationPage extends StatefulWidget {
//   @override
//   _NavigationPageState createState() => _NavigationPageState();
// }

// class _NavigationPageState extends State<NavigationPage> {
//   bool isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     FirebaseAuth.instance.authStateChanges().listen((event) {
//       if (event != null) {
//         setState(() {
//           isLoggedIn = true;
//         });
//       } else {
//         setState(() {
//           isLoggedIn = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoggedIn == false ? IntroductionAuthScreen() : HomeScreen(),
//     );
//   }
// }
