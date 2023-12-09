import 'dart:developer';

import 'package:dutwrapper/model/custom_clock.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get current school year', () async {
    log('Get current school year');
    log('=====================================');
    var value = await DutUtils.getCurrentSchoolYear();
    if (value != null) {
      log('School year: ${value.schoolYear}');
      log('School year value: ${value.schoolYearVal}');
      log('Week: ${value.week}');
    } else {
      log('Fetch failed!');
    }
    log('');
  });

  test('Get current dut lesson', () {
    log('Get current dut lesson');
    log('=====================================');
    var value2 = CustomClock.current();
    log('Current time: ${value2.toString()}');
    log('Current lesson: ${value2.toDUTLesson()}');
    log('');
  });
}
