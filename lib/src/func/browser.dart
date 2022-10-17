import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:timetable/src/model/subject.dart';
import 'package:timetable/src/model/timetable.dart';
import 'package:timetable/src/model/form_options_item.dart';

class TimetableBrowser {
  //  HTTP client
  final _client = http.Client();
  //  Uri used as a starting point (timetable.ait.ie)
  final String _originUri;
  //  Uri extensions (set as default)
  final String loginUri, defaultUri, showUri;

  //  baseUri
  late String _baseUri;

  //  Objects used for
  Map<String, List<FormOptionItem>>? _tableOptions;
  late Map<String, String> _postBody;
  late String _cookies;
  int _cookiesTime = 0;

  //  Constructor
  TimetableBrowser(this._originUri, {this.loginUri = 'login.aspx', this.defaultUri = 'default.aspx', this.showUri = 'showtimetable.aspx'});

  //  Get method for _tableOptions (querries if unavailable)
  Future<Map<String, List<FormOptionItem>>> getTableOptions() async {
    if (_tableOptions != null && _cookiesTime + 600000 > DateTime.now().millisecondsSinceEpoch) {
      return _tableOptions!;
    } else {
      await _updateTableOptions();
      return _tableOptions!;
    }
  }

  Future<TimeTable> querryTimetable(Map<String, String> params) async {
    //  Make copy of _postBody
    Map<String, String> querryBody = Map.from(_postBody);
    //  Add params provided (dlOptions, dlDays, etc.)
    querryBody.addAll(params);
    querryBody['RadioType'] = 'TextSpreadsheet;swsurl;student+set+textspreadsheet';
    //  Send post request
    var response = await _postRequest(_baseUri + defaultUri, body: querryBody, cookies: _cookies);
    //  Should capture some testing for valid response
    var timetableresponse = await _getRequest(_baseUri + showUri, cookies: _cookies);
    return _parseTable(timetableresponse);
  }

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

  Future<Map<String, List<FormOptionItem>>> _getTableOptions(String uri, Map<String, String> body, String cookies) async {
    var response = await _postRequest(uri, body: body, cookies: cookies);
    var doc = html.parse(response.body);
    Map<String, List<FormOptionItem>> options = {};
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

    //  Save form inputs
    _postBody = _getFormInputs(response, submitId: 'bGetTimetable');

    return options;
  }

  Future<bool> _updateTableOptions() async {
    //  Get baseUri (redirect from origin url)
    _baseUri = await _getBaseUrl();

    //  get login body
    _postBody = await _getLoginForm(_baseUri + loginUri);

    //  Get cookies using _postBody
    _cookies = await _postLoginForm(_baseUri + loginUri, _postBody);
    //  Save timestamp
    _cookiesTime = DateTime.now().millisecondsSinceEpoch;

    //  Get default page (redudant page that redirects to table selection)
    _postBody = await _getDefaultPage(_baseUri + defaultUri, _cookies);

    //  Get _tableOptions
    _tableOptions = await _getTableOptions(_baseUri + defaultUri, _postBody, _cookies);
    //  ! Table options updates _postBody

    return true;
  }

  //  PLACEHOLDER
  TimeTable _parseTable(http.Response response) {
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
    return tb;
  }

  //  Maps options of given element by ID
  List<FormOptionItem> _getSelectOptions(Document doc, String elID) {
    List<FormOptionItem> optionsMap = [];
    doc.getElementById(elID)?.getElementsByTagName('option').forEach((element) {
      optionsMap.add(FormOptionItem(element.attributes['value'].toString(), element.text)); //[element.attributes['value'].toString()] = element.text;
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
