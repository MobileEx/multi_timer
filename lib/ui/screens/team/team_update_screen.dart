import 'package:fairplay/models/team_model.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/dialogs/color_picker_dialog.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class TeamUpdateScreen extends StatefulWidget {
  @override
  _TeamUpdateScreenState createState() => _TeamUpdateScreenState();
}

class _TeamUpdateScreenState extends State<TeamUpdateScreen> {
  TextEditingController _teamController = TextEditingController();
  TeamModel teamModel;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        teamModel = ModalRoute.of(context).settings.arguments;
      });
      _teamController.text = teamModel.teamName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService().bgColor,
      appBar: AppBar(
        backgroundColor: ThemeService().bgColor,
        elevation: 0.0,
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
          'Demo FC',
          style: CustomTextStyle().h3,
        ),
      ),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),

                  /*Title Start*/
                  Text(
                    'Rename',
                    style: CustomTextStyle().h1,
                  ),
                  /*Title end*/

                  SizedBox(
                    height: 10,
                  ),

                  /*subtitle Start*/
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 44),
                    child: Text(
                      'Update your team logo and a colour!',
                      textAlign: TextAlign.center,
                      style: CustomTextStyle().h4.copyWith(height: 1.4),
                    ),
                  ),
                  /* subtitle end*/

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
                          child: Icon(
                            Icons.shield,
                            color: ThemeService().bgColor,
                            size: 70,
                          ),
                          width: 102,
                          height: 102,
                          decoration: BoxDecoration(
                              color: Color(int.parse(
                                  '0xff${teamModel == null ? 'ffffff' : teamModel.color}')),
                              shape: BoxShape.circle),
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
                                      value: Color(int.parse('0xff${teamModel.color}')),
                                      onChangeColor: (Color v) {
                                    setState(() {
                                      teamModel.color = v.hex;
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
                    controller: _teamController,
                    onChanged: (v) {
                      teamModel.teamName = v;
                    },
                  ),
                  /*Team Name Field End*/
                  SizedBox(
                    height: 30,
                  ),
                  PrimaryButton(
                    height: 40,
                    width: 96,
                    padding: false,
                    buttonText: 'UPDATE',
                    outlineButton: false,
                    onPressed: () {
                      teamModel.save().then((value) => Navigator.pop(context));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        color: ThemeService().tertiary.withOpacity(.1),
        padding: EdgeInsets.symmetric(horizontal: 25),
      ),
    );
  }
}
