import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neighbor_net/auth/auth.dart';
import 'package:neighbor_net/auth/login_or_register.dart';
import 'package:neighbor_net/firebase_options.dart';
import 'package:neighbor_net/pages/events_page.dart';
import 'package:neighbor_net/pages/forum_page.dart';
import 'package:neighbor_net/pages/home_page.dart';
import 'package:neighbor_net/pages/neighborhood_page.dart';
import 'package:neighbor_net/pages/profile_page.dart';
import 'package:neighbor_net/pages/report_issue_page.dart';
import 'package:neighbor_net/pages/users_page.dart';
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
      routes: {
        '/login_register_page':(context) => const LoginOrRegister(),
        '/home_page':(context) => HomePage(),
        '/profile_page':(context) => ProfilePage(),
        '/users_page':(context) => const UsersPage(),
        '/forum_page':(context) => ForumPage(),
        '/report_issue_page':(context) => const ReportIssuePage(),
        '/events_page':(context) => EventsPage(),
        '/neighborhood_page':(context) => NeighborhoodPage(),
      },
    );
  }
}
