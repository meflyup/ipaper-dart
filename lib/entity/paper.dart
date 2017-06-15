/**
 * this is the pojo class for a paper
 */
class Paper {
  final int id; //the paper's id
  String title; //the title of thepaper ,e.g,'a framework of elearning'
  String rmdSource; //the raw rmd code of the paper;
  Paper(this.id,this.title,this.rmdSource) ;
  
  factory Paper.fromJson(Map<String, dynamic> paper) =>
      new Paper(_toInt(paper['id']), paper['title'],paper['rmdSource']);

  Map toJson() => {'id': id, 'title': title,'rmdSource':rmdSource};
}

int _toInt(id) => id is int ? id : int.parse(id);
