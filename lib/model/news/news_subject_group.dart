import 'dart:convert';

import '../subject_code.dart';

class NewsSubjectGroup {
  List<SubjectCode> codeList = [];
  String subjectName = '';

  NewsSubjectGroup.createDefault()
      : codeList = [],
        subjectName = '';

  NewsSubjectGroup({
    required this.codeList,
    required this.subjectName,
  });

  @override
  String toString() {
    return '$subjectName [${codeList.join(', ')}]';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codeList': codeList.map((x) => x.toMap()).toList()});
    result.addAll({'subjectName': subjectName});

    return result;
  }

  factory NewsSubjectGroup.fromMap(Map<String, dynamic> map) {
    return NewsSubjectGroup(
      codeList: List<SubjectCode>.from(
          map['codeList']?.map((x) => SubjectCode.fromMap(x))),
      subjectName: map['subjectName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsSubjectGroup.fromJson(String source) =>
      NewsSubjectGroup.fromMap(json.decode(source));
}
