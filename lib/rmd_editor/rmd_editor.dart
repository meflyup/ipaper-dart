import 'package:angular2/core.dart';
import 'package:codemirror/codemirror.dart';
import 'dart:html';
@Component(
  selector: 'rmd-editor',
  templateUrl: 'rmd_editor.html',
  styleUrls: const <String>['rmd_editor.css'])
 

class RmdEditor implements OnInit {
 
 static Map options = {
  'mode':  'markdown',
  'theme': 'elegant'
};


  RmdEditor();

  @override
  void ngOnInit() {
CodeMirror editor = new CodeMirror.fromElement(
    querySelector('#rmdEditor'), options: options);
editor.getDoc().setValue('foo.bar(1, 2, 3);');
}
}
