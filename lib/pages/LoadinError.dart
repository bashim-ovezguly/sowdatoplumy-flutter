import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';

class LoadingErrorAlert extends StatefulWidget {
  LoadingErrorAlert({Key? key}) : super(key: key);
  @override
  _LoadingErrorAlertState createState() => _LoadingErrorAlertState();
}

class _LoadingErrorAlertState extends State<LoadingErrorAlert> {
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
                'Bagyşlan ýalñyşlyk ýüze çykdy täzeden synanşyp görüň!',
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
