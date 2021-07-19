// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerTypeAdapter extends TypeAdapter<PlayerType> {
  @override
  final int typeId = 2;

  @override
  PlayerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlayerType.active;
      case 1:
        return PlayerType.notPlaying;
      case 2:
        return PlayerType.substitute;
      case 3:
        return PlayerType.notRotating;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, PlayerType obj) {
    switch (obj) {
      case PlayerType.active:
        writer.writeByte(0);
        break;
      case PlayerType.notPlaying:
        writer.writeByte(1);
        break;
      case PlayerType.substitute:
        writer.writeByte(2);
        break;
      case PlayerType.notRotating:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerModelAdapter extends TypeAdapter<PlayerModel> {
  @override
  final int typeId = 1;

  @override
  PlayerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerModel(
      playerNO: fields[0] as int,
      playerName: fields[1] as String,
      type: fields[2] as PlayerType,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.playerNO)
      ..writeByte(1)
      ..write(obj.playerName)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
