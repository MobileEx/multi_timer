import 'package:fairplay/provider/team_data_provider.dart';
import 'package:fairplay/provider/timer_provider.dart';
import 'package:fairplay/services/hive_service.dart';
import 'package:fairplay/services/notification_service.dart';
import 'package:fairplay/services/shared_pref_services.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/static_data.dart';
import 'package:fairplay/ui/onboarding/onboarding_view.dart';
import 'package:fairplay/ui/screens/player/adding_player_from_timer_screen.dart';
import 'package:fairplay/ui/screens/settings/app_settings_screen.dart';
import 'package:fairplay/ui/screens/settings/game_settings_screen.dart';
import 'package:fairplay/ui/screens/home_screen.dart';
import 'package:fairplay/ui/screens/player/player_adding_from_team_screen.dart';
import 'package:fairplay/ui/screens/player/player_updating_Screen.dart';
import 'package:fairplay/ui/screens/team/team_creation_page.dart';
import 'package:fairplay/ui/screens/team/team_update_screen.dart';
import 'package:fairplay/ui/screens/team_player_timer_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  String initialRoute = '';
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await SharedPrefService().init();
  await HiveService().init();
  await ThemeService().init();
  NotificationService().initNotifications();
  var onboarding = SharedPrefService().getData(StaticData.PLAY_ONBOARDING) ?? true;
  if (onboarding == false) {
    initialRoute = '/home';
  } else {
    initialRoute = '/';
  }
  if (SharedPrefService().getData(StaticData.FIRST_TIME) ?? true) {
    HiveService().writeToStorage(StaticData.demoTeam);
  }
  SharedPrefService().setData(StaticData.FIRST_TIME, false);

  runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
        ChangeNotifierProvider<TeamDataProvider>(
          create: (_) => TeamDataProvider(),
        ),
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => OnBoardingScreen(),
          '/home': (context) => HomeScreen(),
          '/teamCreationScreen': (context) => TeamCreationPage(),
          '/playerAddingScreen': (context) => PlayerAddingFromTeamScreen(),
          '/appSettings': (context) => AppSettingsScreen(),
          '/gameSettings': (context) => GameSettingsScreen(),
          '/teamPlayerTimersScreen': (context) => TeamPlayerTimerScreen(),
          '/teamNameRenameScreen': (context) => TeamUpdateScreen(),
          '/playerAddingFromTimerScreen': (context) => AddingPlayerFromTimerScreen(),
          '/updatePlayerScreen': (context) => UpdatePlayerScreen(),
        },
      ),
    );
  }
}
