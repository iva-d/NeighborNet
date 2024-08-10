import 'package:flutter/material.dart';
import 'package:neighbor_net/auth/login_or_register.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:neighbor_net/theme/light_mode.dart';
import 'package:neighbor_net/theme/dark_mode.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
