// Copyright (c) 2017, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:async';
import 'todo_list/todo_paper_component.dart';
import 'rmd_editor/rmd_editor.dart';
import 'md_previewer/md_previewer.dart';
import './entity/paper_service.dart';
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives,
    TodoPaperComponent,
    RmdEditor,
    MdPreviewer
  ],
  providers: const [materialProviders, PaperService],
)
class AppComponent implements OnInit {
  // Nothing here yet. All logic is in TodoListComponent.
  String errorMessage;
  final PaperService _paperService;
  AppComponent(this._paperService);
  @override
  Future<Null> ngOnInit() async {
    try {
      await _paperService.getPapers();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
