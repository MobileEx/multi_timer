import 'package:fairplay/models/player_model.dart';
import 'package:hive/hive.dart';

part 'team_model.g.dart';

@HiveType(typeId: 0)
class TeamModel extends HiveObject {
  @HiveField(0)
  String teamName;
  @HiveField(1)
  String color;
  @HiveField(2)
  String logoPath;
  @HiveField(3)
  List<PlayerModel> players;
  @HiveField(4)
  int maxActivePlayer = 8;

  List<PlayerModel> totalRotatingPlayer = [];
  List<PlayerModel> activePlayingPlayer = [];

  TeamModel({
    this.teamName,
    this.color,
    this.logoPath,
    this.players,
    this.maxActivePlayer,
  });

  initRotation() {
    activePlayingPlayer = [];
    totalRotatingPlayer = [];
    print(players);
    players.forEach((player) {
      if (player.type != PlayerType.notRotating && player.type != PlayerType.notPlaying) {
        totalRotatingPlayer.add(player);
      }
      if (player.type == PlayerType.active) activePlayingPlayer.add(player);
    });
    maxActivePlayer = activePlayingPlayer.length;
  }

  rotation() {
    refreshQueue();
    for (int i = 0; i < activePlayingPlayer.length; i++) {
      PlayerModel temp = totalRotatingPlayer[i];
      temp.type = PlayerType.active;
      activePlayingPlayer[i] = temp;
    }
    print(activePlayingPlayer);
  }

  refreshQueue() {
    for (int i = 0; i < activePlayingPlayer.length; i++) {
      PlayerModel temp = totalRotatingPlayer.removeAt(0);
      temp.type = PlayerType.substitute;
      totalRotatingPlayer.add(temp);
    }
    print(totalRotatingPlayer);
  }

  // getNotRotatingPlayer() {
  //   players.forEach((player) {
  //     if (player.type == PlayerType.notRotating) {
  //       notRotatingPlayer.add(player);
  //     }
  //     if (player.type == PlayerType.notPlaying) {
  //       notPlayingPlayer.add(player);
  //     }
  //   });
  // }
}
