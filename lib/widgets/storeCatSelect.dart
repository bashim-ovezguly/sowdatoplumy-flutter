import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class StoreCategoryDialog extends StatefulWidget {
  Function callbackFunc;

  StoreCategoryDialog({super.key, required this.callbackFunc});

  @override
  State<StoreCategoryDialog> createState() =>
      StoreCategoryDialogState(callbackFunc: this.callbackFunc);
}

class StoreCategoryDialogState extends State<StoreCategoryDialog> {
  bool status = false;
  bool is_loading = false;
  List<dynamic> categories = [];
  Function callbackFunc;

  void initState() {
    super.initState();
    this.getData();
  }

  getData() async {
    var response = await http.get(Uri.parse(serverIp + '/mob/index/store'));
    var decodedData = jsonDecode(utf8.decode(response.bodyBytes));
    this.setState(() {
      this.categories = decodedData['categories'];
    });
  }

  StoreCategoryDialogState({required this.callbackFunc});

  // StoreCategoryDialog({});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Kategoriýa saýlaň"),
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.appColorWhite,
        child: ListView(
          children: [
            Column(
              children: this
                  .categories
                  .map((e) => MaterialButton(
                        padding: EdgeInsets.all(10),
                        minWidth: double.maxFinite,
                        elevation: 0,
                        onPressed: () {
                          final category = {
                            'id': e['id'],
                            'name': e['name_tm']
                          };
                          this.callbackFunc(category);
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e['name_tm'],
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
