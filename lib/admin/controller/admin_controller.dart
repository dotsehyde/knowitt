import 'package:cloud_firestore/cloud_firestore.dart';
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

  void setStatus(AdminStatus status) {
    status = status;
    notifyListeners();
  }

  final _db = FirebaseFirestore.instance;

  Future<bool> signIn() async {
    try {
      setStatus(AdminStatus.waiting);
      var doc = await _db
          .collection(adminCollection)
          .where("username", isEqualTo: username)
          .where("password", isEqualTo: password)
          .get();
      print(doc);
      if (doc.docs.isNotEmpty) {
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
