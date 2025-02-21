import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Profile/loadingWidget.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import 'package:http/http.dart' as http;

class PasswordChange extends StatefulWidget {
  final String customer_id;

  const PasswordChange({
    Key? key,
    required this.customer_id,
  }) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  bool isLoading = false;
  var passwordController = TextEditingController();
  var passwordConfController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  save() async {
    String url = storeUrl + widget.customer_id.toString();

    var data = {
      'old_password': passwordController.text,
      'new_password': passwordConfController.text,
    };

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    showLoaderDialog(context);

    final uri = Uri.parse(url);
    var token = await get_access_token();
    var response = await http.put(uri, body: data, headers: {'token': token});
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Ýatda saklandy',
          confirmBtnText: 'OK');
    }

    // ON ERROR
    if (response.statusCode != 200) {
      QuickAlert.show(
          text: 'Error', context: context, type: QuickAlertType.error);
    }
    if (response.statusCode == 401) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Täze açar sözi",
            style: CustomText.appBarText,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Açar sözi')),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  controller: passwordConfController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Açar sözüniň tassyklamasy')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(15),
                minWidth: double.infinity,
                textColor: Colors.white,
                color: CustomColors.appColor,
                onPressed: () {
                  this.save();
                },
                child: Text('Tassyklamak'),
              ),
            )
          ],
        ));
  }
}
