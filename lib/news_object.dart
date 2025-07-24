import 'dart:convert';

import 'enums.dart';
import 'news_function.dart';
import 'range_class.dart';
import 'subject_code.dart';

class NewsCore {
  String title;
  String newsType;
  String contentHtml;
  String content;
  int datePublished;
  int dateFetched;
  List<NewsResource> resources = [];

  NewsCore.createDefault()
      : newsType = 'unknown',
        title = '',
        contentHtml = '',
        content = '',
        datePublished = 0,
        dateFetched = 0,
        resources = [];

  NewsCore({
    this.newsType = 'unknown',
    this.title = '',
    this.contentHtml = '',
    this.content = '',
    this.datePublished = 0,
    this.dateFetched = 0,
    required this.resources,
  });

  String toMarkdown() {
    String result = content;
    var resTemp = resources.reversed.where((p) => p.type == "link").toList();

    for (var linkItem in resTemp) {
      if (linkItem.type == 'link') {
        result = result.replaceRange(
          linkItem.position,
          linkItem.position + linkItem.text.length,
          "[${linkItem.text}](${linkItem.content})",
        );
      }
    }

    return result;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'news_type': newsType});
    result.addAll({'title': title});
    result.addAll({'content_html': contentHtml});
    result.addAll({'content': content});
    result.addAll({'date_published': datePublished});
    result.addAll({'date_fetched': dateFetched});
    result.addAll({'resources': resources.map((x) => x.toMap()).toList()});

    return result;
  }

  factory NewsCore.fromMap(Map<String, dynamic> map) {
    return NewsCore(
      newsType: map['news_type'] ?? 'unknown',
      title: map['title'] ?? '',
      contentHtml: map['content_html'] ?? '',
      content: map['content'] ?? '',
      datePublished: map['date_published']?.toInt() ?? 0,
      dateFetched: map['date_fetched']?.toInt() ?? 0,
      resources: List<NewsResource>.from(map['resources']?.map((x) => NewsResource.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsCore.fromJson(String source) => NewsCore.fromMap(json.decode(source));

  NewsSubject convertToNewsSubject() {
    try {
      if (newsType != NewsType.subject.toString()) {
        return NewsSubject(
          datePublished: this.datePublished,
          title: this.title,
          contentHtml: this.contentHtml,
          content: this.content,
          resources: this.resources.toList(),
          dateFetched: this.dateFetched,
          // Lecturer name
          lecturerName: NewsFunction.getNewsLecturerName(this.title),
          // Lecturer gender
          lecturerGender: NewsFunction.getNewsLecturerGender(this.title),
          // Check if is make up or leaving subject lessons.
          lessonStatus: NewsFunction.getNewsLessonStatus(this.content),
          // Affected class (got from title).
          affectedClasses: NewsFunction.getNewsAffectedSubjects(this.title),
          // Lesson (Works only if lesson status is leaving and make up)
          affectedLessons: NewsFunction.getNewsAffectedLessons(this.content),
          // Date (Works only if lesson status is leaving and make up)
          affectedDate: NewsFunction.getNewsAdjustDate(this.content),
          // Room (Works only if lesson status is maked up)
          affectedRoom: NewsFunction.getNewsMakeupRoom(this.content),
        );
      } else
        throw Exception('This news isn\'t for subject news.');
    } catch (_) {
      return NewsSubject(
        datePublished: this.datePublished,
        title: this.title,
        contentHtml: this.contentHtml,
        content: this.content,
        dateFetched: this.dateFetched,
        resources: this.resources.toList(),
      );
    }
  }
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

  factory NewsResource.fromJson(String source) => NewsResource.fromMap(json.decode(source));
}

class NewsSubject extends NewsCore {
  List<SubjectAffected> affectedClasses;
  int affectedDate;
  LessonStatus lessonStatus;
  RangeInt affectedLessons;
  String affectedRoom;
  String lecturerName;
  LecturerGender lecturerGender;

  NewsSubject({
    super.newsType = 'unknown',
    super.title = '',
    super.contentHtml = '',
    super.content = '',
    super.datePublished = 0,
    super.dateFetched = 0,
    required super.resources,
    List<SubjectAffected>? affectedClasses,
    this.affectedDate = 0,
    this.lessonStatus = LessonStatus.unknown,
    RangeInt? affectedLessons,
    this.affectedRoom = '',
    this.lecturerName = '',
    this.lecturerGender = LecturerGender.unknown,
  })  : affectedClasses = affectedClasses ?? [],
        affectedLessons = affectedLessons ?? RangeInt();

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

    result.addAll({'news_type': newsType});
    result.addAll({'title': super.title});
    result.addAll({'content_html': super.contentHtml});
    result.addAll({'content': super.content});
    result.addAll({'date_published': super.datePublished});
    result.addAll({'date_fetched': dateFetched});
    result.addAll({'resources': super.resources.map((x) => x.toMap()).toList()});
    result.addAll({'affected_class': affectedClasses.map((x) => x.toMap()).toList()});
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
      newsType: map['news_type'] ?? 'unknown',
      title: map['title'] ?? '',
      contentHtml: map['content_html'] ?? '',
      content: map['content'] ?? '',
      datePublished: map['date_published']?.toInt() ?? 0,
      dateFetched: map['date_fetched']?.toInt() ?? 0,
      resources: List<NewsResource>.from(map['resources']?.map((x) => NewsResource.fromMap(x))),
      affectedClasses: List<SubjectAffected>.from(map['affected_class']?.map((x) => SubjectAffected.fromMap(x))),
      affectedDate: map['affected_date']?.toInt() ?? 0,
      lessonStatus: LessonStatus.values.firstWhere(
        (element) => element.value == (map['status'] ?? 0),
        orElse: () => LessonStatus.unknown,
      ),
      affectedLessons: map['affected_lessons'] != null ? RangeInt.fromMap(map['affected_lessons']) : RangeInt(start: 0, end: 0),
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

  factory NewsSubject.fromJson(String source) => NewsSubject.fromMap(json.decode(source));
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
      codeList: List<SubjectCode>.from(map['code_list']?.map((x) => SubjectCode.fromMap(x))),
      subjectName: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectAffected.fromJson(String source) => SubjectAffected.fromMap(json.decode(source));
}
