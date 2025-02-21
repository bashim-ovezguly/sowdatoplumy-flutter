import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RequiredUpdate extends StatefulWidget {
  const RequiredUpdate({super.key});

  @override
  State<RequiredUpdate> createState() => _RequiredUpdateState();
}

class _RequiredUpdateState extends State<RequiredUpdate> {
  var data = {};
  var device_id = '';
  var language = 'TM';

  bool status = false;
  void initState() {
    // getAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: const Text("Täzeleniş", style: CustomText.appBarText)),
        body: Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 120,
                      color: CustomColors.appColor,
                    ),
                    Text(
                      'Programmany soňky wersiýa täzelemegiňizi haýyş edýäris!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    MaterialButton(
                      color: CustomColors.appColor,
                      textColor: Colors.white,
                      onPressed: () {
                        launchUrl(Uri.parse('http://business-complex.com.tm'));
                      },
                      child: Text(
                        'Web saýtdan ýükläp almak',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 18),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  Future<void> getAppInfo() async {
    String url = serverIp + '/about_us';

    var pref = await SharedPreferences.getInstance();
    setState(() {
      device_id = pref.getString('device_id').toString();
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
