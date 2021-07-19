import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final bool bold;
  CustomTextButton({
    this.buttonText,
    this.onPressed,
    this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: bold ?? false ? CustomTextStyle().h3 : CustomTextStyle().h4,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final double height;
  final double width;
  final bool outlineButton;
  final Color bgColor;
  final bool padding;
  PrimaryButton({
    @required this.buttonText,
    @required this.onPressed,
    @required this.outlineButton,
    this.padding,
    this.height,
    this.width,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      width: width ?? double.infinity,
      margin: EdgeInsets.symmetric(horizontal: padding ?? true ? 32 : 0, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: outlineButton ? Colors.transparent : ThemeService().primaryColor,
          border: Border.all(color: ThemeService().primaryColor, width: 2)),
      child: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Text(
          buttonText,
          style: CustomTextStyle().h3.copyWith(
              color: outlineButton ? ThemeService().primaryColor : ThemeService().bgColor),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  CustomTextField({
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        cursorColor: ThemeService().tertiary,
        style: CustomTextStyle().h3.copyWith(color: ThemeService().tertiary),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 4),
          hintStyle: CustomTextStyle().h4.copyWith(color: ThemeService().tertiary),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ThemeService().bgColor,
          border: Border.all(color: ThemeService().tertiary),
          borderRadius: BorderRadius.all(Radius.circular(8))),
    );
  }
}

class CustomSwitchTile extends StatelessWidget {
  final bool switchValue;
  final String title;
  final ValueChanged<bool> onChange;
  CustomSwitchTile({this.switchValue, this.title, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: CustomTextStyle().h4,
          ),
          CupertinoSwitch(
              activeColor: ThemeService().success, value: switchValue, onChanged: onChange)
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;
  final Color color;
  RoundIconButton({this.iconData, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      child: Container(
        child: Icon(
          iconData,
          size: 25,
          color: ThemeService().bgColor,
        ),
        height: 40,
        width: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? ThemeService().tertiary),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final Function onPressed;
  final String teamName;
  final String teamColor;
  final int playerCount;
  final String icon;
  CustomListTile({
    this.onPressed,
    this.teamName,
    this.playerCount,
    this.icon,
    this.teamColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: 100,
          width: double.infinity,
          color: ThemeService().tertiary.withOpacity(.2),
          child: Center(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              horizontalTitleGap: 30,
              onTap: onPressed,
              leading: CircleAvatar(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    'assets/icons/profileteam.svg',
                    // height: 40,
                    width: 40,
                  ),
                ),
                radius: 30,
                backgroundColor: Color(int.parse('0xff$teamColor')),
              ),
              title: Text(
                teamName,
                style: CustomTextStyle().h3,
              ),
              subtitle: Text(
                '$playerCount Players',
                style: CustomTextStyle().h5.copyWith(color: ThemeService().primaryColor),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: ThemeService().tertiary,
                size: 18,
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: ThemeService().tertiary,
          margin: EdgeInsets.symmetric(horizontal: 15),
        )
      ],
    );
  }
}

class SwitchContainer extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChange;
  SwitchContainer({
    this.title,
    this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: ThemeService().tertiary),
        ),
      ),
      child: CustomSwitchTile(
        title: title,
        switchValue: value,
        onChange: onChange,
      ),
    );
  }
}

class GameSettingsTile extends StatelessWidget {
  final String label;
  final String text;
  final Function onPressed;
  final Color color;

  GameSettingsTile({
    this.label,
    this.text,
    this.onPressed,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Center(
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 35),
          onTap: onPressed,
          title: Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              label,
              style: CustomTextStyle().h5.copyWith(color: color ?? ThemeService().tertiary),
            ),
          ),
          subtitle: Text(
            text,
            style: CustomTextStyle().h2.copyWith(color: color ?? ThemeService().secondary),
          ),
          trailing: onPressed != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: ThemeService().tertiary,
                  size: 18,
                )
              : null,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: ThemeService().tertiary),
        ),
      ),
    );
  }
}

class PlayTimerWidget extends StatefulWidget {
  final Function onTilePressed;
  final Function onIconPressed;
  final String playerNo;
  final String playerName;
  final String reamingTime;
  final String totalTime;
  final double percentProgress;
  final Color color;
  final bool play;
  PlayTimerWidget({
    this.onTilePressed,
    this.onIconPressed,
    this.playerNo,
    this.color,
    this.playerName,
    this.reamingTime,
    this.totalTime,
    this.play,
    this.percentProgress,
  });

  @override
  _PlayTimerWidgetState createState() => _PlayTimerWidgetState();
}

