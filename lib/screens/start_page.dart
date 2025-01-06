import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_plant_application/services/apple_sign_in_service.dart';

// 사용자 정의 예외 클래스
class EmptyNameException implements Exception {
  final String message;
  EmptyNameException(this.message);

  @override
  String toString() => message;
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  int currentButtonIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> _signInWithGoogle() async {
    try {
      // 구글 로그인 시도
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인을 취소했을 때
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인 인증 시도
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Firestore에 사용자 정보 저장
      if (user != null) {
        try {
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
          // 사용자의 정보를 Firestore에 저장. 기존 데이터가 있다면 덮어쓰기

          await userRef.set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'lastSignInTime': user.metadata.lastSignInTime,
            'creationTime': user.metadata.creationTime,
          }, SetOptions(merge: true));

          // print('사용자 정보가 Firestore에 성공적으로 저장되었습니다.');
        } catch (e) {
          // print('Firestore에 사용자 정보를 저장하는 중 오류 발생: $e');
        }
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDoc = await userRef.get();
        if (userDoc.exists && userDoc.data()?['nickname'] != null) {
          // nickname 필드가 이미 존재하면 바로 페이지로 이동
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/startPageAfterLogin");
          }
        }
        changeButton();
      } else {
        // print('로그인한 사용자 정보가 없습니다.');
      }
    } catch (e) {
      // 예외 처리
      // print("구글 로그인 오류: $e");
    }
  }

  // 로그인 상태 확인 함수
  Future<void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 화면이 빌드된 후 네비게이션을 호출하기 위해 지연 추가
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/startPageAfterLogin");
        }
      });
    } else {
      // print('사용자가 로그인되어 있지 않습니다.');
      setState(() {
        _signOut();
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      // print('로그아웃 성공');
    } catch (e) {
      // print("로그아웃 중 오류 발생: $e");
    }
  }

  final List<List<String>> buttonTexts = [
    // 각 페이지의 [한국어 텍스트, 영어 텍스트]
    ['한국어', 'English'], // 언어 선택 페이지
    ['Sign in with Google', 'Sign in with Apple'], // 로그인 선택 페이지
    ['이름을 입력해주세요.', 'Please enter your name'], // 이름 입력 페이지 힌트 메시지
    ['제출', 'Comfirm']
  ];

  final List<String> pageMessages = [
    'Please select your preferred language', // 한국어: 언어 선택 페이지 메시지
    '로그인할 계정을 선택해주세요', // 한국어: 로그인 선택 페이지 메시지
    '이름을 작성해주세요', // 한국어: 이름 입력 페이지 메시지
    'Please select your preferred language', // 영어: 언어 선택 페이지 메시지
    'Select the account to log in', // 영어: 로그인 선택 페이지 메시지
    'Please enter your name' // 영어: 이름 입력 페이지 메시지
  ];

  @override
  void initState() {
    super.initState();

    //==========================================================

    _checkLoginStatus(); // 로그인 상태 확인

    //==========================================================
  }

  void changeButton() {
    setState(() {
      if (currentButtonIndex < buttonTexts.length - 1) {
        currentButtonIndex++;
      }
    });
  }

  Future<void> _submitName() async {
    try {
      final name = _nameController.text.trim();

      if (name.isEmpty) {
        throw EmptyNameException(
            context.read<LanguageProvider>().currentLanguage == Language.ko
                ? '이름을 입력해주세요!'
                : 'Please enter your name!');
      }

      // Firestore에 이름 저장
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'nickname': name,
        });
      }

      // SharedPreferences와 상태 업데이트

      // 다음 페이지로 이동
      if (mounted) {
        await context.read<NameProvider>().updateName(name);
        if (mounted) {
          Navigator.pushNamed(context, "/startPageAfterLogin");
        }
      }
    } on EmptyNameException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            context.read<LanguageProvider>().currentLanguage == Language.ko
                ? '이름 저장에 실패했습니다.'
                : 'Failed to save the name.';
      });
      // print("Error saving name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),
                const Text(
                  'AI for\nrecording life',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'NanumFontSetup_TTF_SQUARE',
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  currentButtonIndex == 0
                      ? (isKorean
                          ? pageMessages[0] // 한국어: 언어 선택
                          : pageMessages[3]) // 영어: 언어 선택
                      : currentButtonIndex == 1
                          ? (isKorean
                              ? pageMessages[1] // 한국어: 로그인 선택
                              : pageMessages[4]) // 영어: 로그인 선택
                          : (isKorean
                              ? pageMessages[2] // 한국어: 이름 입력
                              : pageMessages[5]), // 영어: 이름 입력
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NanumFontSetup_TTF_SQUARE',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                if (currentButtonIndex < 2) ...[
                  OutlinedButton(
                    onPressed: () async {
                      if (currentButtonIndex == 0) {
                        context
                            .read<LanguageProvider>()
                            .setLanguage(Language.ko);
                        changeButton();
                      } else if (currentButtonIndex == 1) {
                        await _signInWithGoogle(); // 구글 로그인 결과 확인
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      buttonTexts[currentButtonIndex][0],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (currentButtonIndex == 0) {
                        context
                            .read<LanguageProvider>()
                            .setLanguage(Language.en);
                        changeButton();
                      } else if (currentButtonIndex == 1) {
                        try {
                          await AppleSignInService.signInWithApple(
                              context); // 애플 로그인
                        } catch (e) {
                          debugPrint("Apple Sign-In failed: $e");
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      buttonTexts[currentButtonIndex][1],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: buttonTexts[2]
                              [isKorean ? 0 : 1], // 힌트 메시지 변경
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  OutlinedButton(
                    onPressed: _submitName,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: Text(
                      buttonTexts[3]
                          [isKorean ? 0 : 1], // 버튼 텍스트를 '제출' 또는 'Confirm'으로 설정
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
