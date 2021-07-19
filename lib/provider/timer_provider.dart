import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/services/hive_service.dart';
import 'package:fairplay/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pausable_timer/pausable_timer.dart';

enum TimerCondition { NotActive, Active, Pause, Expired, First }

class PlayerTimerModel {
  int countDown;
  double percent;

  PausableTimer timer;
  TimerCondition status;
  String countDownString;
}

class TimerModel {
  int totalTime = 40;
  int timePerSegment = 20;
  int totalSegments = 2;
  int currentRound = 0; //todo increasee this when second round is started

  double eachPlayerTime;
  double eachRotationTime = 0;
  String eachRotationTimeString;

  List<PausableTimer> rounds = [];
  List<TimerCondition> roundsStatus;

  Map<int, PlayerTimerModel> playersTimerModels = {};

  String countDownInString;

  String getEachPlayerTimeString() {
    int countDown = (eachPlayerTime * 60).toInt();
    String time;
    String min = (countDown ~/ 60).toString();
    var sec = (countDown % 60).toString();

    if (int.parse(min) < 10) {
      min = min.padLeft(2, '0');
    }
    if (int.parse(sec) < 10) {
      sec = sec.padLeft(2, '0');
    }

    time = "$min:$sec";

    return time;
  }
}

class TimerProvider extends ChangeNotifier {
  bool init = false;
  Map<int, TimerModel> teamTimer = {};

  setMaxActivePlayer(int maxActivePlayer, int key) {
    HiveService.teamBox.get(key).maxActivePlayer = maxActivePlayer;
    HiveService.teamBox.get(key).save();
    setTimers(key: key);
  }

  setTimePerSegment(int timeInMin, int key) {
    teamTimer[key].timePerSegment = timeInMin;
    _calculateTotalTime(key);
    notifyListeners();
  }

  setTotalSegment(int numberOfSegments, int key) {
    teamTimer[key].totalSegments = numberOfSegments;
    _calculateTotalTime(key);
    notifyListeners();
  }

  _calculateTotalTime(int key) {
    teamTimer[key].totalTime =
        teamTimer[key].timePerSegment * teamTimer[key].totalSegments;
    setTimers(key: key);
  }

  _calculateEachPlayerTime(
      int totalTime, int totalPlayers, int activePlayer, int key) {
    teamTimer[key].eachPlayerTime = (totalTime /
        ((totalPlayers -
                HiveService.teamBox
                    .get(key)
                    .players
                    .where((element) => element.type == PlayerType.notRotating)
                    .toList()
                    .length) /
            activePlayer));
  }

  _calculateEachRotation(int key, int totalTime, int totalPlayer) {
    teamTimer[key].eachRotationTime = totalTime /
        (totalPlayer -
            HiveService.teamBox
                .get(key)
                .players
                .where((element) => element.type == PlayerType.notRotating)
                .toList()
                .length);
  }

  _doRotating(key) {
    HiveService.teamBox.get(key).rotation();
    HiveService.teamBox.get(key).activePlayingPlayer.forEach((player) {
      if (player.type == PlayerType.active &&
              teamTimer[key].playersTimerModels[player.playerNO].status ==
                  TimerCondition.NotActive ||
          teamTimer[key].playersTimerModels[player.playerNO].status ==
              TimerCondition.Pause) {
        teamTimer[key].playersTimerModels[player.playerNO].timer.start();
        teamTimer[key].playersTimerModels[player.playerNO].status =
            TimerCondition.Active;
      }
    });
    HiveService.teamBox.get(key).totalRotatingPlayer.forEach((player) {
      if (player.type == PlayerType.substitute ||
          player.type == PlayerType.notPlaying) {
        teamTimer[key].playersTimerModels[player.playerNO].timer.pause();
        teamTimer[key].playersTimerModels[player.playerNO].status =
            TimerCondition.Pause;
      }
    });
  }

  String getEachRotatingTime(int key) {
    return teamTimer[key].eachRotationTimeString;
  }

