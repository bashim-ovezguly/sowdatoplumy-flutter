import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TCSelectorDialog extends StatefulWidget {
  Function callbackFunc;

  TCSelectorDialog({super.key, required this.callbackFunc});

  @override
  State<TCSelectorDialog> createState() =>
      TCSelectorDialogState(callbackFunc: this.callbackFunc);
}

class TCSelectorDialogState extends State<TCSelectorDialog> {
  bool status = false;
  bool is_loading = false;
  List<dynamic> tc_list = [];
  Function callbackFunc;

  void initState() {
    super.initState();
    this.getData();
  }

  getData() async {
    var response = await http.get(Uri.parse(serverIp + '/index/store'));
    var decodedData = jsonDecode(utf8.decode(response.bodyBytes));
    this.setState(() {
      this.tc_list = decodedData['trade_centers'];
    });
  }

  TCSelectorDialogState({required this.callbackFunc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Söwda merkez saýlaň",
        style: TextStyle(color: Colors.blue),
      ),
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: Colors.white,
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.appColorWhite,
        child: ListView(
          children: [
            Column(
              children: this
                  .tc_list
                  .map((e) => MaterialButton(
                        padding: EdgeInsets.all(5),
                        minWidth: double.maxFinite,
                        elevation: 0,
                        onPressed: () {
                          final tc = {'id': e['id'], 'name': e['name']};
                          this.callbackFunc(tc);
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e['name'],
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
