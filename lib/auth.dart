import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/Home.dart';

class Authentication {
  String? message = null;
  Future<void> Sinup(
      {required String email,
      required String password,
      required String? usern,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .set({'userName': usern, 'email': email});

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provide to weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print('Un expected error : $e');
    }
  }

  Future<void> Sinin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provide for that user.';
      }
      Fluttertoast.showToast(
        msg: message!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print('Un expected error : $e');
    }
  }
}

Future<void> signInWithGoogle({required BuildContext context}) async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    print("No user found !");
    return;
  }

  GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

  AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken, idToken: googleAuth!.idToken);

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  String uid = userCredential.user!.uid;

  DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('Users').doc(uid);

  DocumentSnapshot userDoc = await userDocRef.get();
  if (!userDoc.exists) {
    await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'Gname': userCredential.user?.displayName,
      'Gmail': userCredential.user?.email
    });
  }

  await Future.delayed(const Duration(seconds: 1));
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => Home()));

  print(userCredential.user?.displayName);
}
