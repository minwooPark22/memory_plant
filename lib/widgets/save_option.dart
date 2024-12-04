import 'package:flutter/material.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class SaveOptionDropdown extends StatelessWidget {
  final void Function(String) onOptionSelected;

  const SaveOptionDropdown({Key? key, required this.onOptionSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // 드롭다운 배경 흰색
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 0.3), // 회색 테두리 추가
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 28), // 드롭다운 위치
        onSelected: onOptionSelected,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: '요약',
            child: Text(
              'summary',
              style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.w400),
            ),
          ),
          PopupMenuItem<String>(
            value: '노 요약',
            child: Text(
              'Don\'t leave the summary to the plant keeper',
              style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.w400),
            ),
          ),
        ],
        child: Row(
          children: [
            Icon(Icons.expand_more, color: AppStyles.textColor, size: 20),
            SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}