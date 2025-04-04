import 'package:dutwrapper/custom_clock.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get current school year', () async {
    debugPrint('Get current school year');
    debugPrint('=====================================');
    var value = await Utils.getCurrentSchoolYear();
    if (value != null) {
      debugPrint('School year: ${value.schoolYear}');
      debugPrint('School year value: ${value.schoolYearVal}');
      debugPrint('Week: ${value.week}');
    } else {
      debugPrint('Fetch failed!');
    }
    debugPrint('');
  });

  test('Get current dut lesson', () {
    debugPrint('Get current dut lesson');
    debugPrint('=====================================');
    var value2 = CustomClock.current();
    debugPrint('Current time: ${value2.toString()}');
    debugPrint('Current lesson: ${value2.toDUTLesson()}');
    debugPrint('');
  });

  test('Check if have internet', () async {
    debugPrint('Checking...');
    Utils.ensureServerWorking();
    debugPrint('If you reached here, you have connected to sv.dut.udn.vn.');
  });
}
