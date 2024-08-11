import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neighbor_net/auth/auth.dart';
import 'package:neighbor_net/auth/login_or_register.dart';
import 'package:neighbor_net/firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:neighbor_net/theme/light_mode.dart';
import 'package:neighbor_net/theme/dark_mode.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
