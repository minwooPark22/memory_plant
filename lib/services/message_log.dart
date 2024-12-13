class MessageLog {
  String? id; // Firestore 문서 ID (추가추가)
  String? content;
  String? time;
  String? date;
  bool? isSentByMe;

  MessageLog({this.id, this.content, this.time, this.date, this.isSentByMe});

  MessageLog.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    content = json['content'];
    time = json['time'];
    date = json['date'];
    isSentByMe = json['isSentByMe'];
  }
/*
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['time'] = time;
    data['date'] = date;
    data['isSentByMe'] = isSentByMe;
    return data;
  }*/
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'time': time,
      'date': date,
      'isSentByMe': isSentByMe,
    };
  }
}