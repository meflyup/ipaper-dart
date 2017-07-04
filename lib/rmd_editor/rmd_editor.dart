import 'package:angular2/core.dart';
import 'package:codemirror/codemirror.dart';
import 'dart:html';
import '../entity/paper.dart';
import '../entity/paper_service.dart';
import 'dart:async';
import 'dart:convert';
import '../utity/observer.dart';
@Component(
  selector: 'rmd-editor',
  templateUrl: 'rmd_editor.html',
  styleUrls: const <String>['rmd_editor.css'],
  // providers: const [PaperService],
)
class RmdEditor implements OnInit ,Observer {
  static Map options = {'mode': 'markdown', 'theme': 'elegant'};
  final PaperService _paperService;
  CodeMirror editor;
  List<Paper> papers = [];
  RmdEditor(this._paperService){

   _paperService.register(this);//make sure when the currentPaper is update in the rmd ediror;
  }
  update(Object object) {
    Paper paper=object;
    editor.getDoc().setValue(UTF8.decode(paper.rmdSource));
  }

  @override
  Future<Null> ngOnInit() async {
    editor = new CodeMirror.fromElement(querySelector('#rmdEditor'),
        options: options);
    papers = await _paperService.getPapers();
    editor.getDoc().setValue(UTF8.decode(papers[0].rmdSource));
  }
}
