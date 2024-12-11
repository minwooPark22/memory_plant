class MemoryLog {
  String? memoryId;
  String? title;
  String? contents;
  String? timestamp;
  bool? isUser;
  MemoryLog({this.memoryId, this.title, this.contents, this.timestamp, this.isUser});


  MemoryLog.fromJson(Map<String, dynamic> json, String docId) {
    memoryId = docId; // Firestore 문서 ID
    title = json['title'];
    contents = json['contents'];
    timestamp = json['timestamp'];
    isUser = json['isUser'];
  }
/*
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['contents'] = contents;
    data['timestamp'] = timestamp;
    data['isUser'] = isUser;
    return data;
  }
}
 */

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'contents': contents,
      'timestamp': timestamp,
      'isUser': isUser,
    };
  }
}

