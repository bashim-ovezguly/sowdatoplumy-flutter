import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Customer/login.dart';

import '../../dB/constants.dart';

class DeleteAlert extends StatefulWidget {
  DeleteAlert(
      {Key? key,
      required this.action,
      required this.id,
      required this.callbackFunc})
      : super(key: key);
  final String action;
  final String id;
  final Function callbackFunc;
  @override
  State<DeleteAlert> createState() =>
      _DeleteAlertState(action: action, id: id, callbackFunc: callbackFunc);
}

class _DeleteAlertState extends State<DeleteAlert> {
  bool isChecked = false;
  final String action;
  final String id;
  final Function callbackFunc;

  void initState() {
    super.initState();
  }

  _DeleteAlertState(
      {required this.action, required this.id, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            'Bozmaga ynamyňyz barmy?',
            style: TextStyle(color: CustomColors.appColor, fontSize: 15),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
          )
        ],
      ),
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Ýok'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Align(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  String url = serverIp +
                      '/mob/' +
                      action.toString() +
                      "/delete/" +
                      id.toString();
                  if (action == 'lenta') {
                    url = serverIp +
                        '/mob/' +
                        action.toString() +
                        "/" +
                        id.toString() +
                        "/delete";
                  }
                  final uri = Uri.parse(url);
                  Map<String, String> headers = {};
                  for (var i in global_headers.entries) {
                    headers[i.key] = i.value.toString();
                  }
                  headers['token'] = await get_access_token();
                  final response = await http.post(uri, headers: headers);
                  if (response.statusCode == 200) {
                    callbackFunc();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  if (response.statusCode != 200) {
                    if (response == false) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }
                  }
                },
                child: const Text('Hawa'),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[],
    );
  }
}

class DeletePhoneAlert extends StatefulWidget {
  DeletePhoneAlert({Key? key, required this.id, required this.callbackFunc})
      : super(key: key);
  final String id;
  final Function callbackFunc;
  @override
  State<DeletePhoneAlert> createState() =>
      _DeletePhoneAlertState(id: id, callbackFunc: callbackFunc);
}

class _DeletePhoneAlertState extends State<DeletePhoneAlert> {
  bool isChecked = false;

  final String id;
  final Function callbackFunc;

  void initState() {
    super.initState();
  }

  _DeletePhoneAlertState({required this.id, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text(
            'Pozmaga ynamyñyz barmy?',
            style: TextStyle(color: CustomColors.appColor, fontSize: 15),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
          )
        ],
      ),
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Goý bolsun'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Align(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  Urls server_url = new Urls();
                  String url = server_url.get_server_url() +
                      '/mob/stores/contact/delete/' +
                      id.toString();
                  final uri = Uri.parse(url);

                  Map<String, String> headers = {};
                  for (var i in global_headers.entries) {
                    headers[i.key] = i.value.toString();
                  }
                  headers['token'] = await get_access_token();
                  final response = await http.post(
                    uri,
                    headers: headers,
                  );

                  if (response.statusCode == 200) {
                    callbackFunc();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Bozmak'),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[],
    );
  }
}
