import 'enums.dart';

class GlobalUrl {
  static String newsLink({
    NewsType newsType = NewsType.global,
    int page = 1,
    NewsSearchMethod searchType = NewsSearchMethod.byTitle,
    String? query,
  }) {
    // Parameter - E
    String e = switch (newsType) {
      NewsType.subject => "CTRTBGV",
      NewsType.unknown => "",
      _ => "CTRTBSV",
    };

    // Parameter - COL
    String col = searchType.toString();

    // Parameter - TAB
    String tab = newsType.value.toString();

    return "${baseLink()}/WebAjax/evLopHP_Load.aspx?"
        "E=${e}&PAGETB=${page}&COL=${col}&NAME=${query ?? ""}&TAB=${tab}";
  }

  static String subjectScheduleLink({
    int year = 23,
    int semester = 1,
  }) {
    if (semester > 3 || semester < 1) {
      throw ArgumentError("Invaild argument(s)!");
    }
    String code = '$year${semester < 3 ? semester : 2}${semester == 3 ? 1 : 0}';
    return "${baseLink()}/WebAjax/evLopHP_Load.aspx?E=TTKBLoad&Code=$code";
  }

  static String subjectFeeLink({
    int year = 23,
    int semester = 1,
  }) {
    if (semester > 3 || semester < 1) {
      throw ArgumentError("Invaild argument(s)!");
    }
    String code = '$year${semester < 3 ? semester : 2}${semester == 3 ? 1 : 0}';
    return "${baseLink()}/WebAjax/evLopHP_Load.aspx?E=THPhiLoad&Code=$code";
  }

  static String baseLink() => "https://sv.dut.udn.vn";

  static String loginLink() => "${baseLink()}/PageDangNhap.aspx";

  static String logoutLink() => "${baseLink()}/PageLogout.aspx";

  static String accountInformationLink() => "${baseLink()}/PageCaNhan.aspx";

  static String trainingStatusLink() => "${baseLink()}/PageKQRL.aspx";

  static String dutSchedulePage() => "https://lichtuan.dut.udn.vn/home";
}
