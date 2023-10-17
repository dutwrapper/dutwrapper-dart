library dutwrapper;

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'model/enums.dart';
import 'model/range_class.dart';
import 'model/subject_code_item.dart';
import 'model/news_obj.dart';
import 'model/subject_group_item.dart';

class News {
  static Future<List<NewsGlobal>> _getNews({
    int page = 1,
    required NewsType newsType,
  }) async {
    final List<NewsGlobal> result = [];

    String newsUrl =
        "http://sv.dut.udn.vn/WebAjax/evLopHP_Load.aspx?E=${(newsType == NewsType.global) ? 'CTRTBSV' : 'CTRTBGV'}&PAGETB=$page&COL=TieuDe&NAME=&TAB=0";

    final response = await http.Client().get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      var doc = parse(response.body).getElementById('pnBody');
      if (doc != null) {
        doc.getElementsByClassName('tbBox').forEach((element) {
          NewsGlobal newsItem = NewsGlobal();
          var splitted = element
              .getElementsByClassName('tbBoxCaption')[0]
              .text
              .split(':     ');
          // Date
          final dateTime = DateTime.parse(
              splitted[0].split('/').reversed.toList().join('-'));
          newsItem.date = dateTime.millisecondsSinceEpoch;
          // Title
          newsItem.title = splitted[1];
          // Html and content string
          newsItem.content =
              element.getElementsByClassName('tbBoxContent')[0].innerHtml;
          newsItem.contentString =
              element.getElementsByClassName('tbBoxContent')[0].text;
          // Detect links
          int position = 1;
          var contentTemp = newsItem.contentString;
          element
              .getElementsByClassName('tbBoxContent')[0]
              .getElementsByTagName('a')
              .forEach((element) {
            if (contentTemp.contains(element.text)) {
              position += contentTemp.indexOf(element.text);
              NewsLinkItem newsLink = NewsLinkItem(
                  text: element.text,
                  position: position,
                  url: element.attributes['href']!);
              newsItem.links.add(newsLink);

              position += element.text.length;

              // https://stackoverflow.com/questions/24220509/exception-when-replacing-brackets
              // var temp = contentTemp.split(element.text);
              // if (temp.length > 1) contentTemp = temp[1];
              contentTemp = contentTemp.substring(
                  contentTemp.indexOf(element.text) + element.text.length);
            }
          });

          // Add to list.
          result.add(newsItem);
        });
      }
    }

