import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/widgets/alarm.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class TimeSettingDialog extends StatefulWidget {
  final Function onSave;

  const TimeSettingDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  _TimeSettingDialogState createState() => _TimeSettingDialogState();
}

class _TimeSettingDialogState extends State<TimeSettingDialog> {
  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedTime();
  }

  Future<void> _loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedHour = prefs.getInt('alarm_hour') ?? 0;
      selectedMinute = prefs.getInt('alarm_minute') ?? 0;
    });
  }

  Future<void> _saveTime(bool isKorean) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarm_hour', selectedHour);
    await prefs.setInt('alarm_minute', selectedMinute);
    await scheduleDailyNotification(selectedHour, selectedMinute, isKorean);
    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

    return CupertinoAlertDialog(
      title: Text(isKorean ? "알람 시간 설정" : "Set Alarm Time"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 시 선택 슬라이더
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(initialItem: selectedHour),
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        selectedHour = value;
                      });
                    },
                    children: List<Widget>.generate(24, (int index) {
                      return Center(child: Text(index.toString()));
                    }),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(":", style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedMinute == 0 ? 0 : 1,
                    ),
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        selectedMinute = value * 30;
                      });
                    },
                    children: [
                      Center(child: Text("00")),
                      Center(child: Text("30")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: Text(isKorean ? "취소" : "Cancel",
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            _saveTime(isKorean); // isKorean
            Navigator.pop(context);
          },
          child: Text(isKorean ? "저장" : "Save",
            style: TextStyle(color: AppStyles.maindeepblue),),
        ),
      ],
    );
  }
}
