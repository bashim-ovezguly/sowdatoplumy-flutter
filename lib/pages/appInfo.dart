import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  var data = {};
  bool status = false;
  void initState() {
    getAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title:
                const Text("Programma barada", style: CustomText.appBarText)),
        body: status
            ? ListView(children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/logo.png',
                              height: 120, width: 120),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text("Sowda toplumy",
                                  style: TextStyle(
                                      color: CustomColors.appColors,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))),
                          Container(
                              child: Text("dükanlar we bildirişler",
                                  style: TextStyle(
                                      color: CustomColors.appColors,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))
                        ])),
                Container(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        child: Text(data['about_us'].toString(),
                            style: TextStyle(
                                color: CustomColors.appColors,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)))),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                        child: Text('Ulanyş düzgünleri'.toString(),
                            style: TextStyle(
                                color: CustomColors.appColors,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)))),
                for (var item in data['rules'])
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                          child: Text("- " + item.toString(),
                              style: TextStyle(
                                  color: CustomColors.appColors,
                                  fontSize: 14)))),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                        child: Text('Habarlaşmak üçin'.toString(),
                            style: TextStyle(
                                color: CustomColors.appColors,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)))),
                for (var item in data['contacts'])
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: SizedBox(
                          child: Text(item.toString(),
                              style: TextStyle(
                                  color: CustomColors.appColors,
                                  fontSize: 14))))
              ])
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColors)));
  }

  Future<void> getAppInfo() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/about_us';

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    try {
      final response = await get(Uri.parse(url), headers: headers);
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        data = json;
        status = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
