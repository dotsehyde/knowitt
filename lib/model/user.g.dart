// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      username: fields[0] as String,
      nickname: fields[1] as String,
      email: fields[2] as String,
      score: fields[3] as int,
      questionsAnswered: fields[4] as int,
      questionsCorrect: fields[5] as int,
      questionsWrong: fields[6] as int,
      sid: fields[7] as String,
      fcmToken: fields[8] as String,
      avatar: fields[9] as String?,
      badges: (fields[10] as List).cast<String>(),
      isOnline: fields[11] as bool,
      lastSeen: fields[12] as DateTime,
      createdAt: fields[13] as DateTime,
      uid: fields[14] as String,
      platform: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.questionsAnswered)
      ..writeByte(5)
      ..write(obj.questionsCorrect)
      ..writeByte(6)
      ..write(obj.questionsWrong)
      ..writeByte(7)
      ..write(obj.sid)
      ..writeByte(8)
      ..write(obj.fcmToken)
      ..writeByte(9)
      ..write(obj.avatar)
      ..writeByte(10)
      ..write(obj.badges)
      ..writeByte(11)
      ..write(obj.isOnline)
      ..writeByte(12)
      ..write(obj.lastSeen)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.uid)
      ..writeByte(15)
      ..write(obj.platform);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
