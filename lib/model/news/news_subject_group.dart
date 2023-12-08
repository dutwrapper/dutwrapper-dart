import '../subject_code.dart';

class NewsSubjectGroup {
  List<SubjectCode> codeList = [];
  String subjectName = '';

  @override
  String toString() {
    return '$subjectName [${codeList.join(', ')}]';
  }
}
