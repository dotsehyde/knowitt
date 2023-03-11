// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuestionModel {
  final String question;
  final String answer;
  final String category;
  final int duration;
  final int points;
  final int wrongPoints;
  final String? image;
  final List<String> options;
  final DateTime createdAt;
  final String id;
  QuestionModel({
    required this.question,
    required this.answer,
    required this.category,
    required this.duration,
    required this.points,
    required this.wrongPoints,
    this.image,
    required this.options,
    required this.createdAt,
    required this.id,
  });

  QuestionModel copyWith({
    String? question,
    String? answer,
    String? category,
    int? duration,
    int? points,
    int? wrongPoints,
    String? image,
    List<String>? options,
    DateTime? createdAt,
    String? id,
  }) {
    return QuestionModel(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      points: points ?? this.points,
      wrongPoints: wrongPoints ?? this.wrongPoints,
      image: image ?? this.image,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'answer': answer,
      'category': category,
      'duration': duration,
      'points': points,
      'wrongPoints': wrongPoints,
      'image': image,
      'options': options,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory QuestionModel.fromMap(Map map) {
    return QuestionModel(
      question: map['question'] as String,
      answer: map['answer'] as String,
      category: map['category'] as String,
      duration: map['duration'] as int,
      points: map['points'] as int,
      wrongPoints: map['wrongPoints'] as int,
      image: map['image'] != null ? map['image'] as String : null,
      options: List<String>.from(map['options'] as List<dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestionModel(question: $question, answer: $answer, category: $category, duration: $duration, points: $points, wrongPoints: $wrongPoints, image: $image, options: $options, createdAt: $createdAt, id: $id)';
  }

  @override
  bool operator ==(covariant QuestionModel other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        other.answer == answer &&
        other.category == category &&
        other.duration == duration &&
        other.points == points &&
        other.wrongPoints == wrongPoints &&
        other.image == image &&
        listEquals(other.options, options) &&
        other.createdAt == createdAt &&
        other.id == id;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        answer.hashCode ^
        category.hashCode ^
        duration.hashCode ^
        points.hashCode ^
        wrongPoints.hashCode ^
        image.hashCode ^
        options.hashCode ^
        createdAt.hashCode ^
        id.hashCode;
  }
}
