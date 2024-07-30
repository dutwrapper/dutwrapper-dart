library dutwrapper;

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'account_object.dart';
import 'account_session_object.dart';
import 'enums.dart';
import 'http_element_parser.dart';
import 'global_url.dart';
import 'range_class.dart';
import 'request_data_response.dart';
import 'subject_code.dart';

class Accounts {
  static String? _getSessionIdFromHeader(Map<String, String>? headers) {
    if (headers == null) {
      return null;
    }
    var cookieHeader = headers['set-cookie'] ?? headers['cookie'];
    if (cookieHeader == null) {
      return null;
    }

    List<String> cookieHeaderSplit = cookieHeader.split(';');
    for (String item in cookieHeaderSplit) {
      var itemTmp = item.trim();
      if (itemTmp.contains('ASP.NET_SessionId')) {
        var data = itemTmp.split('=');
        if (data.length == 2) {
          return data[1];
        }
      }
    }

    return null;
  }

  static String _sessionToCookieItem(String sessionId) {
    return 'ASP.NET_SessionId=$sessionId;';
  }

  static Future<AccountSession> generateNewSession({int timeout = 60}) async {
    // Request new session.
    RequestDataResponse response = await RequestDataResponse.getAsync(
      url: GlobalUrl.loginLink(),
    );
    // If have exception -> Request is not successful. Just throw them.
    if (response.ex != null) {
      throw response.ex!;
    }
    // If status isn't returned with code in range 200-299, throw here.
    if ((response.statusCode ?? 0) < 200 || (response.statusCode ?? 0) > 299) {
      throw Exception('Request was returned with code ${response.statusCode}.');
    }

    // Parse content in response to Document.
    var docHtml = parse(response.webContent!);
    return AccountSession(
      sessionId: _getSessionIdFromHeader(response.setHeaders),
      viewState: docHtml.getElementById("__VIEWSTATE").getValue(),
      viewStateGenerator:
          docHtml.getElementById("__VIEWSTATEGENERATOR").getValue(),
    );
  }

  static Future<LoginStatus> isLoggedIn({
    required AccountSession session,
    int timeout = 60,
  }) async {
    session.ensureValidSessionId();

    // Header data
    Map<String, String> headers = <String, String>{
      'cookie': _sessionToCookieItem(session.sessionId!)
    };

    final response = await RequestDataResponse.getAsync(
      url: GlobalUrl.subjectScheduleLink(year: 22, semester: 1),
      headers: headers,
      timeout: timeout,
    );

    if (response.ex != null) {
      return LoginStatus.unknown;
    } else if ((response.statusCode ?? 0) >= 200 &&
        (response.statusCode ?? 0) <= 299) {
      return LoginStatus.loggedIn;
    } else {
      return LoginStatus.loggedOut;
    }
  }

