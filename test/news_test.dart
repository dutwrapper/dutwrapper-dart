import 'package:dutwrapper/enums.dart';
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
      final response = await News.getNews(newsType: NewsType.global, page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('News list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('News type: ${element.newsType}');
          debugPrintSynchronously('Date: ${element.datePublished}');
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
      final response = (await News.getNews(newsType: NewsType.subject, page: i)).map((p) => p.convertToNewsSubject()).toList();

      if (response.isNotEmpty) {
        debugPrintSynchronously('Subject news list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('News type: ${element.newsType}');
          debugPrintSynchronously('Date: ${element.datePublished}');
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
      final response = await News.getNews(newsType: NewsType.studentAffairs, page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('News list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('News type: ${element.newsType}');
          debugPrintSynchronously('Date: ${element.datePublished}');
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
      final response = await News.getNews(newsType: NewsType.examination, page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('News list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('News type: ${element.newsType}');
          debugPrintSynchronously('Date: ${element.datePublished}');
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
      final response = await News.getNews(newsType: NewsType.tuitionFee, page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('News list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('News type: ${element.newsType}');
          debugPrintSynchronously('Date: ${element.datePublished}');
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

  test('News - Statute and policy', () async {
    final checkResponse = await Utils.checkPageStatus();
    checkResponse.ensureSuccessfulStatusCode();

    for (int i = 1; i <= 5; i++) {
      debugPrintSynchronously('== GET NEWS - STATUTE AND POLICY - PAGE $i =');
      final response = await News.getNews(newsType: NewsType.statuteRegulation, page: i);

      if (response.isNotEmpty) {
        debugPrintSynchronously('News list: ${response.length}');
        for (var element in response) {
          debugPrintSynchronously('========================================');
          debugPrintSynchronously('News type: ${element.newsType}');
          debugPrintSynchronously('Date: ${element.datePublished}');
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
