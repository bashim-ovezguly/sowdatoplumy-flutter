import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/Profile.dart';
import 'package:my_app/pages/Customer/restore.dart';
import 'package:my_app/pages/Customer/verificationCode.dart';
import 'package:my_app/pages/register.dart';
import 'package:my_app/pages/success.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dB/textStyle.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _password = true;

  bool isLoading = false;

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

  loginClick() async {
    if (usernameController.text.length == 8 && passwordController.text != '') {
      setState(() {
        isLoading = true;
      });

      final uri = Uri.parse(tokenObtainUrl);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'password': passwordController.text.toString(),
          'phone': usernameController.text.toString()
        },
      );

      setState(() {
        isLoading = false;
      });

      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        if (json['error_code'] == 5) {
          showDialog(
              context: context,
              builder: (context) {
                return SmsCodeSend(
                    phone: usernameController.text,
                    password: passwordController.text);
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', usernameController.text.toString());
        await prefs.setInt('user_id', json['data']['id']);
        await prefs.setString('name', json['data']['name']);
        await prefs.setString('phone', usernameController.text.toString());
        await prefs.setString('logo_url', json['data']['logo_url']);
        await prefs.setString('access_token', json['data']['access_token']);
        await prefs.setString('refresh_token', json['data']['refresh_token']);

        prefs.setBool('login', true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Profile()));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertError();
          });
    }
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
            "Login",
            style: CustomText.appBarText,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, color: CustomColors.appColor, size: 150),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(children: [
                  TextFormField(
                      maxLength: 8,
                      maxLines: 1,
                      controller: usernameController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '+993',
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'xx xxxxxx',
                        labelText: "Telefon belgiňiz",
                        labelStyle: TextStyle(color: CustomColors.appColor),
                        fillColor: CustomColors.appColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: CustomColors.appColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: CustomColors.appColor, width: 1),
                        ),
                      )),
                  SizedBox(height: 10),
                  Container(
                      height: 50,
                      child: TextFormField(
                          controller: passwordController,
                          obscureText: _password,
                          focusNode: passwordFieldFocusNode,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                size: 24,
                                color: CustomColors.appColor,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                      _password
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                      color: CustomColors.appColor),
                                ),
                              ),
                              labelText: "Açar sözi",
                              labelStyle:
                                  TextStyle(color: CustomColors.appColor),
                              fillColor: CustomColors.appColor,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: CustomColors.appColor, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CustomColors.appColor, width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0)))))
                ])),
            if (this.isLoading)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProgresBar(),
              ),
            if (!this.isLoading)
              Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            onPressed: () async {
                              this.loginClick();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColor,
                            ),
                            child: Text("Giriş",
                                style: TextStyle(
                                    fontSize: 18,
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
                                color: CustomColors.appColor,
                              ),
                            ),
                            child: Text("Registrasiýa",
                                style: TextStyle(
                                  color: CustomColors.appColor,
                                  fontSize: 18,
                                ))),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RestoreAccount()));
                            },
                            child: Text("Açar sözüni dikeltmek",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColor))),
                      )
                    ],
                  )),
          ],
        ));
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
                  'Hormatly ulanyjy, siziň belgiňiz tassyklanmadyk. SMS kod üsti bilen belgiňizi tassyklamagyňyzy haýyş edýäris!',
                  style: TextStyle(fontSize: 17, color: CustomColors.appColor),
                  textAlign: TextAlign.center,
                  maxLines: 4)
            ])),
        actions: <Widget>[
          Align(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColor,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, 'Close');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Verification(
                                  action: "login",
                                  email: widget.phone,
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
                backgroundColor: CustomColors.appColor,
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
