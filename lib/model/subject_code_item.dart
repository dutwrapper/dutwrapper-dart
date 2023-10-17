// Details in http://daotao.dut.udn.vn/download2/Guide_Dangkyhoc.pdf, page 28
class SubjectCodeItem {
  // Area 1
  int subjectId = 0;
  // Area 2
  int schoolYearId = 0;
  // Area 3
  String studentYearId = '';
  // Area 4
  String classId = '';

  SubjectCodeItem();
  SubjectCodeItem.fromTwoLastDigit(
      {required this.studentYearId, required this.classId});
  SubjectCodeItem.from(
      {required this.subjectId,
      required this.schoolYearId,
      required this.studentYearId,
      required this.classId});
  SubjectCodeItem.fromString({required String input}) {
    if (input.isNotEmpty) {
      final splitted = input.split('.');
      if (splitted.length == 4) {
        subjectId = int.parse(splitted[0]);
        schoolYearId = int.parse(splitted[1]);
        studentYearId = splitted[2];
        classId = splitted[3];
      }
    }
  }

  @override
  String toString() {
    return '$subjectId.$schoolYearId.$studentYearId.$classId';
  }

  String toStringTwoLastDigit() {
    return '$studentYearId.$classId';
  }

  bool equalsTwoLastDigits(SubjectCodeItem item) {
    return item.classId == classId && item.studentYearId == studentYearId;
  }

  bool equals(SubjectCodeItem item) {
    return item.subjectId == subjectId &&
        item.schoolYearId == schoolYearId &&
        equalsTwoLastDigits(item);
  }
}
