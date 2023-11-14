// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/pages/Notifications/notificationsDetail.dart';
import 'package:my_app/pages/Restaurants/list.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/appInfo.dart';
import 'package:my_app/pages/chatAdmin.dart';
import 'package:my_app/pages/messageAdmin.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:my_app/pages/ribbon/ribbonList.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:my_app/pages/adPage.dart';
import 'package:my_app/pages/regionWidget.dart';
import 'package:my_app/dB/colors.dart';
import '../dB/providers.dart';
import '../main.dart';
import 'Search/search.dart';
import 'Store/store.dart';
import 'homePageLocation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool a = false;
  bool status = true;
  List<dynamic> dataSlider1 = [];
  List<dynamic> dataSlider2 = [];
  List<dynamic> dataSlider3 = [];
  List<dynamic> stores_list = [];
  List<dynamic> announcements_list = [];
  List<dynamic> items = [];
  List<dynamic> messages = [];
  String store_count = '';
  var region = {};
  bool determinate = false;
  bool determinate1 = false;
  var baseurl = "";

  void initState() {
    timers();
    get_userinfo();
    get_messages();
    setState(() {
      determinate = false;
      status = true;
      region = Provider.of<UserInfo>(context, listen: false).regionsCode;
    });
    getHomePage();
    super.initState();
  }

  callbackLocation(new_value) {
    setState(() {
      Provider.of<UserInfo>(context, listen: false)
          .chang_Region_Code(new_value);
      region = Provider.of<UserInfo>(context, listen: false).regionsCode;
      determinate = false;
      getHomePage();
    });
  }

  timers() async {
    setState(() {
      status = true;
    });
    final completer = Completer();
    final t = Timer(Duration(seconds: 5), () => completer.complete());
    print(t);
    await completer.future;
    setState(() {
      status = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserInfo>(context, listen: false).user_info;

    return determinate1 == true
        ? Scaffold(
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
                          Text("Programmanyň täze wersiýasyny",
                              style: TextStyle(
                                  color: CustomColors.appColors, fontSize: 18)),
                          Text("ýükläp alyň!",
                              style: TextStyle(
                                  color: CustomColors.appColors, fontSize: 18))
                        ]
                      )
                    )),
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
                Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 0, 137, 249),
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              const url =
                                  'https://play.google.com/store/apps/details?id=com.sowda_toplum.sowda_toplum&hl=ru&gl=US';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await FlutterWebBrowser.openWebPage(url: url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text("Ýükläp al",
                                style: TextStyle(
                                    color: CustomColors.appColorWhite,
                                    fontSize: 18)),
                          )),
                    )),
                Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/images/google-play.png')),
                    )),
              ],
            ),
          ))
        : status == false && determinate1 == false
            ? Scaffold(
                backgroundColor: CustomColors.appColorWhite,
                appBar: AppBar(
                    title: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Baş sahypa",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 3),
                            alignment: Alignment.centerLeft,
                            child: region != {} && region['name_tm'] != null
                                ? Text(
                                    region['name_tm'].toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.appColorWhite),
                                  )
                                : Container()),
                      ],
                    ),
                    actions: [
                      Row(children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RibbonList()));
                                },
                                child: Stack(
                                  children: [
                                    Icon(Icons.bookmark_border,
                                        color: Colors.white),
                                    Positioned(
                                        right: 0,
                                        child: Icon(Icons.circle,
                                            size: 10, color: Colors.green))
                                  ],
                                ))),
                        Container(
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return LocationWidget(
                                          callbackFunc: callbackLocation);
                                    },
                                  );
                                },
                                child: const Icon(Icons.location_on,
                                    size: 25, color: Colors.white))),
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Search(index: 0)));
                                },
                                child: Icon(Icons.search,
                                    color: Colors.white, size: 25)))
                      ])
                    ]),
                body: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: CustomColors.appColors,
                    onRefresh: () async {
                      setState(() {
                        determinate = false;
                        initState();
                      });
                      return Future<void>.delayed(const Duration(seconds: 3));
                    },
                    child: determinate
                        ? Stack(
                            children: [
                              CustomScrollView(
                                  physics: ClampingScrollPhysics(),
                                  slivers: [
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                      childCount: 1,
                                      (BuildContext context, int index) {
                                        return ClipRRect(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10,
                                                left: 5,
                                                right: 5,
                                                top: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              child: Container(
                                                child: ImageSlideshow(
                                                  indicatorColor:
                                                      CustomColors.appColors,
                                                  indicatorBackgroundColor:
                                                      Colors.grey,
                                                  disableUserScrolling:
                                                      dataSlider1.length > 1
                                                          ? false
                                                          : true,
                                                  onPageChanged: (value) {},
                                                  autoPlayInterval: 6666,
                                                  isLoop: true,
                                                  children: [
                                                    if (dataSlider1.length == 0)
                                                      ClipRect(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: Image.asset(
                                                                'assets/images/default.jpg'),
                                                          ),
                                                        ),
                                                      ),
                                                    for (var item
                                                        in dataSlider1)
                                                      if (item['img'] != null &&
                                                          item['img'] != '')
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AdPage(
                                                                              id: item['id'].toString(),
                                                                            )));
                                                          },
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    baseurl +
                                                                        item[
                                                                            'img']),
                                                                fit: BoxFit
                                                                    .cover, // -> 02
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                      childCount: 1,
                                      (BuildContext context, int index) {
                                        return ClipRRect(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  child: Container(
                                                    height: 180,
                                                    color: Colors.black12,
                                                    child: ImageSlideshow(
                                                      width: double.infinity,
                                                      initialPage: 0,
                                                      indicatorColor:
                                                          CustomColors
                                                              .appColors,
                                                      disableUserScrolling:
                                                          dataSlider2.length > 1
                                                              ? false
                                                              : true,
                                                      indicatorBackgroundColor:
                                                          Colors.grey,
                                                      onPageChanged: (value) {},
                                                      autoPlayInterval: 5555,
                                                      isLoop: true,
                                                      children: [
                                                        if (dataSlider2
                                                                .length ==
                                                            0)
                                                          ClipRect(
                                                            child: Container(
                                                              height: 220,
                                                              width: double
                                                                  .infinity,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
                                                                child: Image.asset(
                                                                    'assets/images/default.jpg'),
                                                              ),
                                                            ),
                                                          ),
                                                        for (var item
                                                            in dataSlider2)
                                                          if (item['img'] !=
                                                                  null &&
                                                              item['img'] != '')
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => AdPage(
                                                                                id: item['id'].toString(),
                                                                              )));
                                                                },
                                                                child: ClipRect(
                                                                  child:
                                                                      Container(
                                                                    height: 220,
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      child: Image
                                                                          .network(
                                                                        baseurl +
                                                                            item['img'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  child: Container(
                                                    height: 180,
                                                    color: Colors.black12,
                                                    child: ImageSlideshow(
                                                      disableUserScrolling:
                                                          dataSlider3.length > 1
                                                              ? false
                                                              : true,
                                                      width: double.infinity,
                                                      initialPage: 0,
                                                      indicatorColor:
                                                          CustomColors
                                                              .appColors,
                                                      indicatorBackgroundColor:
                                                          Colors.grey,
                                                      onPageChanged: (value) {},
                                                      autoPlayInterval: 4444,
                                                      isLoop: true,
                                                      children: [
                                                        if (dataSlider3
                                                                .length ==
                                                            0)
                                                          ClipRect(
                                                              child: Container(
                                                                  height: 220,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/images/default.jpg'),
                                                                  ))),
                                                        for (var item
                                                            in dataSlider3)
                                                          if (item['img'] !=
                                                                  null &&
                                                              item['img'] != '')
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => AdPage(
                                                                                id: item['id'].toString(),
                                                                              )));
                                                                },
                                                                child: ClipRect(
                                                                    child: Container(
                                                                        height: 220,
                                                                        width: double.infinity,
                                                                        child: FittedBox(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          child:
                                                                              Image.network(
                                                                            baseurl +
                                                                                item['img'],
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ))))
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                              ])),
                                        );
                                      },
                                    )),
                                    if (stores_list.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              childCount: 1,
                                              (BuildContext context,
                                                  int index) {
                                        return Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 5, bottom: 5),
                                            child: Text('Dükanlar',
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)));
                                      })),
                                    if (stores_list.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              childCount: stores_list.length,
                                              (BuildContext context,
                                                  int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MarketDetail(
                                                              id: stores_list[
                                                                          index]
                                                                      ['id']
                                                                  .toString(),
                                                              title:
                                                                  'Dükanlar')));
                                            },
                                            child: Container(
                                                height: 110,
                                                child: Card(
                                                    color: CustomColors
                                                        .appColorWhite,
                                                    shadowColor:
                                                        const Color.fromARGB(
                                                            255, 200, 198, 198),
                                                    surfaceTintColor:
                                                        CustomColors
                                                            .appColorWhite,
                                                    elevation: 5,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        child: Container(
                                                            height: 110,
                                                            child: Row(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                          child:
                                                                              ClipRect(child: Container(height: 110, width: double.infinity, child: FittedBox(fit: BoxFit.cover, child: stores_list[index]['img'] != null && stores_list[index]['img'] != '' ? Image.network(baseurl + stores_list[index]['img'].toString()) : Image.asset('assets/images/default.jpg')))))),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                          margin: EdgeInsets.only(left: 2),
                                                                          padding: const EdgeInsets.all(5),
                                                                          color: CustomColors.appColorWhite,
                                                                          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                                            SizedBox(height: 10),
                                                                            Expanded(child: Align(alignment: Alignment.topLeft, child: Text(stores_list[index]['name'].toString(), overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(color: CustomColors.appColors, fontSize: 14, fontWeight: FontWeight.bold)))),
                                                                            SizedBox(height: 5),
                                                                            Expanded(child: Container(alignment: Alignment.centerLeft, child: Text(stores_list[index]['location'].toString(), overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(color: CustomColors.appColors, fontSize: 14)))),
                                                                            SizedBox(height: 5),
                                                                            Expanded(child: Container(alignment: Alignment.centerLeft, child: Text(stores_list[index]['description'].toString(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: CustomColors.appColors, fontSize: 14)))),
                                                                            SizedBox(height: 10)
                                                                          ])))
                                                                ]))))));
                                      })),
                                    if (announcements_list.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              childCount: 1,
                                              (BuildContext context,
                                                  int index) {
                                        return Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 5, bottom: 5),
                                            child: Text('Bildirişler',
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)));
                                      })),
                                    if (announcements_list.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              childCount:
                                                  announcements_list.length,
                                              (BuildContext context,
                                                  int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NotificationsDetail(
                                                              id: announcements_list[
                                                                          index]
                                                                      ['id']
                                                                  .toString(),
                                                              title:
                                                                  'Bildiriş')));
                                            },
                                            child: Container(
                                                height: 110,
                                                child: Card(
                                                    color: CustomColors
                                                        .appColorWhite,
                                                    shadowColor:
                                                        const Color.fromARGB(
                                                            255, 200, 198, 198),
                                                    surfaceTintColor:
                                                        CustomColors
                                                            .appColorWhite,
                                                    elevation: 5,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        child: Container(
                                                            height: 110,
                                                            child: Row(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                          child:
                                                                              ClipRect(child: Container(height: 110, width: double.infinity, child: FittedBox(fit: BoxFit.cover, child: announcements_list[index]['img'] != null && announcements_list[index]['img'] != '' ? Image.network(baseurl + announcements_list[index]['img'].toString()) : Image.asset('assets/images/default.jpg')))))),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                          margin: EdgeInsets.only(left: 2),
                                                                          padding: const EdgeInsets.all(5),
                                                                          color: CustomColors.appColorWhite,
                                                                          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                                            SizedBox(height: 10),
                                                                            Expanded(child: Align(alignment: Alignment.topLeft, child: Text(announcements_list[index]['name'].toString(), overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(color: CustomColors.appColors, fontSize: 14, fontWeight: FontWeight.bold)))),
                                                                            SizedBox(height: 5),
                                                                            Expanded(child: Container(alignment: Alignment.centerLeft, child: Text(announcements_list[index]['created_at'].toString(), overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(color: CustomColors.appColors, fontSize: 14)))),
                                                                            SizedBox(height: 5),
                                                                            Expanded(child: Container(alignment: Alignment.centerLeft, child: Text(announcements_list[index]['location'].toString(), overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(color: CustomColors.appColors, fontSize: 14)))),
                                                                            SizedBox(height: 10)
                                                                          ])))
                                                                ]))))));
                                      }))
                                  ]),
                              ListView.builder(
                                  itemCount: messages.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print(user);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminMessage(user: user)));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          child: Card(
                                              color: CustomColors.appColorWhite,
                                              surfaceTintColor:
                                                  CustomColors.appColorWhite,
                                              shadowColor:
                                                  CustomColors.appColorWhite,
                                              elevation: 5,
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  messages[index]
                                                                          [
                                                                          'created_at']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: CustomColors
                                                                          .appColors)),
                                                              Spacer(),
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                       this.messages.removeAt(index);
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .black))
                                                            ]),
                                                        SizedBox(
                                                            child: Text(
                                                                messages[index]
                                                                        ['name']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    color: CustomColors
                                                                        .appColors,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        SizedBox(
                                                            child: Text(
                                                                messages[index]
                                                                        ['msg']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: CustomColors
                                                                        .appColors,
                                                                    fontSize:
                                                                        13)))
                                                      ])))),
                                    );
                                  })
                            ],
                          )
                        : CustomProgressIndicator(funcInit: initState)),
                drawer: MyDraver(),
                floatingActionButton: FloatingActionButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topLeft: Radius.circular(100))),
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      var datas = [];
                      var allRows = await dbHelper.queryAllRows();
                      for (final row in allRows) {
                        datas.add(row);
                      }
                      if (datas.length == 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDatasPage(index: 0)));
                      }
                    },
                    child: Icon(Icons.add, color: Colors.white)))
            : HomePageProgressIndicator(
                funcInit: initState, determinate1: determinate1);
  }

  showConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RegionWidget();
      },
    );
  }

  void get_messages() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/notifs?status=preview';

    var data1 = [];
    var allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      data1.add(row);
    }
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    if (data1.length > 0) {
      headers['Token'] = data1[0]['name'];
    }

    print("");
    print(headers);
    print("");

    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      messages = json;
      print(messages);
    });
  }

  void getHomePage() async {
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/home_ads';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      baseurl = server_url.get_server_url();
      dataSlider1 = json['data']['slider1'];
      if (dataSlider1.length == 0) {
        dataSlider1 = [
          {"img": "", 'name': "", 'location': ''}
        ];
      }
      dataSlider2 = json['data']['slider2'];
      if (dataSlider2.length == 0) {
        dataSlider2 = [
          {"img": "", 'name': "", 'location': ''}
        ];
      }
      dataSlider3 = json['data']['slider3'];
      if (dataSlider3.length == 0) {
        dataSlider3 = [
          {"img": "", 'name': "", 'location': ''}
        ];
      }
      stores_list = json['data']['stores_list'];
      announcements_list = json['data']['announcements_list'];

      if (dataSlider1.length != 0) {
        setState(() {
          determinate = true;
          status = false;
        });
      }

      Map<String, dynamic> new_statistic = {
        "store_count": json['data']['store_count'].toString(),
        "pharmacy_count": json['data']['pharmacy_count'].toString(),
        "bazar_count": json['data']['bazar_count'].toString(),
        "shopping_center_count":
            json['data']['shopping_center_count'].toString(),
        "car_count": json['data']['car_count'].toString(),
        "part_count": json['data']['part_count'].toString(),
        "product_count": json['data']['product_count'].toString(),
        "factory_count": json['data']['factory_count'].toString(),
        "flat_count": json['data']['flat_count'].toString(),
        "announcements": json['data']['announcements'].toString(),
        "count_message": json['data']['notifs'].toString(),
      };
      if (json['data']['update'] == true) {
        determinate1 = true;
      }
      Provider.of<UserInfo>(context, listen: false)
          .set_statistic(new_statistic);
      Provider.of<UserInfo>(context, listen: false)
          .set_update_app(json['data']['update']);
      // Provider.of<UserInfo>(context, listen: false).set_update_app(false);
    });
  }

  void get_userinfo() async {
    var all_ids = await dbHelper.get_all_divive_id();
    var _allids = [];
    var data = [];
    final response;
    String url;

    for (final row in all_ids) {
      _allids.add(row);
    }
    if (_allids.length == 0) {
      Urls server_url = new Urls();
      url = server_url.get_server_url() + '/mob/device_id';
      final uri = Uri.parse(url);
      Map<String, String> headers = {};
      for (var i in global_headers.entries) {
        headers[i.key] = i.value.toString();
      }
      var response1 = await http.get(uri, headers: headers);
      final json = jsonDecode(utf8.decode(response1.bodyBytes));
      Map<String, dynamic> row = {'id': json['device_id']};
      var device = await dbHelper.insert2(row);
      Provider.of<UserInfo>(context, listen: false)
          .set_device_id(json['device_id']);
    } else {
      Provider.of<UserInfo>(context, listen: false)
          .set_device_id(_allids[0]['id']);
    }

    var allRows = await dbHelper.queryAllRows();
    Urls server_url = new Urls();
    for (final row in allRows) {
      data.add(row);
    }
    if (data.length > 0) {
      url = server_url.get_server_url() +
          '/mob/customer/' +
          data[0]['userId'].toString();
      final uri = Uri.parse(url);

      Map<String, String> headers = {};
      for (var i in global_headers.entries) {
        headers[i.key] = i.value.toString();
      }
      headers['Token'] = data[0]['name'];
      response = await http.get(uri, headers: headers);
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        Provider.of<UserInfo>(context, listen: false)
            .set_user_info(json['data']);
        baseurl = server_url.get_server_url();
      });
      Provider.of<UserInfo>(context, listen: false)
          .setAccessToken(data[0]['name'], data[0]['age']);
    }
  }
}