  setTimers({int key}) {
    if (key != null) {
      teamTimer[key].rounds = [];
      teamTimer[key].roundsStatus =
          List.filled(teamTimer[key].totalSegments, TimerCondition.NotActive);
      teamTimer[key].roundsStatus[0] = TimerCondition.First;
      HiveService().getTeam(key).initRotation();
      _calculateEachPlayerTime(
          teamTimer[key].totalTime,
          HiveService().getTeam(key).players.length,
          HiveService().getTeam(key).maxActivePlayer,
          key);
      _calculateEachRotation(key, teamTimer[key].totalTime,
          HiveService().getTeam(key).players.length);
      int rotationCountDown = (teamTimer[key].eachRotationTime * 60).toInt();

      String rotationMin = (rotationCountDown ~/ 60).toString();
      var rotationSeconds = (rotationCountDown % 60).toString();
      if (int.parse(rotationMin) < 10) {
        rotationMin = rotationMin.padLeft(2, '0');
      }
      if (int.parse(rotationSeconds) < 10) {
        rotationSeconds = rotationSeconds.padLeft(2, '0');
      }
      teamTimer[key].eachRotationTimeString = '$rotationMin:$rotationSeconds';

      //////////////////
      HiveService().getTeam(key).totalRotatingPlayer.forEach((player) {
        PlayerTimerModel playerTimer = PlayerTimerModel()
          ..percent = 100
          ..status = TimerCondition.NotActive
          ..countDownString = teamTimer[key].getEachPlayerTimeString();
        int countDown = (teamTimer[key].eachPlayerTime * 60).toInt();
        PausableTimer timer = PausableTimer(
          Duration(seconds: 1),
          () {
            countDown--;
            teamTimer[key].playersTimerModels[player.playerNO].countDown =
                countDown;
            String playerTimerCountDownMin = (countDown ~/ 60).toString();
            var playerCountDownSecond = (countDown % 60).toString();
            if (int.parse(playerTimerCountDownMin) < 10) {
              playerTimerCountDownMin = playerTimerCountDownMin.padLeft(2, '0');
            }
            if (int.parse(playerCountDownSecond) < 10) {
              playerCountDownSecond = playerCountDownSecond.padLeft(2, '0');
            }
            teamTimer[key].playersTimerModels[player.playerNO].countDownString =
                '$playerTimerCountDownMin:$playerCountDownSecond';
            teamTimer[key].playersTimerModels[player.playerNO].percent =
                (countDown / (teamTimer[key].eachPlayerTime * 60)) * 100;

            if (teamTimer[key].playersTimerModels[player.playerNO].countDown >
                0) {
              teamTimer[key].playersTimerModels[player.playerNO].timer
                ..reset()
                ..start();
            }
            notifyListeners();
          },
        );
        playerTimer.timer = timer;
        teamTimer[key].playersTimerModels[player.playerNO] = playerTimer;
      });

      //////////////////////

      for (int i = 0; i < teamTimer[key].totalSegments; i++) {
        int countDownInSeconds = teamTimer[key].timePerSegment * 60;

        PausableTimer timer = PausableTimer(
          Duration(seconds: 1),
          () {
            teamTimer[key].roundsStatus[i] = TimerCondition.Active;
            countDownInSeconds--;
            rotationCountDown--;

            String rotationMin = (rotationCountDown ~/ 60).toString();
            var rotationSeconds = (rotationCountDown % 60).toString();
            if (int.parse(rotationMin) < 10) {
              rotationMin = rotationMin.padLeft(2, '0');
            }
            if (int.parse(rotationSeconds) < 10) {
              rotationSeconds = rotationSeconds.padLeft(2, '0');
            }

            teamTimer[key].eachRotationTimeString =
                '$rotationMin:$rotationSeconds';
            if (rotationCountDown == 0) {
              NotificationService().showNotification('Rotation Needed',
                  'Please Rotate Players According to the timer');
              _doRotating(key);

              rotationCountDown =
                  (teamTimer[key].eachRotationTime * 60).toInt();
            }
            if (countDownInSeconds > 0) {
              teamTimer[key].rounds[i]
                ..reset()
                ..start();
            }
            int esclipedTime =
                ((teamTimer[key].timePerSegment * 60) - countDownInSeconds);

            String min = (esclipedTime ~/ 60).toString();
            var seconds = (esclipedTime % 60).toString();
            if (int.parse(min) < 10) {
              min = min.padLeft(2, '0');
            }
            if (int.parse(seconds) < 10) {
              seconds = seconds.padLeft(2, '0');
            }

            teamTimer[key].countDownInString = "$min:$seconds";
            notifyListeners();
            if (teamTimer[key].rounds[i].isExpired) {
              teamTimer[key].roundsStatus[i] = TimerCondition.Expired;
              if (i != teamTimer[key].totalSegments - 1) {
                countDownInSeconds = teamTimer[key].timePerSegment * 60;
                esclipedTime =
                    ((teamTimer[key].timePerSegment * 60) - countDownInSeconds);
                String min = (esclipedTime ~/ 60).toString();
                var seconds = (esclipedTime % 60).toString();
                if (int.parse(min) < 10) {
                  min = min.padLeft(2, '0');
                }
                if (int.parse(seconds) < 10) {
                  seconds = seconds.padLeft(2, '0');
                }
                teamTimer[key].countDownInString = "$min:$seconds";
                HiveService.teamBox
                    .get(key)
                    .activePlayingPlayer
                    .forEach((player) {
                  teamTimer[key]
                      .playersTimerModels[player.playerNO]
                      .timer
                      .pause();
                });
                teamTimer[key].roundsStatus[i + 1] = TimerCondition.Pause;
                notifyListeners();
              } else {
                NotificationService().showFullScreenNotification();
              }
            }
          },
        );
        teamTimer[key].rounds.add(timer);
      }
      return;
    }
    if (!init) {
      init = true;
      HiveService.teamBox.values.toList().asMap().forEach((key, value) {
        teamTimer[key] = TimerModel();
        teamTimer[key].roundsStatus =
            List.filled(teamTimer[key].totalSegments, TimerCondition.NotActive);
        teamTimer[key].roundsStatus[0] = TimerCondition.First;
        int countDownInSeconds = teamTimer[key].timePerSegment * 60;

        HiveService().getTeam(key).initRotation();

        _calculateEachPlayerTime(
            teamTimer[key].totalTime,
            HiveService().getTeam(key).players.length,
            HiveService().getTeam(key).maxActivePlayer,
            key);
        _calculateEachRotation(key, teamTimer[key].totalTime,
            HiveService().getTeam(key).players.length);

        //////////////////////
        int rotationCountDown = (teamTimer[key].eachRotationTime * 60).toInt();
        String rotationMin = (rotationCountDown ~/ 60).toString();
        var rotationSeconds = (rotationCountDown % 60).toString();
        if (int.parse(rotationMin) < 10) {
          rotationMin = rotationMin.padLeft(2, '0');
        }
        if (int.parse(rotationSeconds) < 10) {
          rotationSeconds = rotationSeconds.padLeft(2, '0');
        }
        teamTimer[key].eachRotationTimeString = '$rotationMin:$rotationSeconds';

        //////////////////
        HiveService().getTeam(key).totalRotatingPlayer.forEach((player) {
          PlayerTimerModel playerTimer = PlayerTimerModel()
            ..percent = 100
            ..status = TimerCondition.NotActive
            ..countDownString = teamTimer[key].getEachPlayerTimeString();
          int countDown = (teamTimer[key].eachPlayerTime * 60).toInt();
          PausableTimer timer = PausableTimer(
            Duration(seconds: 1),
            () {
              countDown--;
              teamTimer[key].playersTimerModels[player.playerNO].countDown =
                  countDown;
              String playerTimerCountDownMin = (countDown ~/ 60).toString();
              var playerCountDownSecond = (countDown % 60).toString();
              if (int.parse(playerTimerCountDownMin) < 10) {
                playerTimerCountDownMin =
                    playerTimerCountDownMin.padLeft(2, '0');
              }
              if (int.parse(playerCountDownSecond) < 10) {
                playerCountDownSecond = playerCountDownSecond.padLeft(2, '0');
              }
              teamTimer[key]
                      .playersTimerModels[player.playerNO]
                      .countDownString =
                  '$playerTimerCountDownMin:$playerCountDownSecond';
              teamTimer[key].playersTimerModels[player.playerNO].percent =
                  (countDown / (teamTimer[key].eachPlayerTime * 60)) * 100;

              if (teamTimer[key].playersTimerModels[player.playerNO].countDown >
                  0) {
                teamTimer[key].playersTimerModels[player.playerNO].timer
                  ..reset()
                  ..start();
              }
              notifyListeners();
            },
          );
          playerTimer.timer = timer;
          teamTimer[key].playersTimerModels[player.playerNO] = playerTimer;
        });
        for (int i = 0; i < teamTimer[key].totalSegments; i++) {
          teamTimer[key].rounds.add(PausableTimer(
                Duration(seconds: 1),
                () {
                  teamTimer[key].roundsStatus[i] = TimerCondition.Active;
                  countDownInSeconds--;
                  rotationCountDown--;

                  String rotationMin = (rotationCountDown ~/ 60).toString();
                  String rotationSeconds = (rotationCountDown % 60).toString();

                  if (int.parse(rotationMin) < 10) {
                    rotationMin = rotationMin.padLeft(2, '0');
                  }
                  if (int.parse(rotationSeconds) < 10) {
                    rotationSeconds = rotationSeconds.padLeft(2, '0');
                  }

                  teamTimer[key].eachRotationTimeString =
                      '$rotationMin:$rotationSeconds';

                  if (rotationCountDown == 0) {
                    NotificationService().showNotification('Rotation Needed',
                        'Please Rotate Players According to the timer');

                    _doRotating(key);

                    rotationCountDown =
                        (teamTimer[key].eachRotationTime * 60).toInt();
                  }
                  if (countDownInSeconds > 0) {
                    teamTimer[key].rounds[i]
                      ..reset()
                      ..start();
                  }

                  int roundEsclipedTime =
                      ((teamTimer[key].timePerSegment * 60) -
                          countDownInSeconds);
                  String roundMin = (roundEsclipedTime ~/ 60).toString();
                  var roundSeconds = (roundEsclipedTime % 60).toString();
                  if (int.parse(roundMin) < 10) {
                    roundMin = roundMin.padLeft(2, '0');
                  }
                  if (int.parse(roundSeconds) < 10) {
                    roundSeconds = roundSeconds.padLeft(2, '0');
                  }

                  teamTimer[key].countDownInString = "$roundMin:$roundSeconds";

                  notifyListeners();
                  if (teamTimer[key].rounds[i].isExpired) {
                    teamTimer[key].roundsStatus[i] = TimerCondition.Expired;
                    if (i != teamTimer[key].totalSegments - 1) {
                      countDownInSeconds = teamTimer[key].timePerSegment * 60;
                      roundEsclipedTime =
                          ((teamTimer[key].timePerSegment * 60) -
                              countDownInSeconds);
                      String min = (roundEsclipedTime ~/ 60).toString();
                      var seconds = (roundEsclipedTime % 60).toString();
                      if (int.parse(min) < 10) {
                        min = min.padLeft(2, '0');
                      }
                      if (int.parse(seconds) < 10) {
                        seconds = seconds.padLeft(2, '0');
                      }
                      teamTimer[key].countDownInString = "$min:$seconds";
                      HiveService.teamBox
                          .get(key)
                          .activePlayingPlayer
                          .forEach((player) {
                        teamTimer[key]
                            .playersTimerModels[player.playerNO]
                            .timer
                            .pause();
                      });
                      teamTimer[key].roundsStatus[i + 1] = TimerCondition.Pause;
                      notifyListeners();
                    } else {
                      HiveService.teamBox
                          .get(key)
                          .activePlayingPlayer
                          .forEach((player) {
                        teamTimer[key]
                            .playersTimerModels[player.playerNO]
                            .timer
                            .cancel();
                      });
                      NotificationService().showFullScreenNotification();
                    }
                  }
                },
              ));
        }
      });
    }
  }

