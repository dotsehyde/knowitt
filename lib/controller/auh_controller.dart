import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knowitt/core/config/hive_box.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/model/user.dart';
import 'package:nb_utils/nb_utils.dart';

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController();
});

enum AuthState { initial, waiting, success, error }

class AuthController extends ChangeNotifier {
  AuthState status = AuthState.initial;
  String? errMsg;
  final _db = FirebaseFirestore.instance.collection(userCollection);
  final _auth = FirebaseAuth.instance;
  //Google Sign In
  Future<void> googleSignIn() async {
    try {
      status = AuthState.waiting;
      notifyListeners();
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
        var doc = await _db.doc(user.uid).get();
        var exist = doc.exists;
        if (exist) {
          status = AuthState.success;
          notifyListeners();
          return;
        }
        UserModel newUser = UserModel(
            platform: isWeb ? "web" : Platform.operatingSystem,
            uid: user.uid,
            username: user.email!.split("@")[0],
            nickname: user.email!.split("@")[0],
            email: user.email!,
            score: 0,
            questionsAnswered: 0,
            questionsCorrect: 0,
            questionsWrong: 0,
            sid: user.uid.substring(0, 6).toLowerCase(),
            fcmToken: "",
            badges: [],
            avatar: user.photoURL ?? "",
            isOnline: true,
            lastSeen: DateTime.now(),
            createdAt: DateTime.now());
        _db.doc(user.uid).set(newUser.toMap());
      }
    } catch (e) {
      status = AuthState.error;
      notifyListeners();
      rethrow;
    }
  }

  void listenUser() {
    _db.doc(FirebaseAuth.instance.currentUser!.uid).snapshots().listen((event) {
      var user = UserModel.fromMap(event.data()!);
      LocalDB.localUser.put(0, user);
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userStream =>
      _db.doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
}
