import 'package:flutter/cupertino.dart';

class DarkThemeMode extends ChangeNotifier{
  bool _thememode =false;
  bool get Thememode =>_thememode;

  void Chnagetheme(){
    _thememode =! _thememode;
    notifyListeners();
  }

}