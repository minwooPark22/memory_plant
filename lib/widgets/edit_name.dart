import 'package:flutter/material.dart';

class EditNameDialog extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onNameSaved; // 추가

  const EditNameDialog({
    super.key,
    required this.currentName,
    required this.onNameSaved, // 추가
  });

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
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

  void _saveName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a name!';
      });
      return;
    }
    widget.onNameSaved(name); // 콜백 호출
    Navigator.of(context).pop(); // 다이얼로그 닫기
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Name'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          errorText: _errorMessage,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveName,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
