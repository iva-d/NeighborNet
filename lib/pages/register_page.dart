import 'package:flutter/material.dart';
import 'package:neighbor_net/components/my_button.dart';
import 'package:neighbor_net/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register method
  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
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

              // username textfield
              MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
              ),
              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
              ),
              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
              ),
              const SizedBox(height: 10),

              // confirm password textfield
              MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
              ),
              const SizedBox(height: 10),

              // forgot password
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text("Forgot Password?", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
              //   ],
              // ),
              const SizedBox(height: 25),

              // register button
              MyButton(
                text: "Register",
                onTap: register,
              ),
              const SizedBox(height: 25),

              // already have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Login here",
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
    );
  }
}
