import 'subject_code_item.dart';
import 'range_class.dart';

class SubjectScheduleItem {
  SubjectCodeItem id = SubjectCodeItem();
  String name = '';
  int credit = 0;
  bool isHighQuality = false;
  String lecturerName = '';
  SubjectStudyList subjectStudy = SubjectStudyList();
  SubjectExamItem subjectExam = SubjectExamItem();
  String pointFormula = '';
}

class SubjectExamItem {
  int date = 0;
  String room = '';
  bool isGlobal = false;
  String group = '';
}

class SubjectStudyList {
  List<SubjectStudyItem> subjectStudyList = [];
  List<RangeInt> weekList = [];
}

class SubjectStudyItem {
  // 0: Sunday, 1: Monday -> 6: Saturday
  int dayOfWeek = 0;
  RangeInt lesson = RangeInt(start: 0, end: 0);
  String room = '';
}
