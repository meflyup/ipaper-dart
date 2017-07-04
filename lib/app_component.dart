// Copyright (c) 2017, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';

import 'todo_list/todo_paper_component.dart';
import 'rmd_editor/rmd_editor.dart';
import './entity/paper_service.dart';
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, TodoPaperComponent,RmdEditor],
  providers: const [materialProviders,PaperService],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
