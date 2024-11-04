import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:flutter/cupertino.dart';
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    widget.onNameSaved(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKorean = StartPage.selectedLanguage == 'ko';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,

      title: Text(isKorean ? "이름 수정" : "Name",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 17,
            fontWeight:FontWeight.bold
        ),
      ),
      content: TextField(
        controller: _nameController,
        maxLength: 20,
        decoration: InputDecoration(
          //hintText: isKorean ? "이름 입력" : "Name",
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            '취소',
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () async {
            await _saveName(); // Save name
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text(
            '저장',
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
        ),
      ],
    );
  }
}
/*
class EditNameDialog extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onNameSaved;


  const EditNameDialog({Key? key, required this.currentName, required this.onNameSaved}) : super(key: key);

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}
class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _nameController;

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    widget.onNameSaved(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';
    return AlertDialog(
        title: Text('이름 수정'),
    content: TextField(
    controller: _nameController,
    maxLength: 20,
    decoration: InputDecoration(
    hintText: '이름 입력',
    ),
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
          },
          child: Text(isKorean ? "저장" : "Save",
            style: TextStyle(color: AppStyles.maindeepblue),),
        ),
      ],
    );
  }
}
*/
/*
class EditNameDialog extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onNameSaved;

  const EditNameDialog({Key? key, required this.currentName, required this.onNameSaved}) : super(key: key);

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _nameController;

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    widget.onNameSaved(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

    return CupertinoAlertDialog(
      title: Text('이름 수정'),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CupertinoTextField(
          controller: _nameController,
          maxLength: 20,
          placeholder: '이름 입력',
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: Text(isKorean ? "취소" : "Cancel",
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () async {
            await _saveName();
            Navigator.pop(context);
          },
          child: Text(isKorean ? "저장" : "Save",
            style: TextStyle(color: AppStyles.maindeepblue),
          ),
        ),
      ],
    );
  }
}
*/

