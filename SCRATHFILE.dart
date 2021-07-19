import 'package:pausable_timer/pausable_timer.dart';

///Created by zakria khan at 10/06/2021///
///email contact@zakriakhan.com///
///fiver link :  https://www.fiverr.com/users/toptutorial270///

void main() async {
  startFirstRound();
}

int totalTime = 40;
int firstRoundTime = 1;
int secondRoundTime = 20;
// Round firstRound;
// Round secondRound;

int countDownInSeconds;
PausableTimer timer;

startFirstRound() {
  countDownInSeconds = 60 * firstRoundTime;
  timer = PausableTimer(
    Duration(seconds: 1),
    () {
      countDownInSeconds--;
      if (countDownInSeconds > 0) {
        timer
          ..reset()
          ..start();
      }
      int min = (countDownInSeconds ~/ 60);
      var seconds = countDownInSeconds % 60;
      print("$min : $seconds");
      if (timer.isExpired) {
        print('start second Timer');
      }
    },
  )..start();
}
