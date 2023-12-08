import '../enums.dart';
import '../range_class.dart';
import 'news_global.dart';
import 'news_subject_group.dart';

class NewsSubject extends NewsGlobal {
  List<NewsSubjectGroup> affectedClasses = [];
  int affectedDate = 0;
  LessonStatus lessonStatus = LessonStatus.unknown;
  RangeInt affectedLessons = RangeInt(start: 0, end: 0);
  String affectedRoom = '';
  String lecturerName = '';
  LecturerGender lecturerGender = LecturerGender.other;
}
