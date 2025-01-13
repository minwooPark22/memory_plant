class MessageLog {
  String? content;
  String? timestamp;
  bool? isSentByMe;

  MessageLog({this.content, this.timestamp, this.isSentByMe});

  MessageLog.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    timestamp = json['timestamp'];
    isSentByMe = json['isSentByMe'];
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timestamp': timestamp,
      'isSentByMe': isSentByMe,
    };
  }
}
