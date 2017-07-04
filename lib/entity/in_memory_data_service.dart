import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:angular2/angular2.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'paper.dart';

@Injectable()
class InMemoryDataService extends MockClient {
  static final _initialPapers = [
    {'id': 11, 'title': '中文名','rmdSource':r'''# 配置和使用rmarkdown

## 安装pandoc，通过 stack方法安装。 
Install stack 

-	首先添加yum 库
```
curl -sSL https://s3.amazonaws.com/download.fpcomplete.com/centos/7/fpco.repo | sudo tee /etc/yum.repos.d/fpco.repo
```
-	安装
```
sudo yum -y install stack 

```
-	获取pandoc源代码 
```
git clone https://github.com/jgm/pandoc
cd pandoc
git submodule update --init   # to fetch the templates

```
- 安装依赖的zlib  

```
sudo yum install zlib-devel
``` 

-	然后就可以安装pandoc了 
```
stack setup
stack install 
```
- 完了之后配置PATH
```
vi /etc/profile 
```
   在最后添加如何path配置 
```
export PATH=/root/pandoc/.stack-work/install/x86_64-linux/lts-6.14/7.10.3/bin:$PATH
```
然后使配置生效
```
Source /etc/profile
```
# 安装R、 rmarkdown
[参考地址](https://cran.rstudio.com/bin/linux/redhat/README)
- 安装R
```
sudo yum install R 

```
## 安装web 版rstudio
如果想要安装web server版本的rstudio，那么[参考](https://www.rstudio.com/products/rstudio/download-server/) 
安装完成R之后，再命令行运行R进入R交互解释器
```
R
```

输入:
```
install.packages("rmarkdown"）#安装rmarkdown包
```
[参考](https://github.com/rstudio/rmarkdown)   
```
install.packages("rticles", type = "source") # 安装用于科学文章格式的rticle
```

[参考](https://github.com/rstudio/rticles)  

# 安装texlive 完整版
在上面安装R的时候，自动安装了其依赖的texlive，但是在amazon ami上，只安装到texlive2013版本。且这个安装中似乎少了很多的包，因此用rmarkdown输出PDF的时候缺少很多的.sty文件，比如titling.sty这个关键的包，导致编译不通过。并且这个版本不能使用tlmgr命令来管理。于是，我只能再安装一个完整版本的texlive，用最新版2016版，然后从其中拷贝出来。幸好texlive 2016都会安装在一个目录，不会跟yum install R时所依赖的冲突。ps:有其他好方法的请指出。安装方法如下。  

在这个[地址](http://tug.org/texlive/acquire-netinstall.html)去下载[install-tl-unx.tar.gz](http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz)   

解压后进入目录执行:
```
sudo ./install-tl

```
等待一段时间之后，输入  

```
i(可能大小写要注意，有提示的)    
```  

然后等待安装完成。安装的位置默认在：
```
/usr/local/texlive/2016 

```
然后，可以使用root权限运行tlmgr命令，进行texlive的管理。[参考](http://tug.org/texlive/tlmgr.html)
> amazon ami linux中，默认可使用：
```
sudo su -
```
命令进入root   
然后用下面的命令：
```
cp -r /usr/local/texlive/2016/texmf-dist/ /usr/share/texlive/
```

源目录就是tex2016的包所在的目录，其中就有titling包。后者是yum instal R时自动安装的texlive2013的一个目录，里面只有少数的包。因此使用上面的命令把这个里面的都拷贝过去。

完成上述步骤之后，就可以顺利顺利编译pdf文档了。当然根据各自使用的latex模版不同，也可能需要其他的texlive 包，那时候就按照上面如法炮制就可以了。''','bibtex':'''@article{Meghir2004Educational,
  title={Educational Reform, Ability, and Family Background},
  author={Meghir, Costas and Palme, Mårten},
  journal={Ifs Working Papers},
  volume={95},
  number={1},
  pages={414-424},
  year={2004},
}
'''},
    {'id': 12, 'title': 'Narco','rmdSource':'''# hello''','bibtex':''' '''},
    {'id': 13, 'title': 'Bombasto','rmdSource':'''# hello''','bibtex':''' '''},
    {'id': 14, 'title': 'Celeritas','rmdSource':'''# hello''','bibtex':''' '''}
//    {'id': 15, 'title': 'Magneta'},
//    {'id': 16, 'title': 'RubberMan'},
//    {'id': 17, 'title': 'Dynama2'},
//    {'id': 18, 'title': 'Dr IQ'},
//    {'id': 19, 'title': 'Magma'},
//    {'id': 20, 'title': 'Tornado'}
  ];
  static final List<Paper> _paperesDb =
      _initialPapers.map((json) => new Paper.fromJson(json)).toList();
  static int _nextId = _paperesDb.map((paper) => paper.id).fold(0, max) + 1;

  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        final id =
            int.parse(request.url.pathSegments.last, onError: (_) => null);
        if (id != null) {
          data = _paperesDb
              .firstWhere((paper) => paper.id == id); // throws if no match
        } else {
          String prefix = request.url.queryParameters['title'] ?? '';
          final regExp = new RegExp(prefix, caseSensitive: false);
          data = _paperesDb.where((paper) => paper.title.contains(regExp)).toList();
        }
        break;
      case 'POST':
        var title = JSON.decode(request.body)['title'];
        var rmdSource = JSON.decode(request.body)['rmdSource'];
        var bibtex=JSON.decode(request.body)['bibtex'];
        var newPaper = new Paper(_nextId++, title,rmdSource,bibtex);
        _paperesDb.add(newPaper);
        data = newPaper;
        break;
      case 'PUT':
        var paperChanges = new Paper.fromJson(JSON.decode(request.body));
        var targetPaper = _paperesDb.firstWhere((h) => h.id == paperChanges.id);
        targetPaper.title = paperChanges.title;
        data = targetPaper;
        break;
      case 'DELETE':
        var id = int.parse(request.url.pathSegments.last);
        _paperesDb.removeWhere((paper) => paper.id == id);
        // No data, so leave it as null.
        data=id;
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    
    return new Response(JSON.encode({'data': data}), 200,
        headers: {'content-type': 'application/json','charset':'utf-8'});
  }

  InMemoryDataService() : super(_handler);
}
