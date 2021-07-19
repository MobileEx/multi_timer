import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/static_data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static Box<TeamModel> teamBox = Hive.box<TeamModel>(StaticData.DATABASE_NAME);

  Future<void> init() async {
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    Hive.registerAdapter(TeamModelAdapter());
    Hive.registerAdapter(PlayerModelAdapter());
    Hive.registerAdapter(PlayerTypeAdapter());
    await Hive.openBox<TeamModel>(StaticData.DATABASE_NAME);
    teamBox = Hive.box<TeamModel>(StaticData.DATABASE_NAME);
  }

  Future<int> writeToStorage(TeamModel team) async {
    await Hive.openBox<TeamModel>(StaticData.DATABASE_NAME);
    int key = await teamBox.add(team);
    print(key);
    await team.save();
    return key;
  }

  TeamModel getTeam(dynamic key) {
    Hive.openBox<TeamModel>(StaticData.DATABASE_NAME);
    return teamBox.get(key);
  }
}
