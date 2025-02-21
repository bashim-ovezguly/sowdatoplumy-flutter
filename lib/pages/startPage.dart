import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/HomePage.dart';
import 'package:my_app/pages/Update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoading = true;
  List<dynamic> dataSlider1 = [];
  List<dynamic> dataSlider2 = [];
  List<dynamic> dataSlider3 = [];
  List<dynamic> stores_list = [];
  List<dynamic> cars = [];
  List<dynamic> parts = [];
  List<dynamic> productsList = [];
  List<dynamic> messages = [];
  List<dynamic> trade_centers = [];
  String storeCount = '';

  var region = {};

  bool tryAgain = false;
  bool update = false;
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 300), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  fetchData() async {
    final pref = await SharedPreferences.getInstance();
    final uri = Uri.parse(homePageUrl);
    global_headers['device-id'] = await pref.getString('device_id').toString();
    if (await pref.getInt('location') != null) {
      global_headers['location-id'] = await pref.getInt('location').toString();
    }
    final response = await http.get(uri, headers: global_headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    pref.setBool('update', json['data']['update']);
    if (json['data']['update'] == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RequiredUpdate()),
          (Route<dynamic> route) => false);
    }

    if (mounted) {
      setState(() {
        region = {
          'id': pref.getInt('location'),
          'name_tm': pref.getString('location_name')
        };

        isLoading = false;

        cars = json['data']['cars'];
        stores_list = json['data']['stores'];
        parts = json['data']['parts'];
        productsList = json['data']['products'];
        dataSlider1 = json['data']['slider1'];
        dataSlider2 = json['data']['slider2'];
        dataSlider3 = json['data']['slider3'];

        if (json['data']['update'] == true) {
          update = true;
        }
      });
    }
  }

  _StartPageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset('assets/images/logo.png',
                  width: MediaQuery.sizeOf(context).width * 0.5),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Söwda toplumy',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: CustomColors.appColor),
              ),
            ),
            Text(
              'business-complex.com.tm',
              style: TextStyle(fontSize: 20, color: CustomColors.appColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SizedBox(
                child: LinearProgressIndicator(),
                width: 200,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
