import 'package:flutter/material.dart';
import '../dB/colors.dart';

class SuccessAlert extends StatefulWidget {
  final String action;
  final  Function callbackFunc;
  SuccessAlert({Key? key, required this.action, required this.callbackFunc }): super(key: key);
  @override
  _SuccessAlertState createState() => _SuccessAlertState(action: action, callbackFunc: callbackFunc);
}

class _SuccessAlertState extends State<SuccessAlert> {
final String action;
final Function callbackFunc;
_SuccessAlertState({required this.action, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      
      content: Container(
        width: 200,
        height: 100,
        child: Text(
          'Maglumat goşuldy operatoryñ tassyklamagyna garaşyñ'
        ),
      ),
      actions: <Widget>[

        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            onPressed: () async {
              callbackFunc();
                Navigator.pop(context);
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}



class ProgresBar extends StatefulWidget {
  const ProgresBar({super.key});

  @override
  State<ProgresBar> createState() => _ProgresBarState();
}

class _ProgresBarState extends State<ProgresBar> {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),);
  }
}