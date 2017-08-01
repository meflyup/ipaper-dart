// Copyright (c) 2017, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import '../entity/paper.dart';
import '../entity/paper_service.dart';
final SelectionModel<Paper> targetPaperSelection =
      new SelectionModel.withList(allowMulti: false);
@Component(
  selector: 'todo-list',
  styleUrls: const ['todo_paper_component.css'],
  templateUrl: 'todo_paper_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  // providers: const [PaperService],
)
class TodoPaperComponent implements OnInit {
  final PaperService _paperService;
  List<Paper> papers = [];
  int selectPaperIndex=0;
  String title = '';
  String errorMessage;
  TodoPaperComponent(this._paperService);


  @override
  Future<Null> ngOnInit() async {
    try {
      // papers = await _paperService.getPapers();
      // _paperService.currentPaper = papers[0];
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<Null> addPaper(String title) async {
    title = title.trim();
    if (title.isEmpty) return;
    try {
      papers.add(await _paperService.createPaper(title));
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<Null> selectPaper(int index) async {
    var paper = papers[index];
    _paperService.currentPaperIndex=index;
    try {
      // _paperService.currentPaper = paper;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<Null> removePaper(int index) async {
    try {
      int theIndex = await _paperService.removePaper(index);
      papers.removeAt(theIndex);
    } catch (e) {}
  }

  void onReorder(ReorderEvent e) =>
      papers.insert(e.destIndex, papers.removeAt(e.sourceIndex));
}
