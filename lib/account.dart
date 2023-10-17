library dutwrapper;

import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'model/account_obj.dart';
import 'model/enums.dart';
import 'model/global_variables.dart';
import 'model/range_class.dart';
import 'model/request_result.dart';
import 'model/subject_code_item.dart';

class Account {
  static Future<RequestResult> generateSessionID({int timeout = 60}) async {
    RequestResult ars = const RequestResult();

    try {
      final response = await http
          .get(Uri.parse('http://sv.dut.udn.vn/'))
          .timeout(Duration(seconds: timeout));

      // Get session id
      var cookieHeader = response.headers['set-cookie'];
      if (cookieHeader != null) {
        String splitChar;
        if (cookieHeader.contains('; ')) {
          splitChar = '; ';
        } else {
          splitChar = ';';
        }

        List<String> cookieHeaderSplit = cookieHeader.split(splitChar);
        for (String item in cookieHeaderSplit) {
          if (item.contains('ASP.NET_SessionId')) {
            List<String> sessionIdSplit = item.split('=');
            ars = ars.clone(sessionId: sessionIdSplit[1]);
          }
        }
      }

      ars = ars.clone(
        statusCode: response.statusCode,
        requestCode: [200, 204].contains(response.statusCode)
            ? RequestCode.successful
            : RequestCode.failed,
      );
    } catch (ex) {
      // print(ex);
      ars = ars.clone(requestCode: RequestCode.exceptionThrown);
    }
    return ars;
  }

  static Future<RequestResult> isLoggedIn({
    required String sessionId,
    int timeout = 60,
  }) async {
    RequestResult ars = RequestResult(sessionId: sessionId);

    Map<String, String> header = <String, String>{
      'cookie': 'ASP.NET_SessionId=$sessionId;'
    };

    try {
      final response = await http
          .get(
            Uri.parse(
                'http://sv.dut.udn.vn/WebAjax/evLopHP_Load.aspx?E=TTKBLoad&Code=2010'),
            headers: header,
          )
          .timeout(Duration(seconds: timeout));
      ars = ars.clone(
        statusCode: response.statusCode,
        requestCode: [200, 204].contains(response.statusCode)
            ? RequestCode.successful
            : RequestCode.failed,
      );
    } catch (ex) {
      // print(ex);
      ars = ars.clone(requestCode: RequestCode.exceptionThrown);
    }
    return ars;
  }

