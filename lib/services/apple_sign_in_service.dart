import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInService {
  static Future<void> signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.memoryplantapplication', // 여기에 번들 ID를 입력하세요
          redirectUri: Uri.parse(
              'https://fluttertest-bc391.firebaseapp.com/__/auth/handler'), // Firebase 인증 리디렉션 URI
        ),
      );

      final oAuthProvider = OAuthProvider("apple.com");
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase 인증
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      if (user != null) {
        // Firestore에 사용자 정보 저장
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email ?? "Unknown",
          'displayName': user.displayName ?? "Unknown",
          'lastSignInTime': user.metadata.lastSignInTime,
          'creationTime': user.metadata.creationTime,
        }, SetOptions(merge: true)); // 병합 옵션

        // 로그인 성공 시 다음 페이지로 이동
        Navigator.pushReplacementNamed(context, "/startPageAfterLogin");
      } else {
        throw Exception("Apple Sign-In failed: No user data");
      }
    } catch (error) {
      debugPrint("Apple Sign-In error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Apple Sign-In failed: $error")),
      );
    }
  }
}
