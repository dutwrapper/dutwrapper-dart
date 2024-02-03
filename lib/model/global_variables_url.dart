import 'enums.dart';

class GlobalVariablesUrl {
  static String newsLink({
    NewsType newsType = NewsType.global,
    int page = 1,
    NewsSearchType searchType = NewsSearchType.byTitle,
    String? query,
  }) {
    return "${baseLink()}/WebAjax/evLopHP_Load.aspx?E=${(newsType == NewsType.global) ? 'CTRTBSV' : 'CTRTBGV'}&PAGETB=$page&COL=${searchType == NewsSearchType.byTitle ? "TieuDe" : "NoiDung"}&NAME=${query ?? ""}&TAB=0";
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

  static String baseLink() => "http://sv.dut.udn.vn";

  static String loginLink() => "${baseLink()}/PageDangNhap.aspx";

  static String logoutLink() => "${baseLink()}/PageLogout.aspx";

  static String accountInformationLink() => "${baseLink()}/PageCaNhan.aspx";

  static String trainingStatusLink() => "${baseLink()}/PageKQRL.aspx";

  static String dutSchedulePage() => "http://dut.udn.vn/Lichtuan";
}
