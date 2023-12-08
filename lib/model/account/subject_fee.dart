import '../subject_code.dart';

class SubjectFee {
  SubjectCode id = SubjectCode();
  String name = '';
  int credit = 0;
  bool isHighQuality = false;
  double price = 0;
  bool isDebt = false;
  bool isReStudy = false;
  String? confirmedPaymentAt;
}
