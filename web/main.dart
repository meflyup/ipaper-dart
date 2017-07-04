// Copyright (c) 2017, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';

import 'package:testpaper/app_component.dart';
import  'package:http/http.dart';
import 'package:testpaper/entity/in_memory_data_service.dart' ;
void main() {
  bootstrap(AppComponent,[provide(Client,useClass:InMemoryDataService)]);
}
