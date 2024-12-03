import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shadowColor: CustomColors.appColorWhite,
    surfaceTintColor: CustomColors.appColorWhite,
    backgroundColor: CustomColors.appColorWhite,
    content: new Row(
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
