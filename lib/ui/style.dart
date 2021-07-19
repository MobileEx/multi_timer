import 'package:fairplay/services/theme_service.dart';
import 'package:flutter/material.dart';

class CustomTextStyle {
  TextStyle h1 = TextStyle(fontSize: 40, color: ThemeService().primaryColor);
  TextStyle h2 = TextStyle(fontSize: 20, color: ThemeService().secondary);
  TextStyle h3 =
      TextStyle(fontSize: 14, color: ThemeService().secondary, fontWeight: FontWeight.bold);
  TextStyle h4 = TextStyle(fontSize: 14, color: ThemeService().secondary);
  TextStyle h5 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: ThemeService().tertiary);
}