  addNewTimerForNewlyAddedTeam(int key, context) {
    teamTimer[key] = TimerModel();
    teamTimer[key].roundsStatus =
        List.filled(teamTimer[key].totalSegments, TimerCondition.NotActive);
    teamTimer[key].roundsStatus[0] = TimerCondition.First;
    HiveService().getTeam(key).initRotation();

    _calculateEachPlayerTime(
        teamTimer[key].totalTime,
        HiveService().getTeam(key).players.length,
        HiveService().getTeam(key).maxActivePlayer,
        key);
    _calculateEachRotation(key, teamTimer[key].totalTime,
        HiveService().getTeam(key).players.length);
    int countDownInSeconds = teamTimer[key].timePerSegment * 60;

    int rotationCountDown = (teamTimer[key].eachRotationTime * 60).toInt();
    String rotationMin = (rotationCountDown ~/ 60).toString();
    var rotationSeconds = (rotationCountDown % 60).toString();
    if (int.parse(rotationMin) < 10) {
      rotationMin = rotationMin.padLeft(2, '0');
    }
    if (int.parse(rotationSeconds) < 10) {
      rotationSeconds = rotationSeconds.padLeft(2, '0');
    }
    teamTimer[key].eachRotationTimeString = '$rotationMin:$rotationSeconds';
    HiveService().getTeam(key).totalRotatingPlayer.forEach((player) {
      PlayerTimerModel playerTimer = PlayerTimerModel()
        ..percent = 100
        ..status = TimerCondition.NotActive
        ..countDownString = teamTimer[key].getEachPlayerTimeString();
      int countDown = (teamTimer[key].eachPlayerTime * 60).toInt();
      PausableTimer timer = PausableTimer(
        Duration(seconds: 1),
        () {
          countDown--;
          teamTimer[key].playersTimerModels[player.playerNO].countDown =
              countDown;
          String playerTimerCountDownMin = (countDown ~/ 60).toString();
          var playerCountDownSecond = (countDown % 60).toString();
          if (int.parse(playerTimerCountDownMin) < 10) {
            playerTimerCountDownMin = playerTimerCountDownMin.padLeft(2, '0');
          }
          if (int.parse(playerCountDownSecond) < 10) {
            playerCountDownSecond = playerCountDownSecond.padLeft(2, '0');
          }
          teamTimer[key].playersTimerModels[player.playerNO].countDownString =
              '$playerTimerCountDownMin:$playerCountDownSecond';
          teamTimer[key].playersTimerModels[player.playerNO].percent =
              (countDown / (teamTimer[key].eachPlayerTime * 60)) * 100;

          if (teamTimer[key].playersTimerModels[player.playerNO].countDown >
              0) {
            teamTimer[key].playersTimerModels[player.playerNO].timer
              ..reset()
              ..start();
          }
          notifyListeners();
        },
      );
      playerTimer.timer = timer;
      teamTimer[key].playersTimerModels[player.playerNO] = playerTimer;
    });

    for (int i = 0; i < teamTimer[key].totalSegments; i++) {
      teamTimer[key].rounds.add(PausableTimer(
            Duration(seconds: 1),
            () {
              teamTimer[key].roundsStatus[i] = TimerCondition.Active;
              countDownInSeconds--;
              rotationCountDown--;

              String rotationMin = (rotationCountDown ~/ 60).toString();
              String rotationSeconds = (rotationCountDown % 60).toString();

              if (int.parse(rotationMin) < 10) {
                rotationMin = rotationMin.padLeft(2, '0');
              }
              if (int.parse(rotationSeconds) < 10) {
                rotationSeconds = rotationSeconds.padLeft(2, '0');
              }

              teamTimer[key].eachRotationTimeString =
                  '$rotationMin:$rotationSeconds';

              if (rotationCountDown == 0) {
                NotificationService().showNotification('Rotation Needed',
                    'Please Rotate Players According to the timer');

                rotationCountDown =
                    (teamTimer[key].eachRotationTime * 60).toInt();
                _doRotating(key);
              }
              if (countDownInSeconds > 0) {
                teamTimer[key].rounds[i]
                  ..reset()
                  ..start();
              }
              int esclipedTime =
                  ((teamTimer[key].timePerSegment * 60) - countDownInSeconds);
              String min = (esclipedTime ~/ 60).toString();
              var seconds = (esclipedTime % 60).toString();
              if (int.parse(min) < 10) {
                min = min.padLeft(2, '0');
              }
              if (int.parse(seconds) < 10) {
                seconds = seconds.padLeft(2, '0');
              }

              teamTimer[key].countDownInString = "$min:$seconds";
              notifyListeners();
              if (teamTimer[key].rounds[i].isExpired) {
                teamTimer[key].roundsStatus[i] = TimerCondition.Expired;
                if (i != teamTimer[key].totalSegments - 1) {
                  countDownInSeconds = teamTimer[key].timePerSegment * 60;
                  esclipedTime = ((teamTimer[key].timePerSegment * 60) -
                      countDownInSeconds);
                  String min = (esclipedTime ~/ 60).toString();
                  var seconds = (esclipedTime % 60).toString();
                  if (int.parse(min) < 10) {
                    min = min.padLeft(2, '0');
                  }
                  if (int.parse(seconds) < 10) {
                    seconds = seconds.padLeft(2, '0');
                  }
                  teamTimer[key].countDownInString = "$min:$seconds";

                  HiveService.teamBox
                      .get(key)
                      .activePlayingPlayer
                      .forEach((player) {
                    teamTimer[key]
                        .playersTimerModels[player.playerNO]
                        .timer
                        .pause();
                  });
                  teamTimer[key].roundsStatus[i + 1] = TimerCondition.Pause;
                  notifyListeners();
                } else {
                  NotificationService().showFullScreenNotification();
                }
              }
            },
          ));
    }
  }

