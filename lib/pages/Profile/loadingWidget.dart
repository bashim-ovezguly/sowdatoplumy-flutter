import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    content: new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: CustomColors.appColor,
        ),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Garaşyň...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
