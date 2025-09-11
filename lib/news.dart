import 'dart:io';

import 'package:html/parser.dart';

import 'enums.dart';
import 'global_url.dart';
import 'http_client_wrapper.dart';
import 'news_function.dart';
import 'news_object.dart';

class News {
  static Future<List<NewsCore>> getNews({
    int page = 1,
    required NewsType newsType,
    NewsSearchMethod newsSearchMethod = NewsSearchMethod.byTitle,
    String? newsSearchQuery,
  }) async {
    final List<NewsCore> result = [];

    String newsUrl = GlobalUrl.newsLink(
      newsType: newsType,
      page: page,
      searchType: newsSearchMethod,
      query: newsSearchQuery,
    );

    final response = await HttpClientWrapper.get(uri: Uri.parse(newsUrl));
    response.ensureSuccessfulStatusCode();
    final doc = parse(response.body).getElementById('pnBody');
    if (doc != null) {
      doc.getElementsByClassName('tbBox').forEach((element) {
        // Add to list.
        result.add(NewsCore(
          // News type
          newsType: newsType.toString(),
          // Date published & title
          title: NewsFunction.getNewsTitle(element.getElementsByClassName('tbBoxCaption')[0].text),
          datePublished: NewsFunction.getNewsDate(element.getElementsByClassName('tbBoxCaption')[0].text),
          // Html and content string
          content: element.getElementsByClassName('tbBoxContent')[0].text,
          contentHtml: element.getElementsByClassName('tbBoxContent')[0].innerHtml,
          // Detect resources
          resources: NewsFunction.getNewsContentResources(element.getElementsByClassName('tbBoxContent')[0].innerHtml),
          // Date fetched
          dateFetched: DateTime.now().toUtc().millisecondsSinceEpoch,
        ));
        sleep(Duration(milliseconds: 25));
      });
    }

    return result;
  }
}
