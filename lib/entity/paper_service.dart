
import 'dart:async';
import 'dart:convert';

import 'package:angular2/angular2.dart';
import 'package:http/http.dart';

import 'paper.dart';

@Injectable()
class PaperService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _paperesUrl = 'apix/paperes'; // URL to web API
  final Client _http;

  PaperService(this._http);

  Future<List<Paper>> getHeroes() async {
    try {
      final response = await _http.get(_paperesUrl);
      final paperes = _extractData(response)
          .map((value) => new Paper.fromJson(value))
          .toList();
      return paperes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Paper> create(String name) async {
    try {
      final response = await _http.post(_paperesUrl,
          headers: _headers, body: JSON.encode({'name': name}));
      return new Paper.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => JSON.decode(resp.body)['data'];

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return new Exception('Server error; cause: $e');
  }
}

/*
  static const _paperesUrl = 'paperes.json'; // URL to JSON file
*/
