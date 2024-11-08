class MemoryLog {
  String? title;
  String? contents;
  String? timestamp;
  MemoryLog({this.title, this.contents, this.timestamp});

  MemoryLog.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    contents = json['contents'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['contents'] = contents;
    data['timestamp'] = timestamp;
    return data;
  }
}


