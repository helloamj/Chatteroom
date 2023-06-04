// ignore_for_file: use_build_context_synchronously

import 'package:chatteroom/models/UserModel.dart';
import 'package:chatteroom/pages/UserDetailSetupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/HomePage.dart';
import '../pages/OtpPage.dart';

class FirebaseMethods {
  static User? user;
  static String? uphoneNumber;
  static String? verificationId;
  static bool indicator = false;

  static void sendOTP(String? phoneNumber, BuildContext context) async {
    uphoneNumber = phoneNumber;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to ${phoneNumber}'),
          ),
        );
      },
      verificationFailed: (ex) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Phone number verification failed: ${ex.code.toString()}'),
          ),
        );
      },
      codeSent: (verificationId, forceResendingToken) {
        Navigator.pop(context);
        FirebaseMethods.verificationId = verificationId;
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const OtpPage()),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }

  static verifyOTP(String otp, BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: FirebaseMethods.verificationId!, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc('${FirebaseMethods.uphoneNumber}')
            .get();
        if (!snapshot.exists) {
          Navigator.pop(context);
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const UserDetailSetupPage()),
          );
        } else {
          UserModel userModel =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

          UserModel.mainuserModel = userModel;
          FirebaseMethods.user = FirebaseAuth.instance.currentUser;
          print(user!.phoneNumber.toString());
          Navigator.pop(context);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => HomePage(
                        userModel: userModel,
                      )));
        }
      }
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content:
              Text('Phone number verification failed: ${ex.code.toString()}'),
        ),
      );
    }
  }

  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
