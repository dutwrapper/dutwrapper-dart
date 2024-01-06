import 'dart:convert';

class NewsLink {
  final String text;
  final int position;
  final String url;

  const NewsLink({
    required this.text,
    required this.position,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'position': position});
    result.addAll({'url': url});

    return result;
  }

  factory NewsLink.fromMap(Map<String, dynamic> map) {
    return NewsLink(
      text: map['text'] ?? '',
      position: map['position']?.toInt() ?? 0,
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsLink.fromJson(String source) =>
      NewsLink.fromMap(json.decode(source));
}
