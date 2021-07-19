import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/provider/team_data_provider.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/player_no_dialog.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AddingPlayerFromTimerScreen extends StatefulWidget {
  @override
  _AddingPlayerFromTimerScreenState createState() => _AddingPlayerFromTimerScreenState();
}

class _AddingPlayerFromTimerScreenState extends State<AddingPlayerFromTimerScreen> {
  TextEditingController _controller = TextEditingController();

  PlayerModel player;
  TeamModel team;
  bool _substitute = false;
  bool _notPlaying = false;
  bool _nonRotating = false;
  bool playerAdded;

  checkIfActivePlayer() {
    if (!_substitute && !_nonRotating && !_notPlaying) {
      player.type = PlayerType.active;
    }
  }

  @override
  void initState() {
    playerAdded = false;
    player = PlayerModel()..type = PlayerType.active;
    Future.delayed(Duration.zero, () {
      team = (ModalRoute.of(context).settings.arguments as Map<String, dynamic>)['team'];
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
                padding: EdgeInsets.all(0),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 25,
                  color: ThemeService().secondary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'ADD PLAYERS',
                style: CustomTextStyle().h3,
              ),
              CustomTextButton(
                buttonText: 'DONE',
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          backgroundColor: ThemeService().bgColor,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: double.infinity,
          width: double.infinity,
          color: ThemeService().tertiary.withOpacity(.1),
          // child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),

                /*Player Number Start*/
                CupertinoButton(
                  onPressed: () {
                    showDialog(
                        barrierColor: ThemeService().bgColor.withOpacity(.5),
                        context: context,
                        builder: (context) => playerNoDialog(context,
                                no: player.playerNO != null ? player.playerNO.toString() : '',
                                onChange: (v) {
                              setState(() {
                                if (v != '') {
                                  player.playerNO = int.parse(v);
                                }
                              });
                            }));
                  },
                  padding: EdgeInsets.all(0),
                  child: Container(
                    child: Center(
                        child: playerAdded
                            ? Icon(
                                Icons.check,
                                color: ThemeService().bgColor,
                                size: 40,
                              )
                            : Text(
                                player.playerNO != null ? player.playerNO.toString() : '#',
                                style: TextStyle(fontSize: 52, color: ThemeService().bgColor),
                              )),
                    height: 102,
                    width: 102,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: playerAdded ? ThemeService().success : ThemeService().tertiary),
                  ),
                )
                /*Player Number End*/,
                SizedBox(
                  height: 20,
                ),

                /*Player name field start*/
                CustomTextField(
                  hintText: 'Player Name',
                  controller: _controller,
                  onChanged: (v) {
                    player.playerName = v;
                  },
                ),
                /*Player name field end*/

                SizedBox(
                  height: 5,
                ),

                /*Switch Section Start*/
                CustomSwitchTile(
                  title: 'Non-Rotating',
                  switchValue: _nonRotating,
                  onChange: (v) {
                    setState(() {
                      _nonRotating = v;
                    });
                    if (v) {
                      player.type = PlayerType.notRotating;
                    }
                    checkIfActivePlayer();
                  },
                ),
                CustomSwitchTile(
                  title: 'Starting Substitute',
                  switchValue: _substitute,
                  onChange: (v) {
                    setState(() {
                      _substitute = v;
                    });
                    if (v) {
                      player.type = PlayerType.substitute;
                    }
                    checkIfActivePlayer();
                  },
                ),
                CustomSwitchTile(
                  title: 'Not playing',
                  switchValue: _notPlaying,
                  onChange: (v) {
                    setState(() {
                      _notPlaying = v;
                    });
                    if (v) {
                      player.type = PlayerType.notPlaying;
                    }
                    checkIfActivePlayer();
                  },
                ),
                /*Switch Section End*/

                SizedBox(
                  height: 25,
                ),

                /*Save and Next Button Start*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                      height: 40,
                      width: 96,
                      padding: false,
                      buttonText: 'SAVE',
                      outlineButton: playerAdded,
                      onPressed: playerAdded ? null : _save,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    PrimaryButton(
                      height: 40,
                      width: 96,
                      padding: false,
                      buttonText: 'NEXT',
                      outlineButton: !playerAdded,
                      onPressed: !playerAdded ? null : _next,
                    )
                  ],
                )
                /*Save and Next Button End*/
              ],
            ),
          ),
          // ),
        ));
  }

  void _save() {
    if (player.playerNO == null) {
      EasyLoading.showInfo('Please enter player number');
      return;
    } else {
      if (playerNoExistCheck(context, player)) {
        EasyLoading.showInfo('Player number must not be unique');
        return;
      }
      if (player.playerName == null) {
        EasyLoading.showInfo('Player name must not be null');
        return;
      } else {
        if (player.playerName.length > 12) {
          EasyLoading.showInfo('Player name must not be less than 12 charc');
          return;
        }
        team.players.add(player);
        team.save();
        setState(() {
          playerAdded = true;
        });
      }
    }
  }

  void _next() {
    setState(() {
      _controller.clear();
      player.playerNO = null;
      player.type = null;
      playerAdded = false;
    });
  }

  bool playerNoExistCheck(context, player) {
    bool duplicate = false;
    Provider.of<TeamDataProvider>(context, listen: false).player.forEach((existingPlayer) {
      if (existingPlayer.playerNO == player.playerNO) {
        print('duplicate found');
        duplicate = true;
      }
    });
    return duplicate;
  }
}
