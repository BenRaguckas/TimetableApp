import 'package:html/dom.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:timetable/subject.dart';
import 'package:timetable/timetable.dart';

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
  Future<http.Response> _postRequest(String uri, {Map<String, String>? body, String? cookies}) async {
    http.Response response;
    if (cookies != null && body != null) {
      response = await _client.post(Uri.parse(uri), body: body, headers: {'cookie': cookies});
    } else if (body != null) {
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

  Future<Map<String, String>> _getDefaultPage(String uri, String cookies) async {
    var response = await _getRequest(uri, cookies: cookies);
    Map<String, String> formInputs = _getFormInputs(response);
    //  HARDCODED to specify what link to click
    formInputs['__EVENTTARGET'] = 'LinkBtn_StudentSetByName';
    return formInputs;
  }

  Future<Map<String, Map<String, String>>> _getTableOptions(String uri, Map<String, String> body, String cookies) async {
    var response = await _postRequest(uri, body: body, cookies: cookies);
    var doc = html.parse(response.body);
    Map<String, Map<String, String>> options = {};
    //  Gather dlObject (used to get subject code);
    options['dlObject'] = _getSelectOptions(doc, 'dlObject');
    //  Gather dlFilter2 options (to filter by department)
    options['dlFilter2'] = _getSelectOptions(doc, 'dlFilter2');
    //  Gather lbWeeks (target weeks)
    options['lbWeeks'] = _getSelectOptions(doc, 'lbWeeks');
    //  Gather lbDays (dunno)
    options['lbDays'] = _getSelectOptions(doc, 'lbDays');
    //  Gather dlPeriod
    options['dlPeriod'] = _getSelectOptions(doc, 'dlPeriod');

    //  Get form inputs
    Map<String, String> test = _getFormInputs(response, submitId: 'bGetTimetable');
    options['extra'] = test;

    return options;
  }

  Future<bool> testMethod() async {
    String baseUri = await _getBaseUrl();
    Map<String, String> loginBody = await _getLoginForm(baseUri + loginUri);
    String cookies = await _postLoginForm(baseUri + loginUri, loginBody);
    Map<String, String> defaultBody = await _getDefaultPage(baseUri + defaultUri, cookies);

    // var response = await _postRequest(baseUri + defaultUri, body: defaultBody, cookies: cookies);
    var item = await _getTableOptions(baseUri + defaultUri, defaultBody, cookies);

    //  TEST
    Map<String, String> submitBody = item['extra']!;
    item.forEach((key, value) {
      if (key != 'extra') {
        submitBody[key] = value.keys.first;
      }
    });
    submitBody['RadioType'] = 'TextSpreadsheet;swsurl;student+set+textspreadsheet';
    submitBody.forEach((key, value) {
      print("$key: ${value.substring(0, math.min(value.length, 50))}");
    });

    //  submit for timetable
    var response = await _postRequest(baseUri + defaultUri, body: submitBody, cookies: cookies);
    print(response.headers['content-length']);

    //  get for timetable
    var timetableresponse = await _getRequest(baseUri + showUri, cookies: cookies);
    print(timetableresponse.headers['content-length']);

    _parseTable(timetableresponse);
    // print(timetableresponse.body);
    return true;
  }

  //  PLACEHOLDER
  void _parseTable(http.Response response) {
    var doc = html.parse(response.body);
    List<List<Subject>> allSubjects = [];
    String title = '';
    //  Catch every Body > table element (root elements to avoid table nestingness present)
    doc.getElementsByTagName('body > table').asMap().forEach((key, value) {
      //  Catch first table (heading)
      if (key == 0) {
        title = value.text.split(' ').first;
        // print(value.text.trim());
      } //  All the following tables with borders (should only be weekdays)
      else if (value.attributes['border'] == '1') {
        List<Subject> subjects = [];
        //  Iterate through consecutive table_rows
        value.getElementsByTagName('tr').asMap().forEach((key, value) {
          //  Skip headers
          if (key != 0) {
            List<String> inputs = [];
            value.getElementsByTagName('td').forEach((element) {
              inputs.add(element.text);
            });
            subjects.add(Subject.fromList(inputs));
          }
        });
        subjects.sort();
        allSubjects.add(subjects);
      }
    });
    TimeTable tb = TimeTable(title, allSubjects);

    print(tb);
  }

  //  Maps options of given element by ID
  Map<String, String> _getSelectOptions(Document doc, String elID) {
    Map<String, String> optionsMap = {};
    doc.getElementById(elID)?.getElementsByTagName('option').forEach((element) {
      optionsMap[element.attributes['value'].toString()] = element.text;
    });
    return optionsMap;
  }

  //  Gets form inputs
  Map<String, String> _getFormInputs(http.Response response, {String submitId = ''}) {
    var doc = html.parse(response.body);
    var formInputs = <String, String>{};
    doc.getElementsByTagName('input').forEach((element) {
      //  Check if a value exists (null / empty)
      if (element.attributes['value'] != null && element.attributes['value']!.isNotEmpty) {
        //  Check if it is submit input
        if (element.attributes['type'].toString() == 'hidden') {
          formInputs[element.attributes['id'].toString()] = element.attributes['value']!;
        } else if (element.attributes['id'].toString() == submitId) {
          formInputs[element.attributes['id'].toString()] = element.attributes['value']!;
        }
      }
    });
    return formInputs;
  }
}
