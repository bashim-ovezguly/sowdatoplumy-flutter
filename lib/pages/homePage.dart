import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';
import 'package:my_app/pages/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/advertiseDetail.dart';
import 'package:my_app/pages/regionWidget.dart';

import '../main.dart';
import 'Search/search.dart';
import 'Store/Stores.dart';
import 'homePageLocation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

const double menuFontSize = 17.0;
const TextStyle menuTextStyle = TextStyle(
    fontSize: menuFontSize,
    fontWeight: FontWeight.w400,
    color: CustomColors.appColor);

class _HomeState extends State<Home> {
  List<dynamic> dataSlider1 = [];
  List<dynamic> dataSlider2 = [];
  List<dynamic> dataSlider3 = [];
  List<dynamic> stores_list = [];
  List<dynamic> cars = [];
  List<dynamic> parts = [];
  List<dynamic> productsList = [];
  List<dynamic> messages = [];
  String storeCount = '';

  var region = {};

  bool isLoading = true;
  bool tryAgain = false;
  bool update = false;

  BoxShadow bannerBoxShadow =
      BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(0, 2));

  BoxShadow storeBoxShadow =
      BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(0, 2));

  @override
  void initState() {
    super.initState();
    getData();
    getNotifications();
    checkDeviceId();
  }

  setLocation(new_value) async {
    print(new_value);
    final pref = await SharedPreferences.getInstance();

    try {
      pref.setInt('location', new_value['id']);
      pref.setString('location_name', new_value['name_tm']);
    } catch (err) {
      pref.remove('location');
      pref.remove('location_name');
    }
    getData();
  }

  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  alignment: Alignment.centerLeft,
                  child: region != {} && region['name_tm'] != null
                      ? Text(
                          region['name_tm'].toString(),
                          style: TextStyle(
                              fontSize: 12, color: CustomColors.appColorWhite),
                        )
                      : Container()),
            ],
          ),
          actions: [
            Row(children: <Widget>[
              Container(
                  child: GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return LocationWidget(callbackFunc: setLocation);
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
                                builder: (context) => Search(index: 0)));
                      },
                      child: Icon(Icons.search, color: Colors.white, size: 25)))
            ])
          ]),
      body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColor,
          onRefresh: () async {
            this.getData();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: CustomColors.appColor,
                    )),
                  ),
                if (dataSlider1.length > 0)
                  ImageSlideshow(
                      initialPage: 0,
                      height: 250,
                      isLoop: true,
                      autoPlayInterval: 3000,
                      children: [
                        for (var item in dataSlider1)
                          if (item['img'] != null && item['img'] != '')
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdPage(
                                              id: item['id'].toString(),
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 180,
                                      clipBehavior: Clip.hardEdge,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        boxShadow: [bannerBoxShadow],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        serverIp + item['img'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (item['title'] != null)
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          item['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: CustomColors.appColor,
                                              fontSize: 16),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                      ]),
                Row(
                  children: [
                    if (dataSlider2.length > 0)
                      ImageSlideshow(
                          width: MediaQuery.of(context).size.width * 0.5,
                          isLoop: true,
                          autoPlayInterval: 4000,
                          initialPage: 0,
                          children: [
                            for (var item in dataSlider2)
                              if (item['img'] != null && item['img'] != '')
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdPage(
                                                  id: item['id'].toString(),
                                                )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [bannerBoxShadow],
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              serverIp + item['img']),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                          ]),
                    if (dataSlider3.length > 0)
                      ImageSlideshow(
                          initialPage: 0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          isLoop: true,
                          autoPlayInterval: 4500,
                          children: [
                            for (var item in dataSlider3)
                              if (item['img'] != null && item['img'] != '')
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdPage(
                                                  id: item['id'].toString(),
                                                )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      boxShadow: [bannerBoxShadow],
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              serverIp + item['img']),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                          ]),
                  ],
                ),
                if (stores_list.length > 0)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Stores()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        "Dükanlar",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: stores_list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoreDetail(
                                      id: stores_list[index]['id'],
                                    )));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.all(2),
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [storeBoxShadow],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.network(
                                  serverIp + stores_list[index]['logo'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.6,
                                    child: Text(
                                      stores_list[index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: CustomColors.appColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                      ),
                                      Text(stores_list[index]['location']),
                                    ],
                                  ),
                                  Text(stores_list[index]['category'])
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDatasPage(index: 0)));
          },
          child: Icon(Icons.add, color: Colors.white)),
    );
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

  Widget item(int index) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => AdminMessage(user: user)));
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: Container(
            height: 100,
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Card(
                color: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                shadowColor: CustomColors.appColorWhite,
                elevation: 5,
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messages[index]['created_at'].toString(),
                                    style: TextStyle(
                                        color: CustomColors.appColor)),
                                Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        this.messages.removeAt(index);
                                      });
                                    },
                                    child:
                                        Icon(Icons.close, color: Colors.black))
                              ]),
                          SizedBox(
                              child: Text(messages[index]['name'].toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: CustomColors.appColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(
                              child: Text(messages[index]['msg'].toString(),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: CustomColors.appColor,
                                      fontSize: 13)))
                        ])))),
      ),
    );
  }

  void getNotifications() async {
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

    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      messages = json;
    });
  }

  void checkDeviceId() async {
    Map<String, String> headers = global_headers;

    final pref = await SharedPreferences.getInstance();

    var device_id = await pref.getString('device_id').toString();
    if (device_id == 'null') {
      final response =
          await http.get(Uri.parse(device_id_url), headers: headers);
      final response_json = jsonDecode(utf8.decode(response.bodyBytes));
      final generated_dev_id = response_json['device_id'];
      pref.setString('device_id', generated_dev_id);
    }
  }

  void getData() async {
    final pref = await SharedPreferences.getInstance();
    final uri = Uri.parse(homePageUrl);
    global_headers['device-id'] = await pref.getString('device_id').toString();
    if (await pref.getInt('location') != null) {
      global_headers['location-id'] = await pref.getInt('location').toString();
    }
    final response = await http.get(uri, headers: global_headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    pref.setBool('update', json['data']['update']);

    setState(() {});

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