  startTimers(int key) {
    int index = teamTimer[key]
        .roundsStatus
        .indexWhere((element) => element == TimerCondition.Pause);
    if (index == -1) {
      index = teamTimer[key]
          .roundsStatus
          .indexWhere((element) => element == TimerCondition.First);
    }

    teamTimer[key].rounds[index].start();
    HiveService.teamBox.get(key).activePlayingPlayer.forEach((player) {
      teamTimer[key].playersTimerModels[player.playerNO].timer.start();
      teamTimer[key].playersTimerModels[player.playerNO].status =
          TimerCondition.Active;
    });
  }

  pauseTimers(int key) {
    int index = teamTimer[key]
        .roundsStatus
        .indexWhere((element) => element == TimerCondition.Active);
    teamTimer[key].roundsStatus[index] = TimerCondition.Pause;
    teamTimer[key].rounds[index].pause();
    HiveService.teamBox.get(key).activePlayingPlayer.forEach((player) {
      teamTimer[key].playersTimerModels[player.playerNO].timer.pause();
      teamTimer[key].playersTimerModels[player.playerNO].status =
          TimerCondition.Pause;
    });
    notifyListeners();
  }

  pauseSinglePlayer(int key, PlayerModel player) {
    teamTimer[key].playersTimerModels[player.playerNO].timer.pause();
    teamTimer[key].playersTimerModels[player.playerNO].status =
        TimerCondition.Pause;
  }

  resumeSinglePlayer(int key, PlayerModel player) {
    teamTimer[key].playersTimerModels[player.playerNO].timer.start();
    teamTimer[key].playersTimerModels[player.playerNO].status =
        TimerCondition.Active;
  }

  TimerCondition getPlayerTimerStatus(int key, PlayerModel player) {
    return teamTimer[key].playersTimerModels[player.playerNO].status;
  }

  resumeTimer(int key) {
    int index = teamTimer[key]
        .roundsStatus
        .indexWhere((element) => element == TimerCondition.Pause);
    teamTimer[key].rounds[index].start();
    HiveService.teamBox.get(key).activePlayingPlayer.forEach((player) {
      teamTimer[key].playersTimerModels[player.playerNO].timer.start();
    });
  }

  stopTimer(int key) {
    int index = teamTimer[key].roundsStatus.indexWhere((element) =>
        element == TimerCondition.Active || element == TimerCondition.Pause);
    teamTimer[key].rounds[index].cancel();
    HiveService.teamBox.get(key).activePlayingPlayer.forEach((player) {
      teamTimer[key].playersTimerModels[player.playerNO].timer.cancel();
    });
  }

  getTimerStatus(int index, int key) {
    return teamTimer[key].roundsStatus[index];
  }
}