  static Future<void> login({
    required AccountSession session,
    required AuthInfo authInfo,
    int timeout = 60,
  }) async {
    session.ensureValidLoginForm();
    authInfo.ensureValidAuthInfo();

    // Header data
    Map<String, String> headers = <String, String>{
      'Cookie': _sessionToCookieItem(session.sessionId!),
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    // Post data
    var postData = <String, String>{
      '__VIEWSTATE': session.viewState!,
      '__VIEWSTATEGENERATOR': session.viewStateGenerator!,
      '_ctl0:MainContent:DN_txtAcc': authInfo.username!,
      '_ctl0:MainContent:DN_txtPass': authInfo.password!,
      '_ctl0:MainContent:QLTH_btnLogin': 'Đăng+nhập'
    };

    await RequestDataResponse.postAsync(
      url: GlobalUrl.loginLink(),
      headers: headers,
      postData: postData,
      timeout: timeout,
    );
  }

  static Future<void> logout({
    required AccountSession session,
    int timeout = 60,
  }) async {
    session.ensureValidSessionId();

    // Header data
    Map<String, String> headers = <String, String>{
      'cookie': _sessionToCookieItem(session.sessionId!)
    };

    await RequestDataResponse.getAsync(
      url: GlobalUrl.logoutLink(),
      headers: headers,
      timeout: timeout,
    );
  }

  static Future<List<SubjectInformation>> fetchSubjectInformation({
    required AccountSession session,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    session.ensureValidSessionId();

    if (await Accounts.isLoggedIn(session: session) != LoginStatus.loggedIn) {
      throw Exception('You\'re not logged in!');
    }

    // Header data
    Map<String, String> headers = <String, String>{
      'cookie': _sessionToCookieItem(session.sessionId!)
    };

    final response = await RequestDataResponse.getAsync(
      url: GlobalUrl.subjectScheduleLink(year: year, semester: semester),
      headers: headers,
    ).timeout(Duration(seconds: timeout));

    if (response.ex != null) {
      throw response.ex!;
    }

    if ((response.statusCode ?? 0) < 200 || (response.statusCode ?? 0) > 299) {
      throw Exception('Request was returned with code ${response.statusCode}.');
    }

    // Check if response have content here.
    // If not, just return empty list.
    if (response.webContent == null) {
      return [];
    }

    List<SubjectInformation> result = [];

    // Subject study
    var docSchStudy =
        parse(response.webContent!).getElementById('TTKB_GridInfo');
    if (docSchStudy != null) {
      var schRow = docSchStudy.getElementsByClassName('GridRow');
      if (schRow.isNotEmpty) {
        for (var row in schRow) {
          var schCell = row.getElementsByClassName('GridCell');
          if (schCell.length < 10) {
            continue;
          }

          SubjectInformation item = SubjectInformation.createDefault();
          // Subject id
          item.id = SubjectCode.fromString(input: schCell[1].text);
          // Subject name
          item.name = schCell[2].text;
          // Subject credit
          item.credit = int.tryParse(schCell[3].text) ?? 0;
          // Subject is high quality
          item.isHighQuality = schCell[5].isGridChecked();
          // Lecturer
          item.lecturerName = schCell[6].text;
          // Subject study
          // Will be replaced with following regex after spliited by "; "
          // (Thứ [2-7]|CN),([0-9]{1,2}-[0-9]{1,2}),(.*)
          if (schCell[7].text.isNotEmpty) {
            RegExp regex =
                RegExp("(Thứ [2-7]|CN),([0-9]{1,2})-([0-9]{1,2}),(.*)");
            schCell[7].text.split('; ').forEach((element) {
              if (regex.hasMatch(element)) {
                item.subjectStudy.subjectStudyList.add(
                  SubjectSchedule.from(
                    dayOfWeek: regex.firstMatch(element)?.group(1) == null
                        ? 1
                        : regex.firstMatch(element)?.group(1) == "CN"
                            ? 1
                            : int.parse(regex
                                .firstMatch(element)!
                                .group(1)!
                                .split(' ')[1]),
                    lesson: RangeInt(
                      start: int.tryParse(
                              regex.firstMatch(element)?.group(2) ?? "") ??
                          0,
                      end: int.tryParse(
                              regex.firstMatch(element)?.group(3) ?? "") ??
                          0,
                    ),
                    room: regex.firstMatch(element)?.group(4) ?? "",
                  ),
                );
              }
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
          result.add(item);
        }
      }
    }

    // Subject exam
    var docSchExam = parse(response.webContent!).getElementById('TTKB_GridLT');
    if (docSchExam != null) {
      var schRow = docSchExam.getElementsByClassName('GridRow');
      if (schRow.isNotEmpty) {
        for (var row in schRow) {
          var schCell = row.getElementsByClassName('GridCell');
          if (schCell.length < 5) {
            continue;
          }

          try {
            SubjectInformation schItem = result.firstWhere((element) =>
                element.id == SubjectCode.fromString(input: schCell[1].text));

            // Will be replaced with following regex:
            // Ngày: ([0-9]{2}\/[0-9]{2}\/[0-9]{4}), Phòng: (.*), Giờ: ([0-9]{1,2}h[0-9]{2}), Xuất: (.*)

            if (schCell[5].text.isNotEmpty) {
              RegExp regex = RegExp(
                  r"Ngày: ([0-9]{2}\/[0-9]{2}\/[0-9]{4}), Phòng: (.*), Giờ: ([0-9]{1,2}h[0-9]{2}), Xuất: (.*)");
              if (regex.hasMatch(schCell[5].text)) {
                var dateSplit =
                    regex.firstMatch(schCell[5].text)!.group(1)!.split("/");
                var timeSplit = regex.firstMatch(schCell[5].text)!.group(3)!;

                DateTime dt = DateTime.parse(
                    "${dateSplit[2]}-${dateSplit[1]}-${dateSplit[0]}");
                dt = dt.add(Duration(
                  hours: int.parse(timeSplit.split("h")[0]),
                  minutes: timeSplit.split("h").length == 2
                      ? int.parse(timeSplit.split("h")[1])
                      : 0,
                ));

                schItem.subjectExam.date = dt.millisecondsSinceEpoch;
                schItem.subjectExam.room =
                    regex.firstMatch(schCell[5].text)?.group(2) ?? "";
                // Is global - Get from root element
                schItem.subjectExam.isGlobal = schCell[4].isGridChecked();
                // Group - Get from root element
                schItem.subjectExam.group = schCell[3].text;
              }
            }
          } catch (ex) {
            log(ex.toString());
            // Skip them
            continue;
          }
        }
      }
    }

    return result;
  }

  static Future<List<SubjectFee>> fetchSubjectFee({
    required AccountSession session,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    session.ensureValidSessionId();

    if (await Accounts.isLoggedIn(session: session) != LoginStatus.loggedIn) {
      throw Exception('You\'re not logged in!');
    }

    // Header data
    Map<String, String> headers = <String, String>{
      'cookie': _sessionToCookieItem(session.sessionId!)
    };

    final response = await RequestDataResponse.getAsync(
      url: GlobalUrl.subjectFeeLink(year: year, semester: semester),
      headers: headers,
    ).timeout(Duration(seconds: timeout));

    if (response.ex != null) {
      throw response.ex!;
    }

    if ((response.statusCode ?? 0) < 200 || (response.statusCode ?? 0) > 299) {
      throw Exception('Request was returned with code ${response.statusCode}.');
    }

    // Check if response have content here.
    // If not, just return empty list.
    if (response.webContent == null) {
      return [];
    }

    List<SubjectFee> result = [];

    // Main processing
    var docSchFee =
        parse(response.webContent!).getElementById("THocPhi_GridInfo");
    if (docSchFee != null) {
      var schRow = docSchFee.getElementsByClassName("GridRow");
      if (schRow.isNotEmpty) {
        for (var row in schRow) {
          var schCell = row.getElementsByClassName('GridCell');
          if (schCell.length < 10) {
            continue;
          }

          SubjectFee item = SubjectFee(
            id: SubjectCode.fromString(input: schCell[1].text),
            name: schCell[2].text,
            credit: int.tryParse(schCell[3].text) ?? 0,
            isHighQuality: schCell[4].isGridChecked(),
            price: double.tryParse(schCell[5].text.replaceAll(",", "")) ?? 0,
            isDebt: schCell[6].isGridChecked(),
            isReStudy: schCell[7].isGridChecked(),
            confirmedPaymentAt: schCell[8].text,
          );

          result.add(item);
        }
      }
    }

    return result;
  }

  static String _parseStudentId(String data) {
    RegExp regex = RegExp(r"Chào (.*) \((.*)\)");
    data = data.trim();
    if (regex.hasMatch(data)) {
      var match1 = regex.firstMatch(data);
      return match1?.group(2) ?? "";
    } else {
      return "";
    }
  }

  static Future<StudentInformation> fetchStudentInformation({
    required AccountSession session,
    int timeout = 60,
  }) async {
    session.ensureValidSessionId();

    if (await Accounts.isLoggedIn(session: session) != LoginStatus.loggedIn) {
      throw Exception('You\'re not logged in!');
    }

    // Header data
    Map<String, String> headers = <String, String>{
      'cookie': _sessionToCookieItem(session.sessionId!)
    };

    final response = await RequestDataResponse.getAsync(
      url: GlobalUrl.accountInformationLink(),
      headers: headers,
    ).timeout(Duration(seconds: timeout));

    if (response.ex != null) {
      throw response.ex!;
    }

    if ((response.statusCode ?? 0) < 200 || (response.statusCode ?? 0) > 299) {
      throw Exception('Request was returned with code ${response.statusCode}.');
    }

    // Check if response have content here.
    // If not, just throw errors.
    if (response.webContent == null) {
      throw Exception(
          'We can\'t receive any information about this request! Please, try again.');
    }

    // Main processing
    var webDoc = parse(response.webContent!);
    return StudentInformation(
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
      accountBankName: webDoc.getElementById("CN_txtNgHang").getValueOrEmpty(),
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
      studentId: _parseStudentId(
          webDoc.getElementById("Main_lblHoTen").getTextOrEmpty()),
    );
  }

  static Future<TrainingResult> fetchTrainingResult({
    required AccountSession session,
    int timeout = 60,
  }) async {
    session.ensureValidSessionId();

    if (await Accounts.isLoggedIn(session: session) != LoginStatus.loggedIn) {
      throw Exception('You\'re not logged in!');
    }

    // Header data
    Map<String, String> headers = <String, String>{
      'cookie': _sessionToCookieItem(session.sessionId!)
    };

    final response = await RequestDataResponse.getAsync(
      url: GlobalUrl.trainingStatusLink(),
      headers: headers,
    ).timeout(Duration(seconds: timeout));

    if (response.ex != null) {
      throw response.ex!;
    }

    if ((response.statusCode ?? 0) < 200 || (response.statusCode ?? 0) > 299) {
      throw Exception('Request was returned with code ${response.statusCode}.');
    }

    // Check if response have content here.
    // If not, just throw errors.
    if (response.webContent == null) {
      throw Exception(
          'We can\'t receive any information about this request! Please, try again.');
    }

    // Main processing
    var webDoc = parse(response.webContent!);

    return TrainingResult(
      trainingSummary: _parseTrainingSummary(webDoc: webDoc),
      graduateStatus: _parseGraduateStatus(webDoc: webDoc),
      subjectResultList: _parseSubjectResultList(webDoc: webDoc),
    );
  }

  static TrainingSummary _parseTrainingSummary({required Document webDoc}) {
    // Training summary
    TrainingSummary trainSum = TrainingSummary(
      schoolYearStart: "",
      schoolYearCurrent: "",
      creditCollected: 0,
      avgTrainingScore4: 0,
      avgSocial: 0,
    );
    var webDocTrainSum =
        webDoc.getElementById("KQRLGridTH")?.getElementsByClassName("GridRow");
    if (webDocTrainSum == null) {
      throw Exception("No data for training summary");
    }
    for (var gridRow in webDocTrainSum) {
      var gridCell = gridRow.getElementsByClassName("GridCell");
      if (gridCell[0].isTextEmpty() ||
          gridCell[gridCell.length - 1].isTextEmpty() ||
          gridCell[gridCell.length - 2].isTextEmpty() ||
          gridCell[gridCell.length - 3].isTextEmpty()) {
        continue;
      }

      trainSum = trainSum.copyWith(
        schoolYearStart: (trainSum.schoolYearStart.isEmpty)
            ? gridCell[0].getTextOrEmpty()
            : trainSum.schoolYearStart,
        schoolYearCurrent: gridCell[0].getTextOrEmpty(),
        creditCollected:
            double.tryParse(gridCell[gridCell.length - 3].getTextOrEmpty()) ??
                0,
        avgTrainingScore4:
            double.tryParse(gridCell[gridCell.length - 2].getTextOrEmpty()) ??
                0,
        avgSocial:
            double.tryParse(gridCell[gridCell.length - 1].getTextOrEmpty()) ??
                0,
      );
    }

    return trainSum;
  }

  static GraduateStatus _parseGraduateStatus({required Document webDoc}) {
    // Gradudate status
    var webDocGraduateStat =
        webDoc.getElementById("KQRLdvCc").convertToDocument();
    if (webDocGraduateStat == null) {
      throw Exception("No data for gradudate status");
    }
    GraduateStatus gradStat = GraduateStatus(
      hasSigGDTC: webDocGraduateStat.getElementById("KQRL_chkGDTC").isChecked(),
      hasSigGDQP: webDocGraduateStat.getElementById("KQRL_chkQP").isChecked(),
      hasSigEnglish:
          webDocGraduateStat.getElementById("KQRL_chkCCNN").isChecked(),
      hasSigIT: webDocGraduateStat.getElementById("KQRL_chkCCTH").isChecked(),
      hasQualifiedGraduate:
          webDocGraduateStat.getElementById("KQRL_chkCNTN").isChecked(),
      rewardsInfo: webDocGraduateStat
          .getElementById("KQRL_txtKT")
          .getTextOrEmpty()
          .trim(),
      disciplineInfo: webDocGraduateStat
          .getElementById("KQRL_txtKL")
          .getTextOrEmpty()
          .trim(),
      eligibleGraduationThesisStatus: webDocGraduateStat
          .getElementById("KQRL_txtInfo")
          .getTextOrEmpty()
          .trim(),
      eligibleGraduationStatus: webDocGraduateStat
          .getElementById("KQRL_txtCNTN")
          .getTextOrEmpty()
          .trim(),
    );
    return gradStat;
  }

  static List<SubjectResult> _parseSubjectResultList(
      {required Document webDoc}) {
    // Subject result list
    var webDocSubjectResult = webDoc
        .getElementById("KQRL_divContent")
        .convertToDocument()
        ?.getElementById("KQRLGridKQHT")
        ?.getElementsByClassName("GridRow");
    if (webDocSubjectResult == null) {
      throw Exception("No data for subject result list");
    }
    List<SubjectResult> subjectResultList = [];
    for (var row in webDocSubjectResult.reversed) {
      var gridCell = row.getElementsByClassName('GridCell');
      // if (gridCell.length < 10) {
      //   continue;
      // }

      subjectResultList.add(SubjectResult(
        index: int.tryParse(gridCell[0].getTextOrEmpty()) ?? 0,
        schoolYear: gridCell[1].getTextOrEmpty(),
        isExtendedSemester: gridCell[2].isGridChecked(),
        id: SubjectCode.fromString(input: gridCell[3].getTextOrEmpty()),
        name: gridCell[4].getTextOrEmpty(),
        credit: double.tryParse(gridCell[5].getTextOrEmpty()) ?? 0,
        pointFormula: gridCell[6].getText(),
        pointBT: double.tryParse(gridCell[7].getTextOrEmpty()),
        pointBV: double.tryParse(gridCell[8].getTextOrEmpty()),
        pointCC: double.tryParse(gridCell[9].getTextOrEmpty()),
        pointCK: double.tryParse(gridCell[10].getTextOrEmpty()),
        pointGK: double.tryParse(gridCell[11].getTextOrEmpty()),
        pointQT: double.tryParse(gridCell[12].getTextOrEmpty()),
        pointTH: double.tryParse(gridCell[13].getTextOrEmpty()),
        pointTT: double.tryParse(gridCell[14].getTextOrEmpty()),
        resultT10: double.tryParse(gridCell[15].getTextOrEmpty()),
        resultT4: double.tryParse(gridCell[16].getTextOrEmpty()),
        resultByCharacter: gridCell[17].getText(),
        isReStudy: subjectResultList.firstWhereOrNull((element) =>
                element.name.toLowerCase() ==
                gridCell[4].getTextOrEmpty().toLowerCase()) !=
            null,
      ));
    }
    return subjectResultList;
  }
}
