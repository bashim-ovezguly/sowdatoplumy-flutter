import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dB/colors.dart';
import '../dB/providers.dart';


class CustomDialog extends StatefulWidget {

  CustomDialog({Key? key, required this.sort_value, required this.callbackFunc}) : super(key: key);
   String sort_value;
   final Function callbackFunc;
  @override
  _CustomDialogState createState() => _CustomDialogState(sort_value: sort_value, callbackFunc: callbackFunc);
}

class _CustomDialogState extends State<CustomDialog> {
  final Function callbackFunc;
  String sort_value;
  bool canUpload = false;
  int  _value = 1;

  void initState() {
      var ss = Provider.of<UserInfo>(context, listen: false).sort;
      setState(() {_value = int.parse(ss);});
    super.initState();
  }
  
  _CustomDialogState({required this.sort_value, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text('Tertip' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
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
                    activeColor: CustomColors.appColors,
                    value: 1,
                    groupValue: _value,
                    onChanged: (value){ setState(() {
                      _value = value!;
                    });}),
                GestureDetector(
                  onTap: (){setState(() {
                    _value = 1;
                    Provider.of<UserInfo>(context, listen: false).setsort('1');
                  });},
                  child: Text("Hiç hili"),)
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  splashRadius: 20.0,
                  activeColor: CustomColors.appColors,
                    value: 2,
                    groupValue: _value,
                    onChanged: (value){ setState(() {
                        _value = value!;
                        
                        Provider.of<UserInfo>(context, listen: false).setsort('2');
                                                
                      });}),
                GestureDetector(
                  onTap: (){setState(() {_value = 2;
                  Provider.of<UserInfo>(context, listen: false).setsort('2');
                  
                  });},
                  child: Text("Arzandan gymmada"),)
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                    activeColor: CustomColors.appColors,
                    value: 3,
                    groupValue: _value,
                    onChanged: (value){ setState(() {
                      _value = value!;
                      Provider.of<UserInfo>(context, listen: false).setsort('3');
                    });}),
                GestureDetector(
                  onTap: (){setState(() {
                    _value = 3;
                    Provider.of<UserInfo>(context, listen: false).setsort('3');
                    
                    });},
                  child: Text("Gymmatdan arzana"),)
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                    activeColor: CustomColors.appColors,
                    value: 4,
                    groupValue: _value,
                    onChanged: (value){ setState(() {
                      Provider.of<UserInfo>(context, listen: false).setsort('4');
                      _value = value!;
                    });}),
                GestureDetector(
                  onTap: (){setState(() {_value = 4;
                  Provider.of<UserInfo>(context, listen: false).setsort('4');
                        });},
                  child: Text("Köneden täzä"),)
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                    activeColor: CustomColors.appColors,
                    value: 5,
                    groupValue: _value,
                    onChanged: (value){ setState(() {
                      var sort = Provider.of<UserInfo>(context, listen: false).sort;
                        sort = '5';
                        print(sort);
                      _value = value!;
                    });}),
                GestureDetector(
                  onTap: (){setState(() {_value = 5;
                  var sort = Provider.of<UserInfo>(context, listen: false).sort;
                        sort = '5';
                        print(sort);
                  });},
                  child: Text("Täzeden könä"),)
              ],
            ),
          ],
        )
      ),
      actions: <Widget>[

        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
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
