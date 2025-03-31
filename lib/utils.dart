import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'http_client_wrapper.dart';
import 'http_element_parser.dart';
import 'global_url.dart';
import 'lib_exception.dart';
import 'utils_object.dart';

class Utils {
  static int getCurrentTimeUnixMilliseconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static Future<HttpClientResponse> checkPageStatus({int timeout = 60}) async {
    return HttpClientWrapper.get(uri: Uri.parse(GlobalUrl.baseLink()));
  }

  static Future<DutSchoolYear?> getCurrentSchoolYear({int timeout = 60}) async {
    try {
      final response = await http
          .get(Uri.parse(GlobalUrl.dutSchedulePage()))
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
        throw DutWrapperException(
          message: "We can't receive any information about this request! "
              "Please, try again later.",
          reason: DutWrapperExceptionReason.dataNotFoundException,
        );
      } else {
        schYear = cbbYear.getText();
        schYearVal = int.parse(cbbYear.getValue() ?? "0");
      }

      // Week item processing
      var cbbWeek = webDoc
          .getElementById("dnn_ctr442_View_cboTuan")
          .getSelectedOptionInComboBox();
      if (cbbWeek == null) {
        throw DutWrapperException(
          message: "We can't receive any information about this request! "
              "Please, try again later.",
          reason: DutWrapperExceptionReason.dataNotFoundException,
        );
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

  static Future<bool> _checkDomain(String domain) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup(domain);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  static Future<void> ensureServerWorking() async {
    debugPrint("Checking internet access...");
    if (!await _checkDomain("example.com")) {
      throw DutWrapperException(
        message: "Looks like you don't have an internet connection. "
            "Check your internet settings, and try again.",
        reason: DutWrapperExceptionReason.internetNotFound,
      );
    }
    debugPrint("Checking sv.dut.udn.vn...");
    if (!await _checkDomain("sv.dut.udn.vn")) {
      throw DutWrapperException(
        message: "Looks like you have an internet connection, "
            "but can't connect to sv.dut.udn.vn server. Try again later. "
            "You might need to check your internet settings again to confirm.",
        reason: DutWrapperExceptionReason.internetNotFound,
      );
    }
    debugPrint("It looks like you have connected to sv.dut.udn.vn.");
  }
}
