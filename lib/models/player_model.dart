import 'package:hive/hive.dart';

part 'player_model.g.dart';

@HiveType(typeId: 1)
class PlayerModel extends HiveObject {
  @HiveField(0)
  int playerNO;
  @HiveField(1)
  String playerName;
  @HiveField(2)
  PlayerType type;

  double percent = 0;
  PlayerModel({this.playerNO, this.playerName, this.type});
}

@HiveType(typeId: 2)
enum PlayerType {
  @HiveField(0)
  active,
  @HiveField(1)
  notPlaying,
  @HiveField(2)
  substitute,
  @HiveField(3)
  notRotating,
}
