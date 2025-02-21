// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';

class SortDialog extends StatefulWidget {
  SortDialog({Key? key, required this.sort_value, required this.callbackFunc})
      : super(key: key);
  String sort_value;
  final Function callbackFunc;
  @override
  _SortDialogState createState() =>
      _SortDialogState(sort_value: sort_value, callbackFunc: callbackFunc);
}

class _SortDialogState extends State<SortDialog> {
  final Function callbackFunc;
  String sort_value;
  bool canUpload = false;
  int _value = 1;

  void initState() {
    super.initState();
  }

  _SortDialogState({required this.sort_value, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text(
            'Tertibi',
            style: TextStyle(color: CustomColors.appColor),
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
          width: 200,
          height: 250,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                      splashRadius: 20.0,
                      activeColor: CustomColors.appColor,
                      value: 1,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 1;
                      });
                    },
                    child: Text("Hiç hili"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      splashRadius: 20.0,
                      activeColor: CustomColors.appColor,
                      value: 2,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 2;
                      });
                    },
                    child: Text("Arzandan gymmada"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      activeColor: CustomColors.appColor,
                      value: 3,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 3;
                      });
                    },
                    child: Text("Gymmatdan arzana"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      activeColor: CustomColors.appColor,
                      value: 4,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 4;
                      });
                    },
                    child: Text("Köneden täzä"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      activeColor: CustomColors.appColor,
                      value: 5,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 5;
                      });
                    },
                    child: Text("Täzeden könä"),
                  )
                ],
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
              callbackFunc();
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Tertiple'),
          ),
        )
      ],
    );
  }
}
