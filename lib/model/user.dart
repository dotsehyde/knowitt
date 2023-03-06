import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String username;
  final String nickname;
  final String email;
  final int score;
  final int questionsAnswered;
  final int questionsCorrect;
  final int questionsWrong;
  final String sid;
  final String fcmToken;
  final String? avatar;
  final List<String> badges;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final String uid;
  UserModel({
    required this.username,
    required this.nickname,
    required this.email,
    required this.score,
    required this.questionsAnswered,
    required this.questionsCorrect,
    required this.questionsWrong,
    required this.sid,
    required this.fcmToken,
    this.avatar,
    required this.badges,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
    required this.uid,
  });

  UserModel copyWith({
    String? username,
    String? nickname,
    String? email,
    int? score,
    int? questionsAnswered,
    int? questionsCorrect,
    int? questionsWrong,
    String? sid,
    String? fcmToken,
    String? avatar,
    List<String>? badges,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    String? uid,
  }) {
    return UserModel(
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      score: score ?? this.score,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      questionsCorrect: questionsCorrect ?? this.questionsCorrect,
      questionsWrong: questionsWrong ?? this.questionsWrong,
      sid: sid ?? this.sid,
      fcmToken: fcmToken ?? this.fcmToken,
      avatar: avatar ?? this.avatar,
      badges: badges ?? this.badges,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'nickname': nickname,
      'email': email,
      'score': score,
      'questionsAnswered': questionsAnswered,
      'questionsCorrect': questionsCorrect,
      'questionsWrong': questionsWrong,
      'sid': sid,
      'fcmToken': fcmToken,
      'avatar': avatar,
      'badges': badges,
      'isOnline': isOnline,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      nickname: map['nickname'] as String,
      email: map['email'] as String,
      score: map['score'] as int,
      questionsAnswered: map['questionsAnswered'] as int,
      questionsCorrect: map['questionsCorrect'] as int,
      questionsWrong: map['questionsWrong'] as int,
      sid: map['sid'] as String,
      fcmToken: map['fcmToken'] as String,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      badges: List<String>.from(map['badges'] as List<String>),
      isOnline: map['isOnline'] as bool,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, nickname: $nickname, email: $email, score: $score, questionsAnswered: $questionsAnswered, questionsCorrect: $questionsCorrect, questionsWrong: $questionsWrong, sid: $sid, fcmToken: $fcmToken, avatar: $avatar, badges: $badges, isOnline: $isOnline, lastSeen: $lastSeen, createdAt: $createdAt, uid: $uid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.nickname == nickname &&
        other.email == email &&
        other.score == score &&
        other.questionsAnswered == questionsAnswered &&
        other.questionsCorrect == questionsCorrect &&
        other.questionsWrong == questionsWrong &&
        other.sid == sid &&
        other.fcmToken == fcmToken &&
        other.avatar == avatar &&
        listEquals(other.badges, badges) &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen &&
        other.createdAt == createdAt &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        nickname.hashCode ^
        email.hashCode ^
        score.hashCode ^
        questionsAnswered.hashCode ^
        questionsCorrect.hashCode ^
        questionsWrong.hashCode ^
        sid.hashCode ^
        fcmToken.hashCode ^
        avatar.hashCode ^
        badges.hashCode ^
        isOnline.hashCode ^
        lastSeen.hashCode ^
        createdAt.hashCode ^
        uid.hashCode;
  }
}
