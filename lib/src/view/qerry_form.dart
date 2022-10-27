import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:timetable/src/view/load_table.dart';
import 'package:timetable/src/model/form_options_item.dart';
import '../func/browser.dart';

class QuerryForm {
  final _formKey = GlobalKey<FormState>();

  final Map<String, List<FormOptionItem>> _options;

  final TimetableBrowser _tb;

  Map<String, String> formInputs = {};

  Map<String, String> formOptions = {};

  //  Base consturctor
  QuerryForm(this._options, this._tb);
  //  Actual constructor
  static Future<QuerryForm> create() async {
    TimetableBrowser tb = TimetableBrowser('https://timetable.ait.ie/');
    var options = await tb.getTableOptions();
    return QuerryForm(options, tb);
  }

  //  Try making async builder and include defaults

  Future<Form> querryForm(BuildContext context) async {
    Form f = Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        //  Item 1 - dlFilter2
        // const Padding(padding: EdgeInsets.all(8)),
        // const Text("dlFilter2"),
        // const Divider(),
        // Row(
        //   children: [
        //     Expanded(
        //       //  dlFilter2 dropdown  (Needs tweaking to accomodate or drop)
        //       child: DropdownSearch<FormOptionItem>(
        //         asyncItems: (String? filter) => _getOptionList('dlFilter2', filter),
        //         popupProps: PopupPropsMultiSelection.modalBottomSheet(
        //           showSelectedItems: true,
        //           itemBuilder: _tableOptionBuilder,
        //           showSearchBox: true,
        //         ),
        //         compareFn: (i, s) => i == s,
        //         dropdownDecoratorProps: DropDownDecoratorProps(
        //           dropdownSearchDecoration: InputDecoration(
        //             labelText: 'User *',
        //             filled: true,
        //             fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        //  Item 2 - dlOptions
        const Padding(padding: EdgeInsets.all(8)),
        const Text("dlObject"),
        const Divider(),
        Row(
          children: [
            Expanded(
              //  dlOptions dropdown (subject selection)
              child: DropdownSearch<FormOptionItem>(
                onSaved: (newValue) {
                  formInputs['dlObject'] = newValue!.id;
                  formOptions['title'] = newValue.trimName();
                },
                // asyncItems: (filter) => _getOptionList('dlObject', filter),
                asyncItems: (filter) => _getOptions('dlObject', filter),
                compareFn: (i, s) => i == s,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: ((value) {
                  if (value == null) return 'required Field';
                  return null;
                }),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  isFilterOnline: true,
                  showSelectedItems: true,
                  showSearchBox: true,
                  // itemBuilder: _tableOptionBuilder,
                  itemBuilder: (context, item, isSelected) => _tableOptionBuilder(context, item, isSelected, trimName: true),
                  favoriteItemProps: FavoriteItemProps(
                    showFavoriteItems: true,
                    favoriteItems: (us) {
                      return us.where((e) => e.name.contains("AL_KCLOU_8_4")).toList();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        //  Item 3 - lbWeeks
        const Padding(padding: EdgeInsets.all(8)),
        const Text("lbWeeks"),
        const Divider(),
        Row(
          children: [
            Expanded(
              //  lbWeeks dropdown
              child: DropdownSearch<FormOptionItem>(
                onSaved: (newValue) => formInputs['lbWeeks'] = newValue!.id,
                asyncItems: (String? filter) => _getOptions('lbWeeks', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                  showSearchBox: true,
                ),
                compareFn: (i, s) => i == s,
                selectedItem: (await _getOptions('lbWeeks', null)).first,
              ),
            )
          ],
        ),
        //  Item 4 - lbDays
        const Padding(padding: EdgeInsets.all(8)),
        const Text("lbDays"),
        const Divider(),
        Row(
          children: [
            Expanded(
              //  lbDays dropdown
              child: DropdownSearch<FormOptionItem>(
                onSaved: (newValue) => formInputs['lbDays'] = newValue!.id,
                asyncItems: (String? filter) => _getOptions('lbDays', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                ),
                compareFn: (i, s) => i == s,
                selectedItem: (await _getOptions('lbDays', null)).first,
              ),
            )
          ],
        ),
        //  Item 5 - dlPeriod
        const Padding(padding: EdgeInsets.all(8)),
        const Text("dlPeriod"),
        const Divider(),
        Row(
          children: [
            Expanded(
              //  dlPeriod dropdown
              child: DropdownSearch<FormOptionItem>(
                onSaved: (newValue) {
                  formInputs['dlPeriod'] = newValue!.id;
                  formOptions['period'] = newValue.id;
                },
                asyncItems: (String? filter) => _getOptions('dlPeriod', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                ),
                compareFn: (i, s) => i == s,
                selectedItem: (await _getOptions('dlPeriod', null)).first,
              ),
            )
          ],
        ),
        //  Item 6 - Submit
        const Padding(padding: EdgeInsets.all(8)),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ShowTable(_tb.querryTimetable(formInputs), formOptions);
                  },
                ));
              }
            },
            child: const Text('Submit'),
          ),
        )
      ]),
    );

    return f;
  }

  //  Options layout
  Widget _tableOptionBuilder(
    BuildContext context,
    FormOptionItem item,
    bool isSelected, {
    bool trimName = false,
  }) {
    String name = item.name;
    if (trimName) name = item.trimName();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      //  This specifies the apperence of selected item
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      //  This specifies the apperance of each item
      child: ListTile(
        selected: isSelected,
        title: Text(name),
        subtitle: Text(item.id),
      ),
    );
  }

  Future<List<FormOptionItem>> _getOptions(String target, String? filter) async {
    // _options ??= await _getAllOptions();
    List<FormOptionItem> itemList = _options[target]!;
    if (filter != null && filter.isNotEmpty) {
      return itemList.where((element) => element.name.toLowerCase().contains(filter.toLowerCase())).toList();
    }
    return itemList;
  }
}
