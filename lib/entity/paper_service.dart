import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:angular2/angular2.dart';
import 'package:http/http.dart';
import 'paper.dart';
import '../utity/observer.dart';

@Injectable()
class PaperService {
  static final _headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8'
  };
  Paper paper;
  int index;
  int get currentPaperIndex => index;
  void set currentPaperIndex(int index) {
    if (this.index != index) {
      this.index = index;
      notify(index);
    }
  }

  List<Object> observers = [];
  static const _paperesUrl = 'apix/paperes'; // URL to web API
  final Client _http;
  void set currentPaper(Paper paper) {
    this.paper = paper;
    // notify(paper);
  } // the current paper user is editing.

  Paper get currentPaper => this.paper;
  PaperService(this._http);
  /**
   * register the observer for data change
   */
  register(Object reserver) {
    try {
      observers.add(reserver);
      print(observers[1].toString());
    } catch (e) {
      e.toString();
    }
  }

  notify(int index) {
    for (Observer observer in observers) {
      observer.update(index);
    }
  }

  List<Paper> papers = [];
  Future<List<Paper>> getPapers() async {
    try {
      final response = await _http.get(_paperesUrl);
      papers = _extractData(response)
          .map((value) => new Paper.fromJson(value))
          .toList();
      currentPaperIndex = 0;
      return papers;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<int> removePaper(int id) async {
    try {
      final response = await _http.delete(_paperesUrl + "/" + id.toString(),
          headers: _headers);
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Paper> createPaper(String title) async {
    try {
      // var titleUtf8=UTF8.encode(title);
      //var strTitleUtf8=UTF8.decode(titleUtf8);
      String titleJson = JSON.encode({'title': title});
      final response = await _http.post(_paperesUrl,
          headers: _headers,
          body: JSON.encode({
            'title': title,
            'rmdSource': '# a new paper  put  a template for a paper here ',
            'bibtex': '''@article{Meghir2004Educational,
  title={Educational Reform, Ability, and Family Background},
  author={Meghir, Costas and Palme, Mårten},
  journal={Ifs Working Papers},
  volume={95},
  number={1},
  pages={414-424},
  year={2004},
}
'''
          }));
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
