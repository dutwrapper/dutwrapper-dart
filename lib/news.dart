library dutwrapper;

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'enums.dart';
import 'global_url.dart';
import 'news_object.dart';
import 'range_class.dart';
import 'subject_code.dart';

class News {
  static Future<List<NewsGlobal>> _getNews({
    int page = 1,
    required NewsType newsType,
  }) async {
    final List<NewsGlobal> result = [];

    String newsUrl =
        GlobalUrl.newsLink(newsType: newsType, page: page);

    final response = await http.Client().get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      var doc = parse(response.body).getElementById('pnBody');
      if (doc != null) {
        doc.getElementsByClassName('tbBox').forEach((element) {
          // Add to list.
          result.add(NewsGlobal(
            // Date & title
            title: _getNewsTitle(
                element.getElementsByClassName('tbBoxCaption')[0].text),
            date: _getNewsDate(
                element.getElementsByClassName('tbBoxCaption')[0].text),
            // Html and content string
            content: element.getElementsByClassName('tbBoxContent')[0].text,
            contentHtml:
                element.getElementsByClassName('tbBoxContent')[0].innerHtml,
            // Detect resources
            resources: _getNewsContentResources(
                element.getElementsByClassName('tbBoxContent')[0].innerHtml),
          ));
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
      // Add all items from news global.
      NewsSubject item = NewsSubject(
        date: newsItem.date,
        title: newsItem.title,
        contentHtml: newsItem.contentHtml,
        content: newsItem.content,
        resources: newsItem.resources.toList(),
        // Lecturer name
        lecturerName: _getNewsLecturerName(newsItem.title),
        // Lecturer gender
        lecturerGender: _getNewsLecturerGender(newsItem.title),
        // Check if is make up or leaving subject lessons.
        lessonStatus: _getNewsLessonStatus(newsItem.content),
        // Affected class (got from title).
        affectedClasses: _getNewsAffectedSubjects(newsItem.title),
        // Lesson (Works only if lesson status is leaving and make up)
        affectedLessons: _getNewsAffectedLessons(newsItem.content),
        // Date (Works only if lesson status is leaving and make up)
        affectedDate: _getNewsAdjustDate(newsItem.content),
        // Room (Works only if lesson status is maked up)
        affectedRoom: _getNewsMakeupRoom(newsItem.content),
      );

      // Add to list
      result.add(item);
    }

    return result;
  }

  static String _getNewsTitle(String tbTitle) {
    var split = tbTitle.split(':     ');
    if (split.length != 2) {
      return split[0];
    }
    return split[1];
  }

  static int _getNewsDate(String tbTitle) {
    var split = tbTitle.split(':     ');
    if (split.length != 2) {
      return 0;
    }
    final dateTime =
        DateTime.parse(split[0].split('/').reversed.toList().join('-'));
    return dateTime.millisecondsSinceEpoch;
  }

  static List<NewsResource> _getNewsContentResources(
      String tbContentInnerHtml) {
    List<NewsResource> resources = [];
    tbContentInnerHtml =
        "<!--suppress HtmlRequiredLangAttribute --><html><body>$tbContentInnerHtml</body></html>";
    var docHtml = parse(tbContentInnerHtml);
    var contentTemp = docHtml.body?.text ?? "";
    int position = 1;

    docHtml.getElementsByTagName('a').forEach((element) {
      if (contentTemp.contains(element.text)) {
        position += contentTemp.indexOf(element.text);
        NewsResource newsLink = NewsResource(
            text: element.text,
            position: position,
            type: 'link',
            content: element.attributes['href']!);
        resources.add(newsLink);

        position += element.text.length;

        // https://stackoverflow.com/questions/24220509/exception-when-replacing-brackets
        // var temp = contentTemp.split(element.text);
        // if (temp.length > 1) contentTemp = temp[1];
        contentTemp = contentTemp
            .substring(contentTemp.indexOf(element.text) + element.text.length);
      }
    });

    return resources;
  }

  static LecturerGender _getNewsLecturerGender(String newsTitle) {
    String lecturerProcessing =
        newsTitle.split(' thông báo đến lớp: ')[0].trim();
    switch (lecturerProcessing
        .substring(0, lecturerProcessing.indexOf(' '))
        .trim()
        .toLowerCase()) {
      case 'thầy':
        {
          return LecturerGender.male;
        }
      case 'cô':
        {
          return LecturerGender.female;
        }
      default:
        {
          return LecturerGender.unknown;
        }
    }
  }

  static String _getNewsLecturerName(String newsTitle) {
    String tmp = newsTitle.split(' thông báo đến lớp: ')[0].trim();
    return tmp.substring(tmp.indexOf(' ') + 1);
  }

  static LessonStatus _getNewsLessonStatus(String tbContent) {
    if (tbContent.contains('HỌC BÙ')) {
      return LessonStatus.makeUp;
    } else if (tbContent.contains('NGHỈ HỌC')) {
      return LessonStatus.leaving;
    } else {
      return LessonStatus.notify;
    }
  }

  static List<SubjectAffected> _getNewsAffectedSubjects(String tbTitle) {
    List<SubjectAffected> result = [];

    // Subject processing
    tbTitle.split(' thông báo đến lớp: ')[1].split(' , ').forEach(
          (element) {
        final start = element.lastIndexOf('[') + 1;
        final end = element.lastIndexOf(']');
        final classId = element.substring(start, end);
        final className = element.substring(0, start - 1).trimRight();

        final affectedClassIndex = result
            .indexWhere((element) => element.subjectName == className);
        if (affectedClassIndex > -1) {
          var affectedClass = result[affectedClassIndex];
          affectedClass.codeList.add(
            SubjectCode.fromTwoLastDigit(
              studentYearId: classId.split('.')[0],
              classId: classId.split('.')[1],
            ),
          );
        } else {
          SubjectAffected subjectGroupItem = SubjectAffected.createDefault();
          subjectGroupItem.subjectName = className;
          try {
            subjectGroupItem.codeList.add(
              SubjectCode.fromTwoLastDigit(
                studentYearId: classId.split('.')[0],
                classId: classId.split('.')[1],
              ),
            );
          } catch (ex) {
            subjectGroupItem.codeList.add(
              SubjectCode.fromTwoLastDigit(
                studentYearId: classId.substring(0, 2),
                classId: classId.substring(2),
              ),
            );
          }
          result.add(subjectGroupItem);
        }
      },
    );

    return result;
  }

  static RangeInt _getNewsAffectedLessons(String tbContent) {
    var query = '';
    var ls = _getNewsLessonStatus(tbContent);
    switch (ls) {
      case LessonStatus.makeUp:
        query = 'tiết: .*[0-9],';
        break;
      case LessonStatus.leaving:
        query = '\\(tiết:.*[0-9]\\)';
        break;
      default:
        break;
    }

    // If query is empty, that means just notify news and doesn't affect
    // to subject schedule. So, just ignore that and return default value.
    if (query.isEmpty) {
      return RangeInt();
    }

    RegExp regExp = RegExp(query);
    var firstMatch = regExp.firstMatch(tbContent.toLowerCase());
    if (firstMatch != null) {
      var splitted = tbContent
          .substring(firstMatch.start, firstMatch.end)
          .toLowerCase()
          .replaceFirst(
          (ls == LessonStatus.makeUp)
              ? 'tiết: '
              : '(tiết:',
          '')
          .replaceFirst(
          (ls == LessonStatus.makeUp) ? ',' : ')', '')
          .trim()
          .split('-');
      return RangeInt(
        start: int.parse(splitted[0]),
        end: int.parse(splitted[1]),
      );
    }

    // If doesn't find anything, return default value.
    return RangeInt();
  }

  static int _getNewsAdjustDate(String tbContent) {
    LessonStatus ls = _getNewsLessonStatus(tbContent);

    // If lesson isn't maked up or leaving, return 0.
    // Only maked up or leaving lesson will have date affected.
    if (ls != LessonStatus.makeUp && ls != LessonStatus.leaving) {
      return 0;
    }

    RegExp regExp = RegExp('\\d{2}[-|/]\\d{2}[-|/]\\d{4}');
    var firstMatch = regExp.firstMatch(tbContent);
    if (firstMatch != null) {
      final dateTime = DateTime.parse(tbContent
          .substring(firstMatch.start, firstMatch.end)
          .split('/')
          .reversed
          .toList()
          .join('-'));
      return dateTime.millisecondsSinceEpoch;
    }

    // If doesn't find anything, return 0.
    return 0;
  }

  static String _getNewsMakeupRoom(String tbContent) {
    LessonStatus ls = _getNewsLessonStatus(tbContent);

    // If lesson isn't maked up, return empty string.
    // Only maked up lesson will have make up room.
    if (ls != LessonStatus.makeUp) {
      return "";
    }

    RegExp regExp = RegExp('phòng:.*');
    var firstMatch = regExp.firstMatch(tbContent.toLowerCase());
    if (firstMatch != null) {
      return tbContent
          .toLowerCase()
          .substring(firstMatch.start, firstMatch.end)
          .replaceFirst('phòng:', '')
          .replaceFirst(',', '')
          .trim()
          .toUpperCase();
    }

    // If doesn't find anything, return empty string.
    return "";
  }
}
