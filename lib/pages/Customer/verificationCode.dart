// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:my_app/dB/db.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/newPassword.dart';
import '../../dB/constants.dart';
import '../../main.dart';
import 'confirmNewPassword.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final String phone;
  final String action;
  final String password;
  MyHomePage({Key? key, required this.phone, this.action = "", this.password=''})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(phone: phone);
}

class _MyHomePageState extends State<MyHomePage> {
  final String phone;

  final _code = TextEditingController();

  int _duration = 60;
  final CountDownController _controller = CountDownController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  bool status = false;

  @override
  void initState() {
    super.initState();
  }

  refresh() async {
    setState(() {
      status = false;
      _controller.start();
    });
  }

  _MyHomePageState({required this.phone});
  @override
  build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: widget.action != 'login'
                ? Text("Açar sözüni dikeltmek", style: CustomText.appBarText)
                : Text("SMS kody tassykla", style: CustomText.appBarText)),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 80,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/sms_code_icon.png'),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("+993 " + phone + " belgä ugradylan",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontSize: 16)),
                            Text("SMS kody giriziň",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontSize: 16)),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: 50,
                        child: TextFormField(
                            controller: _code,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                fillColor: CustomColors.appColors,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CustomColors.appColors,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CustomColors.appColors,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                )))),
                    SizedBox(height: 30),
                    Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_code.text.length != 4) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ErrorAlert(
                                        message:
                                            'Bagyşlaň telefon belgiňize gelen sms kody giriziň',
                                      );
                                    });
                              } else {
                                Urls server_url = new Urls();
                                String url =
                                    server_url.get_server_url() + '/mob/verif';
                                final uri = Uri.parse(url);

                                var map = new Map<String, dynamic>();
                                map['phone'] = phone;
                                map['code'] = _code.text;

                                final response =
                                    await http.post(uri, body: map);
                                final json =
                                    jsonDecode(utf8.decode(response.bodyBytes));

                                if (response.statusCode == 200) {
                                  final deleteallRows =
                                      await dbHelper.deleteAllRows();
                                  final deleteallRows1 =
                                      await dbHelper.deleteAllRows1();

                                  print('-----1--------  $deleteallRows');
                                  print('-----2--------  $deleteallRows1');

                                  String access_token = json['access_token'];
                                  String refresh_token = json['refresh_token'];
                                  int customer_id = json['id'];
                                  if (widget.action != 'login') {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmNewPassword(
                                                    phone: phone,
                                                    access_token: access_token,
                                                    refresh_token:
                                                        refresh_token,
                                                    customer_id: customer_id)));
                                  } else {
                                    Map<String, dynamic> row = {
                                      DatabaseSQL.columnUserId: customer_id,
                                      DatabaseSQL.columnName: access_token,
                                      DatabaseSQL.columnPassword: refresh_token,
                                    };

                                    Map<String, dynamic> row1 = {
                                      DatabaseSQL.columnName: widget.phone.toString(),
                                      DatabaseSQL.columnPassword: widget.password.toString()
                                    };

                                    final id = await dbHelper.insert(row);
                                    final id1 = await dbHelper.inser1(row1);
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ErrorAlert(
                                          message:
                                              'Tassyklaýyş kodyňyz nädogry täzeden synanşyp görüň',
                                        );
                                      });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColors,
                            ),
                            child: Text("Tassyklamak",
                                style: TextStyle(
                                    color: CustomColors.appColorWhite)))),
                    Container(
                        child: CircularCountDownTimer(
                      duration: _duration,
                      initialDuration: 0,
                      controller: _controller,
                      isReverse: true,
                      width: 50,
                      height: 50,
                      ringColor: Colors.white,
                      fillColor: Colors.white,
                      textStyle: TextStyle(
                          color: CustomColors.appColors,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      onStart: () {
                        debugPrint('Countdown Started');
                      },
                      onComplete: () {
                        setState(() {
                          status = true;
                        });
                      },
                    )),
                    if (status == false)
                      Align(
                        child: TextButton(
                          onPressed: null,
                          child: Text("SMS kody täzeden ugratmak"),
                        ),
                      )
                    else
                      Align(
                        child: TextButton(
                          onPressed: () async {
                            refresh();

                            Urls server_url = new Urls();
                            String url = server_url.get_server_url() +
                                '/mob/customers/send/code';
                            final uri = Uri.parse(url);
                            var request =
                                new http.MultipartRequest("POST", uri);

                            request.headers.addAll({
                              'Content-Type':
                                  'application/x-www-form-urlencoded',
                            });
                            request.fields['phone'] = phone;

                            final response = await request.send();
                            if (response.statusCode == 200) {
                              print(response.statusCode);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ErrorAlert(
                                      message:
                                          'Bagyşlaň ýalňyşlyk ýüze çykdy, täzeden synanşyp gorüň',
                                    );
                                  });
                            }
                          },
                          child: Text("SMS kody täzeden ugratmak",
                              style: TextStyle(color: CustomColors.appColors)),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