    return result;
  }

  static Future<List<NewsGlobal>> getNewsGlobal({int page = 1}) async {
    return await _getNews(page: page, newsType: NewsType.global);
  }

  static Future<List<NewsSubject>> getNewsSubject({int page = 1}) async {
    List<NewsSubject> result = [];

    var newsBaseList = await _getNews(page: page, newsType: NewsType.subject);
    for (var newsItem in newsBaseList) {
      NewsSubject item = NewsSubject();
      // Add all items in news global.
      item.date = newsItem.date;
      item.title = newsItem.title;
      item.content = newsItem.content;
      item.contentString = newsItem.contentString;
      item.links.clear();
      item.links.addAll(newsItem.links);

      // For title
      String lecturerProcessing =
          newsItem.title.split(' thông báo đến lớp: ')[0].trim();

      // Lecturer name
      item.lecturerName =
          lecturerProcessing.substring(lecturerProcessing.indexOf(' ') + 1);
      // Lecturer gender
      switch (lecturerProcessing
          .substring(0, lecturerProcessing.indexOf(' '))
          .trim()
          .toLowerCase()) {
        case 'thầy':
          {
            item.lecturerGender = LecturerGender.male;
            break;
          }
        case 'cô':
          {
            item.lecturerGender = LecturerGender.female;
            break;
          }
        default:
          {
            item.lecturerGender = LecturerGender.other;
            break;
          }
      }

      // Subject processing
      newsItem.title.split(' thông báo đến lớp: ')[1].split(' , ').forEach(
        (element) {
          final start = element.lastIndexOf('[') + 1;
          final end = element.lastIndexOf(']');
          final classId = element.substring(start, end);
          final className = element.substring(0, start - 1).trimRight();

          final affectedClassIndex = item.affectedClasses
              .indexWhere((element) => element.subjectName == className);
          if (affectedClassIndex > -1) {
            var affectedClass = item.affectedClasses[affectedClassIndex];
            affectedClass.codeList.add(
              SubjectCodeItem.fromTwoLastDigit(
                studentYearId: classId.split('.')[0],
                classId: classId.split('.')[1],
              ),
            );
          } else {
            SubjectGroupItem subjectGroupItem = SubjectGroupItem();
            subjectGroupItem.subjectName = className;
            try {
              subjectGroupItem.codeList.add(
                SubjectCodeItem.fromTwoLastDigit(
                  studentYearId: classId.split('.')[0],
                  classId: classId.split('.')[1],
                ),
              );
            } catch (ex) {
              subjectGroupItem.codeList.add(
                SubjectCodeItem.fromTwoLastDigit(
                  studentYearId: classId.substring(0, 2),
                  classId: classId.substring(2),
                ),
              );
            }
            item.affectedClasses.add(subjectGroupItem);
          }
        },
      );

      // Check if is make up or leaving subject lessons.
      if (item.contentString.contains('HỌC BÙ')) {
        item.lessonStatus = LessonStatus.makeUp;
      } else if (item.contentString.contains('NGHỈ HỌC')) {
        item.lessonStatus = LessonStatus.leaving;
      } else {
        item.lessonStatus = LessonStatus.unknown;
      }

      // Date (These works apply only if lesson status is leaving and make up)
      if ([LessonStatus.leaving, LessonStatus.makeUp]
          .contains(item.lessonStatus)) {
        RegExp regExp = RegExp('\\d{2}[-|/]\\d{2}[-|/]\\d{4}');
        var firstMatch = regExp.firstMatch(item.contentString);
        if (firstMatch != null) {
          final dateTime = DateTime.parse(item.contentString
              .substring(firstMatch.start, firstMatch.end)
              .split('/')
              .reversed
              .toList()
              .join('-'));
          item.affectedDate = dateTime.millisecondsSinceEpoch;
        }
      }

      // Lesson (These works apply only if lesson status is leaving and make up)
      if ([LessonStatus.leaving, LessonStatus.makeUp]
          .contains(item.lessonStatus)) {
        var query = '';
        if (item.lessonStatus == LessonStatus.makeUp) {
          query = 'tiết: .*[0-9],';
        } else {
          query = '\\(tiết:.*[0-9]\\)';
        }
        RegExp regExp = RegExp(query);
        var firstMatch = regExp.firstMatch(item.contentString.toLowerCase());
        if (firstMatch != null) {
          var splitted = item.contentString
              .substring(firstMatch.start, firstMatch.end)
              .toLowerCase()
              .replaceFirst(
                  (item.lessonStatus == LessonStatus.makeUp)
                      ? 'tiết: '
                      : '(tiết:',
                  '')
              .replaceFirst(
                  (item.lessonStatus == LessonStatus.makeUp) ? ',' : ')', '')
              .trim()
              .split('-');
          item.affectedLessons = RangeInt(
            start: int.parse(splitted[0]),
            end: int.parse(splitted[1]),
          );
        }
      }

      // Room (These works apply only if lesson status is make up)
      if ([LessonStatus.makeUp].contains(item.lessonStatus)) {
        RegExp regExp = RegExp('phòng:.*');
        var firstMatch = regExp.firstMatch(item.contentString.toLowerCase());
        if (firstMatch != null) {
          item.affectedRoom = item.contentString
              .toLowerCase()
              .substring(firstMatch.start, firstMatch.end)
              .replaceFirst('phòng:', '')
              .replaceFirst(',', '')
              .trim()
              .toUpperCase();
        }
      }

      // Add to list
      result.add(item);
    }

    return result;
  }
}
