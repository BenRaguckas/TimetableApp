import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:timetable/user_model.dart';
import 'browser.dart';

const List<String> list = ['1', '2', '3', '4'];

final _userEditTextController = TextEditingController(text: 'Mrs');

void main() {
  runApp(const TimetableApp());
}

class TimetableApp extends StatefulWidget {
  const TimetableApp({Key? key}) : super(key: key);

  @override
  State<TimetableApp> createState() => _TimetableAppState();
}

class _TimetableAppState extends State<TimetableApp> {
  TimetableBrowser tb = TimetableBrowser('https://timetable.ait.ie/');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("TimetableApp"),
      ),
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
      body: Center(
        child: DropdownSearch<TableOptionsItem>(
          asyncItems: (filter) => getOptionList('dlObject', filter),
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
      ),
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
      margin: EdgeInsets.symmetric(horizontal: 8),
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
        leading: CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }

  Future<List<TableOptionsItem>> getOptionList(String target, filter) async {
    Map<String, List<TableOptionsItem>> options = await tb.getTableOptions();
    if (options[target] != null) {
      return options[target]!;
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
