import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return AlertDialog(
      title: Text('이름 수정'),
      content: TextField(
        controller: _nameController,
        maxLength: 20,
        decoration: InputDecoration(
          hintText: '이름 입력',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () async {
            await _saveName(); // Save name
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text('저장'),
        ),
      ],
    );
  }
}
