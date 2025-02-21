import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/db.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Aksiya/List.dart';
import 'package:my_app/pages/TradeCenters/List.dart';
import 'package:my_app/pages/AppInfo.dart';
import 'package:my_app/pages/AdminChat.dart';
import 'package:my_app/pages/news/News.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:my_app/pages/Profile/Profile.dart';
import 'Store/Stores.dart';

const double menuFontSize = 17.0;
const play_market_url =
    'https://play.google.com/store/apps/details?id=com.sowda_toplum.sowda_toplum&hl=ru&gl=US';

const TextStyle menuTextStyle = TextStyle(
    fontSize: menuFontSize,
    fontWeight: FontWeight.w400,
    color: CustomColors.appColor);

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String name = '';
  String phone_number = '';
  String logo_url = '';
  bool login = false;

  late String website_url = 'http://business-complex.com.tm/';

  @override
  void initState() {
    super.initState();

    check_login();
    refreshData();
    get_store_data();
  }

  check_login() async {
    final pref = await SharedPreferences.getInstance();

    if (await pref.getBool('login') == true)
      setState(() {
        this.login = true;
      });
    else {
      setState(() {
        this.login = false;
      });
    }
  }

  get_store_data() async {
    var headers = global_headers;

    final uri = Uri.parse(profileUrl);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 401) {
      final pref = await SharedPreferences.getInstance();
      pref.setBool('login', false);
    }
  }

  refreshData() async {
    final name = await getLocalStorage('name');
    final phone = await getLocalStorage('phone');
    final logo_url = await getLocalStorage('logo_url');

    setState(() {
      try {
        this.name = name.toString();
        this.phone_number = '+993' + phone.toString();
        this.logo_url = logo_url.toString();
      } catch (err) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 5),
                child: SizedBox(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
              ),
              Text(
                'Söwda toplumy',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.appColor),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () async {
                    String url = website_url;
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await FlutterWebBrowser.openWebPage(url: url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'business-complex.com.tm',
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.appColor,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    if (false == true)
                      GestureDetector(
                          onTap: () async {
                            const url = play_market_url;
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await FlutterWebBrowser.openWebPage(url: url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(
                                  left: 12, right: 12, top: 5, bottom: 5),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 5,
                                        color: Colors.grey)
                                  ]),
                              child: Row(children: [
                                SizedBox(width: 10),
                                Image.asset("assets/images/playmarket.png",
                                    width: 30, height: 30, fit: BoxFit.cover),
                                SizedBox(width: 10),
                                Text('Täze wersiýasyny ýükläp alyň!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColor))
                              ]))),
                    GestureDetector(
                      onTap: () async {
                        if (this.login == false) {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(children: [
                              if (this.login)
                                CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      serverIp + logo_url,
                                    ))
                              else
                                CircleAvatar(
                                  backgroundColor: CustomColors.appColor,
                                  radius: 20,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              SizedBox(width: 10),
                              if (this.login == true)
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Text(name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColors.appColor)),
                                      Text(phone_number,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColors.appColor))
                                    ]))
                              else
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          child: Text('Ulgama gir',
                                              style: TextStyle(
                                                  color: CustomColors.appColor,
                                                  fontSize: 17))),
                                    ])
                            ])),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/home");
                        },
                        child: Container(
                            width: double.infinity,
                            // color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(children: [
                              Icon(Icons.home_outlined,
                                  size: 25, color: CustomColors.appColor),
                              SizedBox(width: 14),
                              Text('Baş sahypa', style: menuTextStyle)
                            ]))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsList()));
                        },
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(children: [
                              Icon(Icons.newspaper,
                                  size: 25, color: CustomColors.appColor),
                              SizedBox(width: 14),
                              Text('Habarlar', style: menuTextStyle)
                            ]))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Stores()));
                        },
                        child: Container(
                            // color: Colors.white,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(children: [
                              Icon(
                                Icons.store_outlined,
                                size: 25,
                                color: CustomColors.appColor,
                              ),
                              SizedBox(width: 14),
                              Text('Dükanlar', style: menuTextStyle),
                              Spacer(),
                              Text('',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: CustomColors.appColor)),
                              SizedBox(width: 15),
                            ]))),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/othergoods/list");
                        },
                        child: Container(
                            width: double.infinity,
                            // color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                                child: Row(children: [
                              Icon(
                                Icons.card_giftcard,
                                size: 25,
                                color: CustomColors.appColor,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Text('Harytlar', style: menuTextStyle),
                              Spacer(),
                              Text('',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: CustomColors.appColor)),
                              SizedBox(width: 15),
                            ])))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Lenta()));
                        },
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(children: [
                              Icon(
                                Icons.bookmark_border_outlined,
                                size: 25,
                                color: CustomColors.appColor,
                              ),
                              SizedBox(width: 14),
                              Text('Aksiýalar', style: menuTextStyle),
                            ]))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TradeCenters();
                          }));
                        },
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(children: [
                              Icon(
                                Icons.business_outlined,
                                size: 25,
                                color: CustomColors.appColor,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Text('Söwda merkezler', style: menuTextStyle),
                              Spacer(),
                              Text('',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: CustomColors.appColor)),
                              SizedBox(width: 15),
                            ]))),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/car");
                        },
                        child: Container(
                            // color: Colors.white,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(children: [
                              Icon(
                                Icons.time_to_leave_outlined,
                                size: 25,
                                color: CustomColors.appColor,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Text('Awtoulaglar', style: menuTextStyle),
                              Spacer(),
                              Text('',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: CustomColors.appColor)),
                              SizedBox(width: 15),
                            ]))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminChat()));
                        },
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: GestureDetector(
                                child: Container(
                                    child: Row(children: [
                              Icon(Icons.support_agent,
                                  size: 25, color: CustomColors.appColor),
                              SizedBox(width: 14),
                              Text('Admine ýaz', style: menuTextStyle),
                              SizedBox(width: 15),
                            ]))))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppInfo()));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 25,
                                color: CustomColors.appColor,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Text('Programma barada', style: menuTextStyle),
                              SizedBox(width: 15)
                            ]))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
