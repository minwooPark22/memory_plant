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
  String? _nickname; // Firestore에서 가져온 nickname
  String? _email; // Firebase에서 가져온 사용자 이메일

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _loadUserData(); // 사용자 데이터 로드
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Firestore에서 사용자 데이터 로드 (photoURL 및 nickname)
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        setState(() {
          _email = user.email; // 사용자 이메일 설정
        });
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            _photoURL = doc.data()?['photoURL']; // photoURL 가져오기
            _nickname = doc.data()?['nickname']; // nickname 가져오기
            _nameController.text = _nickname ?? ""; // TextField에 nickname 설정
          });
        }
      } catch (e) {
        // print("사용자 데이터 로드 중 오류 발생: $e");
      }
    }
  }

  Future<void> _saveNameToFirestore(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'nickname': name,
        });
        // print("Firestore에 이름이 성공적으로 업데이트되었습니다.");
      } catch (e) {
        // print("Firestore 이름 업데이트 오류: $e");
        throw Exception("Failed to update name in Firestore.");
      }
    } else {
      // print("로그인된 사용자 정보가 없습니다.");
      throw Exception("User not logged in.");
    }
  }

// 로그아웃 처리 함수
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase Auth 로그아웃
      // print('로그아웃 성공');
    } catch (e) {
      // print('로그아웃 중 오류 발생: $e');
    }
  }

  void _saveName() async {
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
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage =
        context.read<LanguageProvider>().currentLanguage == Language.ko
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
          isKorean ? "계정 관리" : "My Account",
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                  backgroundImage: _photoURL != null
                      ? NetworkImage(_photoURL!)
                      : null, // photoURL 적용
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
            // 사용자 이름 및 이메일
            _buildNameAndEmailField(
              nameLabel: isKorean ? '사용자 이름' : 'USER NAME',
              emailLabel: isKorean ? '로그인된 이메일' : 'Signed-in Email',
              controller: _nameController,
              email: _email ?? '',
              errorMessage: _errorMessage,
            ),
            const Spacer(),
            // 로그아웃 버튼
            TextButton(
              onPressed: () async {
                await _signOut(); // 로그아웃 처리

                // context가 여전히 유효하다면 Navigator를 호출
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/",
                          (Route<dynamic> route) => false,
                    ); // StartPage로 이동
                  }
                });
              },
              child: Text(
                isKorean ? '로그아웃' : 'Log out', // 언어 설정
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndEmailField({
    required String nameLabel,
    required String emailLabel,
    required TextEditingController controller,
    required String email,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nameLabel,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        errorText: errorMessage,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      controller.clear(); // 이름 필드 지우기
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              Text(
                '$emailLabel: $email',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
