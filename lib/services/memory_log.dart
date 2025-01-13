class MemoryLog {
  String? title;
  String? contents;
  String? timestamp;
  bool? isUser;
  MemoryLog({this.title, this.contents, this.timestamp, this.isUser});

  MemoryLog.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    contents = json['contents'];
    timestamp = json['timestamp'];
    isUser = json['isUser'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'contents': contents,
      'timestamp': timestamp,
      'isUser': isUser,
    };
  }
}
