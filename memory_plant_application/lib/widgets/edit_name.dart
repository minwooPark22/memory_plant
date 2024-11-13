import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/screens/start_page.dart';

class EditNameDialog extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onNameSaved;

  const EditNameDialog({Key? key, required this.currentName, required this.onNameSaved}) : super(key: key);

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _nameController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = StartPage.selectedLanguage == 'ko' ? '이름을 작성해주세요!' : 'Please enter your name!';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    widget.onNameSaved(name);
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: Text(
        isKorean ? "이름 수정" : "Edit Name",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppStyles.maindeepblue,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: isKorean ? '이름을 입력하세요' : 'Enter your name',
              hintStyle: const TextStyle(color: Colors.grey),
              errorText: _errorMessage,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppStyles.maindeepblue),
              ),
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _nameController.clear();
                  setState(() {
                    _errorMessage = null; // 에러 메시지 초기화
                  });
                },
              )
                  : null,
            ),
            onChanged: (text) {
              setState(() {}); // 텍스트 변경 시 suffixIcon 업데이트
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            isKorean ? '취소' : 'Cancel',
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () async {
            await _saveName(); // Save name
            if (_errorMessage == null) {
              Navigator.of(context).pop(); // Close dialog if no error
            }
          },
          child: Text(
            isKorean ? '저장' : 'Save',
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
        ),
      ],
    );
  }
}