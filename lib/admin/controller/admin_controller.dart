import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/model/category.dart';
import 'package:knowitt/model/question.dart';

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
  String question = '';
  String correctAnswer = '';
  int correctPoints = 0;
  int wrongPoints = 0;
  int duration = 0;
  List<String> options = [];
  List<String> listCat = [];
  final _auth = FirebaseAuth.instance;
  void setStatus(AdminStatus status) {
    status = status;
    notifyListeners();
  }

  final _db = FirebaseFirestore.instance;

//delete question
  Future<void> deleteQuestion(String id) async {
    try {
      await _db.collection(questionCollection).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  //delete category
  Future<void> deleteCategory(String id) async {
    try {
      await _db.collection(categoryCollection).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addQuestion() async {
    try {
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      var newQuestion = QuestionModel(
          createdAt: DateTime.now(),
          id: id,
          question: question,
          answer: correctAnswer,
          points: correctPoints,
          wrongPoints: wrongPoints,
          duration: duration,
          options: options,
          category: selCat);
      _db.collection(questionCollection).doc(id).set(newQuestion.toMap());
    } catch (e) {
      rethrow;
    }
  }

//update question
  Future<void> updateQuestion(String id) async {
    try {
      var newQuestion = QuestionModel(
          createdAt: DateTime.now(),
          id: id,
          question: question,
          answer: correctAnswer,
          points: correctPoints,
          wrongPoints: wrongPoints,
          duration: duration,
          options: options,
          category: selCat);
      _db.collection(questionCollection).doc(id).update(newQuestion.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCategory() async {
    try {
      var id = DateTime.now().millisecondsSinceEpoch.toString();
      var newCat = CategoryModel(name: categoryName.toLowerCase(), id: id);
      _db.collection(categoryCollection).doc(id).set(newCat.toMap());
      listCat.clear();
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
      listCat.addAll(list);
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
