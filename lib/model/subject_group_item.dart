import 'subject_code_item.dart';

class SubjectGroupItem {
  List<SubjectCodeItem> codeList = [];
  String subjectName = '';

  @override
  String toString() {
    return '$subjectName [${codeList.join(', ')}]';
  }
}
