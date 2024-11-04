// ignore_for_file: avoid_print
// This is already test file, we need to all log here

import 'dart:convert';

import 'package:dutwrapper/news.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('News Global', () async {
    for (int i = 1; i <= 5; i++) {
      print('======= GET GLOBAL NEWS - PAGE $i ========');
      final response = await News.getNewsGlobal(page: i);

      if (response.isNotEmpty) {
        print('Subject list: ${response.length}');
        for (var element in response) {
          print('========================================');
          print('Date: ${element.date}');
          print('Title: ${element.title}');
          print('Content: ${element.content}');
          for (var link in element.resources) {
            print('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
        }

        print(jsonEncode(response));
      } else {
        print('Nothing in list!');
      }
    }
  });

  test('News Subject', () async {
    for (int i = 1; i <= 5; i++) {
      print('======= GET SUBJECT NEWS - PAGE $i =======');
      final response = await News.getNewsSubject(page: i);

      if (response.isNotEmpty) {
        print('Subject list: ${response.length}');
        for (var element in response) {
          print('========================================');
          print('Date: ${element.date}');
          print('Title: ${element.title}');
          print('Content: ${element.content}');
          for (var link in element.resources) {
            print('Link: ${link.position} - ${link.type} - ${link.text} - ${link.content}');
          }
          for (var affectedClassItem in element.affectedClasses) {
            print(
                "Class affected: ${affectedClassItem.subjectName} - ${affectedClassItem.codeList.map((p) => "${p.studentYearId}-${p.classId}").toList().join(", ")}");
          }
          print('Lecturer Gender: ${element.lecturerGender.toString()}');
          print('Lecturer Name: ${element.lecturerName}');
          print('Lesson Status: ${element.lessonStatus.toString()}');
          print('Affected Date: ${element.affectedDate}');
          print('Affected Lesson: ${element.affectedLessons.toString()}');
          print('Affected Room: ${element.affectedRoom}');
        }
        print(jsonEncode(response));
      } else {
        print('Nothing in list!');
      }
    }
  });
}
