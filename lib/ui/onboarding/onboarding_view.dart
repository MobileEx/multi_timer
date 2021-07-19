import 'package:fairplay/services/shared_pref_services.dart';
import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/static_data.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _index = 0;

  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService().bgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /*onBoarding Body START*/
          PageView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                _index = value;
              });
            },
            children: onBoardings
                .map(
                  (data) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 35),
                        child: Image.asset(
                          'assets/onboarding/${data.assetImage}',
                          // fit: _index == 1 ? null : BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 85),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.title,
                                  style: CustomTextStyle().h1,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  data.subTitle,
                                  style: CustomTextStyle().h4,
                                )
                              ],
                            ),
                            height: MediaQuery.of(context).size.height / 2,
                            color: ThemeService().tertiary.withOpacity(.1),
                          ),
                          Container(
                            child: SafeArea(
                              child: Padding(
                                padding: EdgeInsets.only(top: 85),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(onBoardings.length, (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: _index == index
                                              ? ThemeService().tertiary
                                              : ThemeService().tertiary.withOpacity(.3),
                                          shape: BoxShape.circle),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 2,
                          )
                        ],
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          /*onBoarding Body END*/

          /*Create Your Team Button START*/
          Visibility(
            visible: _index == 4,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: PrimaryButton(
                  outlineButton: false,
                  buttonText: SharedPrefService().getData(StaticData.FIRST_TIME) ?? true
                      ? 'CREATE YOUR TEAM'
                      : 'GO TO HOME',
                  onPressed: () {
                    SharedPrefService().setData(StaticData.PLAY_ONBOARDING, false);
                    SharedPrefService().setData(StaticData.FIRST_TIME, false);

                    SharedPrefService().getData(StaticData.FIRST_TIME) ?? true
                        ? Navigator.pushNamed(context, '/teamCreationScreen')
                        : Navigator.pushNamed(context, '/home');
                  },
                ),
              ),
            ),
          ),
          /*Create Your Team Button END*/

          /*Skip Button START*/
          Visibility(
            visible: _index != 4,
            child: Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 45, top: 5),
                      child: CustomTextButton(
                        bold: true,
                        buttonText: 'SKIP',
                        onPressed: () {
                          setState(() {
                            _controller.animateToPage(onBoardings.length - 1,
                                duration: Duration(milliseconds: 500), curve: Curves.ease);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*Skip Button END*/
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
