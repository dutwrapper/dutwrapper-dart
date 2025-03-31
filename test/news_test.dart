// ignore_for_file: avoid_print
// This is already test file, we need to all log here

import 'dart:convert';

import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('News Global', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrint('======= GET GLOBAL NEWS - PAGE $i ========');
      final response = await News.getNewsGlobal(page: i);

      if (response.isNotEmpty) {
        debugPrint('Subject list: ${response.length}');
        for (var element in response) {
          debugPrint('========================================');
          debugPrint('Date: ${element.date}');
          debugPrint('Title: ${element.title}');
          debugPrint('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrint(
                'Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
        }

        debugPrint(jsonEncode(response));
      } else {
        debugPrint('Nothing in list!');
      }
    }
  });

  test('News Subject', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrint('======= GET SUBJECT NEWS - PAGE $i =======');
      final response = await News.getNewsSubject(page: i);

      if (response.isNotEmpty) {
        debugPrint('Subject list: ${response.length}');
        for (var element in response) {
          debugPrint('========================================');
          debugPrint('Date: ${element.date}');
          debugPrint('Title: ${element.title}');
          debugPrint('Content: ${element.content}');
          for (var link in element.resources) {
            debugPrint(
                'Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
          for (var affectedClassItem in element.affectedClasses) {
            debugPrint(
                "Class affected: ${affectedClassItem.subjectName} - ${affectedClassItem.codeList.map((p) => "${p.studentYearId}-${p.classId}").toList().join(", ")}");
          }
          debugPrint('Lecturer Gender: ${element.lecturerGender.toString()}');
          debugPrint('Lecturer Name: ${element.lecturerName}');
          debugPrint('Lesson Status: ${element.lessonStatus.toString()}');
          debugPrint('Affected Date: ${element.affectedDate}');
          debugPrint('Affected Lesson: ${element.affectedLessons.toString()}');
          debugPrint('Affected Room: ${element.affectedRoom}');
        }
        debugPrint(jsonEncode(response));
      } else {
        debugPrint('Nothing in list!');
      }
    }
  });
}
