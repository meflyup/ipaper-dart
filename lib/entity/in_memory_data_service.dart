import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:angular2/angular2.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'paper.dart';

@Injectable()
class InMemoryDataService extends MockClient {
  static final _initialPapers = [
    {'id': 11, 'title': 'Mr. Nice','rmdSource':'''# hello'''},
    {'id': 12, 'title': 'Narco','rmdSource':'''# hello'''},
    {'id': 13, 'title': 'Bombasto','rmdSource':'''# hello'''},
    {'id': 14, 'title': 'Celeritas','rmdSource':'''# hello'''}
//    {'id': 15, 'title': 'Magneta'},
//    {'id': 16, 'title': 'RubberMan'},
//    {'id': 17, 'title': 'Dynama2'},
//    {'id': 18, 'title': 'Dr IQ'},
//    {'id': 19, 'title': 'Magma'},
//    {'id': 20, 'title': 'Tornado'}
  ];
  static final List<Paper> _paperesDb =
      _initialPapers.map((json) => new Paper.fromJson(json)).toList();
  static int _nextId = _paperesDb.map((paper) => paper.id).fold(0, max) + 1;

  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        final id =
            int.parse(request.url.pathSegments.last, onError: (_) => null);
        if (id != null) {
          data = _paperesDb
              .firstWhere((paper) => paper.id == id); // throws if no match
        } else {
          String prefix = request.url.queryParameters['title'] ?? '';
          final regExp = new RegExp(prefix, caseSensitive: false);
          data = _paperesDb.where((paper) => paper.name.contains(regExp)).toList();
        }
        break;
      case 'POST':
        var name = JSON.decode(request.body)['title'];
        var newPaper = new Paper(_nextId++, name);
        _paperesDb.add(newPaper);
        data = newPaper;
        break;
      case 'PUT':
        var paperChanges = new Paper.fromJson(JSON.decode(request.body));
        var targetPaper = _paperesDb.firstWhere((h) => h.id == paperChanges.id);
        targetPaper.name = paperChanges.name;
        data = targetPaper;
        break;
      case 'DELETE':
        var id = int.parse(request.url.pathSegments.last);
        _paperesDb.removeWhere((paper) => paper.id == id);
        // No data, so leave it as null.
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    return new Response(JSON.encode({'data': data}), 200,
        headers: {'content-type': 'application/json'});
  }

  InMemoryDataService() : super(_handler);
}
