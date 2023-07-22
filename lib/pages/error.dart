import 'package:flutter/material.dart';


class ErrorAlert extends StatefulWidget {
  
  ErrorAlert({Key? key}) : super(key: key);
  @override
  _ErrorAlertState createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 100,
        height: 100,
        child: Text(
          'Bagyşlan ýalñyşlyk ýüze çykdy täzeden synanşyp görün!'
        ),
      ),
      actions: <Widget>[

        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context,'Close');
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}
