import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String? _photoURL; // Firestore에서 가져온 photoURL

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _loadPhotoURL(); // photoURL 로드
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Firestore에서 photoURL 로드
  Future<void> _loadPhotoURL() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _photoURL = doc.data()?['photoURL']; // photoURL 가져오기
          });
        }
      } catch (e) {
        print("photoURL 로드 중 오류 발생: $e");
      }
    }
  }

  Future<void> _saveNameToFirestore(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'nickname': name,
        });
        print("Firestore에 이름이 성공적으로 업데이트되었습니다.");
      } catch (e) {
        print("Firestore 이름 업데이트 오류: $e");
        throw Exception("Failed to update name in Firestore.");
      }
    } else {
      print("로그인된 사용자 정보가 없습니다.");
      throw Exception("User not logged in.");
    }
  }

  void _saveName() async{
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        final isKorean =
            context.read<LanguageProvider>().currentLanguage == Language.ko;
        _errorMessage = isKorean ? '이름을 입력해주세요!' : 'Please enter a name!';
      });
      return;
    }
    try {
      // Firestore에 이름 저장
      await _saveNameToFirestore(name);

      // 앱 상태에 이름 저장
      widget.onNameSaved(name);

      // 페이지 닫기
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = context.read<LanguageProvider>().currentLanguage ==
            Language.ko
            ? '이름 저장에 실패했습니다.'
            : 'Failed to save the name.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isKorean ? '프로필 수정' : 'Edit Profile', // 언어 설정
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveName,
            child: Text(
              isKorean ? '저장' : 'Save', // 언어 설정
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
            const SizedBox(height: 70),
            // 프로필 사진 및 편집 아이콘
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppStyles.primaryColor,
                  backgroundImage:
                  _photoURL != null ? NetworkImage(_photoURL!) : null, // photoURL 적용
                  child: _photoURL == null
                      ? const Icon(
                    MdiIcons.robot, // 기본 아이콘
                    size: 70,
                    color: Colors.white,
                  )
                      : null, // photoURL이 없으면 기본 아이콘 표시
                ),
              ],
            ),
            const SizedBox(height: 30),
            // USER NAME
            _buildTextField(
              label: isKorean ? '사용자 이름' : 'USER NAME', // 언어 설정
              controller: _nameController,
              errorMessage: _errorMessage,
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
