import 'dart:convert';

import 'news_link.dart';

class NewsGlobal {
  String title;
  String content;
  String contentString;
  int date;
  List<NewsLink> links = [];

  NewsGlobal.createDefault()
      : title = '',
        content = '',
        contentString = '',
        date = 0,
        links = [];

  NewsGlobal({
    this.title = '',
    this.content = '',
    this.contentString = '',
    this.date = 0,
    required this.links,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'contentString': contentString});
    result.addAll({'date': date});
    result.addAll({'links': links.map((x) => x.toMap()).toList()});

    return result;
  }

  factory NewsGlobal.fromMap(Map<String, dynamic> map) {
    return NewsGlobal(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      contentString: map['contentString'] ?? '',
      date: map['date']?.toInt() ?? 0,
      links: List<NewsLink>.from(map['links']?.map((x) => NewsLink.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsGlobal.fromJson(String source) =>
      NewsGlobal.fromMap(json.decode(source));
}
