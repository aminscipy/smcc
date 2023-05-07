import 'package:cc/Views/homepage.dart';
import 'package:cc/Views/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInController extends GetxController {
  var isLoading = false.obs;
  Future<void> handleSignIn() async {
    try {
      isLoading.value = true;
      // decide the scope
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      // opens the pop up to choose gmail account
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // get you access token and id token
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // use access token and id token to create credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        //use credential to sign in to firebase
        final UserCredential googleUserCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        Get.off(() => const HomePage());
        debugPrint(googleUserCredential.user!.email.toString());
        Fluttertoast.showToast(msg: "You're Logged in");
      }
      isLoading.value = false;
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    try {
      const CircularProgressIndicator();
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: 'You"re Logged out!');
      Get.offAll(() => const SignIn());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  Widget statePersist() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const HomePage();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return const SignIn();
        });
  }
}
