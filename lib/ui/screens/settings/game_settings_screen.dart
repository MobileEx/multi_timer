import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/provider/timer_provider.dart';
import 'package:fairplay/services/hive_service.dart';
import 'package:fairplay/ui/dialogs/add_segments_dialog.dart';
import 'package:fairplay/ui/dialogs/time_per_segment_dialog.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/delete_team_dialog.dart';
import 'package:fairplay/ui/screens/home_screen.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int key = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeService().bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CupertinoButton(
            child: Icon(
              Icons.arrow_back_rounded,
              color: ThemeService().secondary,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'SETTINGS',
          style: CustomTextStyle().h3,
        ),
        backgroundColor: ThemeService().bgColor,
        elevation: 0.0,
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.teamBox.listenable(),
        builder: (context, Box<TeamModel> teams, _) {
          TeamModel team = teams.get(key);
          if (team != null)
            return LayoutBuilder(
              builder: (context, constraint) => Container(
                height: constraint.maxHeight,
                color: ThemeService().tertiary.withOpacity(.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<TimerProvider>(
                      builder: (context, timeProvider, _) => Column(
                        children: [
                          GameSettingsTile(
                            label: 'RENAME YOUR TEAM',
                            text: team.teamName,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/teamNameRenameScreen',
                                  arguments: team);
                            },
                          ),
                          GameSettingsTile(
                            label: 'NUMBER OF TOTAL PLAYERS',
                            text: team.players.length.toString(),
                          ),
                          GameSettingsTile(
                            label: 'NUMBER OF ACTIVE PLAYERS',
                            text: team.maxActivePlayer.toString(),
                            // onPressed: () {
                            //   showDialog(
                            //       context: context,
                            //       builder: (context) => maxActivePlayerDialog(context,
                            //               activePlayer: team.maxActivePlayer, onChange: (v) {
                            //             timeProvider.setMaxActivePlayer(int.parse(v), key);
                            //           }));
                            // },
                          ),
                          GameSettingsTile(
                            label: 'NOT ROTATING/GOALKEEPER',
                            text: team.players
                                .where((element) =>
                                    element.type == PlayerType.notRotating)
                                .toList()
                                .length
                                .toString(),
                          ),
                          GameSettingsTile(
                            label: 'TIME PER SEGMENT',
                            text:
                                '${timeProvider.teamTimer[key].timePerSegment < 10 ? '0' + timeProvider.teamTimer[key].timePerSegment.toString() : timeProvider.teamTimer[key].timePerSegment} Minutes',
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => timePerSegmentDialog(
                                          context,
                                          segments: timeProvider.teamTimer[key]
                                              .timePerSegment, onChange: (v) {
                                        if (v != '')
                                          timeProvider.setTimePerSegment(
                                              int.parse(v), key);
                                      }));
                            },
                          ),
                          GameSettingsTile(
                            label: 'SEGMENTS',
                            text:
                                '${timeProvider.teamTimer[key].totalSegments} x ${timeProvider.teamTimer[key].timePerSegment} Minutes',
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => addSegmentDialog(
                                          context,
                                          segments: timeProvider.teamTimer[key]
                                              .totalSegments, onChange: (v) {
                                        if (v != '')
                                          timeProvider.setTotalSegment(
                                              int.parse(v), key);
                                      }));
                            },
                          ),
                          GameSettingsTile(
                            label: 'TOTAL GAME TIME PER PLAYER',
                            text: timeProvider.teamTimer[key]
                                .getEachPlayerTimeString(),
                            color: ThemeService().primaryColor,
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                        child: PrimaryButton(
                            buttonText: 'DELETE TEAM',
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      deleteTeam(context, onPressed: () {
                                        team.delete().then((value) {
                                          Navigator.pushAndRemoveUntil<dynamic>(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  HomeScreen(),
                                              transitionDuration:
                                                  Duration(seconds: 1),
                                              transitionsBuilder:
                                                  (_, anim, __, child) =>
                                                      FadeTransition(
                                                          opacity: anim,
                                                          child: child),
                                            ),
                                            (route) =>
                                                false, //if you want to disable back feature set to false
                                          );
                                        });
                                      }));
                            },
                            outlineButton: true))
                  ],
                ),
              ),
            );
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

//todo icon select from Gallery
//todo fix the uniue number checking . only check if no is edited
