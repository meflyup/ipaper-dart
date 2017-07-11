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
// import 'package:markdown/markdown.dart';
import 'package:mdown/mdown.dart';

@Component(
  selector: 'md-previewer',
  templateUrl: 'md_previewer.html',
  styleUrls: const <String>['md_previewer.css'],
  // providers: const [PaperService],

  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
)
class MdPreviewer implements OnInit, Observer, AfterViewInit {
   ElementRef _elementRef;
  static Map options = {
    'mode': 'html',
    'theme': 'elegant',
    'lineWrapping': true
  };
  final PaperService _paperService;
  // CodeMirror editor;
  List<Paper> papers = [];
  @ViewChild("mdPreviewer")
  var mdPreviewer;
  MdPreviewer(this._paperService,this._elementRef) {
    _paperService.register(
        this); //make sure when the currentPaper is update in the rmd ediror;
  }
  update(Object object) {
    Paper paper = object;
    String rmdSource = UTF8.decode(papers[0].rmdSource);
    DivElement htmlDiv= mdPreviewer.nativeElement;
    htmlDiv.setInnerHtml(markdownToHtml(rmdSource));
  }

  // @override
  // Future<Null> ngAfterViewChecked() async {}
  @override
  ngAfterViewInit() async {
    papers = await _paperService.getPapers();
    String rmdSource = UTF8.decode(papers[0].rmdSource);
     DivElement htmlDiv= mdPreviewer.nativeElement;
 htmlDiv.setInnerHtml(markdownToHtml(rmdSource));
  }

  @override
  Future<Null> ngOnInit() async {
    //var rmdEditor = _elementRef.nativeElement.querySelector("#rmdEditor");
  }
}
