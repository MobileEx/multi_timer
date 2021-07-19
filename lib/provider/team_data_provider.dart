import 'package:flutter/cupertino.dart';

import '../models/player_model.dart';

class TeamDataProvider extends ChangeNotifier {
  List<PlayerModel> _player = [];

  addPlayer(PlayerModel player) {
    _player.add(player);
    notifyListeners();
  }

  removePlayer(player) {
    _player.remove(player);
    notifyListeners();
  }

  List<PlayerModel> get player => _player;
}
