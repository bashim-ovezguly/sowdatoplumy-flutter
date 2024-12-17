// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:my_app/pages/Profile/restore.dart';

import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

class setNewPassword extends StatefulWidget {
  final String phone;
  final String access_token;
  final String refresh_token;
  final int customer_id;
  setNewPassword(
      {Key? key,
      required this.phone,
      required this.access_token,
      required this.refresh_token,
      required this.customer_id})
      : super(key: key);

  @override
  State<setNewPassword> createState() => _setNewPasswordState(
      phone: phone,
      access_token: access_token,
      refresh_token: refresh_token,
      customer_id: customer_id);
}

class _setNewPasswordState extends State<setNewPassword> {
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  bool _password = false;
  bool _confirmPassword = false;
  final String phone;
  final String access_token;
  final String refresh_token;
  final int customer_id;

  final passwordFieldFocusNode = FocusNode();
  final confirmpasswordFieldFocusNode = FocusNode();

  void _toggleObscured() {
    setState(() {
      _password = !_password;
      if (passwordFieldFocusNode.hasPrimaryFocus) return;
      passwordFieldFocusNode.canRequestFocus = false;
    });
  }

  void _toggleObscured1() {
    setState(() {
      _confirmPassword = !_confirmPassword;
      if (confirmpasswordFieldFocusNode.hasPrimaryFocus) return;
      confirmpasswordFieldFocusNode.canRequestFocus = false;
    });
  }

  _setNewPasswordState(
      {required this.phone,
      required this.access_token,
      required this.refresh_token,
      required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: Text(
          'Täze açar sözi',
          style: CustomText.appBarText,
        ),
      ),
      body: Center(
          child: Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: _password,
              controller: passwordController,
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
                labelText: "Açar söz",
                fillColor: CustomColors.appColor,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black12, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
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
                labelText: "Açar sözüni tassykla",
                fillColor: CustomColors.appColor,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black12, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () async {
                    String password = passwordController.text;
                    String confirmpassword = confirmpasswordController.text;

                    if (password == '') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorAlert(
                              message: 'Täze açar sözüňüzi ýazyň !',
                            );
                          });
                    } else if (confirmpassword == '') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorAlert(
                              message: 'Täze açar gaýtadan ýazyň !',
                            );
                          });
                    } else if (password != confirmpassword) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorAlert(
                              message:
                                  'Täze açar sözüňiz bilen tasyklanylan açar sözüňiz birmeňzeş däl',
                            );
                          });
                    } else {
                      String url = serverIp + '/mob/restore/password';
                      final uri = Uri.parse(url);

                      var map = new Map<String, dynamic>();
                      map['phone'] = phone;
                      map['new_password'] = password;

                      final response = await http.post(uri,
                          headers: {'token': access_token}, body: map);
                      final json = jsonDecode(utf8.decode(response.bodyBytes));
                      print(response.body);
                      if (response.statusCode == 200) {
                        // final pref = await SharedPreferences.getInstance();
                        // pref.setInt('user_id', customer_id);
                        // pref.setString('access_token', access_token);
                        // pref.setString('refresh_token', refresh_token);
                        // pref.setBool('login', true);

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ErrorAlert(
                                  message:
                                      'Bagyşlaň ýalnyşlyk ýüze çykdy täzeden synanşyp görüň');
                            });
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(CustomColors.appColor),
                  ),
                  child: const Text(
                    "Tassykla",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
