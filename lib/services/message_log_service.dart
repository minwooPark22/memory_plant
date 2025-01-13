import 'package:memory_plant_application/services/message_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMessageLog(MessageLog message) async {
    final user = FirebaseAuth.instance.currentUser;
    final currentYear = DateTime.now().year.toString();
    if (user != null) {
      final chatLogDoc = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chatlog')
          .doc(currentYear);

      final docSnapshot = await chatLogDoc.get();
      if (!docSnapshot.exists) {
        await chatLogDoc.set({
          'messages': [message.toJson()]
        });
      } else {
        await chatLogDoc.update({
          'messages': FieldValue.arrayUnion([message.toJson()])
        });
      }
    }
  }

  // 메시지 불러오기 (역순)
  Future<List<MessageLog>> loadMessageLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentYear = DateTime.now().year.toString();
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chatlog')
          .doc(currentYear)
          .get();

      List<MessageLog> loadedMessages = [];
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final messages = data['messages'] as List;
          loadedMessages =
              messages.map((message) => MessageLog.fromJson(message)).toList();
          loadedMessages = loadedMessages.reversed.toList();
        }
      }
      return loadedMessages;
    }
    return [];
  }

  // 메시지 삭제
  Future<void> deleteMessage(MessageLog message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoryYear = DateTime.parse(message.timestamp!).year.toString();
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chatlog')
          .doc(memoryYear);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.update({
          'messages': FieldValue.arrayRemove([message.toJson()])
        });
      } // Firestore에서 메시지 삭제
    }
  }
}
