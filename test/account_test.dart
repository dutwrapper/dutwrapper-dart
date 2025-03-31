// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_print
// This is already test file, we need to all log here

import 'dart:convert';
import 'dart:io';

import 'package:dutwrapper/account_session_object.dart';
import 'package:dutwrapper/accounts.dart';
import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/lib_exception.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter/foundation.dart';
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
      throw DutWrapperException(
        message: "No dut_account varaiable found!\n"
            "Make sure you're added them in environment variable!",
        reason: DutWrapperExceptionReason.parameterException,
      );
    }
    if (env1.split('|').length != 2) {
      throw DutWrapperException(
        message: "Invaild dut_account varaiable!\n"
            "Make sure you're formatted correctly "
            "following (username|password)!",
        reason: DutWrapperExceptionReason.parameterException,
      );
    }

    // Checking server is available before starting test.
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    // Get session
    debugPrint('\nGetting new session...');
    AccountSession session = await Accounts.generateNewSession();
    debugPrint(session.toJson());

    // Check if logged in before
    debugPrint('\nChecking if this session has been logged in before...');
    debugPrint((await Accounts.isLoggedIn(session: session)).toString());

    // Login and check again
    debugPrint('\nLogging in...');
    Accounts.login(
      session: session,
      authInfo: AuthInfo(
        username: env1.split('|')[0],
        password: env1.split('|')[1],
      ),
    );
    debugPrint('Done! Now checking if session has been logged in...');
    var loggedIn1 = await Accounts.isLoggedIn(session: session);
    debugPrint(loggedIn1.toString());
    if (loggedIn1 != LoginStatus.loggedIn) {
      throw DutWrapperException(
        message:
            'Sorry, your login information is incorrect. This test cannot continue...',
        reason: DutWrapperExceptionReason.notAuthorized,
      );
    }

    // Fetch subject information
    debugPrint('\nFetching subject information...');
    if (FETCH_SUBJECT_INFORMATION) {
      debugPrint(jsonEncode(await Accounts.fetchSubjectInformation(
        session: session,
        year: SUBJECT_SCHEDULE_YEAR,
        semester: SUBJECT_SCHEDULE_SEMESTER,
      )));
    }

    // Fetch subject fee
    debugPrint('\nFetching subject fee...');
    if (FETCH_SUBJECT_FEE) {
      debugPrint(jsonEncode(await Accounts.fetchSubjectFee(
        session: session,
        year: SUBJECT_SCHEDULE_YEAR,
        semester: SUBJECT_SCHEDULE_SEMESTER,
      )));
    }

    // Fetch student information
    debugPrint('\nFetching student information...');
    if (FETCH_STUDENT_INFORMATION) {
      debugPrint(
          (await Accounts.fetchStudentInformation(session: session)).toJson());
    }

    // Fetch training result
    debugPrint('\nFetching training result...');
    if (FETCH_TRAINING_RESULT) {
      debugPrint(
          (await Accounts.fetchTrainingResult(session: session)).toJson());
    }

    // Logout and ensure logged out
    debugPrint('\nLogging out...');
    await Accounts.logout(session: session);
    debugPrint('Done! Now checking if session has been logged out...');
    debugPrint((await Accounts.isLoggedIn(session: session)).toString());

    debugPrint('\nThis test has been finished!\n');
  });
}
