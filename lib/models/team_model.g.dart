// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamModelAdapter extends TypeAdapter<TeamModel> {
  @override
  final int typeId = 0;

  @override
  TeamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamModel(
      teamName: fields[0] as String,
      color: fields[1] as String,
      logoPath: fields[2] as String,
      players: (fields[3] as List)?.cast<PlayerModel>(),
      maxActivePlayer: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TeamModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.teamName)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.logoPath)
      ..writeByte(3)
      ..write(obj.players)
      ..writeByte(4)
      ..write(obj.maxActivePlayer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
