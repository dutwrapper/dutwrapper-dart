import 'dart:convert';

import '../subject_code.dart';
import 'subject_schedule_exam.dart';
import 'subject_schedule_study.dart';

class SubjectSchedule {
  SubjectCode id;
  String name;
  int credit;
  bool isHighQuality;
  String lecturerName;
  SubjectScheduleStudyList subjectStudy;
  SubjectScheduleExam subjectExam;
  String pointFormula;

  SubjectSchedule.createDefault()
      : id = SubjectCode(),
        name = '',
        credit = 0,
        isHighQuality = false,
        lecturerName = '',
        subjectStudy = SubjectScheduleStudyList.createDefault(),
        subjectExam = SubjectScheduleExam.createDefault(),
        pointFormula = '';

  SubjectSchedule({
    required this.id,
    required this.name,
    required this.credit,
    required this.isHighQuality,
    required this.lecturerName,
    required this.subjectStudy,
    required this.subjectExam,
    required this.pointFormula,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id.toMap()});
    result.addAll({'name': name});
    result.addAll({'credit': credit});
    result.addAll({'isHighQuality': isHighQuality});
    result.addAll({'lecturerName': lecturerName});
    result.addAll({'subjectStudy': subjectStudy.toMap()});
    result.addAll({'subjectExam': subjectExam.toMap()});
    result.addAll({'pointFormula': pointFormula});

    return result;
  }

  factory SubjectSchedule.fromMap(Map<String, dynamic> map) {
    return SubjectSchedule(
      id: SubjectCode.fromMap(map['id']),
      name: map['name'] ?? '',
      credit: map['credit']?.toInt() ?? 0,
      isHighQuality: map['isHighQuality'] ?? false,
      lecturerName: map['lecturerName'] ?? '',
      subjectStudy: map['subjectStudy'] != null
          ? SubjectScheduleStudyList.fromMap(map['subjectStudy'])
          : SubjectScheduleStudyList.createDefault(),
      subjectExam: map['subjectExam'] != null
          ? SubjectScheduleExam.fromMap(map['subjectExam'])
          : SubjectScheduleExam.createDefault(),
      pointFormula: map['pointFormula'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectSchedule.fromJson(String source) =>
      SubjectSchedule.fromMap(json.decode(source));
}
