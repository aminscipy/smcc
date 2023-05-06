import 'package:cc/Controllers/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    SignInController signInController = Get.put(SignInController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMCC',
        ),
      ),
      body: Center(
          child: GestureDetector(
        onTap: () async {
          await signInController.handleSignIn();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset('assets/google.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Log In',
            )
          ],
        ),
      )),
    );
  }
}
