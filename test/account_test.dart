// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_print
// This is already test file, we need to all log here

import 'dart:convert';
import 'dart:io';

import 'package:dutwrapper/account_session_object.dart';
import 'package:dutwrapper/accounts.dart';
import 'package:dutwrapper/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Accounts functions', () async {
    var SUBJECT_SCHEDULE_YEAR = 20; // YY
    var SUBJECT_SCHEDULE_SEMESTER = 2; // 1,2,3
    var FETCH_SUBJECT_INFORMATION = true;
    var FETCH_SUBJECT_FEE = true;
    var FETCH_STUDENT_INFORMATION = true;
    var FETCH_TRAINING_RESULT = true;

    var env1 = Platform.environment['dut_account'];
    if (env1 == null) {
      throw Exception(
          'No dut_account varaiable found!\nMake sure you\'re added them in environment variable!');
    }
    if (env1.split('|').length != 2) {
      throw Exception(
          'Invaild dut_account varaiable!\nMake sure you\'re formatted correctly following (username|password)!');
    }

    // Get session
    print('\nGetting new session...');
    AccountSession session = await Accounts.generateNewSession();
    print(session.toJson());

    // Check if logged in before
    print('\nChecking if this session has been logged in before...');
    print(await Accounts.isLoggedIn(session: session));

    // Login and check again
    print('\nLogging in...');
    Accounts.login(
      session: session,
      authInfo: AuthInfo(
        username: env1.split('|')[0],
        password: env1.split('|')[1],
      ),
    );
    print('Done! Now checking if session has been logged in...');
    var loggedIn1 = await Accounts.isLoggedIn(session: session);
    print(loggedIn1);
    if (loggedIn1 != LoginStatus.loggedIn) {
      throw Exception('Sorry, your login information is incorrect. This test cannot continue...');
    }

    // Fetch subject information
    print('\nFetching subject information...');
    if (FETCH_SUBJECT_INFORMATION) {
      print(jsonEncode(await Accounts.fetchSubjectInformation(
        session: session,
        year: SUBJECT_SCHEDULE_YEAR,
        semester: SUBJECT_SCHEDULE_SEMESTER,
      )));
    }

    // Fetch subject fee
    print('\nFetching subject fee...');
    if (FETCH_SUBJECT_FEE) {
      print(jsonEncode(await Accounts.fetchSubjectFee(
        session: session,
        year: SUBJECT_SCHEDULE_YEAR,
        semester: SUBJECT_SCHEDULE_SEMESTER,
      )));
    }

    // Fetch student information
    print('\nFetching student information...');
    if (FETCH_STUDENT_INFORMATION) {
      print(
          (await Accounts.fetchStudentInformation(session: session)).toJson());
    }

    // Fetch training result
    print('\nFetching training result...');
    if (FETCH_TRAINING_RESULT) {
      print((await Accounts.fetchTrainingResult(session: session)).toJson());
    }

    // Logout and ensure logged out
    print('\nLogging out...');
    await Accounts.logout(session: session);
    print('Done! Now checking if session has been logged out...');
    print(await Accounts.isLoggedIn(session: session));

    print('\nThis test has been finished!\n');
  });
}
