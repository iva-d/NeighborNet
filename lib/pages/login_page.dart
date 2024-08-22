import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbor_net/components/my_button.dart';
import 'package:neighbor_net/components/my_textfield.dart';
import 'package:neighbor_net/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async{
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      // pop loading circle
      if(context.mounted) Navigator.pop(context);

      // new way
      Navigator.of(context).pushReplacementNamed('/home_page');
    }

    // display any errors
    on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // logo
              children: [
                Icon(
                    Icons.person_pin_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 25),
        
                // app name
                Text(
                  "N E I G H B O R N E T",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
        
                // email textfield
                MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController
                ),
                const SizedBox(height: 10),
        
                // password textfield
                MyTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController
                ),
                const SizedBox(height: 10),
        
                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                  ],
                ),
                const SizedBox(height: 25),
        
                // sign in button
                MyButton(
                    text: "Login",
                    onTap: login,
                ),
                const SizedBox(height: 25),
        
                // don't have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
