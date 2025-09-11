import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'global_url.dart';
import 'http_client_wrapper.dart';
import 'http_element_parser.dart';
import 'lib_exception.dart';
import 'utils_object.dart';

class Utils {
  static Future<HttpClientResponse> checkPageStatus({int timeout = 60}) async {
    return HttpClientWrapper.get(uri: Uri.parse(GlobalUrl.baseLink()));
  }

  static Future<DutSchoolYear?> getCurrentSchoolYear({int timeout = 60}) async {
    try {
      final response = await http.get(Uri.parse(GlobalUrl.dutSchedulePage())).timeout(Duration(seconds: timeout));

      // Main processing
      var webDoc = parse(response.body);

      DutSchoolYear? result;
      int? schYearVal;
      String? schYear;
      int? week;
      int? firstDateWeek;

      // School year item processing
      var cbbYear = webDoc.getElementById("year-select").getSelectedOptionInComboBox();
      if (cbbYear == null) {
        throw DutWrapperException(
          message: "We can't receive any information about this request! "
              "Please, try again later.",
          reason: DutWrapperExceptionReason.dataNotFoundException,
        );
      } else {
        schYear = cbbYear.getText()?.replaceAll(' ', '').trim();
        schYearVal = int.parse(schYear?.split('-')[0].substring(2) ?? '0');
      }

      // Week item processing
      var cbbWeek = webDoc.getElementById("week-container").getOptionListInComboBox().firstWhereOrNull((p) => p.text.toLowerCase().contains("tuần 1"));
      if (cbbWeek == null) {
        throw DutWrapperException(
          message: "We can't receive any information about this request! "
              "Please, try again later.",
          reason: DutWrapperExceptionReason.dataNotFoundException,
        );
      } else {
        // RegExp regex = RegExp("Tuần (\\d{1,2}) : (\\d{1,2}-\\d{1,2}-\\d{4})");
        // if (regex.hasMatch(cbbWeek.text)) {
        //   var match1 = regex.firstMatch(cbbWeek.text)!;
        //   week = int.parse(match1.group(1)!);

        //   final dateFirstWeekString = match1.group(2)?.split('-') ?? [];
        //   if (dateFirstWeekString.length != 3) {
        //     // TODO: Exception when invalid date format.
        //     throw Exception();
        //   }
        //   final currentDate = DateTime.now().toUtc();
        //   final dateFirstWeek = DateTime.utc(
        //     int.parse(dateFirstWeekString.elementAt(2)),
        //     int.parse(dateFirstWeekString.elementAt(1)),
        //     int.parse(dateFirstWeekString.elementAt(0)),
        //   ).add(Duration(hours: -7));

        //   firstDateWeek = dateFirstWeek.millisecondsSinceEpoch;
        //   week = ((currentDate.millisecondsSinceEpoch - dateFirstWeek.millisecondsSinceEpoch) / (1000 * 60 * 60 * 24 * 7) + 1).toInt();
        // }
        final dateFirstWeekString = cbbWeek.text.split(':')[1].trim().split('-');
        if (dateFirstWeekString.length != 3) {
          // TODO: Exception when invalid date format.
          throw Exception();
        }
        final currentDate = DateTime.now().toUtc();
        final dateFirstWeek = DateTime.utc(
          int.parse(dateFirstWeekString.elementAt(2)),
          int.parse(dateFirstWeekString.elementAt(1)),
          int.parse(dateFirstWeekString.elementAt(0)),
        ).add(Duration(hours: -7));

        firstDateWeek = dateFirstWeek.millisecondsSinceEpoch;
        week = ((currentDate.millisecondsSinceEpoch - dateFirstWeek.millisecondsSinceEpoch) / (1000 * 60 * 60 * 24 * 7) + 1).toInt();
      }

      // schYearVal != null
      if (schYear != null) {
        // remove && week != null && firstDateWeek != null as already passed
        result = DutSchoolYear(
          schoolYear: schYear,
          schoolYearVal: schYearVal,
          week: week,
          firstWeekDate: firstDateWeek,
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
    var dataFull = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
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

  static Future<bool> _checkWebOnline({
    required String domain,
    int timeout = 15,
  }) async {
    bool isConnected = false;
    try {
      if (!(await _checkDomain(domain))) {
        throw Exception();
      }

      final response = await HttpClientWrapper.get(
        uri: Uri.parse("https://$domain"),
        timeout: timeout,
      );
      var _ = response.body;
      isConnected = response.isSuccessfulStatusCode;
    } catch (_) {}
    return isConnected;
  }

  static Future<void> ensureNetworkHaveInternet({int timeout = 15}) async {
    debugPrint("Checking internet access...");
    if (!await _checkWebOnline(domain: "example.com")) {
      throw DutWrapperException(
        message: "Looks like you don't have an internet connection. "
            "Check your internet settings, and try again.",
        reason: DutWrapperExceptionReason.internetNotFound,
      );
    }
  }

  static Future<void> ensureNetworkDutSvOnline({int timeout = 15}) async {
    // debugPrint("Checking sv.dut.udn.vn...");
    if (!await _checkWebOnline(domain: "sv.dut.udn.vn")) {
      throw DutWrapperException(
        message: "Looks like we can't connect to sv.dut.udn.vn server. "
            "Try again later. "
            "You might need to check your internet settings again to confirm.",
        reason: DutWrapperExceptionReason.serverNotFound,
      );
    }
  }
}
