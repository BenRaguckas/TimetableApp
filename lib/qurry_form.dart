import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'browser.dart';

class QuerryForm {
  final _formKey = GlobalKey<FormState>();
  final TimetableBrowser tb = TimetableBrowser('https://timetable.ait.ie/');

  late Map<String, List<TableOptionsItem>> _options;

  QuerryForm() {
    _updateOptions();
  }

  //  Try making async builder and include defaults

  Future<Form> querryForm(BuildContext context) async {
    Form f = Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        //  Item 1 - dlOptions
        const Padding(padding: EdgeInsets.all(8)),
        const Text("dlOptions"),
        const Divider(),
        Row(
          children: [
            Expanded(
              //  dlOptions dropdown (subject selection)
              child: DropdownSearch<TableOptionsItem>(
                // asyncItems: (filter) => _getOptionList('dlObject', filter),
                asyncItems: (filter) => _getOptions('dlObject', filter),
                compareFn: (i, s) => i == s,
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  isFilterOnline: true,
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: _tableOptionBuilder,
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
        //  Item 2 - dlFilter2
        const Padding(padding: EdgeInsets.all(8)),
        const Text("dlFilter2"),
        const Divider(),
        Row(
          children: [
            Expanded(
              //  dlFilter2 dropdown  (Needs tweaking to accomodate or drop)
              child: DropdownSearch<TableOptionsItem>(
                asyncItems: (String? filter) => _getOptionList('dlFilter2', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                  showSearchBox: true,
                ),
                compareFn: (i, s) => i == s,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'User *',
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
              child: DropdownSearch<TableOptionsItem>(
                asyncItems: (String? filter) => _getOptionList('lbWeeks', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                  showSearchBox: true,
                ),
                compareFn: (i, s) => i == s,
                selectedItem: (await _getOptions('lbWeeks', null)).first,
                // dropdownDecoratorProps: DropDownDecoratorProps(
                //   dropdownSearchDecoration: InputDecoration(
                //     labelText: 'User *',
                //     filled: true,
                //     fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                //   ),
                // ),
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
              child: DropdownSearch<TableOptionsItem>(
                asyncItems: (String? filter) => _getOptionList('lbDays', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                  showSearchBox: true,
                ),
                compareFn: (i, s) => i == s,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'User *',
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
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
              child: DropdownSearch<TableOptionsItem>(
                asyncItems: (String? filter) => _getOptionList('dlPeriod', filter),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  itemBuilder: _tableOptionBuilder,
                  showSearchBox: true,
                ),
                compareFn: (i, s) => i == s,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'User *',
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
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
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
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
    TableOptionsItem item,
    bool isSelected,
  ) {
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
        title: Text(item.name),
        subtitle: Text(item.id),
      ),
    );
  }

  //  options retriver
  Future<List<TableOptionsItem>> _getOptionList(String target, String? filter) async {
    Map<String, List<TableOptionsItem>> options = await tb.getTableOptions();
    if (options[target] != null) {
      List<TableOptionsItem> item = options[target]!;
      if (filter != null && filter.isNotEmpty) {
        return item.where((element) => element.name.toLowerCase().contains(filter)).toList();
      }
      return item;
    }
    return [];
  }

  // Future<Map<String, List<TableOptionsItem>>> _getAllOptions() async {
  //   return tb.getTableOptions();
  // }

  void _updateOptions() async {
    _options = await tb.getTableOptions();
  }

  Future<List<TableOptionsItem>> _getOptions(String target, String? filter) async {
    // _options ??= await _getAllOptions();
    List<TableOptionsItem> itemList = _options[target]!;
    if (filter != null && filter.isNotEmpty) {
      return itemList.where((element) => element.name.toLowerCase().contains(filter.toLowerCase())).toList();
    }
    return itemList;
  }
}
