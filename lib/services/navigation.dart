import 'package:flutter/material.dart';
import 'package:mytodo/screens/home_screen.dart';
import 'package:mytodo/screens/login_screen.dart';
import 'package:mytodo/screens/password_screen.dart';
import 'package:mytodo/screens/signup_screen.dart';
import 'package:mytodo/screens/splash_screen.dart';

class Navigation {
  static void navigateToSplashScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const SplashScreen();
        },
      ),
    );
  }

  static void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const HomeScreen();
        },
      ),
    );
  }

  static void navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const LoginScreen();
        },
      ),
    );
  }

  static void navigateToSignupScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const SignupScreen();
        },
      ),
    );
  }

  static void navigateToPasswordScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const PasswordScreen();
        },
      ),
    );
  }
}
