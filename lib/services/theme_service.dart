import 'package:fairplay/services/shared_pref_services.dart';
import 'package:fairplay/static_data.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ThemeService extends ChangeNotifier {
  static bool darkMode;

  Future<void> init() async {
    darkMode = SharedPrefService().getData(StaticData.DARK_MODE) ?? false;
    configLoading();
  }

  Future<void> updateThemeMode(bool mode) async {
    darkMode = mode;
    SharedPrefService().setData(StaticData.DARK_MODE, mode);
    configLoading();
    notifyListeners();
  }

  Color get bgColor {
    return darkMode ? Color(0xff000f0f) : Color(0xffffffff);
  }

  Color get primaryColor {
    return darkMode ? Color(0xffFF5555) : Color(0xffFF573C);
  }

  Color get secondary {
    return darkMode ? Color(0xfff9f9f9) : Color(0xff3F3334);
  }

  Color get tertiary {
    return darkMode ? Color(0xffCacaca) : Color(0xffCAB6A5);
  }

  Color get success {
    return darkMode ? Color(0xff9BD120) : Color(0xff9BD120);
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = ThemeService.darkMode ? EasyLoadingStyle.light : EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 2;
  }
}
