// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/Profile.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../dB/db.dart';
import '../dB/textStyle.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  var text = '';

  var data = {};
  @override
  void initState() {
    super.initState();
  }

  bool _password = true;
  bool _confirmPassword = true;

  final passwordFieldFocusNode = FocusNode();
  final confirmpasswordFieldFocusNode = FocusNode();

  void _toggleObscured() {
    setState(() {
      _password = !_password;
      if (passwordFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscured1() {
    setState(() {
      _confirmPassword = !_confirmPassword;
      if (confirmpasswordFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      confirmpasswordFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: const Text(
          "Registrasiýa",
          style: CustomText.appBarText,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        height: 520,
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  prefixIcon: Icon(Icons.person),
                  labelText: "Adyňyz",
                  fillColor: CustomColors.appColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  prefixText: '+993',
                  labelText: "Telefon belgiňiz",
                  fillColor: CustomColors.appColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, size: 24),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelText: "Email",
                  fillColor: CustomColors.appColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: _password,
                controller: passwordController,
                focusNode: passwordFieldFocusNode,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
                  labelText: "Açar söz",
                  fillColor: CustomColors.appColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: _confirmPassword,
                focusNode: confirmpasswordFieldFocusNode,
                controller: confirmpasswordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  prefixIcon: Icon(Icons.lock_rounded, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured1,
                      child: Icon(
                        _confirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                  labelText: "Açar sözüni gaýtadan giriziň",
                  fillColor: CustomColors.appColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                    onPressed: () async {
                      if (passwordController.text != '' &&
                          phoneController.text != '' &&
                          confirmpasswordController.text ==
                              passwordController.text) {
                        String url = serverIp + '/mob/reg';
                        final uri = Uri.parse(url);

                        showLoaderDialog(context);
                        final response = await http.post(
                          uri,
                          headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                          },
                          body: {
                            'phone': phoneController.text.toString(),
                            'password': passwordController.text.toString(),
                            'name': usernameController.text.toString(),
                            'email': emailController.text.toString()
                          },
                        );
                        Navigator.pop(context);
                        final json =
                            jsonDecode(utf8.decode(response.bodyBytes));

                        if (json['status'] == 'success') {
                          setState(() {
                            data = json;
                            showConfirmationDialogSuccess(context);
                          });
                        } else {
                          if (json['error_code'] == 2) {
                            setState(() {
                              text = 'Bagyşlaň bular ýaly ulanyjy bar';
                            });
                          }
                          showConfirmationDialog(context);
                        }
                      } else {
                        setState(() {
                          text = 'Telefon belgiňiz we açar sözüňiz hökmany';
                        });
                        showConfirmationDialog(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(CustomColors.appColor),
                    ),
                    child: const Text(
                      "Agza bolmak",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  showConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogout(error_msg: text);
      },
    );
  }

  showConfirmationDialogSuccess(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogoutSuccess(
            phone: phoneController.text.toString(),
            email: emailController.text.toString(),
            password: passwordController.text.toString());
      },
    );
  }
}

class CustomDialogLogoutSuccess extends StatefulWidget {
  CustomDialogLogoutSuccess(
      {Key? key,
      required this.phone,
      required this.email,
      required this.password})
      : super(key: key);
  final String phone;
  final String email;
  final String password;

  @override
  _CustomDialogLogoutSuccessState createState() =>
      _CustomDialogLogoutSuccessState(
          phone: phone, email: email, password: password);
}

class _CustomDialogLogoutSuccessState extends State<CustomDialogLogoutSuccess> {
  bool canUpload = false;
  final codeController = TextEditingController();
  final String phone;
  late final String email;
  late final String password;

  _CustomDialogLogoutSuccessState(
      {required String this.phone,
      required String this.email,
      required String this.password});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          'Sms kody ýazyň',
          style: TextStyle(color: CustomColors.appColor),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.pop(context, 'Cancel');
          },
          child: Icon(
            Icons.close,
            color: Colors.red,
          ),
        )
      ]),
      content: Container(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: codeController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            labelText: "Kod",
            fillColor: CustomColors.appColor,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black12, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.appColor,
              foregroundColor: Colors.white),
          onPressed: () async {
            String url = serverIp + '/mob/verif';
            final uri = Uri.parse(url);

            final response = await http.post(
              uri,
              body: {
                'phone': phone.toString(),
                'code': codeController.text.toString(),
                'email': email,
              },
            );

            final json = jsonDecode(utf8.decode(response.bodyBytes));

            if (json['status'] == 'success') {
              final pref = await SharedPreferences.getInstance();
              await pref.setInt('user_id', json['id']);
              await pref.setString('name', json['name']);
              await pref.setString('phone', phone);
              await pref.setString('access_token', json['access_token']);
              await pref.setString('refresh_token', json['refresh_token']);
              await pref.setBool('login', true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Profile(user_customer_id: json['id'].toString());
              }));
            } else {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: 'Ýalňyşlyk ýüze çykdy');
            }
          },
          child: const Text('Tassykla'),
        ),
      ],
    );
  }
}

class CustomDialogLogout extends StatefulWidget {
  final String error_msg;
  CustomDialogLogout({Key? key, required this.error_msg}) : super(key: key);
  @override
  _CustomDialogLogoutState createState() => _CustomDialogLogoutState();
}

class _CustomDialogLogoutState extends State<CustomDialogLogout> {
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ulmaga ýazylmak',
            style: TextStyle(color: CustomColors.appColor),
          ),
        ],
      ),
      content: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            widget.error_msg,
            maxLines: 3,
          )),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.appColor,
              foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Täzeden synanşyp görüñ'),
        ),
      ],
    );
  }
}