  static Future<RequestResult> login({
    required String sessionId,
    required String userId,
    required String password,
    int timeout = 60,
  }) async {
    // Header data
    Map<String, String> header = <String, String>{
      'cookie': 'ASP.NET_SessionId=$sessionId;',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    // Post data
    var postData = <String, String>{
      GlobalVariables.loginViewStateHeader: GlobalVariables.loginViewStateValue,
      GlobalVariables.loginViewStateGeneratorHeader:
          GlobalVariables.loginViewStateGeneratorValue,
      GlobalVariables.loginUserHeader: userId,
      GlobalVariables.loginPassHeader: password,
      GlobalVariables.loginBtnHeader: GlobalVariables.loginBtnValue
    };
    try {
      await http
          .post(Uri.parse('http://sv.dut.udn.vn/PageDangNhap.aspx'),
              headers: header,
              encoding: Encoding.getByName('utf-8'),
              body: postData)
          .timeout(Duration(seconds: timeout));
      return await isLoggedIn(sessionId: sessionId);
    } catch (ex) {
      // print(ex);
      return RequestResult(
        sessionId: sessionId,
        requestCode: RequestCode.exceptionThrown,
      );
    }
  }

  static Future<RequestResult> logout({
    required String sessionId,
    int timeout = 60,
  }) async {
    RequestResult ars = RequestResult(sessionId: sessionId);

    // Header data
    Map<String, String> header = <String, String>{
      'cookie': 'ASP.NET_SessionId=$sessionId;',
    };

    try {
      await http
          .get(Uri.parse('http://sv.dut.udn.vn/PageLogout.aspx'),
              headers: header)
          .timeout(Duration(seconds: timeout));
      RequestResult loginStatus = await isLoggedIn(sessionId: sessionId);
      ars = ars.clone(
        statusCode: loginStatus.statusCode == 404 ? 200 : 404,
        requestCode: loginStatus.requestCode == RequestCode.successful
            ? RequestCode.failed
            : loginStatus.requestCode == RequestCode.failed
                ? RequestCode.successful
                : loginStatus.requestCode,
      );
    } catch (ex) {
      // print(ex);
      ars.clone(requestCode: RequestCode.exceptionThrown);
    }

    return ars;
  }

  static Future<RequestResult<List<SubjectScheduleItem>>> getSubjectSchedule({
    required String sessionId,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    RequestResult<List<SubjectScheduleItem>> ars =
        RequestResult<List<SubjectScheduleItem>>(data: []);

    // Create object if null
    // ars.data ??= [];

    try {
      if (semester <= 0 || semester > 3) {
        throw ArgumentError(
            'Invalid value (previous value: year: $year, semester: $semester)');
      }
      String code =
          '$year${semester < 3 ? semester : 2}${semester == 3 ? 1 : 0}';

      // Header data
      Map<String, String> header = <String, String>{
        'cookie': 'ASP.NET_SessionId=$sessionId;',
      };

      final response = await http
          .get(
              Uri.parse(
                  'http://sv.dut.udn.vn/WebAjax/evLopHP_Load.aspx?E=TTKBLoad&Code=$code'),
              headers: header)
          .timeout(Duration(seconds: timeout));

      // Subject study
      var docSchStudy = parse(response.body).getElementById('TTKB_GridInfo');
      if (docSchStudy != null) {
        var schRow = docSchStudy.getElementsByClassName('GridRow');
        if (schRow.isNotEmpty) {
          for (var row in schRow) {
            var schCell = row.getElementsByClassName('GridCell');
            if (schCell.length < 10) {
              continue;
            }

            SubjectScheduleItem item = SubjectScheduleItem();
            // Subject id
            item.id = SubjectCodeItem.fromString(input: schCell[1].text);
            // Subject name
            item.name = schCell[2].text;
            // Subject credit
            item.credit = int.tryParse(schCell[3].text) ?? 0;
            // Subject is high quality
            item.isHighQuality =
                schCell[5].attributes['class']?.contains('GridCheck') ?? false;
            // Lecturer
            item.lecturerName = schCell[6].text;
            // Subject study
            if (schCell[7].text.isNotEmpty) {
              schCell[7].text.split('; ').forEach((element) {
                SubjectStudyItem subjectStudyItem = SubjectStudyItem();
                // Day of week
                if (element.toUpperCase().contains('CN')) {
                  subjectStudyItem.dayOfWeek = 0;
                } else {
                  subjectStudyItem.dayOfWeek =
                      (int.tryParse(element.split(',')[0].split(' ')[1]) ?? 1) -
                          1;
                }
                // Lesson
                subjectStudyItem.lesson = RangeInt(
                  start:
                      int.tryParse(element.split(',')[1].split('-')[0]) ?? -1,
                  end: int.tryParse(element.split(',')[1].split('-')[1]) ?? -1,
                );
                // Room
                subjectStudyItem.room = element.split(',')[2];
                // Add to item
                item.subjectStudy.subjectStudyList.add(subjectStudyItem);
              });
            }
            // Processing with Week list
            if (schCell[8].text.isNotEmpty) {
              schCell[8].text.split(';').forEach((element) {
                RangeInt weekItem = RangeInt(
                  start: int.tryParse(element.split('-')[0]) ?? -1,
                  end: int.tryParse(element.split('-')[1]) ?? -1,
                );
                item.subjectStudy.weekList.add(weekItem);
              });
            }
            // Point formula
            item.pointFormula = schCell[10].text;
            ars.data!.add(item);
          }
        }
      }

      // Subject exam
      var docSchExam = parse(response.body).getElementById('TTKB_GridLT');
      if (docSchExam != null) {
        var schRow = docSchExam.getElementsByClassName('GridRow');
        if (schRow.isNotEmpty) {
          for (var row in schRow) {
            var schCell = row.getElementsByClassName('GridCell');
            if (schCell.length < 5) {
              continue;
            }

            try {
              SubjectScheduleItem schItem = ars.data!.firstWhere(
                  (element) => element.id.toString() == schCell[1].text);
              // Set group
              schItem.subjectExam.group = schCell[3].text;
              // Is global
              schItem.subjectExam.isGlobal =
                  schCell[4].attributes['class']?.contains('GridCheck') ??
                      false;
              // Date + room
              final temp = schCell[5].text;
              // Use above to split date and room, then add back to subject schedule item.
              DateTime? dateTime;
              temp.split(', ').forEach((element) {
                List<String> itemSplitted = element.split(": ");
                if (itemSplitted.length >= 2) {
                  // Area for day
                  if (element.contains('Ngày')) {
                    try {
                      dateTime = DateTime.parse(itemSplitted[1]
                          .split('/')
                          .reversed
                          .toList()
                          .join('-'));
                    } catch (ex) {
                      print(ex);
                    }
                  } else if (element.contains('Phòng')) {
                    schItem.subjectExam.room = itemSplitted[1];
                  } else if (element.contains('Giờ')) {
                    List<String> timeSplitted = itemSplitted[1].split('h');
                    if (timeSplitted.isNotEmpty) {
                      dateTime?.add(
                          Duration(hours: int.tryParse(timeSplitted[0]) ?? 0));
                    }
                    if (timeSplitted.length > 1) {
                      dateTime?.add(Duration(
                          minutes: int.tryParse(timeSplitted[1]) ?? 0));
                    }
                  }
                }
              });
              schItem.subjectExam.date = dateTime?.millisecondsSinceEpoch ?? 0;
            } catch (ex) {
              // Skip them
              continue;
            }
          }
        }
      }

      ars = ars.clone(
        statusCode: response.statusCode,
        requestCode: [200, 204].contains(response.statusCode)
            ? RequestCode.successful
            : RequestCode.failed,
      );
    } on ArgumentError {
      ars = ars.clone(requestCode: RequestCode.invalid);
    } catch (ex) {
      // print(ex);
      ars = ars.clone(requestCode: RequestCode.exceptionThrown);
    }

    return ars;
  }
}
