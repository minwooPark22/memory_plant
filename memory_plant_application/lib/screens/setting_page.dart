import 'package:flutter/material.dart';

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

          title: Text(isKorean ? "⚙️️설정" : "⚙️Settings"),
          actions: [

          ],
        ),
      body: Container(
        color: Colors.lightBlue[400], // 배경 색상
        child: Center( //알단 노
        ),
      ),
    );
  }
}