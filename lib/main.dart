import 'package:fanpage_app/screens/signin.dart';
import 'package:fanpage_app/screens/signup.dart';
import 'package:fanpage_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/signin': (context) => const SignIn(),
  '/signup': (context) => const SignUp(),
  '/home': (context) => const Home(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return MaterialApp(
        routes: routes,
        initialRoute: '/home',
      );
    } else {
      return MaterialApp(
        routes: routes,
        initialRoute: '/home',
      );
    }
  }
}
