import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('News - Global', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrintSynchronously('======= GET GLOBAL NEWS - PAGE $i ========');
      final response = await News.getNewsGlobal(page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('Subject list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('Date: ${element.date}');
          debugPrintSynchronously('Title: ${element.title}');
          debugPrintSynchronously('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrintSynchronously('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
        }
      } else {
        debugPrintSynchronously('Nothing in list!');
      }
    }
  });

  test('News - Subject', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrintSynchronously('======= GET SUBJECT NEWS - PAGE $i =======');
      final response = await News.getNewsSubject(page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('Subject list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('Date: ${element.date}');
          debugPrintSynchronously('Title: ${element.title}');
          debugPrintSynchronously('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrintSynchronously('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
          for (var affectedClassItem in element.affectedClasses) {
            debugPrintSynchronously(
                "Class affected: ${affectedClassItem.subjectName} - ${affectedClassItem.codeList.map((p) => "${p.studentYearId}-${p.classId}").toList().join(", ")}");
          }
          debugPrintSynchronously('Lecturer Gender: ${element.lecturerGender.toString()}');
          debugPrintSynchronously('Lecturer Name: ${element.lecturerName}');
          debugPrintSynchronously('Lesson Status: ${element.lessonStatus.toString()}');
          debugPrintSynchronously('Affected Date: ${element.affectedDate}');
          debugPrintSynchronously('Affected Lesson: ${element.affectedLessons.toString()}');
          debugPrintSynchronously('Affected Room: ${element.affectedRoom}');
        }
      } else {
        debugPrintSynchronously('Nothing in list!');
      }
    }
  });

  test('News - Student Affairs', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrintSynchronously('=== GET NEWS - STUDENT AFFAIRS - PAGE $i ===');
      final response = await News.getNewsStudentAffairs(page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('Subject list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('Date: ${element.date}');
          debugPrintSynchronously('Title: ${element.title}');
          debugPrintSynchronously('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrintSynchronously('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
        }
      } else {
        debugPrintSynchronously('Nothing in list!');
      }
    }
  });

  test('News - Examination', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrintSynchronously('===== GET NEWS - EXAMINATION - PAGE $i =====');
      final response = await News.getNewsExamination(page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('Subject list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('Date: ${element.date}');
          debugPrintSynchronously('Title: ${element.title}');
          debugPrintSynchronously('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrintSynchronously('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
        }
      } else {
        debugPrintSynchronously('Nothing in list!');
      }
    }
  });

  test('News - Tuition fee', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrintSynchronously('===== GET NEWS - TUITION FEE - PAGE $i =====');
      final response = await News.getNewsTuitionFee(page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('Subject list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('Date: ${element.date}');
          debugPrintSynchronously('Title: ${element.title}');
          debugPrintSynchronously('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrintSynchronously('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
        }
      } else {
        debugPrintSynchronously('Nothing in list!');
      }
    }
  });
}
