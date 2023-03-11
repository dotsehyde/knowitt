import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

final isWebMobile = kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

const String appName = "Know Itt";
const String userCollection = "Users";
const String questionCollection = "Questions";
const String categoryCollection = "Categories";
const String adminCollection = "Admins";

const List<String> initLoadingText = [
  "Visiting the library...",
  "Reading the dictionary...",
  "Looking for the questions...",
  "Searching the internet...",
  "Asking the professors...",
  "Asking the students...",
  "Asking your friends...",
  "Asking your family...",
  "A moment of silence...",
];

const List<String> resultLoadingText = [
  "Let see what we have here...",
  "Compiling your results...",
  "Analyzing your answers...",
  "Calculating your score...",
  "Do you think yo did great?...",
];

String count(int value) {
  return NumberFormat.compact(locale: "en_US").format(value);
}

String moneyCount(int value) {
  return NumberFormat("###,###", "en_US").format(value);
}
