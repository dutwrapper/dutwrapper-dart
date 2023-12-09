import 'package:dutwrapper/utils/html_parser_extension.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'model/dut_school_year.dart';
import 'model/global_variables_url.dart';

class DutUtils {
  static int getCurrentTimeUnixMilliseconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static Future<DutSchoolYear?> getCurrentSchoolYear({int timeout = 60}) async {
    try {
      final response = await http
          .get(Uri.parse(GlobalVariablesUrl.dutSchedulePage()))
          .timeout(Duration(seconds: timeout));

      // Main processing
      var webDoc = parse(response.body);

      DutSchoolYear? result;
      int? schYearVal;
      String? schYear;
      int? week;

      // School year item processing
      var cbbYear = webDoc
          .getElementById("dnn_ctr442_View_cboNamhoc")
          .getSelectedOptionInComboBox();
      if (cbbYear == null) {
        // TODO: Error while parsing here.
        throw Exception("");
      } else {
        schYear = cbbYear.getText();
        schYearVal = int.parse(cbbYear.getValue() ?? "0");
      }

      // Week item processing
      var cbbWeek = webDoc
          .getElementById("dnn_ctr442_View_cboTuan")
          .getSelectedOptionInComboBox();
      if (cbbWeek == null) {
        // TODO: Error while parsing here.
        throw Exception("");
      } else {
        RegExp regex =
            RegExp("Tuần thứ (\\d{1,2}): (\\d{1,2}\\/\\d{1,2}\\/\\d{4})");
        if (regex.hasMatch(cbbWeek.text)) {
          var match1 = regex.firstMatch(cbbWeek.text)!;
          week = int.parse(match1.group(1)!);
        }
      }

      // schYearVal != null
      if (schYear != null && week != null) {
        result = DutSchoolYear(
          schoolYear: schYear,
          schoolYearVal: schYearVal,
          week: week,
        );
      }

      return result;
    } catch (ex) {
      return null;
    }
  }

  // 1: Sunday, 2-7: Monday-Saturday
  // fullString: Monday instead of Mon
  static String dateOfWeekToString({
    int dayOfweek = 1,
    bool fullString = false,
  }) {
    var dataFull = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    var dataShort = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    if (dayOfweek > 7 || dayOfweek < 1) {
      throw ArgumentError("Invaild dayOfWeek argument!");
    }

    return fullString ? dataFull[dayOfweek - 1] : dataShort[dayOfweek - 1];
  }
}
