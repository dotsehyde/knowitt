import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/model/user.dart';

enum AuthState { initial, waiting, success, error }

class AuthController extends ChangeNotifier {
  AuthState status = AuthState.initial;
  String? errMsg;
  final _db = FirebaseFirestore.instance.collection(userCollection);
  //Google Sign In
  Future<void> googleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var auth = await FirebaseAuth.instance.signInWithCredential(credential);
    var user = auth.user;
    if (user != null) {
      UserModel newUser = UserModel(
          uid: user.uid,
          username: user.email!.split("@")[0],
          nickname: user.email!.split("@")[0],
          email: user.email!,
          score: 0,
          questionsAnswered: 0,
          questionsCorrect: 0,
          questionsWrong: 0,
          sid: user.uid.substring(0, 6),
          fcmToken: "",
          badges: [],
          isOnline: true,
          lastSeen: DateTime.now(),
          createdAt: DateTime.now());
      _db.doc(user.uid).set(newUser.toMap());
    }
  }
}
