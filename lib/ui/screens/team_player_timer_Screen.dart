import 'dart:async';

import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/provider/timer_provider.dart';
import 'package:fairplay/services/hive_service.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/saveCsvToDevice.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TeamPlayerTimerScreen extends StatefulWidget {
  @override
  _TeamPlayerTimerScreenState createState() => _TeamPlayerTimerScreenState();
}

class _TeamPlayerTimerScreenState extends State<TeamPlayerTimerScreen> {
  TeamModel team;
  int key;
  bool sorted;
  List<PlayTimerWidget> activePlayer = [];
  List<PlayTimerWidget> nonRotatingPlayer = [];
  List<PlayTimerWidget> notPlaying = [];
  List<PlayTimerWidget> substitutePlayer = [];

  @override
  void initState() {
    sorted = false;
    Future.delayed(Duration.zero, () {
      setState(() {
        Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
        key = data['key'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService().bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeService().secondary,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Text(
              'LET’S PLAY',
              style: CustomTextStyle()
                  .h3
                  .copyWith(color: ThemeService().secondary),
            ),
            CupertinoButton(
                child: Icon(
                  Icons.settings,
                  color: ThemeService().secondary,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/gameSettings', arguments: key);
                })
          ],
        ),
        backgroundColor: ThemeService().bgColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: HiveService.teamBox.listenable(),
          builder: (context, items, _) {
            activePlayer = [];
            nonRotatingPlayer = [];
            notPlaying = [];
            substitutePlayer = [];
            try {
              if (key != null) {
                team = items.get(key);
                if (team != null) {
                  TimerModel data =
                      Provider.of<TimerProvider>(context).teamTimer[key];
                  var widget;
                  if (sorted) {
                    team.players.forEach((PlayerModel player) {
                      if (data.playersTimerModels[player.playerNO] != null)
                        player.percent =
                            data.playersTimerModels[player.playerNO].percent;
                    });

                    team.players.sort((a, b) => a.percent.compareTo(b.percent));
                  }

                  team.players.forEach((PlayerModel player) {
                    if (data.playersTimerModels[player.playerNO] != null) {
                      widget = PlayTimerWidget(
                        play: Provider.of<TimerProvider>(context)
                                    .getPlayerTimerStatus(key, player) ==
                                TimerCondition.Active
                            ? true
                            : false,
                        totalTime: data.getEachPlayerTimeString(),
                        reamingTime: data.playersTimerModels[player.playerNO]
                            .countDownString,
                        playerName: player.playerName.toUpperCase(),
                        playerNo: player.playerNO.toString(),
                        percentProgress:
                            data.playersTimerModels[player.playerNO].percent,
                        color: Color(
                          int.parse('0xff${team.color}'),
                        ),
                        onIconPressed: () {
                          if (Provider.of<TimerProvider>(context, listen: false)
                                  .getPlayerTimerStatus(key, player) ==
                              TimerCondition.Active) {
                            Provider.of<TimerProvider>(context, listen: false)
                                .pauseSinglePlayer(key, player);
                          } else {
                            Provider.of<TimerProvider>(context, listen: false)
                                .resumeSinglePlayer(key, player);
                          }
                        },
                        onTilePressed: () {
                          Provider.of<TimerProvider>(context, listen: false)
                              .pauseTimers(key);

                          Navigator.pushNamed(context, '/updatePlayerScreen',
                              arguments: {
                                'player': player,
                                'team': items.get(key),
                              });
                        },
                      );
                    } else {
                      widget = PlayTimerWidget(
                        play: player.type == PlayerType.substitute,
                        totalTime: '00:00',
                        reamingTime: '00:00',
                        playerName: player.playerName.toUpperCase(),
                        playerNo: player.playerNO.toString(),
                        percentProgress: 0,
                        color: Color(
                          int.parse('0xff${team.color}'),
                        ),
                        onIconPressed: () {},
                        onTilePressed: () {
                          // Provider.of<TimerProvider>(context).getTimerStatus(index, key);
                          Navigator.pushNamed(context, '/updatePlayerScreen',
                              arguments: {
                                'player': player,
                                'team': items.get(key),
                              });
                        },
                      );
                    }
                    if (player.type == PlayerType.active) {
                      activePlayer.add(widget);
                    }
                    if (player.type == PlayerType.notPlaying) {
                      notPlaying.add(widget);
                    }
                    if (player.type == PlayerType.notRotating) {
                      nonRotatingPlayer.add(widget);
                    }
                    if (player.type == PlayerType.substitute) {
                      substitutePlayer.add(widget);
                    }
                  });
                }
              }
            } catch (e) {
              print(e);
              print('error Occured');
            }

            return Consumer<TimerProvider>(
              builder: (context, timerProviderData, _) {
                List<TimerRoundWidget> segments = [];
                if (key != null)
                  for (int i = 0;
                      i < timerProviderData.teamTimer[key].totalSegments;
                      i++) {
                    segments.add(
                      TimerRoundWidget(
                        roundNumber: i == 0
                            ? 'FIRST'
                            : i == 1
                                ? 'SECOND'
                                : 'THIRD',
                        roundTime:
                            '${timerProviderData.teamTimer[key].timePerSegment < 10 ? 0 : ''}${timerProviderData.teamTimer[key].timePerSegment}:00',
                        roundTimer: timerProviderData
                                        .teamTimer[key].roundsStatus[i] ==
                                    TimerCondition.Active ||
                                timerProviderData
                                        .teamTimer[key].roundsStatus[i] ==
                                    TimerCondition.Pause
                            ? timerProviderData.teamTimer[key].countDownInString
                            : timerProviderData
                                        .teamTimer[key].roundsStatus[i] ==
                                    TimerCondition.Expired
                                ? '${timerProviderData.teamTimer[key].timePerSegment < 10 ? 0 : ''}${timerProviderData.teamTimer[key].timePerSegment}:00'
                                : '00:00',
                        iconData: timerProviderData.getTimerStatus(i, key) ==
                                TimerCondition.Active
                            ? Icons.pause
                            : Icons.play_arrow_rounded,
                        onPlayPaused: () {
                          if (timerProviderData.getTimerStatus(i, key) ==
                              TimerCondition.Active) {
                            timerProviderData.pauseTimers(key);
                          } else {
                            timerProviderData.startTimers(key);
                          }
                        },
                        onStopPressed: i == 0
                            ? () {}
                            : () {
                                timerProviderData.stopTimer(key);
                                showDialog(
                                    barrierColor:
                                        ThemeService().bgColor.withOpacity(.5),
                                    context: context,
                                    builder: (context) =>
                                        saveCsvToDevice(context, key: key));
                              },
                        disable: timerProviderData.getTimerStatus(i, key) ==
                                    TimerCondition.Active ||
                                timerProviderData.getTimerStatus(i, key) ==
                                    TimerCondition.First ||
                                timerProviderData.getTimerStatus(i, key) ==
                                    TimerCondition.Pause
                            ? false
                            : true,
                      ),
                    );
                  }

                return Column(
                  children: [
                    ...segments,
                    if (key != null)
                      NextRotationWidget(
                        time: timerProviderData.getEachRotatingTime(key) ?? '0',
                        sorted: sorted,
                        onPressed: () {
                          setState(() {
                            if (sorted) {
                              sorted = false;
                            } else {
                              sorted = true;
                            }
                          });
                        },
                      ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'ACTIVE PLAYER',
                            style: CustomTextStyle().h3,
                          ),
                        ),
                        ...activePlayer
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'NON ROTATING PLAYER',
                            style: CustomTextStyle().h3,
                          ),
                        ),
                        ...nonRotatingPlayer
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'SUBSTITUTES',
                            style: CustomTextStyle().h3,
                          ),
                        ),
                        ...substitutePlayer
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'NOT PLAYING',
                            style: CustomTextStyle().h3,
                          ),
                        ),
                        ...notPlaying
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          RoundIconButton(
                            iconData: Icons.add,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/playerAddingFromTimerScreen',
                                  arguments: {'team': team});
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'ADD PLAYER',
                            style: CustomTextStyle()
                                .h3
                                .copyWith(color: ThemeService().tertiary),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// todo second stop button should save sample csv to device storage

// todo sort player by least amount of time;
