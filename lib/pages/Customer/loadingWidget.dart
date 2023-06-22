import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
  
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            backgroundColor: CustomColors.appColors,
          ),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Garaşyň..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
