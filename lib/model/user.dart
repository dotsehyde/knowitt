import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
part 'user.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String nickname;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final int score;
  @HiveField(4)
  final int questionsAnswered;
  @HiveField(5)
  final int questionsCorrect;
  @HiveField(6)
  final int questionsWrong;
  @HiveField(7)
  final String sid;
  @HiveField(8)
  final String fcmToken;
  @HiveField(9)
  final String? avatar;
  @HiveField(10)
  final List<String> badges;
  @HiveField(11)
  final bool isOnline;
  @HiveField(12)
  final DateTime lastSeen;
  @HiveField(13)
  final DateTime createdAt;
  @HiveField(14)
  final String uid;
  @HiveField(15)
  final String platform;
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
    required this.platform,
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
    String? platform,
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
      platform: platform ?? this.platform,
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
      'platform': platform,
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
      badges: List<String>.from(map['badges'] as List<dynamic>),
      isOnline: map['isOnline'] as bool,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      uid: map['uid'] as String,
      platform: map['platform'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, nickname: $nickname, email: $email, score: $score, questionsAnswered: $questionsAnswered, questionsCorrect: $questionsCorrect, questionsWrong: $questionsWrong, sid: $sid, fcmToken: $fcmToken, avatar: $avatar, badges: $badges, isOnline: $isOnline, lastSeen: $lastSeen, createdAt: $createdAt, uid: $uid, platform: $platform)';
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
        other.uid == uid &&
        other.platform == platform;
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
        uid.hashCode ^
        platform.hashCode;
  }
}
