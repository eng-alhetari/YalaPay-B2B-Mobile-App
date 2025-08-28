import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_pay/routes/app_router.dart';

class AuthService {
  /// Signup method to create a new user
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Create a new user document in the Firestore 'users' collection
      String userId = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });

      await Future.delayed(const Duration(seconds: 1));
      context.goNamed(AppRouter.login.name); // Navigate to the login screen
    } on FirebaseAuthException catch (e) {
      String message = _firebaseAuthErrorHandler(e);
      _showToast(message);
    } catch (e) {
      _showToast('An unexpected error occurred. Please try again.');
    }
  }

  /// Signin method to log in an existing user
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      context.goNamed(AppRouter.dashboard.name); // Navigate to the dashboard
    } on FirebaseAuthException catch (e) {
      String message = _firebaseAuthErrorHandler(e);
      _showToast(message);
    }
  }

  /// Signout method to log out the user
  Future<void> signout({
    required BuildContext context,
  }) async {
    await FirebaseAuth.instance.signOut();

    await Future.delayed(const Duration(seconds: 1));
    context.goNamed(AppRouter.login.name); // Navigate back to the login screen
  }

  /// Displays a toast message
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Firebase Auth exception handler
  String _firebaseAuthErrorHandler(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'An account already exists with that email.';
    } else if (e.code == 'invalid-email') {
      return 'The email address is not valid.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}
