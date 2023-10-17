import 'dart:developer';
import 'dart:io';

import 'package:dutwrapper/account.dart';
import 'package:dutwrapper/model/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dutwrapper/news.dart';

void main() {
  test('Get global news (5 pages first)', () async {
    for (int i = 1; i <= 5; i++) {
      log('======= GET GLOBAL NEWS - PAGE $i ========');
      final response = await News.getNewsGlobal(page: i);

      if (response.isNotEmpty) {
        log('Subject list: ${response.length}');
        for (var element in response) {
          log('========================================');
          log('Date: ${element.date}');
          log('Title: ${element.title}');
          log('Content String: ${element.contentString}');
          log('Links:');
          for (var link in element.links) {
            log('========= Link ========');
            log('Text: ${link.text}');
            log('Position: ${link.position}');
            log('Url: ${link.url}');
          }
        }
      } else {
        log('Nothing in list!');
      }
    }
  });

  test('Get news subject (5 first pages)', () async {
    for (int i = 1; i <= 5; i++) {
      log('======= GET SUBJECT NEWS - PAGE $i =======');
      final response = await News.getNewsSubject(page: 1);

      if (response.isNotEmpty) {
        log('Subject list: ${response.length}');
        for (var element in response) {
          log('========================================');
          log('Date: ${element.date}');
          log('Title: ${element.title}');
          log('Content: ${element.contentString}');
          log('Lecturer Gender: ${element.lecturerGender.toString()}');
          log('Lecturer Name: ${element.lecturerName}');
          log('Lesson Status: ${element.lessonStatus.toString()}');
          log('Affected Date: ${element.affectedDate}');
          log('Affected Lesson: ${element.affectedLessons.toString()}');
          log('Affected Room: ${element.affectedRoom}');
          log('Affected Class:');
          for (var affectedClassItem in element.affectedClasses) {
            log(affectedClassItem.subjectName);
            for (var codeItem in affectedClassItem.codeList) {
              log(codeItem.toStringTwoLastDigit());
            }
          }
        }
      } else {
        log('Nothing in list!');
      }
    }
  });

  test('Account', () async {
    String sessionId = '';
    var env1 = Platform.environment['dut_account'];
    if (env1 == null) {
      throw Exception(
          'No dut_account varaiable found!\nMake sure you\'re added them in environment variable!');
    }
    String username = env1.split('|')[0];
    String password = env1.split('|')[1];

    // Get session id
    await Account.generateSessionID().then((value) => {
          log('GenerateSessionID'),
          log('==================================='),
          sessionId = value.sessionId,
          log('Session ID: ${value.sessionId}'),
          log('Status Code: ${value.statusCode}')
        });

    if (sessionId == '') {
      log('No session id found! Exiting...');
      return;
    }
    log('');

    // Check is logged in
    await Account.isLoggedIn(sessionId: sessionId).then(
      (value) => {
        log('\nCheck is logged in'),
        log('====================================='),
        log('IsLoggedIn (Not logged in code)'),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}')
      },
    );
    log('');

    // Login
    await Account.login(
        userId: username, password: password, sessionId: sessionId);

    // Check again
    await Account.isLoggedIn(sessionId: sessionId).then(
      (value) {
        log('\nCheck is logged in (after login)');
        log('=====================================');
        log('IsLoggedIn (Logged in code)');
        log('Status: ${value.requestCode.toString()}');
        log('Status Code: ${value.statusCode}');

        if (value.requestCode != RequestCode.successful) {
          throw Exception(
              "Can't login your account to DUT system.\nMake sure your information is correct and try again.");
        }
      },
    );
    log('');

    // Subject Schedule
    await Account.getSubjectSchedule(
            sessionId: sessionId, year: 21, semester: 2)
        .then(
      (value) => {
        log('\nSubject Schedule'),
        log('====================================='),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}'),
        value.data?.forEach(
          (element) {
            log('=================');
            log('Id: ${element.id.toString()}');
            log('Name: ${element.name}');
            log('Credit: ${element.credit}');
            log('IsHighQuality: ${element.isHighQuality}');
            log('Lecturer: ${element.lecturerName}');
            log('Subject Study:');
            for (var subjectStudyItem
                in element.subjectStudy.subjectStudyList) {
              log('-========= Item ==========-');
              log('- Day of week: ${subjectStudyItem.dayOfWeek}');
              log('- Lesson: ${subjectStudyItem.lesson.toString()}');
              log('- Room: ${subjectStudyItem.room}');
            }
            log('Subject Exam:');
            log('- Date: ${element.subjectExam.date}');
            log('- Group: ${element.subjectExam.group}');
            log('- IsGlobal: ${element.subjectExam.isGlobal}');
            log('- Room: ${element.subjectExam.room}');
            log('Point formula: ${element.pointFormula}');
          },
        ),
      },
    );
    log('');

    // Logout
    await Account.logout(sessionId: sessionId).then(
      (value) => {
        log('\nLogout'),
        log('====================================='),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}')
      },
    );
    log('');

    // Check again
    await Account.isLoggedIn(sessionId: sessionId).then(
      (value) => {
        log('\nChecked logged out (if successful, will return failed in this request)'),
        log('====================================='),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}')
      },
    );
    log('');
  });
}
