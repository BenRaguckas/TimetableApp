import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class TimetableBrowser {
  final _client = http.Client();
  // final _cookieTimeout = 0;
  String _cookies = "";
  var _body = <String, String>{};
  final String _originUri;
  String targetUri = "";

  //  Empty constructor
  TimetableBrowser(this._originUri);

  //  Step 1
  //  Get timetable url
  Future<bool> getInitialUrl() async {
    var response = await _client.get(Uri.parse(_originUri));
    if (response.statusCode == 200) {
      var doc = html.parse(response.body);
      String content = doc.getElementsByTagName('meta').first.attributes['content'].toString();
      var re = RegExp("'(.*?)'"); //  Isolate element in single quotes
      _setTargetUri(re.firstMatch(content)!.group(1).toString());
    } else {
      throw Exception("getInitialUrl return != 200");
    }
    return true;
  }

  //  Step 2
  //  Gets login form and from it form details (for submit) and target url.
  Future<bool> getLoginForm() async {
    var response = await _client.get(Uri.parse(targetUri));
    if (response.statusCode == 200) {
      _body = _getFormInputs(response, submitId: 'bGuestLogin');
      var doc = html.parse(response.body);
      _setTargetUri(doc.getElementsByTagName('form').first.attributes['action'].toString());
    } else {
      throw Exception("getLoginForm return != 200");
    }
    return true;
  }

  //  Step 3
  //  Submit login and get cookies
  Future<bool> submitLoginForm() async {
    //  Post request for redirect url and cookies
    var response = await _client.post(Uri.parse(targetUri), body: _body);
    if (response.statusCode == 302) {
      _setTargetUri(response.headers['location'], fromOrigin: true);
      if (response.headers.containsKey('set-cookie')) {
        _cookies = response.headers['set-cookie']!.replaceAll('path=/;', '').replaceAll('HttpOnly', '').replaceAll(',', '');
      }
    } else {
      throw Exception("submitLoginForm return != 302");
    }
    response = await _client.get(Uri.parse(targetUri), headers: {'cookie': _cookies});
    response.headers.forEach((key, value) {
      print("$key: $value");
    });

    // var request = http.Request("Get", Uri.parse(uri));
    // request.followRedirects = true;
    // request.bodyFields = _body;
    // var response = await request.send();
    // response.request?.headers.forEach((key, value) {
    //   print("$key: $value");
    // });

    return true;
  }

  //  Gets form inputs
  Map<String, String> _getFormInputs(http.Response response, {String submitId = ''}) {
    var doc = html.parse(response.body);
    var formInputs = <String, String>{};
    doc.getElementsByTagName('input').forEach((element) {
      //  Check if a value exists (null / empty)
      if (element.attributes['value'] != null && element.attributes['value']!.isNotEmpty) {
        //  Check if it is submit input
        if (element.attributes['type'].toString() != 'submit') {
          formInputs[element.attributes['id'].toString()] = element.attributes['value']!;
        } else if (element.attributes['id'].toString() == submitId) {
          formInputs[element.attributes['id'].toString()] = element.attributes['value']!;
        }
      }
    });
    // if (kDebugMode) {
    //   print('Gathered form variables.');
    //   formInputs.forEach((key, value) {
    //     // ignore: avoid_print
    //     print("$key: $value");
    //   });
    // }
    return formInputs;
  }

  //  Some basic checks to ensure '/' is placed correctly
  void _setTargetUri(String? ext, {bool fromOrigin = false}) {
    ext ??= "/";
    if (ext.contains(_originUri)) {
      targetUri = ext;
    } else {
      //  Which base to use
      String uri = "";
      if (fromOrigin) {
        uri = _originUri;
      } else {
        uri = targetUri;
      }
      //
      if (uri[uri.length - 1] != '/' && ext[0] != '/') {
        uri += '/';
      } else if (uri[uri.length - 1] == '/' && ext[0] == '/') {
        uri = uri.substring(0, uri.length - 1);
      }
      uri += ext;
      targetUri = uri;
    }
  }
}
