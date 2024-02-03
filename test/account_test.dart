// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

import 'package:dutwrapper/account.dart';
import 'package:dutwrapper/model/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> fetchSubjectSchedule({
    required String sessionId,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    await Account.getSubjectSchedule(
            sessionId: sessionId, year: 19, semester: 2)
        .then(
      (value) => {
        log('Subject Schedule'),
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
  }

  Future<void> fetchSubjectFee({
    required String sessionId,
    required int year,
    required int semester,
    int timeout = 60,
  }) async {
    await Account.getSubjectFee(sessionId: sessionId, year: 22, semester: 1)
        .then(
      (value) => {
        log('Subject Fee'),
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
            log('Price: ${element.price}');
            log('IsDebt: ${element.isDebt}');
            log('IsReStudy: ${element.isReStudy}');
            log('PaymentAt: ${element.confirmedPaymentAt}');
          },
        ),
      },
    );
    log('');
  }

  Future<void> fetchAccountInformation({
    required String sessionId,
    int timeout = 60,
  }) async {
    log('Account Information');
    log('=====================================');
    await Account.getAccountInformation(sessionId: sessionId)
        .then((value) => {log(value.data.toString())});
    log('');
  }

  Future<void> fetchAccountTrainingStatus({
    required String sessionId,
    int timeout = 60,
  }) async {
    log('Account training status');
    log('=====================================');
    await Account.getAccountTrainingStatus(sessionId: sessionId)
        .then((value) => {log(value.data.toString())});
    log('');
  }

  test('Account functions', () async {
    var SUBJECT_SCHEDULE_YEAR = 19; // YY
    var SUBJECT_SCHEDULE_SEMESTER = 2; // 1,2,3
    var FETCH_SUBJECT_SCHEDULE = true;
    var FETCH_SUBJECT_FEE = true;
    var FETCH_ACCOUNT_INFORMATION = true;
    var FETCH_ACCOUNT_TRAINING_STATUS = true;

    var env1 = Platform.environment['dut_account'];
    if (env1 == null) {
      throw Exception(
          'No dut_account varaiable found!\nMake sure you\'re added them in environment variable!');
    }
    if (env1.split('|').length != 2) {
      throw Exception(
          'Invaild dut_account varaiable!\nMake sure you\'re formatted correctly following (username|password)!');
    }

    String sessionId = '';

    // Get session id
    await Account.generateSessionID().then((value) => {
          log('GenerateSessionID'),
          log('==================================='),
          sessionId = value.sessionId,
          log('Session ID: ${value.sessionId}'),
          log('Status Code: ${value.statusCode}')
        });
    if (sessionId == '') {
      throw Exception('No session id found!');
    }
    log('');

    // Check is logged in
    await Account.isLoggedIn(sessionId: sessionId).then(
      (value) => {
        log('Check is logged in (before login)'),
        log('====================================='),
        log('IsLoggedIn (Not logged in code)'),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}'),
        if (value.requestCode == RequestCode.successful)
          {throw Exception('Look like you have logged in!')}
      },
    );
    log('');

    // Login
    await Account.login(
      userId: env1.split('|')[0],
      password: env1.split('|')[1],
      sessionId: sessionId,
    );

    // Check again
    await Account.isLoggedIn(sessionId: sessionId).then(
      (value) {
        log('Check is logged in (after login)');
        log('=====================================');
        log('IsLoggedIn (Logged in code)');
        log('Status: ${value.requestCode.toString()}');
        log('Status Code: ${value.statusCode}');
        if (value.requestCode != RequestCode.successful) {
          throw Exception(
              "Can't login your account to DUT system. Make sure your information is correct and try again.");
        }
      },
    );
    log('');

    // Trigger subject schedule
    if (FETCH_SUBJECT_SCHEDULE) {
      await fetchSubjectSchedule(
        sessionId: sessionId,
        year: SUBJECT_SCHEDULE_YEAR,
        semester: SUBJECT_SCHEDULE_SEMESTER,
      );
    }

    // Trigger subject fee
    if (FETCH_SUBJECT_FEE) {
      await fetchSubjectFee(
        sessionId: sessionId,
        year: SUBJECT_SCHEDULE_YEAR,
        semester: SUBJECT_SCHEDULE_SEMESTER,
      );
    }

    // Trigger account information
    if (FETCH_ACCOUNT_INFORMATION) {
      await fetchAccountInformation(sessionId: sessionId);
    }

    // Trigger account training status
    if (FETCH_ACCOUNT_TRAINING_STATUS) {
      await fetchAccountTrainingStatus(sessionId: sessionId);
    }

    // Logout
    await Account.logout(sessionId: sessionId).then(
      (value) => {
        log('Logout'),
        log('====================================='),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}')
      },
    );
    log('');

    // Check again
    await Account.isLoggedIn(sessionId: sessionId).then(
      (value) => {
        log('Checked logged out (if successful, will return failed in this request)'),
        log('====================================='),
        log('Status: ${value.requestCode.toString()}'),
        log('Status Code: ${value.statusCode}'),
        if (value.requestCode == RequestCode.successful)
          {
            throw Exception(
                'Look like you have logged in! Did you have successfully logout before?')
          }
      },
    );
    log('');
  });
}
