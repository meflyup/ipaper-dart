import 'package:angular2/core.dart';
import 'package:angular2/angular2.dart';
import 'package:codemirror/codemirror.dart';
import 'dart:html';
import 'package:angular_components/angular_components.dart';
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

  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
)
class RmdEditor implements OnInit, Observer, AfterViewInit {
  ElementRef _elementRef;
  static Map options = {'mode': 'markdown', 'theme': 'elegant','lineWrapping':true};
  final PaperService _paperService;
  CodeMirror editor;
  List<Paper> papers = [];
  @ViewChild("rmdEditor")
  var rmdEditor;
  RmdEditor(this._paperService, this._elementRef) {
    _paperService.register(
        this); //make sure when the currentPaper is update in the rmd ediror;
  }
  update(Object object) {
    Paper paper = object;
    editor.getDoc().setValue(UTF8.decode(paper.rmdSource));
  }

  // @override
  // Future<Null> ngAfterViewChecked() async {}
  @override
  ngAfterViewInit() async {
    papers = await _paperService.getPapers();
    editor =
        new CodeMirror.fromElement(rmdEditor.nativeElement, options: options);

    editor.getDoc().setValue(UTF8.decode(papers[0].rmdSource));
  }

  @override
  Future<Null> ngOnInit() async {
    //var rmdEditor = _elementRef.nativeElement.querySelector("#rmdEditor");
  }
}
