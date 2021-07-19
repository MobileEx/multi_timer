import 'package:fairplay/services/shared_pref_services.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/static_data.dart';
import 'package:fairplay/ui/screens/home_screen.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomeScreen(),
                  transitionDuration: Duration(seconds: 1),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                ),
                (route) => false, //if you want to disable back feature set to false
              );
            }),
        title: Text(
          'SETTINGS',
          style: CustomTextStyle().h3,
        ),
        backgroundColor: ThemeService().bgColor,
        elevation: 0.0,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => Container(
          height: constraint.maxHeight,
          color: ThemeService().tertiary.withOpacity(.1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SwitchContainer(
                      title: StaticData.COUNT_UP,
                      value: SharedPrefService().getData(StaticData.COUNT_UP) ?? true,
                      onChange: (v) {
                        setState(() {});

                        SharedPrefService().setData(StaticData.COUNT_UP, v);
                      },
                    ),
                    SwitchContainer(
                      title: StaticData.DARK_MODE,
                      value: SharedPrefService().getData(StaticData.DARK_MODE) ?? false,
                      onChange: (v) {
                        setState(() {});
                        ThemeService().updateThemeMode(v);
                        SharedPrefService().setData(StaticData.DARK_MODE, v);
                      },
                    ),
                    SwitchContainer(
                      title: StaticData.NOTIFICATION,
                      value: SharedPrefService().getData(StaticData.NOTIFICATION) ?? true,
                      onChange: (v) {
                        setState(() {});

                        SharedPrefService().setData(StaticData.NOTIFICATION, v);
                      },
                    ),
                    SwitchContainer(
                      title: StaticData.PLAY_ONBOARDING,
                      value: SharedPrefService().getData(StaticData.PLAY_ONBOARDING) ?? false,
                      onChange: (v) {
                        setState(() {});
                        SharedPrefService().setData(StaticData.PLAY_ONBOARDING, v);
                      },
                    )
                  ],
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 200),
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StaticData.SETTINGS_TEXT[0],
                              style: CustomTextStyle()
                                  .h4
                                  .copyWith(color: ThemeService().tertiary, wordSpacing: 3),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              StaticData.SETTINGS_TEXT[1],
                              style: CustomTextStyle()
                                  .h4
                                  .copyWith(color: ThemeService().tertiary, wordSpacing: 3),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              StaticData.SETTINGS_TEXT[2],
                              style: CustomTextStyle()
                                  .h4
                                  .copyWith(color: ThemeService().tertiary, wordSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        child: Row(
                          children: [
                            RoundIconButton(
                              iconData: Icons.email,
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RoundIconButton(
                              iconData: Icons.video_call,
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RoundIconButton(
                              iconData: Icons.shopping_bag,
                              color: ThemeService().primaryColor,
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      PrimaryButton(
                        buttonText: 'SUPPORT THE APP, WATCH AN ADVERT',
                        outlineButton: true,
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
