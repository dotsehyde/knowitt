import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/model/category.dart';

enum AdminStatus { initial, waiting, error, done }

final adminControllerProvider = ChangeNotifierProvider<AdminController>((ref) {
  return AdminController();
});

class AdminController extends ChangeNotifier {
  AdminStatus status = AdminStatus.initial;
  String password = '';
  String username = '';
  String categoryName = '';
  String selCat = '';
  List<String> options = [];
  List<String> listCat = ["Computer Science", "Mathematics", "Physics"];
  final _auth = FirebaseAuth.instance;
  void setStatus(AdminStatus status) {
    status = status;
    notifyListeners();
  }

  final _db = FirebaseFirestore.instance;

  Future<void> addCategory() async {
    try {
      var id = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 7);
      var newCat = CategoryModel(name: categoryName, id: id);
      _db.collection(categoryCollection).doc(id).set(newCat.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      List<String> list = [];
      var data = await _db.collection(categoryCollection).orderBy("name").get();
      for (var element in data.docs) {
        var cat = CategoryModel.fromMap(element.data());
        list.add(cat.name);
      }
      return list;
    } catch (e) {
      rethrow;
    }
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
