import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/core/constant/const.dart';

enum AdminStatus { initial, waiting, error, done }

final adminControllerProvider = ChangeNotifierProvider<AdminController>((ref) {
  return AdminController();
});

class AdminController extends ChangeNotifier {
  AdminStatus status = AdminStatus.initial;
  String password = '';
  String username = '';
  final _auth = FirebaseAuth.instance;
  void setStatus(AdminStatus status) {
    status = status;
    notifyListeners();
  }

  Future<bool> signIn() async {
    try {
      setStatus(AdminStatus.waiting);
      var user = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      if (user.user != null) {
        return true;
      } else {
        throw FirebaseException(plugin: "", message: "Invalid Credentials");
      }
    } on FirebaseException catch (e) {
      setStatus(AdminStatus.error);
      rethrow;
    }
  }
}
