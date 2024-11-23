import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:provider/provider.dart';

class LanguageToggleSwitch extends StatefulWidget {
  final ValueChanged<bool> onToggle;

  const LanguageToggleSwitch({super.key, required this.onToggle});

  @override
  State<LanguageToggleSwitch> createState() => _LanguageToggleSwitchState();
}

class _LanguageToggleSwitchState extends State<LanguageToggleSwitch> {
  void _toggleSwitch(bool value) {
    context.read<LanguageProvider>().changeLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: context.watch<LanguageProvider>().currentLanguage == Language.ko,
      onChanged: _toggleSwitch,
      activeColor: Colors.blue,
    );
  }
}
