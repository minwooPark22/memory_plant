class MemoryLog {
  String? title;
  String? contents;
  String? timestamp;
  bool? isUser;
  MemoryLog({this.title, this.contents, this.timestamp, this.isUser});
  // isUser 추가함

  MemoryLog.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    contents = json['contents'];
    timestamp = json['timestamp'];
    isUser = json['isUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['contents'] = contents;
    data['timestamp'] = timestamp;
    data['isUser'] = isUser;
    return data;
  }
}


