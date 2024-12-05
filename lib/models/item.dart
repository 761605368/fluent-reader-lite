class RSSItem {
  String id;
  String sourceId;
  String title;
  String link;
  String content;
  DateTime date;
  bool hasRead;
  bool starred;
  String? creator;
  String? thumb;

  RSSItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    sourceId = map['sourceId'];
    title = map['title'];
    link = map['link'];
    content = map['content'];
    date = DateTime.fromMillisecondsSinceEpoch(map['date']);
    hasRead = map['hasRead'] ?? false;
    starred = map['starred'] ?? false;
    creator = map['creator'];
    thumb = map['thumb'];
  }
}
