import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'model/dut_school_year.dart';

class DutUtils {
  static int getCurrentTimeUnixMilliseconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static Future<DutSchoolYear?> getCurrentSchoolYear({int timeout = 60}) async {
    try {
      final response = await http
          .get(Uri.parse("http://dut.udn.vn/Lichtuan"))
          .timeout(Duration(seconds: timeout));

      // Main processing
      var webDoc = parse(response.body);

      DutSchoolYear? result;
      int? schYearVal;
      String? schYear;
      int? week;

      // School year item processing
      var cbbSchoolYear = webDoc
          .getElementById("dnn_ctr442_View_cboNamhoc")
          ?.getElementsByTagName("option");
      if (cbbSchoolYear == null) {
        // TODO: Error while parsing here.
        throw Exception("");
      }
      cbbSchoolYear.sort((p1, p2) {
        var v1 = int.parse(p1.attributes["value"] ?? "0");
        var v2 = int.parse(p2.attributes["value"] ?? "0");

        return (v1 < v2)
            ? 1
            : (v1 > v2)
                ? -1
                : 0;
      });

      for (var yearItem in cbbSchoolYear) {
        if (yearItem.attributes.containsKey("selected")) {
          schYear = yearItem.text;
          schYearVal = int.parse(yearItem.attributes["value"] ?? "0");
        }
      }

      // Week item processing
      var cbbWeek = webDoc
          .getElementById("dnn_ctr442_View_cboTuan")
          ?.getElementsByTagName("option");
      if (cbbWeek == null) {
        // TODO: Error while parsing here.
        throw Exception("");
      }
      cbbWeek.sort((p1, p2) {
        var v1 = int.parse(p1.attributes["value"] ?? "0");
        var v2 = int.parse(p2.attributes["value"] ?? "0");

        return (v1 < v2)
            ? 1
            : (v1 > v2)
                ? -1
                : 0;
      });

      for (var weekItem in cbbWeek) {
        if (weekItem.attributes.containsKey("selected")) {
          RegExp regex =
              RegExp("Tuần thứ (\\d{1,2}): (\\d{1,2}\\/\\d{1,2}\\/\\d{4})");
          if (regex.hasMatch(weekItem.text)) {
            var match1 = regex.firstMatch(weekItem.text)!;
            week = int.parse(match1.group(1)!);
            break;
          }
        }
      }

      if (schYear != null && schYearVal != null && week != null) {
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
