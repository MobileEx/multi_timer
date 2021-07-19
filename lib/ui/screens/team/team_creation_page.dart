import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/provider/timer_provider.dart';
import 'package:fairplay/services/hive_service.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/color_picker_dialog.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';

import '../../../provider/team_data_provider.dart';

class TeamCreationPage extends StatefulWidget {
  @override
  _TeamCreationPageState createState() => _TeamCreationPageState();
}

class _TeamCreationPageState extends State<TeamCreationPage> {
  String teamName;
  Color teamColor;

  @override
  void initState() {
    teamColor = ThemeService().tertiary;
    Provider.of<TeamDataProvider>(context, listen: false).player.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeService().bgColor,
      appBar: AppBar(
        backgroundColor: ThemeService().tertiary.withOpacity(.1),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: args ?? false
            ? CupertinoButton(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ThemeService().secondary,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
            : null,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => Container(
          height: constraint.maxHeight,
          child: Consumer<TeamDataProvider>(
            builder: (context, data, _) {
              List<PlayerNameAndLogo> players = data.player
                  .map((e) => PlayerNameAndLogo(
                        color: teamColor,
                        name: e.playerName.toUpperCase(),
                        onPressed: () {
                          data.removePlayer(e);
                        },
                      ))
                  .toList();

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),

                        /*Title Start*/
                        Text(
                          'Named Your Team',
                          style: CustomTextStyle().h1,
                        ),
                        /*Title end*/

                        SizedBox(
                          height: 10,
                        ),

                        /*team creation subtitle Start*/
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 44),
                          child: Text(
                            'You can add as many teams as you like! Add your team logo and a colour.',
                            textAlign: TextAlign.center,
                            style: CustomTextStyle().h4.copyWith(height: 1.4),
                          ),
                        ),
                        /*team creation subtitle end*/

                        SizedBox(
                          height: 15,
                        ),

                        /*Icon And Color Picker Start*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Image.asset(
                                  'assets/icons/logo.png',
                                  fit: BoxFit.cover,
                                ),
                                width: 102,
                                height: 102,
                                decoration: BoxDecoration(color: teamColor, shape: BoxShape.circle),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            RoundIconButton(
                              iconData: Icons.brush,
                              color: ThemeService().secondary,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => colorPickerDialog(context,
                                            value: teamColor, onChangeColor: (Color v) {
                                          setState(() {
                                            teamColor = v;
                                          });
                                        }));
                              },
                            ),
                          ],
                        ),
                        /*Icon And Color Picker end*/

                        SizedBox(
                          height: 15,
                        ),

                        /*Team Name Field Start*/
                        CustomTextField(
                          hintText: 'Team Name',
                          onChanged: (v) {
                            teamName = v;
                          },
                        ),
                        /*Team Name Field End*/

                        SizedBox(
                          height: 30,
                        ),

                        /*Add Player Button Start*/
                        data.player.length == 0
                            ? PlayerNameAndLogo(
                                user: false,
                                name: 'ADD PLAYER',
                                color: teamColor,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/playerAddingScreen');
                                },
                              )
                            : GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                childAspectRatio: 50 / 70,
                                crossAxisCount: 5,
                                children: [
                                  ...players,
                                  PlayerNameAndLogo(
                                    user: false,
                                    name: 'ADD PLAYER',
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/playerAddingScreen');
                                    },
                                  ),
                                ],
                              )
                        /*Add Player Button End*/
                        ,
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: PrimaryButton(
                        padding: false,
                        buttonText: 'Create Team',
                        outlineButton: false,
                        onPressed: () async {
                          if (teamName == '' || teamName == null) {
                            EasyLoading.showInfo('Team Name must not be null');
                            return;
                          }
                          if (data.player.length < 2) {
                            EasyLoading.showInfo('Please Added At Least Two Player To Team');
                            return;
                          }

                          TeamModel newTeam = TeamModel(
                              teamName: teamName,
                              color: teamColor.hex,
                              logoPath: 'test',
                              players: data.player);
                          int key = await HiveService().writeToStorage(newTeam);
                          Provider.of<TimerProvider>(context, listen: false)
                              .addNewTimerForNewlyAddedTeam(key, context);
                          if (args == null) {
                            Navigator.pushNamed(context, '/home');
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          color: ThemeService().tertiary.withOpacity(.1),
          padding: EdgeInsets.symmetric(horizontal: 25),
        ),
      ),
    );
  }
}

class PlayerNameAndLogo extends StatelessWidget {
  final String name;
  final bool user;
  final Color color;
  final Function onPressed;
  PlayerNameAndLogo({this.name, this.user, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            RoundIconButton(
              color: color,
              iconData: user ?? true ? Icons.people : Icons.add,
              onPressed: user ?? true ? null : onPressed,
            ),
            Visibility(
              visible: user ?? true,
              child: Positioned(
                top: 0,
                left: 0,
                child: Container(
                  child: GestureDetector(
                    onTap: onPressed,
                    child: Icon(
                      Icons.remove_circle,
                      color: ThemeService().primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: CustomTextStyle().h3.copyWith(color: ThemeService().tertiary),
        )
      ],
    );
  }
}