class MyDraver extends StatefulWidget {
  const MyDraver({super.key});
  @override
  State<MyDraver> createState() => _MyDraverState();
}

class _MyDraverState extends State<MyDraver> {
  String base_url = '';
  @override
  void initState() {
    Urls server_url = new Urls();
    setState(() {
      base_url = server_url.get_server_url();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statistic = Provider.of<UserInfo>(context, listen: false).statistic;
    var user = Provider.of<UserInfo>(context, listen: false).user_info;
    var updateApp = Provider.of<UserInfo>(context, listen: false).updateApp;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                child: Image.asset(
                  'assets/images/lllll.jpeg',
                  height: 140,
                  width: 200,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                const url = 'http://business-complex.com.tm/';
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
                      Image.asset(
                        'assets/images/browser_internet.png',
                        height: 30,
                        width: 30,
                      ),
                      Text(
                        '  business-complex.com.tm',
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.appColors,
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final allRows = await dbHelper.queryAllRows();
                      if (allRows.length == 0) {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyPages()));
                      }
                    },
                    child: Container(
                        color: CustomColors.appColors,
                        width: double.infinity,
                        height: 50,
                        child: Row(children: [
                          SizedBox(width: 20),
                          if (user['img'] != '' && user['img'] != null)
                            CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 206, 204, 204),
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  base_url + user['img'],
                                ))
                          else
                            Image.asset('assets/images/person.png',
                                width: 40,
                                height: 40,
                                color: CustomColors.appColorWhite),
                          SizedBox(width: 10),
                          if (user['name'] != null &&
                              user['name'] != '' &&
                              user['phone'] != null &&
                              user['phone'] != '')
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5),
                                  Expanded(
                                      child: Text(user['name'].toString(),
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Expanded(
                                      child: Text(user['phone'].toString(),
                                          style:
                                              TextStyle(color: Colors.white)))
                                ])
                          else
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text('Ulgama gir',
                                          style:
                                              TextStyle(color: Colors.white))),
                                ])
                        ])),
                  ),
                  if (updateApp == true)
                    GestureDetector(
                      onTap: () async {
                        const url =
                            'https://play.google.com/store/apps/details?id=com.sowda_toplum.sowda_toplum&hl=ru&gl=US';
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await FlutterWebBrowser.openWebPage(url: url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Image.asset(
                              "assets/images/playmarket.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Täze wersiýasyny ýükläp alyň!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.appColors,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/");
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/");
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.home,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text(
                                  'Baş sahypa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColors,
                                  ),
                                ),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Store(title: "Dükanlar")));
                      },
                      child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Store(title: "Dükanlar")));
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.store_outlined,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Dükanlar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['store_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/othergoods/list");
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/othergoods/list");
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.newspaper,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Harytlar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['product_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/car");
                      },
                      child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/car");
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.car_repair,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Awtoulaglar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['car_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/autoParts");
                      },
                      child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/autoParts");
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.settings_outlined,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Awtoşaýlar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['part_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/properties/list");
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/properties/list");
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(Icons.other_houses,
                                    size: 25, color: CustomColors.appColors),
                                SizedBox(width: 14),
                                Text('Gozgalmaýan emläkler',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['flat_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Restaurant(
                                      title: "Naharhanalar",
                                    )));
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Restaurant(
                                              title: "Naharhanalar",
                                            )));
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.restaurant,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Naharhanalar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['flat_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Store(title: "Söwda merkezler")));
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Store(title: "Söwda merkezler")));
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.store,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Söwda merkezler',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['shopping_center_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/pharmacies/list");
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/pharmacies/list");
                              },
                              child: Container(
                                  child: Row(children: [
                                Icon(
                                  Icons.local_pharmacy_sharp,
                                  size: 25,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text('Dermanhanalar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                Spacer(),
                                Text(statistic['pharmacy_count'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.appColors)),
                                SizedBox(width: 15),
                              ]))))),
                  GestureDetector(
                      onTap: () {
                        print(user);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminMessage(user: user)));
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              child: Container(
                                  child: Row(children: [
                            Icon(Icons.notifications,
                                size: 25, color: CustomColors.appColors),
                            SizedBox(width: 14),
                            Text('Habarnamalar',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColors)),
                            SizedBox(width: 15),
                            Spacer(),
                            Text(statistic['count_message'].toString() + "   ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColors)),
                          ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatAdmin()));
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              child: Container(
                                  child: Row(children: [
                            Icon(Icons.chat_sharp,
                                size: 25, color: CustomColors.appColors),
                            SizedBox(width: 14),
                            Text('Admine ýaz',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]))))),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AppInfo()));
                      },
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                              child: Container(
                                  child: Row(children: [
                            Icon(
                              Icons.info,
                              size: 25,
                              color: CustomColors.appColors,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Text('Programma barada',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColors)),
                            SizedBox(width: 15)
                          ]))))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
