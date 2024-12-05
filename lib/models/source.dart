enum SourceOpenTarget {
    Local, FullContent, Webpage, External, InApp
}

class RSSSource {
  String id;
  String url;
  String iconUrl;
  String name;
  SourceOpenTarget openTarget;
  int unreadCount;
  DateTime latest;
  String lastTitle;

  RSSSource(this.id, this.url, this.name) {
    iconUrl = '';
    openTarget = SourceOpenTarget.InApp;
    unreadCount = 0;
    latest = DateTime.now();
    lastTitle = '';
  }

  RSSSource.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    url = map['url'];
    name = map['name'];
    iconUrl = map['iconUrl'] ?? '';
    openTarget = SourceOpenTarget.values[map['openTarget'] ?? 0];
    unreadCount = map['unreadCount'] ?? 0;
    latest = DateTime.fromMillisecondsSinceEpoch(map['latest'] ?? DateTime.now().millisecondsSinceEpoch);
    lastTitle = map['lastTitle'] ?? '';
  }
}
