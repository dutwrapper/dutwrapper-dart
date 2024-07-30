import 'dart:convert';

import 'enums.dart';
import 'range_class.dart';
import 'subject_code.dart';

class NewsGlobal {
  String title;
  String contentHtml;
  String content;
  int date;
  List<NewsResource> resources = [];

  NewsGlobal.createDefault()
      : title = '',
        contentHtml = '',
        content = '',
        date = 0,
        resources = [];

  NewsGlobal({
    this.title = '',
    this.contentHtml = '',
    this.content = '',
    this.date = 0,
    required this.resources,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'content_html': contentHtml});
    result.addAll({'content': content});
    result.addAll({'date': date});
    result.addAll({'resources': resources.map((x) => x.toMap()).toList()});

    return result;
  }

  factory NewsGlobal.fromMap(Map<String, dynamic> map) {
    return NewsGlobal(
      title: map['title'] ?? '',
      contentHtml: map['content_html'] ?? '',
      content: map['content'] ?? '',
      date: map['date']?.toInt() ?? 0,
      resources: List<NewsResource>.from(map['resources']?.map((x) => NewsResource.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsGlobal.fromJson(String source) =>
      NewsGlobal.fromMap(json.decode(source));
}

class NewsResource {
  final String text;
  final int position;
  final String type;
  final String content;

  const NewsResource({
    required this.text,
    required this.position,
    required this.type,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'position': position});
    result.addAll({'type': type});
    result.addAll({'content': content});

    return result;
  }

  factory NewsResource.fromMap(Map<String, dynamic> map) {
    return NewsResource(
      text: map['text'] ?? '',
      position: map['position']?.toInt() ?? 0,
      type: map['type'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsResource.fromJson(String source) =>
      NewsResource.fromMap(json.decode(source));
}

class NewsSubject extends NewsGlobal {
  List<SubjectAffected> affectedClasses;
  int affectedDate;
  LessonStatus lessonStatus;
  RangeInt affectedLessons;
  String affectedRoom;
  String lecturerName;
  LecturerGender lecturerGender;

  NewsSubject({
    super.title = '',
    super.contentHtml = '',
    super.content = '',
    super.date = 0,
    required super.resources,
    required this.affectedClasses,
    this.affectedDate = 0,
    this.lessonStatus = LessonStatus.unknown,
    required this.affectedLessons,
    this.affectedRoom = '',
    this.lecturerName = '',
    this.lecturerGender = LecturerGender.unknown,
  });

  NewsSubject.createDefault()
      : affectedClasses = [],
        affectedDate = 0,
        lessonStatus = LessonStatus.unknown,
        affectedLessons = RangeInt(start: 0, end: 0),
        affectedRoom = '',
        lecturerName = '',
        lecturerGender = LecturerGender.unknown,
        super.createDefault();

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': super.title});
    result.addAll({'content_html': super.contentHtml});
    result.addAll({'content': super.content});
    result.addAll({'date': super.date});
    result.addAll({'resources': super.resources.map((x) => x.toMap()).toList()});
    result.addAll(
        {'affected_class': affectedClasses.map((x) => x.toMap()).toList()});
    result.addAll({'affected_date': affectedDate});
    result.addAll({'affected_lessons': affectedLessons});
    result.addAll({'status': lessonStatus.value});
    result.addAll({'makeup_room': affectedRoom});
    result.addAll({'lecturer_name': lecturerName});
    result.addAll({'lecturer_gender': lecturerGender.value});

    return result;
  }

  factory NewsSubject.fromMap(Map<String, dynamic> map) {
    return NewsSubject(
      title: map['title'] ?? '',
      contentHtml: map['content_html'] ?? '',
      content: map['content'] ?? '',
      date: map['date']?.toInt() ?? 0,
      resources: List<NewsResource>.from(map['resources']?.map((x) => NewsResource.fromMap(x))),
      affectedClasses: List<SubjectAffected>.from(
          map['affected_class']?.map((x) => SubjectAffected.fromMap(x))),
      affectedDate: map['affected_date']?.toInt() ?? 0,
      lessonStatus: LessonStatus.values.firstWhere(
            (element) => element.value == (map['status'] ?? 0),
        orElse: () => LessonStatus.unknown,
      ),
      affectedLessons: map['affectedLessons'] != null
          ? RangeInt.fromMap(map['affected_lessons'])
          : RangeInt(start: 0, end: 0),
      affectedRoom: map['makeup_room'] ?? '',
      lecturerName: map['lecturer_name'] ?? '',
      lecturerGender: LecturerGender.values.firstWhere(
            (element) => element.value == (map['lecturer_gender'] ?? 0),
        orElse: () => LecturerGender.unknown,
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory NewsSubject.fromJson(String source) =>
      NewsSubject.fromMap(json.decode(source));
}

class SubjectAffected {
  List<SubjectCode> codeList;
  String subjectName;

  SubjectAffected.createDefault()
      : codeList = [],
        subjectName = '';

  SubjectAffected({
    required this.codeList,
    required this.subjectName,
  });

  @override
  String toString() {
    return '$subjectName [${codeList.join(', ')}]';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'code_list': codeList.map((x) => x.toMap()).toList()});
    result.addAll({'name': subjectName});

    return result;
  }

  factory SubjectAffected.fromMap(Map<String, dynamic> map) {
    return SubjectAffected(
      codeList: List<SubjectCode>.from(
          map['code_list']?.map((x) => SubjectCode.fromMap(x))),
      subjectName: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectAffected.fromJson(String source) =>
      SubjectAffected.fromMap(json.decode(source));
}
