import 'enums.dart';
import 'range_class.dart';
import 'subject_group_item.dart';

class NewsLinkItem {
  final String text;
  final int position;
  final String url;

  const NewsLinkItem({
    required this.text,
    required this.position,
    required this.url,
  });
}

class NewsGlobal {
  String title = '';
  String content = '';
  String contentString = '';
  int date = 0;
  List<NewsLinkItem> links = [];
}

class NewsSubject extends NewsGlobal {
  List<SubjectGroupItem> affectedClasses = [];
  int affectedDate = 0;
  LessonStatus lessonStatus = LessonStatus.unknown;
  RangeInt affectedLessons = RangeInt(start: 0, end: 0);
  String affectedRoom = '';
  String lecturerName = '';
  LecturerGender lecturerGender = LecturerGender.other;
}
