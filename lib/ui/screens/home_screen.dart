import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/provider/timer_provider.dart';
import 'package:fairplay/services/hive_service.dart';
import 'package:fairplay/services/notification_service.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/bottom_sheet.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<TimerProvider>(context, listen: false).setTimers();
    NotificationService().setContext(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeService().bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ThemeService().bgColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 57,
              ),
              Text(
                'YOUR TEAMS',
                style: CustomTextStyle().h3,
              ),
              SizedBox(
                width: 57,
                child: CupertinoButton(
                    child: Icon(
                      Icons.settings,
                      color: ThemeService().tertiary,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/appSettings');
                    }),
              )
            ],
          ),
          elevation: 0.0,
        ),
        body: LayoutBuilder(
          builder: (context, constraint) => Container(
            color: ThemeService().bgColor,
            height: constraint.maxHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /*bg image Start*/
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 35),
                    child: Image.asset(
                      'assets/home.png',
                      fit: BoxFit.cover,
                    )),
                /*bg image end*/

                /*Team List Section + Add Team Button Start*/
                Container(
                  height: constraint.maxHeight,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 90),
                    child: ValueListenableBuilder(
                      valueListenable: HiveService.teamBox.listenable(),
                      builder: (context, Box<TeamModel> items, _) {
                        List<int> keys;
                        keys = items.keys.cast<int>().toList();
                        List<CustomListTile> teamWidgets = [];
                        keys.forEach((key) {
                          TeamModel team = items.get(key);
                          teamWidgets.add(
                            CustomListTile(
                              teamName: team.teamName,
                              teamColor: team.color,
                              playerCount: team.players.length,
                              onPressed: () {
                                Navigator.pushNamed(context, '/teamPlayerTimersScreen',
                                    arguments: {'key': key});
                              },
                            ),
                          );
                        });

                        return Column(
                          children: [
                            ...teamWidgets,
                            SizedBox(
                              height: 40,
                            ),
                            SafeArea(
                              child: Column(
                                children: [
                                  RoundIconButton(
                                    iconData: Icons.add,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/teamCreationScreen',
                                          arguments: true);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'ADD TEAM',
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
                    ),
                  ),
                ),
                /*Team List Section + Add Team Button End*/

                Positioned(
                  bottom: 0,
                  child: SafeArea(
                    child: RoundIconButton(
                      iconData: Icons.help_outlined,
                      onPressed: () {
                        infoSheet(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
