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
  static Map options = {
    'mode': 'markdown',
    'theme': 'elegant',
    'lineWrapping': true
  };
  final PaperService _paperService;
  CodeMirror editor;
  List<Paper> papers = [];
  int paperIndex = 0; //当前正在编辑的paper在list中的索引;
  @ViewChild("rmdEditor")
  var rmdEditor;
  @ViewChild("tabs")
  MaterialTabComponent tabComponent;
  RmdEditor(this._paperService, this._elementRef) {
    _paperService.register(
        this); //make sure when the currentPaper is update in the rmd ediror;
  }
  update(Object object) {
    Paper paper = object;
    int index=object;
    paper=_paperService.papers[index];
    editor.getDoc().setValue(UTF8.decode(paper.rmdSource));
    editor.refresh();
  }

  // @override
  // Future<Null> ngAfterViewChecked() async {    Paper paper = await _paperService.currentPaper;
  //   editor.getDoc().setValue(UTF8.decode(paper.rmdSource));
  //   editor.setSize('100%', '800px');

  //   editor.refresh();
  // }
  // @override
  ngAfterViewInit() async {
    papers = await _paperService.getPapers();

    paperIndex = _paperService.currentPaperIndex;
    // editor =
    //     new CodeMirror.fromElement(rmdEditor.nativeElement, options: options);
    editor =
        new CodeMirror.fromElement(rmdEditor.nativeElement, options: options);
    editor.onChange.listen((e) => onDataChange(e, paperIndex));
    editor.getDoc().setValue(UTF8.decode(papers[paperIndex].rmdSource));
    editor.setSize('100%', '800px');

    editor.refresh();
  }

  @override
  Future<Null> ngOnInit() async {
    // papers = await _paperService.getPapers();
    //var rmdEditor = _elementRef.nativeElement.querySelector("#rmdEditor");
  }

  void changeToDocumentTab() {
    if (tabComponent.tabId == 0) {
      Paper paper = _paperService.papers[paperIndex];
      editor.getDoc().setValue(UTF8.decode(paper.rmdSource));
      editor.setSize('100%', '800px');

      editor.refresh();
    }
  }

  void onDataChange(event, int index) {
    papers[index].rmdSource = editor.getDoc().getValue();
  }

  @override
  String toString() {}
}
