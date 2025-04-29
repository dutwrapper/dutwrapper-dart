import 'package:dutwrapper/custom_clock.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get current school year', () async {
    debugPrintSynchronously('Get current school year');
    debugPrintSynchronously('=====================================');
    var value = await Utils.getCurrentSchoolYear();
    if (value != null) {
      debugPrintSynchronously('School year: ${value.schoolYear}');
      debugPrintSynchronously('School year value: ${value.schoolYearVal}');
      debugPrintSynchronously('Week: ${value.week}');
    } else {
      debugPrintSynchronously('Fetch failed!');
    }
    debugPrintSynchronously('');
  });

  test('Get current dut lesson', () {
    debugPrintSynchronously('Get current dut lesson');
    debugPrintSynchronously('=====================================');
    var value2 = CustomClock.current();
    debugPrintSynchronously('Current time: ${value2.toString()}');
    debugPrintSynchronously('Current lesson: ${value2.toDUTLesson()}');
    debugPrintSynchronously('');
  });

  test('Check if have internet', () async {
    debugPrintSynchronously('Checking...');
    Utils.ensureServerWorking();
    debugPrintSynchronously('If you reached here, you have connected to sv.dut.udn.vn.');
  });
}
