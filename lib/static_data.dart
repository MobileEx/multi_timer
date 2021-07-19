import 'package:fairplay/models/onBoarding_model.dart';
import 'package:fairplay/models/player_model.dart';
import 'package:fairplay/models/team_model.dart';

List<OnBoardingModel> onBoardings = [
  OnBoardingModel(
    title: 'Fair Play',
    subTitle: 'Manage your player rotations',
    assetImage: '1.png',
  ),
  OnBoardingModel(
    title: 'Create Team',
    subTitle: 'Simply add all your players',
    assetImage: '2.png',
  ),
  OnBoardingModel(
    title: 'Set the time',
    subTitle: 'Each player is allocated equal time',
    assetImage: '3.png',
  ),
  OnBoardingModel(
    title: 'Equal time',
    subTitle: 'Watch each players time count down or up',
    assetImage: '4.png',
  ),
  OnBoardingModel(
    title: 'Final Report',
    subTitle: 'Share the final time so you can easily track',
    assetImage: '5.png',
  ),
];

class StaticData {
  static const List<String> SETTINGS_TEXT = [
    'Support the app by watching an annoying full screen advert or buying it to remove the advertising helps me to make updates or bug fixes that you find.',
    'Any bugs or suggestions please email them.',
    'Privacy Policy, no data is retained only analaytics if you agreed to helps understand usage.'
  ];
  static const ABOUT_SCREEN_TEXT = [
    'Hi, I’m just a dad who loves watching my son and daughter play sports. I want them to keep on playing, but they are not the most skillful player and their coach should not descriminate against them or other children.',
    'All children are out to have fun first and not fulfil the coaches desire to win.'
  ];

  static const String COUNT_UP = 'countUp';
  static const String DARK_MODE = 'darkMode';
  static const String NOTIFICATION = 'notification';
  static const String PLAY_ONBOARDING = 'playOnBoarding';
  static const String FIRST_TIME = 'firstTime';

  static const String DATABASE_NAME = 'fairPlay';

  static TeamModel demoTeam =
      TeamModel(teamName: 'Demo Team', color: 'fff34f', logoPath: '', maxActivePlayer: 8, players: [
    PlayerModel(playerName: 'Player 1', playerNO: 1, type: PlayerType.active),
    PlayerModel(playerName: 'Player 2', playerNO: 2, type: PlayerType.active),
    PlayerModel(playerName: 'Player 3', playerNO: 3, type: PlayerType.active),
    PlayerModel(playerName: 'Player 4', playerNO: 4, type: PlayerType.substitute),
    PlayerModel(playerName: 'Player 5', playerNO: 5, type: PlayerType.active),
    PlayerModel(playerName: 'Player 6', playerNO: 6, type: PlayerType.active),
    PlayerModel(playerName: 'Player 7', playerNO: 7, type: PlayerType.substitute),
    PlayerModel(playerName: 'Player 8', playerNO: 8, type: PlayerType.active),
    PlayerModel(playerName: 'Player 9', playerNO: 9, type: PlayerType.active),
    PlayerModel(playerName: 'Player 10', playerNO: 10, type: PlayerType.active),
    PlayerModel(playerName: 'Player 11', playerNO: 11, type: PlayerType.notPlaying),
    PlayerModel(playerName: 'Player 12', playerNO: 11, type: PlayerType.notRotating),
  ]);
}
