import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/widgets/setting_list.dart'; //original widget
import 'package:memory_plant_application/widgets/blue_box.dart'; //blue box widget

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKorean = StartPage.selectedLanguage == 'ko';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isKorean ? "설정" : "Settings",
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const BlueBox(),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: const SettingsList(),
          ),
        ],
      ),
    );
  }
}
