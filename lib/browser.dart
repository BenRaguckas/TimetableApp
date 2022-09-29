// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

// void getHttp() async {
//   try {
//     var response = await Dio().get('https://timetable.ait.ie/2223');
//     print(response);
//     var doc = parse(response);
//     print(doc.getElementById('__VIEWSTATE'));
//     // var formData = FormData.fromMap({});
//   } catch (e) {
//     print(e);
//   }
// }

void getHttp() async {
  var response = await http.Client().get(Uri.parse('https://timetable.ait.ie/2223'));
  if (response.statusCode == 200) {
    var doc = parse(response.body);
    // print(doc.getElementById('__VIEWSTATE')!.attributes['value']);
    doc.getElementsByTagName('input').forEach((element) {
      print(element.attributes['id']);
    });
  } else {
    throw Exception();
  }
}
