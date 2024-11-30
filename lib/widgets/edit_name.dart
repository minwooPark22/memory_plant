import 'package:flutter/material.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

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
      backgroundColor: Colors.white,
      title: const Text('Edit Name'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          errorText: _errorMessage,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _nameController.clear(); // 텍스트 필드 내용 삭제
              setState(() {
                _errorMessage = null; // 에러 메시지도 초기화
              });
            },
            color: Colors.grey,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel',
          style: TextStyle(color: AppStyles.maindeepblue)
          ),
        ),
        TextButton(
          onPressed: _saveName,
          child: Text(
              'Save',
              style: TextStyle(color: AppStyles.maindeepblue)
          ),
        ),
      ],
    );
  }
}
