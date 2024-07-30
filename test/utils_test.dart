// ignore_for_file: avoid_print
// This is already test file, we need to all log here

import 'package:dutwrapper/custom_clock.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get current school year', () async {
    print('Get current school year');
    print('=====================================');
    var value = await Utils.getCurrentSchoolYear();
    if (value != null) {
      print('School year: ${value.schoolYear}');
      print('School year value: ${value.schoolYearVal}');
      print('Week: ${value.week}');
    } else {
      print('Fetch failed!');
    }
    print('');
  });

  test('Get current dut lesson', () {
    print('Get current dut lesson');
    print('=====================================');
    var value2 = CustomClock.current();
    print('Current time: ${value2.toString()}');
    print('Current lesson: ${value2.toDUTLesson()}');
    print('');
  });
}
