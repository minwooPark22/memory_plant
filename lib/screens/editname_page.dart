import 'package:flutter/material.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditNamePage extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onNameSaved;

  const EditNamePage({
    super.key,
    required this.currentName,
    required this.onNameSaved,
  });

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
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
    Navigator.of(context).pop(); // 페이지 닫기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,actions: [
        TextButton(
          onPressed: _saveName,
          child: Text(
            'Save',
            style: TextStyle(
              color: AppStyles.maindeepblue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // 프로필 사진 및 편집 아이콘
            Stack(
              alignment: Alignment.center,
                children: [
                  // 프로필 사진 및 편집 아이콘
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200], // 배경색
                        child: Icon(
                          MdiIcons.dolphin, // 물고기로 함
                          size: 55,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ]
            ),
            const SizedBox(height: 16),
            // USER NAME
            _buildTextField(
              label: 'USER NAME',
              controller: _nameController,
              errorMessage: _errorMessage,
            ),

            const SizedBox(height: 16),
            // EMAIL ID
            _buildTextField(
              label: 'E-MAIL ID',
              controller: TextEditingController(text: 'example.google.com'), // 예시 데이터
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5), // 기본 테두리
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5), // 활성 상태 테두리
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppStyles.maindeepblue, width: 2), // 포커스 상태 테두리
            ),
            errorText: errorMessage,
          ),
        ),
      ],
    );
  }
}
