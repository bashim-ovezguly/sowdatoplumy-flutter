import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';

class MyDropdownButtonEdit extends StatefulWidget {
  final List<dynamic> items;
  final Function callbackFunc;
  final String text;

  MyDropdownButtonEdit(
      {required this.items, required this.callbackFunc, required this.text});
  @override
  _MyDropdownButtonEditState createState() =>
      _MyDropdownButtonEditState(callbackFunc: callbackFunc, text: text);
}

class _MyDropdownButtonEditState extends State<MyDropdownButtonEdit> {
  String? selectedItem;
  final Function callbackFunc;
  String text;

  _MyDropdownButtonEditState({required this.callbackFunc, required this.text});
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: CustomColors.appColorWhite,
      isExpanded: true,
      alignment: Alignment.center,
      elevation: 16,
      value: selectedItem,
      underline: const SizedBox(),
      onChanged: (dynamic newValue) {
        setState(() {
          selectedItem = newValue.toString();
          for (var i in widget.items) {
            if (i['id'].toString() == newValue) {
              callbackFunc(i);
            }
          }
        });
      },
      items: widget.items.map((value) {
        return DropdownMenuItem<String>(
            value: value['id'].toString(),
            child: FittedBox(
              fit: BoxFit.contain,
              child: value['name'] != null
                  ? Text(
                      value['name'].toString(),
                      style: const TextStyle(
                          fontSize: 17, color: CustomColors.appColor),
                    )
                  : Text(
                      value['name_tm'].toString(),
                      style: const TextStyle(
                          fontSize: 17, color: CustomColors.appColor),
                    ),
            ));
      }).toList(),
    );
  }
}