class _PlayTimerWidgetState extends State<PlayTimerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: widget.onTilePressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(
                    widget.playerNo,
                    style: CustomTextStyle().h2.copyWith(color: ThemeService().bgColor),
                  ),
                  radius: 20,
                  backgroundColor: widget.color,
                ),
                SizedBox(
                  width: 17,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.playerName,
                        style: CustomTextStyle().h3,
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.all(0),
                        onPressed: widget.onIconPressed,
                        child: CircleAvatar(
                          child: Icon(
                            !widget.play ? Icons.play_arrow_rounded : Icons.pause,
                            color: ThemeService().bgColor,
                          ),
                          radius: 15,
                          backgroundColor: ThemeService().primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 17,
                ),
                Container(
                  width: 47,
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: ThemeService().tertiary,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 47,
                  child: Text(
                    widget.reamingTime,
                    style: CustomTextStyle().h4,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(microseconds: 500),
                        width: ((MediaQuery.of(context).size.width * .60) / 100) *
                            (widget.percentProgress),
                        height: 16,
                        decoration: BoxDecoration(
                          color: widget.percentProgress <= 33.3
                              ? ThemeService().primaryColor
                              : widget.percentProgress <= 66.6
                                  ? Colors.orange
                                  : ThemeService().success,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                  height: 16,
                  width: MediaQuery.of(context).size.width * .60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ThemeService().tertiary.withOpacity(.4)),
                ),
                SizedBox(
                  width: 17,
                ),
                Container(
                  width: 47,
                  child: Text(
                    widget.totalTime,
                    style: CustomTextStyle().h4,
                  ),
                ),
              ],
            ),
          ],
        ),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeService().tertiary.withOpacity(.1),
          border: Border(
            bottom: BorderSide(width: 1.0, color: ThemeService().tertiary),
          ),
        ),
      ),
    );
  }
}

class NextRotationWidget extends StatelessWidget {
  final String time;
  final Function onPressed;
  final bool sorted;
  NextRotationWidget({
    this.time,
    this.onPressed,
    this.sorted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            child: Text(
              'Next Rotation',
              style: CustomTextStyle().h5.copyWith(color: ThemeService().primaryColor),
            ),
          ),
          Text(
            time,
            style: CustomTextStyle().h2.copyWith(color: ThemeService().primaryColor, fontSize: 28),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 100,
            child: CupertinoButton(
              padding: EdgeInsets.all(0),
              onPressed: onPressed,
              child: Icon(
                Icons.watch_later_rounded,
                size: 28,
                color: sorted ? ThemeService().primaryColor : ThemeService().tertiary,
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: ThemeService().tertiary.withOpacity(.1),
          border: Border(bottom: BorderSide(color: ThemeService().tertiary, width: 1))),
      height: 55,
      width: double.infinity,
    );
  }
}

class TimerRoundWidget extends StatelessWidget {
  final String roundTime;
  final String roundNumber;
  final String roundTimer;
  final Function onStopPressed;
  final Function onPlayPaused;
  final bool disable;
  final IconData iconData;
  TimerRoundWidget(
      {this.disable,
      this.iconData,
      this.roundTime,
      this.roundNumber,
      this.roundTimer,
      this.onStopPressed,
      this.onPlayPaused});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  roundNumber,
                  style: CustomTextStyle().h5.copyWith(
                      color: disable
                          ? ThemeService().tertiary.withOpacity(.4)
                          : ThemeService().tertiary),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  roundTime,
                  style: CustomTextStyle().h2.copyWith(
                      color: disable
                          ? ThemeService().tertiary.withOpacity(.4)
                          : ThemeService().success),
                )
              ],
            ),
          ),
          Text(
            roundTimer,
            style: CustomTextStyle().h1.copyWith(
                color: disable ? ThemeService().tertiary.withOpacity(.4) : ThemeService().success),
          ),
          Container(
            width: 88,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  onPressed: disable ? null : onStopPressed,
                  child: CircleAvatar(
                    backgroundColor:
                        disable ? ThemeService().tertiary.withOpacity(.4) : ThemeService().tertiary,
                    radius: 14,
                    child: Icon(
                      Icons.stop,
                      size: 20,
                      color: ThemeService().bgColor,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  onPressed: disable ? null : onPlayPaused,
                  child: CircleAvatar(
                    backgroundColor:
                        disable ? ThemeService().tertiary.withOpacity(.4) : ThemeService().success,
                    radius: 14,
                    child: Icon(
                      iconData,
                      size: 20,
                      color: ThemeService().bgColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ThemeService().tertiary.withOpacity(.1),
          border: Border(
              bottom: BorderSide(
                  color:
                      disable ? ThemeService().tertiary.withOpacity(.4) : ThemeService().tertiary,
                  width: 1))),
    );
  }
}
