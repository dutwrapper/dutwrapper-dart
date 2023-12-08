import '../range_class.dart';

class SubjectScheduleStudy {
  // 0: Sunday, 1: Monday -> 6: Saturday
  int dayOfWeek = 0;
  RangeInt lesson = RangeInt(start: 0, end: 0);
  String room = '';
}

class SubjectScheduleStudyList {
  List<SubjectScheduleStudy> subjectStudyList = [];
  List<RangeInt> weekList = [];
}
