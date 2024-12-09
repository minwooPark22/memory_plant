import 'package:flutter/material.dart';

enum Language { ko, en }

class LanguageProvider with ChangeNotifier {
  Language _currentLanguage = Language.ko;

  Language get currentLanguage => _currentLanguage;

  void changeLanguage() {
    _currentLanguage =
        _currentLanguage == Language.ko ? Language.en : Language.ko;
    notifyListeners();
  }

  void setLanguage(Language language) {
    _currentLanguage = language;
    notifyListeners();
  }
}
