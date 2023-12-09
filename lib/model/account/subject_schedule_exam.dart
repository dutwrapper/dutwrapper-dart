class SubjectScheduleExam {
  int date = 0;
  String room = '';
  bool isGlobal = false;
  String group = '';

  SubjectScheduleExam();

  SubjectScheduleExam.from({
    required int date,
    required String room,
    required bool isGlobal,
    required String group,
  });
}
