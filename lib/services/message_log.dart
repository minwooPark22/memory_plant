class MessageLog {
  String? content;
  String? time;
  String? date;
  bool? isSentByMe;

  MessageLog({this.content, this.time, this.date, this.isSentByMe});

  MessageLog.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    time = json['time'];
    date = json['date'];
    isSentByMe = json['isSentByMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['time'] = time;
    data['date'] = date;
    data['isSentByMe'] = isSentByMe;
    return data;
  }
}