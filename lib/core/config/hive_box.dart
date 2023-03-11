import 'package:hive_flutter/hive_flutter.dart';
import 'package:knowitt/model/user.dart';

const String userBox = "user";

class LocalDB {
  static init() async {
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>(userBox);
  }

  static Box<UserModel> get localUser => Hive.box<UserModel>(userBox);
}
