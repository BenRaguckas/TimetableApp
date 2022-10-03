import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class TimetableBrowser {
  final _client = http.Client();
  final String _originUri;

  final String loginUri, defaultUri, showUri;

  //  Constructor
  TimetableBrowser(this._originUri, {this.loginUri = 'login.aspx', this.defaultUri = 'default.aspx', this.showUri = 'showtimetable.aspx'});

  //  First request used to retrieve the base URI used for timetable
  Future<String> _getBaseUrl() async {
    // var response = await _client.get(Uri.parse(_originUri));
    var response = await _getRequest(_originUri);
    var doc = html.parse(response.body);
    String content = doc.getElementsByTagName('meta').first.attributes['content'].toString();
    var re = RegExp("'(.*?)'"); //  Isolate element in single quotes
    String uri = re.firstMatch(content)!.group(1).toString();
    if (uri[uri.length - 1] != '/') uri += '/';
    return uri;
  }

  //  Base method for getRequest that captures 200 response code
  Future<http.Response> _getRequest(String uri, {String? cookies}) async {
    http.Response response;
    if (cookies == null) {
      response = await _client.get(Uri.parse(uri));
    } else {
      response = await _client.get(Uri.parse(uri), headers: {'cookie': cookies});
    }
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Get request for '$uri' had status code NOT 200.");
    }
  }

  //  Base method for postRequest without return capture
  Future<http.Response> _postRequest(String uri, {Map<String, String>? body}) async {
    http.Response response;
    if (body != null) {
      response = await _client.post(Uri.parse(uri), body: body);
    } else {
      response = await _client.post(Uri.parse(uri));
    }
    return response;
  }

  //  Method for getting login form details utilizing loginUri
  Future<Map<String, String>> _getLoginForm(String uri) async {
    var response = await _getRequest(uri);
    return _getFormInputs(response, submitId: 'bGuestLogin');
  }

  //  Method for posting login form to get Cookies utilizing loginUri
  Future<String> _postLoginForm(String uri, Map<String, String> body) async {
    var response = await _postRequest(uri, body: body);
    if (response.statusCode == 302) {
      return response.headers['set-cookie']!.replaceAll('path=/;', '').replaceAll('HttpOnly', '').replaceAll(',', '');
    } else {
      throw Exception("Redirect did not occur for POST to '$uri'");
    }
  }

  Future<http.Response> _getDefaultPage(String uri, String cookies) async {
    var response = await _getRequest(uri, cookies: cookies);
    return response;
  }

  Future<bool> testMethod() async {
    String baseUri = await _getBaseUrl();
    Map<String, String> body = await _getLoginForm(baseUri + loginUri);
    String cookies = await _postLoginForm(baseUri + loginUri, body);
    var response = await _getDefaultPage(baseUri + defaultUri, cookies);
    //  student_timetable step from postman next!
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
    return formInputs;
  }
}
