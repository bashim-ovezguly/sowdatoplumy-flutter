import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/db.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:my_app/pages/Customer/newPassword.dart';
import 'package:my_app/pages/Customer/verificationCode.dart';
import 'package:my_app/pages/Store/checkout.dart';
import 'package:my_app/pages/register.dart';
import 'package:quickalert/quickalert.dart';
import '../../dB/textStyle.dart';
import '../../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _password = true;
  bool loading = false;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  final passwordFieldFocusNode = FocusNode();
  void _toggleObscured() {
    setState(() {
      _password = !_password;
      if (passwordFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    showWorningAlert() {
      QuickAlert.show(
          title: 'Bagyşlaň siz agza bolmadyňyz!',
          text: "Agza bolmak üçin dowam et düwmä basyň",
          context: context,
          confirmBtnText: 'Dowam et',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Register()));
          },
          type: QuickAlertType.info);
    }

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Içeri gir",
            style: CustomText.appBarText,
          ),
        ),
        body: loading == false
            ? ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2 - 10,
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Icon(Icons.account_circle,
                                    color: CustomColors.appColors, size: 150),
                              )),
                          Expanded(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: [
                                    Container(
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: TextFormField(
                                                      controller:
                                                          usernameController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  "Telefon",
                                                              labelStyle: TextStyle(
                                                                  color: CustomColors
                                                                      .appColors),
                                                              fillColor:
                                                                  CustomColors
                                                                      .appColors,
                                                              prefixIcon:
                                                                  Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            top:
                                                                                8),
                                                                        width:
                                                                            50,
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child: Text(
                                                                            "+993 ",
                                                                            style:
                                                                                TextStyle(
                                                                              color: CustomColors.appColors,
                                                                              fontSize: 16,
                                                                            )),
                                                                      )),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .black12,
                                                                    width: 1.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .black12,
                                                                    width: 1.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ))),
                                                ))
                                          ],
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: _password,
                                        focusNode: passwordFieldFocusNode,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock_rounded,
                                            size: 24,
                                            color: CustomColors.appColors,
                                          ),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 4, 0),
                                            child: GestureDetector(
                                              onTap: _toggleObscured,
                                              child: Icon(
                                                  _password
                                                      ? Icons.visibility_rounded
                                                      : Icons
                                                          .visibility_off_rounded,
                                                  size: 24,
                                                  color:
                                                      CustomColors.appColors),
                                            ),
                                          ),
                                          labelText: "Açar sözi",
                                          labelStyle: TextStyle(
                                              color: CustomColors.appColors),
                                          fillColor: CustomColors.appColors,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black12,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black12,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 2 - 100,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (usernameController.text.length == 8 &&
                                      passwordController.text != '') {
                                    setState(() {
                                      loading = true;
                                    });
                                    Urls server_url = new Urls();
                                    String url = server_url.get_server_url() +
                                        '/mob/token/obtain';
                                    final uri = Uri.parse(url);
                                    final response = await http.post(
                                      uri,
                                      headers: {
                                        'Content-Type':
                                            'application/x-www-form-urlencoded'
                                      },
                                      body: {
                                        'password':
                                            passwordController.text.toString(),
                                        'phone':
                                            usernameController.text.toString()
                                      },
                                    );
                                    setState(() {
                                      loading = false;
                                    });

                                    final json = jsonDecode(
                                        utf8.decode(response.bodyBytes));
                                    if (response.statusCode != 200) {
                                      if (json['error_code'] == 5) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SmsCodeSend(
                                                phone: phoneController.text,
                                                password:
                                                    passwordController.text,
                                              );
                                            });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertError();
                                            });
                                      }
                                    }

                                    if (json['status'] == 'success') {
                                      Map<String, dynamic> row = {
                                        DatabaseSQL.columnUserId: json['data']
                                            ['id'],
                                        DatabaseSQL.columnName: json['data']
                                            ['access_token'],
                                        DatabaseSQL.columnPassword: json['data']
                                            ['refresh_token'],
                                      };

                                      Map<String, dynamic> row1 = {
                                        DatabaseSQL.columnName:
                                            usernameController.text.toString(),
                                        DatabaseSQL.columnPassword:
                                            passwordController.text.toString()
                                      };
                                      final id = await dbHelper.insert(row);
                                      final id1 = await dbHelper.inser1(row1);

                                      print('-----1--------  $id');
                                      print('-----2--------  $id1');

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyPages()));
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertError();
                                        });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.appColors,
                                ),
                                child: Text("Giriş",
                                    style: TextStyle(
                                        color: CustomColors.appColorWhite))),
                          ),
                          SizedBox(
                            width: 200,
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: CustomColors.appColors,
                                  ),
                                ),
                                child: Text("Registrasiýa",
                                    style: TextStyle(
                                        color: CustomColors.appColors))),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewPassword()));
                                },
                                child: Text("Açar sözüni dikeltmek",
                                    style: TextStyle(
                                        color: CustomColors.appColors))),
                          )
                        ],
                      )),
                ],
              )
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColors)));
  }
}

class SmsCodeSend extends StatefulWidget {
  final String password;
  final String phone;

  SmsCodeSend({Key? key, required this.phone, required this.password})
      : super(key: key);
  @override
  _SmsCodeSendState createState() => _SmsCodeSendState();
}

class _SmsCodeSendState extends State<SmsCodeSend> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shadowColor: CustomColors.appColorWhite,
        surfaceTintColor: CustomColors.appColorWhite,
        backgroundColor: CustomColors.appColorWhite,
        content: Container(
            width: 80,
            height: 110,
            child: Column(children: [
              Text(
                  'Hormatly ulanyjy, siziň belgiňiz tassyklanmadyk. SMS kod üsti bile belgiňizi tassyklamagyňyzy haýyş edýäris!',
                  style: TextStyle(fontSize: 17, color: CustomColors.appColors),
                  textAlign: TextAlign.center,
                  maxLines: 4)
            ])),
        actions: <Widget>[
          Align(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColors,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, 'Close');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  action: "login",
                                  phone: widget.phone,
                                  password: widget.password,
                                )));
                  },
                  child: const Text('SMS kod ugrat')))
        ]);
  }
}

class AlertError extends StatefulWidget {
  AlertError({Key? key}) : super(key: key);
  @override
  _AlertErrorState createState() => _AlertErrorState();
}

class _AlertErrorState extends State<AlertError> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      content: Container(
          width: 80,
          height: 180,
          child: Column(
            children: [
              Center(child: Icon(Icons.warning, size: 130, color: Colors.red)),
              Text(
                'Açar sözi ýa-da telefon belgi nädogry',
                textAlign: TextAlign.center,
              ),
            ],
          )),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, 'Close');
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}
