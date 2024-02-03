import 'dart:developer';

import 'package:dutwrapper/news.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('News Global', () async {
    for (int i = 1; i <= 5; i++) {
      log('======= GET GLOBAL NEWS - PAGE $i ========');
      final response = await News.getNewsGlobal(page: i);

      if (response.isNotEmpty) {
        log('Subject list: ${response.length}');
        for (var element in response) {
          log('========================================');
          log('Date: ${element.date}');
          log('Title: ${element.title}');
          log('Content String: ${element.contentString}');
          log('Links:');
          for (var link in element.links) {
            log('========= Link ========');
            log('Text: ${link.text}');
            log('Position: ${link.position}');
            log('Url: ${link.url}');
          }
        }
      } else {
        log('Nothing in list!');
      }
    }
  });

  test('News Subject', () async {
    for (int i = 1; i <= 5; i++) {
      log('======= GET SUBJECT NEWS - PAGE $i =======');
      final response = await News.getNewsSubject(page: i);

      if (response.isNotEmpty) {
        log('Subject list: ${response.length}');
        for (var element in response) {
          log('========================================');
          log('Date: ${element.date}');
          log('Title: ${element.title}');
          log('Content: ${element.contentString}');
          log('Lecturer Gender: ${element.lecturerGender.toString()}');
          log('Lecturer Name: ${element.lecturerName}');
          log('Lesson Status: ${element.lessonStatus.toString()}');
          log('Affected Date: ${element.affectedDate}');
          log('Affected Lesson: ${element.affectedLessons.toString()}');
          log('Affected Room: ${element.affectedRoom}');
          log('Affected Class:');
          for (var affectedClassItem in element.affectedClasses) {
            log(affectedClassItem.subjectName);
            for (var codeItem in affectedClassItem.codeList) {
              log(codeItem.toStringTwoLastDigit());
            }
          }
        }
      } else {
        log('Nothing in list!');
      }
    }
  });
}
