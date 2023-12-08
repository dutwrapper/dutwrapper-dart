library dutwrapper;

import 'dart:convert';
import 'dart:developer';

import 'package:dutwrapper/utils/html_parser_extension.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'model/account/account_information.dart';
import 'model/account/subject_fee.dart';
import 'model/account/subject_schedule.dart';
import 'model/account/subject_schedule_study.dart';
import 'model/enums.dart';
import 'model/global_variables.dart';
import 'model/range_class.dart';
import 'model/request_result.dart';
import 'model/subject_code.dart';
import 'model/global_variables_url.dart';

class Account {
  static Future<RequestResult> generateSessionID({int timeout = 60}) async {
    RequestResult ars = RequestResult();

    try {
      final response = await http
          .get(Uri.parse(GlobalVariablesUrl.baseLink()))
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
                GlobalVariablesUrl.subjectScheduleLink(year: 22, semester: 1)),
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
          .post(Uri.parse(GlobalVariablesUrl.loginLink()),
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
          .get(Uri.parse(GlobalVariablesUrl.logoutLink()), headers: header)
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

  static Future<RequestResult<List<SubjectSchedule>>> getSubjectSchedule({
    required String sessionId,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    RequestResult<List<SubjectSchedule>> ars =
        RequestResult<List<SubjectSchedule>>(data: []);

    try {
      // Header data
      Map<String, String> header = <String, String>{
        'cookie': 'ASP.NET_SessionId=$sessionId;',
      };

      final response = await http
          .get(
              Uri.parse(GlobalVariablesUrl.subjectScheduleLink(
                  year: year, semester: semester)),
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

            SubjectSchedule item = SubjectSchedule();
            // Subject id
            item.id = SubjectCode.fromString(input: schCell[1].text);
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
                SubjectScheduleStudy subjectStudyItem = SubjectScheduleStudy();
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
              SubjectSchedule schItem = ars.data!.firstWhere(
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
                      // TODO Error log
                      log(ex.toString());
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
      log(ex.toString());
      ars = ars.clone(requestCode: RequestCode.exceptionThrown);
    }

    return ars;
  }

  static Future<RequestResult<List<SubjectFee>>> getSubjectFee({
    required String sessionId,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    RequestResult<List<SubjectFee>> ars =
        RequestResult<List<SubjectFee>>(data: []);

    try {
      // Header data
      Map<String, String> header = <String, String>{
        'cookie': 'ASP.NET_SessionId=$sessionId;',
      };

      final response = await http
          .get(
              Uri.parse(GlobalVariablesUrl.subjectFeeLink(
                  year: year, semester: semester)),
              headers: header)
          .timeout(Duration(seconds: timeout));

      // Main processing
      var docSchFee = parse(response.body).getElementById("THocPhi_GridInfo");
      if (docSchFee != null) {
        var schRow = docSchFee.getElementsByClassName("GridRow");
        if (schRow.isNotEmpty) {
          for (var row in schRow) {
            var schCell = row.getElementsByClassName('GridCell');
            if (schCell.length < 10) {
              continue;
            }

            SubjectFee item = SubjectFee();
            // Subject id
            item.id = SubjectCode.fromString(input: schCell[1].text);
            // Subject name
            item.name = schCell[2].text;
            // Subject credit
            item.credit = int.tryParse(schCell[3].text) ?? 0;
            // Subject is high quality
            item.isHighQuality =
                schCell[4].attributes['class']?.contains('GridCheck') ?? false;
            // Subject price
            item.price =
                double.tryParse(schCell[5].text.replaceAll(",", "")) ?? 0;
            // Is debt
            item.isDebt =
                schCell[6].attributes['class']?.contains('GridCheck') ?? false;
            // Is restudy
            item.isReStudy =
                schCell[7].attributes['class']?.contains('GridCheck') ?? false;
            // Payment at
            item.confirmedPaymentAt = schCell[8].text;

            ars.data!.add(item);
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

  static Future<RequestResult<AccountInformation?>> getAccountInformation({
    required String sessionId,
    int timeout = 60,
  }) async {
    RequestResult<AccountInformation?> ars =
        RequestResult<AccountInformation?>(data: null);

    String parseStudentId(String data) {
      RegExp regex = RegExp(r"Chào (.*) \((.*)\)");
      data = data.trim();
      if (regex.hasMatch(data)) {
        var match1 = regex.firstMatch(data);
        return match1?.group(2) ?? "";
      } else {
        return "";
      }
    }

    try {
      // Header data
      Map<String, String> header = <String, String>{
        'cookie': 'ASP.NET_SessionId=$sessionId;',
      };

      final response = await http
          .get(Uri.parse("http://sv.dut.udn.vn/PageCaNhan.aspx"),
              headers: header)
          .timeout(Duration(seconds: timeout));

      // Main processing
      var webDoc = parse(response.body);
      ars.data = AccountInformation(
        name: webDoc.getElementById("CN_txtHoTen").getValueOrEmpty(),
        dateOfBirth: webDoc.getElementById("CN_txtNgaySinh").getValueOrEmpty(),
        birthPlace: webDoc
            .getElementById("CN_cboNoiSinh")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        gender: webDoc.getElementById("CN_txtGioiTinh").getValueOrEmpty(),
        ethnicity: webDoc
            .getElementById("CN_cboDanToc")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        nationality: webDoc
            .getElementById("CN_cboQuocTich")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        nationalIdCard: webDoc.getElementById("CN_txtSoCMND").getValueOrEmpty(),
        nationalIdCardIssueDate:
            webDoc.getElementById("CN_txtNgayCap").getValueOrEmpty(),
        nationalIdCardIssuePlace: webDoc
            .getElementById("CN_cboNoiCap")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        citizenIdCard: webDoc.getElementById("CN_txtSoCCCD").getValueOrEmpty(),
        citizenIdCardIssueDate:
            webDoc.getElementById("CN_txtNcCCCD").getValueOrEmpty(),
        religion: webDoc
            .getElementById("CN_cboTonGiao")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        accountBankId: webDoc.getElementById("CN_txtTKNHang").getValueOrEmpty(),
        accountBankName:
            webDoc.getElementById("CN_txtNgHang").getValueOrEmpty(),
        hIId: webDoc.getElementById("CN_txtSoBHYT").getValueOrEmpty(),
        hIExpireDate: webDoc.getElementById("CN_txtHanBHYT").getValueOrEmpty(),
        specialization:
            webDoc.getElementById("MainContent_CN_txtNganh").getValueOrEmpty(),
        schoolClass: webDoc.getElementById("CN_txtLop").getValueOrEmpty(),
        trainingProgramPlan:
            webDoc.getElementById("MainContent_CN_txtCTDT").getValueOrEmpty(),
        trainingProgramPlan2:
            webDoc.getElementById("MainContent_CN_txtCT2").getValueOrEmpty(),
        schoolEmail: webDoc.getElementById("CN_txtMail1").getValueOrEmpty(),
        personalEmail: webDoc.getElementById("CN_txtMail2").getValueOrEmpty(),
        schoolEmailInitPass:
            webDoc.getElementById("CN_txtMK365").getValueOrEmpty(),
        facebookUrl: webDoc.getElementById("CN_txtFace").getValueOrEmpty(),
        phoneNumber: webDoc.getElementById("CN_txtPhone").getValueOrEmpty(),
        address: webDoc.getElementById("CN_txtCuTru").getValueOrEmpty(),
        addressFrom: webDoc
            .getElementById("CN_cboDCCua")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        addressCity: webDoc
            .getElementById("CN_cboTinhCTru")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        addressDistrict: webDoc
            .getElementById("CN_cboQuanCTru")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        addressSubDistrict: webDoc
            .getElementById("CN_divPhuongCTru")
            .getSelectedOptionInComboBox()
            .getTextOrEmpty(),
        // TODO: Implement here!
        studentId: parseStudentId(
            webDoc.getElementById("Main_lblHoTen").getTextOrEmpty()),
      );
      // TODO: Processing here!
    } catch (ex) {
      // print(ex);
      ars = ars.clone(requestCode: RequestCode.exceptionThrown);
    }

    return ars;
  }
}
