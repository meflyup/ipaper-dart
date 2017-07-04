/**
 * this is the pojo class for a paper
 */
import "dart:convert";

class Paper {
  final int id; //the paper's id
  String title; //the title of thepaper ,e.g,'a framework of elearning'
  String bibtex;//the reference in bibtex format for this paper
  String rmdSource; //the raw rmd code of the paper;

  Paper(this.id, this.title, this.rmdSource,this.bibtex);

  factory Paper.fromJson(Map<String, dynamic> paper) {
    int id = _toInt(paper['id']);
    String title = paper['title'];
    String rmdSource = paper['rmdSource'];
    String bibtex=paper['bibtex'];    
    return new Paper(id, title, rmdSource,bibtex);
  }
  String get readableTitle => UTF8.decode(title);// to be readable for chinese charater in html page;

  Map toJson() =>
      {'id': id, 'title': UTF8.encode(title), 'rmdSource': UTF8.encode(rmdSource),'bibtex':UTF8.encode(bibtex)};
}

int _toInt(id) => id is int ? id : int.parse(id);
