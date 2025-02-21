// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';

import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

class DeleteImage extends StatefulWidget {
  final String action;
  var image;
  final Function callbackFunc;

  DeleteImage(
      {Key? key,
      required this.action,
      required this.image,
      required this.callbackFunc})
      : super(key: key);
  @override
  _DeleteImageState createState() => _DeleteImageState(
      action: action, image: image, callbackFunc: callbackFunc);
}

class _DeleteImageState extends State<DeleteImage> {
  bool canUpload = false;
  final String action;
  var image;
  final Function callbackFunc;

  _DeleteImageState(
      {required this.action, required this.image, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text(
            'Suraty pozmak isleýäňizmi?',
            style: TextStyle(color: CustomColors.appColor, fontSize: 17),
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
          alignment: Alignment.center,
          width: 70,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Goý bolsun'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  String url = serverIp +
                      action +
                      "/img/delete/" +
                      image['id'].toString();
                  final uri = Uri.parse(url);
                  var request = new http.MultipartRequest("POST", uri);

                  Map<String, String> headers = {};
                  for (var i in global_headers.entries) {
                    headers[i.key] = i.value.toString();
                  }
                  headers['token'] = await get_access_token();
                  request.headers.addAll(headers);
                  final response = await request.send();

                  if (response.statusCode == 200) {
                    if (action == 'lenta') {
                      callbackFunc();
                    } else {
                      callbackFunc(image);
                    }
                    Navigator.pop(context, 'Cancel');
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ErrorAlert()));
                  }
                },
                child: const Text('Hawa'),
              ),
            ],
          )),
    );
  }
}

class ErrorAlert extends StatefulWidget {
  ErrorAlert({Key? key}) : super(key: key);
  @override
  _ErrorAlertState createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      content: Container(
        width: 200,
        height: 250,
        child: Text('Bagyşlan ýalňyşlyk ýüze çykdy täzeden synanşyp görüň!'),
      ),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, 'Close');
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}
