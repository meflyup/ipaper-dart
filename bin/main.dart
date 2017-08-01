import 'dart:async';
import 'dart:math' show Random;


main() async {
  // List<int> values = [1, 2, 3];
  TestClass tc=new TestClass(); 
  List<int> values2 = tc.values;
  values2.insert(4, 4);
  for (int a in tc.values) print(a);
}
class TestClass{
  List<int> values=[1,2,3,54];
  
}