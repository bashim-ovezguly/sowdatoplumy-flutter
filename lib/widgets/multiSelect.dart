import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';

// ignore: must_be_immutable
class CategorySelect extends StatefulWidget {
  List<dynamic> categories = [];
  final Function callbackFunc;
  CategorySelect(
      {super.key, required this.categories, required this.callbackFunc});
  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  int id = 0;
  bool status = false;
  List<dynamic> _categories = [];

  void initState() {
    setState(() {
      for (var item in widget.categories) {
        var ss = item;
        ss['status'] = false;
        _categories.add(ss);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.appColorWhite,
        child: ListView(
          children: [
            for (var item in _categories)
              if (item['name_tm'] != '')
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item['sub_categories'].length > 0)
                        GestureDetector(
                          onTap: () {
                            for (var item1 in _categories) {
                              if (item1['id'] != item['id']) {
                                setState(() {
                                  item1['status'] = false;
                                });
                              } else {
                                setState(() {
                                  item1['status'] = !item1['status'];
                                });
                              }
                            }
                          },
                          child: !item['status']
                              ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: CustomColors.appColors,
                                    ),
                                    Text(
                                      item['name_tm'],
                                      style: TextStyle(
                                          color: CustomColors.appColors,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.keyboard_arrow_up,
                                          color: CustomColors.appColors,
                                        ),
                                        Text(
                                          item['name_tm'],
                                          style: TextStyle(
                                              color: CustomColors.appColors,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    for (var category_item in item['sub_categories'])
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.callbackFunc(category_item);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "         - " + category_item['name_tm'],
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                        )
                      else
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              widget.callbackFunc(item);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "      " + item['name_tm'],
                                  style: TextStyle(
                                      color: CustomColors.appColors,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                )
          ],
        ),
      ),
    );
  }
}
