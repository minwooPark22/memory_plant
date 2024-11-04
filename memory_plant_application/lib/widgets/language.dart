import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';


class LanguageToggleSwitch extends StatefulWidget {
  final ValueChanged<bool> onToggle;

  const LanguageToggleSwitch({Key? key, required this.onToggle}) : super(key: key);

  @override
  _LanguageToggleSwitchState createState() => _LanguageToggleSwitchState();
}

class _LanguageToggleSwitchState extends State<LanguageToggleSwitch> {
  bool isKorean = StartPage.selectedLanguage == 'ko';

  void _toggleSwitch(bool value) {
    setState(() {
      isKorean = value;
      StartPage.selectedLanguage = value ? 'ko' : 'en';
    });
    widget.onToggle(value);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isKorean,
      onChanged: _toggleSwitch,
      activeColor: Colors.blue,
    );
  }
}
