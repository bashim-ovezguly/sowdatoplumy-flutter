import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  var data = {};
  var device_id = '';
  var language = 'TM';

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
                    height: 220,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/logo.png',
                              height: 120, width: 120),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text("Söwda toplumy",
                                  style: TextStyle(
                                      color: CustomColors.appColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))),
                          Container(
                              child: Text("online dükanlar",
                                  style: TextStyle(
                                      color: CustomColors.appColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))
                        ])),
                Container(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        child: Text(data['about_us'].toString(),
                            style: TextStyle(
                                color: CustomColors.appColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)))),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                        child: Text('Ulanyş düzgünleri'.toString(),
                            style: TextStyle(
                                color: CustomColors.appColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)))),
                for (var item in data['rules'])
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                          child: Text("- " + item.toString(),
                              style: TextStyle(
                                  color: CustomColors.appColor,
                                  fontSize: 14)))),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                        child: Text('Habarlaşmak üçin'.toString(),
                            style: TextStyle(
                                color: CustomColors.appColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)))),
                for (var item in data['contacts'])
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: SizedBox(
                          child: Text(item.toString(),
                              style: TextStyle(
                                  color: CustomColors.appColor,
                                  fontSize: 14)))),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    children: [Text('Device ID'), Spacer(), Text(device_id)],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    children: [Text('Dil'), Spacer(), Text(language)],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    children: [
                      Text('Version'),
                      Spacer(),
                      Text(global_headers['App-Version'].toString())
                    ],
                  ),
                )
              ])
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColor)));
  }

  Future<void> getAppInfo() async {
    String url = serverIp + '/mob/about_us';

    var pref = await SharedPreferences.getInstance();
    print(pref.getKeys());
    setState(() {
      device_id = pref.getString('device_id').toString();
      // language = pref.getString('lang').toString();
    });

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
