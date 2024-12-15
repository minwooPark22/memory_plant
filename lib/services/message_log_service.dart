import 'package:memory_plant_application/services/message_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMessageLog(MessageLog message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final chatLogCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chatlog');
      final docRef =
          await chatLogCollection.add(message.toJson()); // Firestore에 메시지 추가
      message.id = docRef.id; // 새로 생성된 문서의 ID 저장
    }
  }

  // 메시지 불러오기
  Future<List<MessageLog>> loadMessageLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final chatLogCollection = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chatlog')
          .orderBy('date', descending: true);

      final querySnapshot = await chatLogCollection.get();
      return querySnapshot.docs
          .map((doc) => MessageLog.fromJson(doc.data(), doc.id)) // doc.id 추가
          .toList();
    }
    return [];
  }

  // 메시지 삭제
  Future<void> deleteMessage(String messageId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final chatLogCollection =
          _firestore.collection('users').doc(user.uid).collection('chatlog');
      await chatLogCollection.doc(messageId).delete(); // Firestore에서 메시지 삭제
    }
  }
}
