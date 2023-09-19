// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:my_app/pages/Customer/newPassword.dart';


import '../../dB/constants.dart';
import '../../main.dart';
import 'confirmNewPassword.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  final String phone;
  MyHomePage({Key? key, required this.phone,}): super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(phone: phone);
}

class _MyHomePageState extends State<MyHomePage> {
  final String phone;
  bool _onEditing = true;
  String? _code;

  int _duration = 120;
  final CountDownController _controller = CountDownController();
  
  @override
  void initState() {
    super.initState();
  }

  refresh() async {
    Navigator.pop(context);
    setState(() {
      _controller.start();
    });
  }
  _MyHomePageState({required this.phone});
  @override
  build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: Text('SMS kody'),),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text('SMS kody ýazyň',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(width: 20,),
                CircularCountDownTimer(
                  duration: _duration,
                  initialDuration: 0,
                  controller: _controller,
                  isReverse:true,
                  width: 50,
                   height: 50,
                   ringColor: Colors.green,
                   fillColor: Colors.red,
                   onStart: () {
                      debugPrint('Countdown Started');
                    },
                    onComplete: () {
                    showDialog(
                      context: context,
                      builder: (context){
                        return SendSms(action: 'cars', refresh: refresh, phone: phone);});
                        },
                )
              ],
            ),
            )
          ),
          VerificationCode(            
            textStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Theme.of(context).primaryColor, fontSize: 20),
                
            keyboardType: TextInputType.number,
            underlineColor: Color.fromARGB(255, 1, 132, 6), 
            length: 4,
            cursorColor:
                CustomColors.appColors, 

            clearAll: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                'Arassala',
                style: TextStyle(fontSize: 18.0,decoration: TextDecoration.underline,color: CustomColors.appColors),
              ),
              )
            ),
            margin: const EdgeInsets.all(2),
            onCompleted: (String value) {
              setState(() {
                _code = value;
              });
            },
            
            onEditing: (bool value) {
              setState(() {
                _onEditing = value;
              });
              if (!_onEditing) FocusScope.of(context).unfocus();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.appColors,
                          foregroundColor: Colors.white),
                          onPressed: () async {

                            if (_code==null || _code!.length!=4){
                              showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Bagyşlaň telefon belgiňize gelen sms kody giriziň',);});
                            }
                            else{
                                Urls server_url  =  new Urls();
                                String url = server_url.get_server_url() + '/mob/verif';
                                final uri = Uri.parse(url);

                                var map = new Map<String, dynamic>();
                                map['phone'] = phone;
                                map['code'] = _code;

                                final response = await http.post(uri, body: map);
                                final json = jsonDecode(utf8.decode(response.bodyBytes));

                                 if (response.statusCode==200){
                                  final deleteallRows = await dbHelper.deleteAllRows();
                                  final deleteallRows1 = await dbHelper.deleteAllRows1();
                                  print('-----1--------  $deleteallRows');
                                  print('-----2--------  $deleteallRows1');
                                  
                                  String access_token = json['access_token'];
                                  String refresh_token = json['refresh_token'];
                                  int customer_id = json['id'];
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfirmNewPassword(phone: phone,
                                                                                                                     access_token: access_token,
                                                                                                                     refresh_token:refresh_token,
                                                                                                                     customer_id: customer_id
                                                                                                                    )));
                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Tassyklaýyş kodyňyz nädogry täzeden synanşyp görüň',);});
                                }
                            }
                            },
                            child: const Text('OK',style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )
            ),
          )
        ],
      ),
      )
    );
  }
}


class SendSms extends StatefulWidget {

  SendSms({Key? key, required this.action, required this.refresh, required this.phone}) : super(key: key);
  final String action;
  final String phone;
  final Function refresh;
  @override
  State<SendSms> createState() => _SendSmsState(action: action,);
}

class _SendSmsState extends State<SendSms> {
  bool isChecked = false;
  final String action;
  
  void initState() {
    super.initState();
  }
  _SendSmsState({required this.action});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
          )
        ],
      ),
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);                
              },
            child: const Text('Goý bolsun'),
          ),
        ),
        SizedBox(width: 10,),
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            onPressed: () async {
                Urls server_url  =  new Urls();
                                String url = server_url.get_server_url() + '/mob/customers/send/code';
                                final uri = Uri.parse(url);
                                var  request = new http.MultipartRequest("POST", uri);

                                request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', });
                                request.fields['phone'] = widget.phone;
                                
                                final response = await request.send();
                                print(response.statusCode);
                                if (response.statusCode==200){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(phone: widget.phone)));
                                  }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Bagyşlaň ýalňyşlyk ýüze çykdy, täzeden synanşyp gorüň',);});
                                }
              },
            child: const Text('Täze sms ugrat'),
          ),
        )

          ],
          
      ),),
      actions: <Widget>[

      ],
    );
  }
}
