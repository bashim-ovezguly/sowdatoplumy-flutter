import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'package:my_app/dB/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersion extends StatefulWidget {
  final List<dynamic> items;
  final Function callbackFunc;
  final String oldData;

  NewVersion(
      {required this.items, required this.callbackFunc, this.oldData = ''});
  @override
  _NewVersionState createState() =>
      _NewVersionState(callbackFunc: callbackFunc, items: items);
}

class _NewVersionState extends State<NewVersion> {
  final List<dynamic> items;
  String? selectedItem;
  final Function callbackFunc;

  void initState() {
    super.initState();
  }

  _NewVersionState({required this.callbackFunc, required this.items});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: CustomColors.appColorWhite,
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    Text(
                        "Programmanyň täze wersiýasyny ýükläp almagyňyzy haýyş edýäris!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CustomColors.appColor, fontSize: 18)),
                  ]))),
          Expanded(
              flex: 3,
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width / 3,
                    )),
              )),
          Text(
            'Business Complex',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: CustomColors.appColor),
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 137, 249),
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        const url =
                            'https://play.google.com/store/apps/details?id=com.sowdatoplumy.sowdatoplumy';
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await FlutterWebBrowser.openWebPage(url: url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text("Ýükläp al",
                          style: TextStyle(
                              color: CustomColors.appColorWhite, fontSize: 18)),
                    )),
              )),
        ],
      ),
    ));
  }
}
