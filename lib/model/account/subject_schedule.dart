import '../subject_code.dart';
import 'subject_schedule_exam.dart';
import 'subject_schedule_study.dart';

class SubjectSchedule {
  SubjectCode id = SubjectCode();
  String name = '';
  int credit = 0;
  bool isHighQuality = false;
  String lecturerName = '';
  SubjectScheduleStudyList subjectStudy = SubjectScheduleStudyList();
  SubjectScheduleExam subjectExam = SubjectScheduleExam();
  String pointFormula = '';
}
