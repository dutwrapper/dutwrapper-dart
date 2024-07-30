import 'dart:convert';

// Details in http://daotao.dut.udn.vn/download2/Guide_Dangkyhoc.pdf, page 28
class SubjectCode {
  // Area 1
  final String subjectId;
  // Area 2
  final String schoolYearId;
  // Area 3
  final String studentYearId;
  // Area 4
  final String classId;

  SubjectCode()
      : subjectId = '',
        schoolYearId = '',
        studentYearId = '',
        classId = '';

  factory SubjectCode.fromTwoLastDigit({
    required String studentYearId,
    required String classId,
  }) =>
      SubjectCode.from(
          subjectId: '',
          schoolYearId: '',
          studentYearId: studentYearId,
          classId: classId);

  SubjectCode.from({
    required this.subjectId,
    required this.schoolYearId,
    required this.studentYearId,
    required this.classId,
  });

  factory SubjectCode.fromString({required String input}) {
    if (input.isEmpty || (input.split('.').length != 4)) {
      throw ArgumentError("Not a subject code!");
    }

    return SubjectCode.from(
      subjectId: input.split('.')[0],
      schoolYearId: input.split('.')[1],
      studentYearId: input.split('.')[2],
      classId: input.split('.')[3],
    );
  }

  @override
  String toString() {
    return 'SubjectCode(subjectId: $subjectId, schoolYearId: $schoolYearId, studentYearId: $studentYearId, classId: $classId)';
  }

  String toStringTwoLastDigit() {
    return '$studentYearId.$classId';
  }

  bool equalsTwoLastDigits(SubjectCode item) {
    return item.classId == classId && item.studentYearId == studentYearId;
  }

  bool equals(SubjectCode item) {
    return item.subjectId == subjectId &&
        item.schoolYearId == schoolYearId &&
        equalsTwoLastDigits(item);
  }

  SubjectCode copyWith({
    String? subjectId,
    String? schoolYearId,
    String? studentYearId,
    String? classId,
  }) {
    return SubjectCode.from(
      subjectId: subjectId ?? this.subjectId,
      schoolYearId: schoolYearId ?? this.schoolYearId,
      studentYearId: studentYearId ?? this.studentYearId,
      classId: classId ?? this.classId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'subject_id': subjectId});
    result.addAll({'school_year_id': schoolYearId});
    result.addAll({'student_year_id': studentYearId});
    result.addAll({'class_id': classId});

    return result;
  }

  factory SubjectCode.fromMap(Map<String, dynamic> map) {
    return SubjectCode.from(
      subjectId: map['subject_id']?.toInt() ?? 0,
      schoolYearId: map['school_year_id']?.toInt() ?? 0,
      studentYearId: map['student_year_id'] ?? '',
      classId: map['class_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectCode.fromJson(String source) =>
      SubjectCode.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectCode &&
        other.subjectId == subjectId &&
        other.schoolYearId == schoolYearId &&
        other.studentYearId == studentYearId &&
        other.classId == classId;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
        schoolYearId.hashCode ^
        studentYearId.hashCode ^
        classId.hashCode;
  }
}
