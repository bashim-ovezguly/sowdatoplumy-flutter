import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key? key, required this.labelText, required this.callbackFunc, required this.status} ) : super(key: key);
  final String labelText;
  final bool status;
  final Function callbackFunc;
  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState(callbackFunc: callbackFunc);
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;
  final Function callbackFunc;
  
  @override
  void initState() {
    setState(() {
      isChecked = widget.status;
    });
    super.initState();
  }

  _CustomCheckBoxState({required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                setState(() {
                  isChecked = !isChecked;
                  callbackFunc();
                });},
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors, width: 2),),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
                  child: isChecked ? const Icon(Icons.check,size: 22,color: Colors.green,):  Container()),),),
            SizedBox(width: 5,),
            GestureDetector(
              onTap: (){
                setState(() {
                  isChecked = !isChecked;
                  callbackFunc();
                });},
              child: Text(widget.labelText, style: const TextStyle(fontSize: 17, color: CustomColors.appColors),),)],),),);
  }}