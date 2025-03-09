import 'package:flutter/material.dart';

import 'light_mode.dart';
import 'dark_mode.dart';

class ThemeProvider extends ChangeNotifier{
  // initially light mode

  ThemeData _themeData = lightMode;

  // get current theme

  ThemeData get themedata => _themeData;

  // is dark mode ?

  bool get isDarkMode => _themeData == darkMode;

  // set theme

  set themeData(ThemeData themeData){

    _themeData = themeData;
    notifyListeners();

  }

  // toggle theme

  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }




}