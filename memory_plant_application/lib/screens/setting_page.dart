import 'package:flutter/material.dart';
import 'package:memory_plant_application/widgets/setting_list.dart';    //original widget
import 'package:memory_plant_application/widgets/blue_box.dart';   //blue box widget

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context){
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // go back
          },
        ),

          title: Text(isKorean ? "⚙️️설정" : "⚙️Settings"), //일단 임티로 대체
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