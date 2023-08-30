import 'dart:convert';
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/db.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:my_app/pages/Customer/newPassword.dart';
import 'package:my_app/pages/register.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../dB/providers.dart';
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
            Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()));
          },
          type: QuickAlertType.info);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Içeri gir",
            style: CustomText.appBarText,
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(left: 60, right: 60),
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: [
                            CircleFlag(
                              'tm',
                              size: 30,
                            ),
                            Text(
                              "   +993",
                              style: TextStyle(
                                  fontSize: 18, color: CustomColors.appColors),
                            )
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                              labelText: "Telefon",
                              labelStyle:
                                  TextStyle(color: CustomColors.appColors),
                              fillColor: CustomColors.appColors,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black12, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black12, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ))))
                ])),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 60, right: 60),
              child: TextFormField(
                controller: passwordController,
                obscureText: _password,
                focusNode: passwordFieldFocusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_rounded, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _password
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                  labelText: "Açar sözi",
                  labelStyle: TextStyle(color: CustomColors.appColors),
                  fillColor: CustomColors.appColors,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 60, right: 60, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(''),
                  Spacer(),
                  SizedBox(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (usernameController.text != '' &&
                              passwordController.text != '') {
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
                                'password': passwordController.text.toString(),
                                'phone': usernameController.text.toString()
                              },
                            );

                            final json =
                                jsonDecode(utf8.decode(response.bodyBytes));
                            if (response.statusCode != 200) {
                              if (response.statusCode == 404 &&
                                  json['error_code'] == 3) {
                                    showWorningAlert();
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
                                DatabaseSQL.columnUserId: json['data']['id'],
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
                            } else {}
                          }
                        },
                        child: Text(
                          "Içeri gir",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Raleway'),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CustomColors.appColors),
                        )),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 60, top: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    'Agza bolduňyzmy ?',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )),
            Container(
                margin: EdgeInsets.only(left: 60, right: 60, top: 15),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NewPassword()));
                  },
                  child: Text(
                    'Açar sözümi ýadymdan çykardym !',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )),
          ],
        )));
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
      content: Container(
        width: 60,
        height: 60,
        child: Text(
          'Ulanyjy adyňyz ýa-da açar sözüňiz nädogry',
          textAlign: TextAlign.center,
        ),
      ),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
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
