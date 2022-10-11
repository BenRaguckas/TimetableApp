import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:timetable/user_model.dart';
import 'browser.dart';

const List<String> list = ['1', '2', '3', '4'];

void main() {
  runApp(const TimetableApp());
}

class TimetableApp extends StatefulWidget {
  const TimetableApp({Key? key}) : super(key: key);

  @override
  State<TimetableApp> createState() => _TimetableAppState();
}

class _TimetableAppState extends State<TimetableApp> {
  final _formKey = GlobalKey<FormState>();

  TimetableBrowser tb = TimetableBrowser('https://timetable.ait.ie/');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("TimetableApp"),
      ),
      body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
            //  Item 1 - dlOptions
            const Padding(padding: EdgeInsets.all(8)),
            const Text("dlOptions"),
            const Divider(),
            Row(
              children: const [
                Expanded(
                  //  dlOptions dropdown
                  child: Text('selection'),
                )
              ],
            ),
            //  Item 2 - dlFilter2
            const Padding(padding: EdgeInsets.all(8)),
            const Text("dlFilter2"),
            const Divider(),
            Row(
              children: const [
                Expanded(
                  //  dlOptions dropdown
                  child: Text('selection'),
                )
              ],
            ),
            //  Item 3 - lbWeeks
            const Padding(padding: EdgeInsets.all(8)),
            const Text("lbWeeks"),
            const Divider(),
            Row(
              children: const [
                Expanded(
                  //  dlOptions dropdown
                  child: Text('selection'),
                )
              ],
            ),
            //  Item 4 - lbDays
            const Padding(padding: EdgeInsets.all(8)),
            const Text("lbDays"),
            const Divider(),
            Row(
              children: const [
                Expanded(
                  //  dlOptions dropdown
                  child: Text('selection'),
                )
              ],
            ),
            //  Item 5 - lbDays
            const Padding(padding: EdgeInsets.all(8)),
            const Text("dlPeriod"),
            const Divider(),
            Row(
              children: const [
                Expanded(
                  //  dlOptions dropdown
                  child: Text('selection'),
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
          ])),
      //  T

      //  T

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     if (await tb.testMethod())
      //       print('success');
      //     else
      //       print('fail');
      //   },
      // ),

      //  Item with favorites
      // body: Center(
      //   child: DropdownSearch<UserModel>(
      //     asyncItems: (filter) => getData(filter),
      //     compareFn: (i, s) => i.isEqual(s),
      //     popupProps: PopupPropsMultiSelection.modalBottomSheet(
      //       isFilterOnline: true,
      //       showSelectedItems: true,
      //       showSearchBox: true,
      //       itemBuilder: _customPopupItemBuilderExample2,
      //       favoriteItemProps: FavoriteItemProps(
      //         showFavoriteItems: true,
      //         favoriteItems: (us) {
      //           return us.where((e) => e.name.contains("Mrs")).toList();
      //         },
      //       ),
      //     ),
      //   ),
      // ),
      //  Item without favorites
      // body: Center(
      //   child: DropdownSearch<UserModel>(
      //     asyncItems: (String? filter) => getData(filter),
      //     popupProps: PopupPropsMultiSelection.modalBottomSheet(
      //       showSelectedItems: true,
      //       itemBuilder: _customPopupItemBuilderExample2,
      //       showSearchBox: true,
      //     ),
      //     compareFn: (item, sItem) => item.id == sItem.id,
      //     dropdownDecoratorProps: DropDownDecoratorProps(
      //       dropdownSearchDecoration: InputDecoration(
      //         labelText: 'User *',
      //         filled: true,
      //         fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      //       ),
      //     ),
      //   ),
      // ),
      //  end
      //  WORKS
      // body: Center(
      //   child: DropdownSearch<TableOptionsItem>(
      //     asyncItems: (filter) => getOptionList('dlObject', filter),
      //     compareFn: (i, s) => i == s,
      //     popupProps: PopupPropsMultiSelection.modalBottomSheet(
      //       isFilterOnline: true,
      //       showSelectedItems: true,
      //       showSearchBox: true,
      //       itemBuilder: _tableOptionBuilder,
      //       favoriteItemProps: FavoriteItemProps(
      //         showFavoriteItems: true,
      //         favoriteItems: (us) {
      //           return us.where((e) => e.name.contains("AL_KCLOU_8_4")).toList();
      //         },
      //       ),
      //     ),
      //   ),
      // ),
    ));
  }

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

  //  BUILDER
  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
        subtitle: Text(item?.createdAt?.toString() ?? ''),
        leading: const CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }

  Future<List<TableOptionsItem>> getOptionList(String target, String filter) async {
    Map<String, List<TableOptionsItem>> options = await tb.getTableOptions();
    if (options[target] != null) {
      List<TableOptionsItem> item = options[target]!;
      if (filter.isNotEmpty) {
        return item.where((element) => element.name.toLowerCase().contains(filter)).toList();
      }
      return item;
    }
    return [];
  }

  // GET
  Future<List<UserModel>> getData(filter) async {
    var response = await Dio().get(
      "https://5d85ccfb1e61af001471bf60.mockapi.io/user",
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }
}
