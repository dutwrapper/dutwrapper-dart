import 'dart:convert';

import '../enums.dart';
import '../range_class.dart';
import 'news_global.dart';
import 'news_link.dart';
import 'news_subject_group.dart';

class NewsSubject extends NewsGlobal {
  List<NewsSubjectGroup> affectedClasses;
  int affectedDate;
  LessonStatus lessonStatus;
  RangeInt affectedLessons;
  String affectedRoom;
  String lecturerName;
  LecturerGender lecturerGender;

  NewsSubject({
    super.title = '',
    super.content = '',
    super.contentString = '',
    super.date = 0,
    required super.links,
    required this.affectedClasses,
    this.affectedDate = 0,
    this.lessonStatus = LessonStatus.unknown,
    required this.affectedLessons,
    this.affectedRoom = '',
    this.lecturerName = '',
    this.lecturerGender = LecturerGender.other,
  });

  NewsSubject.createDefault()
      : affectedClasses = [],
        affectedDate = 0,
        lessonStatus = LessonStatus.unknown,
        affectedLessons = RangeInt(start: 0, end: 0),
        affectedRoom = '',
        lecturerName = '',
        lecturerGender = LecturerGender.other,
        super.createDefault();

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': super.title});
    result.addAll({'content': super.content});
    result.addAll({'contentString': super.contentString});
    result.addAll({'date': super.date});
    result.addAll({'links': super.links.map((x) => x.toMap()).toList()});
    result.addAll(
        {'affectedClasses': affectedClasses.map((x) => x.toMap()).toList()});
    result.addAll({'affectedDate': affectedDate});
    result.addAll({'affectedLessons': affectedLessons});
    result.addAll({'lessonStatus': lessonStatus.value});
    result.addAll({'affectedRoom': affectedRoom});
    result.addAll({'lecturerName': lecturerName});
    result.addAll({'lecturerGender': lecturerGender.value});

    return result;
  }

  factory NewsSubject.fromMap(Map<String, dynamic> map) {
    return NewsSubject(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      contentString: map['contentString'] ?? '',
      date: map['date']?.toInt() ?? 0,
      links: List<NewsLink>.from(map['links']?.map((x) => NewsLink.fromMap(x))),
      affectedClasses: List<NewsSubjectGroup>.from(
          map['affectedClasses']?.map((x) => NewsSubjectGroup.fromMap(x))),
      affectedDate: map['affectedDate']?.toInt() ?? 0,
      lessonStatus: LessonStatus.values.firstWhere(
        (element) => element.value == (map['lessonStatus'] ?? 0),
        orElse: () => LessonStatus.unknown,
      ),
      affectedLessons: map['affectedLessons'] != null
          ? RangeInt.fromMap(map['affectedLessons'])
          : RangeInt(start: 0, end: 0),
      affectedRoom: map['affectedRoom'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerGender: LecturerGender.values.firstWhere(
        (element) => element.value == (map['lecturerGender'] ?? 0),
        orElse: () => LecturerGender.other,
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory NewsSubject.fromJson(String source) =>
      NewsSubject.fromMap(json.decode(source));
}
