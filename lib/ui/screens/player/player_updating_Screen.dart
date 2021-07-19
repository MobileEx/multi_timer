import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/player_no_dialog.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UpdatePlayerScreen extends StatefulWidget {
  @override
  _UpdatePlayerScreenState createState() => _UpdatePlayerScreenState();
}

class _UpdatePlayerScreenState extends State<UpdatePlayerScreen> {
  TextEditingController _controller = TextEditingController();

  TeamModel team;
  PlayerModel referencePlayer;
  PlayerModel playerToBeUpdated;
  int playerNo;
  bool isPlayerNoUpdate = false;
  bool _substitute = false;
  bool _notPlaying = false;
  bool _nonRotating = false;

  checkIfActivePlayer({PlayerType type}) {
    if (type != null) {
      if (type == PlayerType.substitute) {
        _substitute = true;
      }
      if (type == PlayerType.notPlaying) {
        _notPlaying = true;
      }
      if (type == PlayerType.notRotating) {
        _nonRotating = true;
      }
      return;
    }
    if (!_substitute && !_nonRotating && !_notPlaying) {
      type = PlayerType.active;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context).settings.arguments != null) {
        setState(() {
          team = (ModalRoute.of(context).settings.arguments
              as Map<String, dynamic>)['team'];
          playerToBeUpdated = (ModalRoute.of(context).settings.arguments
              as Map<String, dynamic>)['player'];
          referencePlayer = playerToBeUpdated;
          playerNo = referencePlayer.playerNO;
          _controller.text = playerToBeUpdated.playerName;
          checkIfActivePlayer(type: playerToBeUpdated.type);
          print('initn callled');
        });
      }
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
              playerToBeUpdated != null ? playerToBeUpdated.playerName : '',
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
                              no: playerNo != null ? playerNo.toString() : '',
                              onChange: (v) {
                            setState(() {
                              if (v != '') {
                                if (playerToBeUpdated.playerNO !=
                                    int.parse(v)) {
                                  isPlayerNoUpdate = true;
                                }
                                playerNo = int.parse(v);
                              }
                            });
                          }));
                },
                padding: EdgeInsets.all(0),
                child: Container(
                  child: Center(
                      child: Text(
                    playerNo != null ? playerNo.toString() : '#',
                    style:
                        TextStyle(fontSize: 52, color: ThemeService().bgColor),
                  )),
                  height: 102,
                  width: 102,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ThemeService().tertiary),
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
                  playerToBeUpdated.playerName = v;
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
                    playerToBeUpdated.type = PlayerType.notRotating;
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
                    playerToBeUpdated.type = PlayerType.substitute;
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
                    playerToBeUpdated.type = PlayerType.notPlaying;
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
                    buttonText: 'Delete',
                    outlineButton: true,
                    onPressed: _delete,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  PrimaryButton(
                    height: 40,
                    width: 96,
                    padding: false,
                    buttonText: 'Save',
                    outlineButton: false,
                    onPressed: _update,
                  )
                ],
              )
              /*Save and Next Button End*/
            ],
          ),
        ),
        // ),
      ),
    );
  }

  void _delete() {
    team.players.remove(playerToBeUpdated);
    team.save().then((value) {
      Navigator.pop(context);
    });
  }

  void _update() {
    var index = team.players.indexWhere((player) => player == referencePlayer);
    if (checkIfPlayerNoExist(playerNo)) {
      EasyLoading.showInfo('Player Number Must Be unique');
      return;
    }
    team.players[index] = playerToBeUpdated..playerNO = playerNo;
    team.save().then((value) {
      Navigator.pop(context);
    });
  }

  bool checkIfPlayerNoExist(updatedNo) {
    bool duplicate = false;
    if (isPlayerNoUpdate)
      team.players.forEach((existingPlayer) {
        if (existingPlayer.playerNO == updatedNo) {
          duplicate = true;
        }
      });
    return duplicate;
  }
}
