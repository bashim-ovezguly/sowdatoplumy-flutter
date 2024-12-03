import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';

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
          width: 80,
          height: 180,
          child: Column(
            children: [
              Center(child: Icon(Icons.warning, size: 130, color: Colors.red)),
              Text(
                'Bagyşlan ýalñyşlyk ýüze çykdy täzeden synanşyp görün!',
                textAlign: TextAlign.center,
              ),
            ],
          )),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColor,
                foregroundColor: Colors.white),
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
