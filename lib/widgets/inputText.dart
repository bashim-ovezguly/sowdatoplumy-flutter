import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/pages/select.dart';

class InputText extends StatefulWidget {
  final String title;
  final double height;
  final Function callFunc;
  final String oldData;
  InputText(
      {Key? key,
      required this.title,
      required this.height,
      required this.callFunc,
      this.oldData = ''})
      : super(key: key);
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final _inputValue = TextEditingController();

  void initState() {
    if (widget.oldData != '') {
      _inputValue.text = widget.oldData;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          width: double.infinity,
          height: widget.height,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.appColors, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle),
          child: Container(
              margin: EdgeInsets.only(left: 15),
              child: TextFormField(
                  onChanged: (text) {
                    widget.callFunc(text);
                  },
                  controller: _inputValue,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  }))),
      Positioned(
          left: 25,
          top: 12,
          child: Container(
              color: Colors.white,
              child: Text(widget.title,
                  style: TextStyle(color: Colors.black, fontSize: 12))))
    ]);
  }
}

class InputSelectText extends StatefulWidget {
  final String title;
  final double height;
  final Function callFunc;
  final String oldData;
  List<dynamic> items = [];


  InputSelectText(
      {Key? key,
      required this.title,
      required this.height,
      required this.callFunc,
      required this.items,
      this.oldData=''})
      : super(key: key);
  @override
  _InputSelectTextState createState() => _InputSelectTextState();
}

class _InputSelectTextState extends State<InputSelectText> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          width: double.infinity,
          height: widget.height,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.appColors, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle),
          child: Container(
              margin: EdgeInsets.only(left: 15),
              child: MyDropdownButton(
                  items: widget.items, callbackFunc: widget.callFunc, oldData: widget.oldData))),
      Positioned(
          left: 25,
          top: 12,
          child: Container(
              color: Colors.white,
              child: Text(widget.title,
                  style: TextStyle(color: Colors.black, fontSize: 12))))
    ]);
  }
}
