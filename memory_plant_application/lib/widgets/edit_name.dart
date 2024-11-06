import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_plant_application/screens/start_page.dart';
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
}*/
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 20,
            decoration: InputDecoration(
              errorText: _errorMessage, // Error message if name is empty
            ),
          ),/*
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),*/
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