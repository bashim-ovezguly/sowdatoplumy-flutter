// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/restore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dB/constants.dart';
import '../../main.dart';
import 'setNewPassword.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  final String email;
  final String action;
  final String password;
  Verification(
      {Key? key, required this.email, this.action = "", this.password = ''})
      : super(key: key);

  @override
  State<Verification> createState() => _VerificationState(email: email);
}

class _VerificationState extends State<Verification> {
  final String email;

  final _code = TextEditingController();

  int _duration = 60;
  final CountDownController _controller = CountDownController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  bool status = false;

  @override
  void initState() {
    if (widget.action == 'login') {
      sendSms();
    }
    super.initState();
  }

  refresh() async {
    setState(() {
      status = false;
      _controller.start();
    });
  }

  confirmClick() async {
    if (_code.text.length != 4) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlert(
              message: 'Telefon belgiňize gelen sms kody giriziň',
            );
          });
    } else {
      String url = serverIp + '/mob/verif';
      final uri = Uri.parse(url);

      var map = new Map<String, dynamic>();
      map['email'] = email;
      map['code'] = _code.text;

      final response = await http.post(uri, body: map);
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        final deleteallRows = await dbHelper.deleteAllRows();
        final deleteallRows1 = await dbHelper.deleteAllRows1();

        String access_token = json['access_token'];
        String refresh_token = json['refresh_token'];
        int customer_id = json['id'];
        if (widget.action != 'login') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => setNewPassword(
                      email: email,
                      access_token: access_token,
                      refresh_token: refresh_token,
                      customer_id: customer_id)));
        } else {
          final pref = await SharedPreferences.getInstance();
          pref.setInt('user_id', customer_id);
          pref.setString('access_token', access_token);
          pref.setString('refresh_token', refresh_token);
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorAlert(
                message: 'Tassyklaýyş kodyňyz nädogry täzeden synanşyp görüň',
              );
            });
      }
    }
  }

  _VerificationState({required this.email});
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
                      height: 200,
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/sms_code_icon.png'),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(email + " poçta ugradylan",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 16)),
                            Text("SMS kody giriziň",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 16)),
                          ],
                        )),
                    Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: TextFormField(
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                            maxLength: 4,
                            controller: _code,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              fillColor: CustomColors.appColor,
                            ))),
                    Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              this.confirmClick();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColor,
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
                          color: CustomColors.appColor,
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
                              child: Text("SMS kody täzeden ugratmak")))
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
                            request.fields['phone'] = email;

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
                              style: TextStyle(color: CustomColors.appColor)),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> sendSms() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/customers/send/code';
    final uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);

    request.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    request.fields['phone'] = email;
    final response = await request.send();
    print('SUCCESS');
  }
}
