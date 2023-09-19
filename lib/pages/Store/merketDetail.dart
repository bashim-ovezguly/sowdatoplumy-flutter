import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/order.dart';
import 'package:my_app/pages/Store/producrt.dart';
import 'package:my_app/pages/Store/storeCars.dart';
import 'package:my_app/pages/Store/storeFlats.dart';
import 'package:my_app/pages/Store/storeMaterials.dart';
import 'package:my_app/pages/Store/storeParts.dart';
import 'package:my_app/pages/Store/storeServices.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../../main.dart';
import '../Customer/login.dart';
import '../Customer/myPages.dart';
import '../fullScreenSlider.dart';

class MarketDetail extends StatelessWidget {
  MarketDetail({Key? key, required this.id, required this.title})
      : super(key: key);
  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MyTabStatefulWidget(id: id, title: title);
  }
}

class MyTabStatefulWidget extends StatefulWidget {
  MyTabStatefulWidget({super.key, required this.id, required this.title});
  final String id;
  final String title;

  @override
  State<MyTabStatefulWidget> createState() => _MyTabStatefulWidgetState();
}

class _MyTabStatefulWidgetState extends State<MyTabStatefulWidget>
    with TickerProviderStateMixin {
  List<dynamic> products = [];
  List<dynamic> data_tel = [];
  List<String> imgList = [];

  int item_count = 0;
  int _current = 0;

  String modul_name = "Harytlar";
  String modul = "0";
  String store_name = '';
  String delivery_price_str = "";

  bool determinate = false;
  bool determinate1 = false;

  late TabController _tabController;
  var keyword = TextEditingController();
  var shoping_carts = [];
  var data = {};
  var baseurl = "";
  var modules = {};
  var telefon = {};
  int _tabCount = 0;

  refresh_item_count(value) {
    setState(() {
      item_count = value;
    });
  }

  refresh() {
    getsinglemarkets(id: widget.id, title: widget.title);
  }

  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (imgList.length == 0) {
      imgList.add('x');
    }
    setState(() {
      if (modul.toString() == '0') {
        modul_name = 'Harytlar';
      }
      if (modul.toString() == '1') {
        modul_name = 'Awtoulaglar';
      }
      if (modul.toString() == '2') {
        modul_name = 'Awtoşaýlar';
      }
      if (modul.toString() == '3') {
        modul_name = 'Emläkler';
      }
      if (modul.toString() == '4') {
        modul_name = 'Gurluşyk harytlar';
      }
      if (modul.toString() == '5') {
        modul_name = 'Hyzmatlar';
      }
    });

    super.initState();
    getsinglemarkets(id: widget.id, title: widget.title);
    _tabController = TabController(length: _tabCount + 1, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabCount + 1,
        child: Scaffold(backgroundColor: CustomColors.appColorWhite,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              store_name.toString(),
              style: CustomText.appBarText,
            ),
            actions: [
              // Badge(
              //   badgeColor: Colors.green,
              //   badgeContent: Text(
              //     item_count.toString(),
              //     style: const TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   position: BadgePosition(start: 30, bottom: 30),
              //   child: IconButton(
              //     onPressed: () async {
              //       var allRows = await dbHelper.queryAllRows();
              //       var data1 = [];
              //       for (final row in allRows) {
              //         data1.add(row);
              //       }
              //       if (data1.length == 0) {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => Login()));
              //       } else {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => Order(
              //                     store_name: data['name_tm'].toString(),
              //                     store_id: data['id'].toString(),
              //                     refresh: refresh,
              //                     delivery_price: delivery_price_str)));
              //       }
              //     },
              //     icon: const Icon(Icons.shopping_cart),
              //   ),
              // ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
          body: determinate
              ? ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    Stack(
                        alignment: Alignment.bottomCenter,
                        textDirection: TextDirection.rtl,
                        fit: StackFit.loose,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Container(
                              height: 200,
                              margin: const EdgeInsets.all(10),
                              child: GestureDetector(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: 200,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay:
                                            imgList.length > 1 ? true : false,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                    items: imgList
                                        .map((item) => Container(
                                              color: Colors.white,
                                              child: Center(
                                                child: ClipRect(
                                                  child: Container(
                                                    height: 200,
                                                    width: double.infinity,
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: item != 'x'
                                                          ? Image.network(
                                                              item.toString(),
                                                            )
                                                          : Image.asset(
                                                              'assets/images/default16x9.jpg'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  onTap: () {
                                    if (imgList.length == 1 &&
                                        imgList[0] == 'x') {
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenSlider(
                                                      imgList: imgList)));
                                    }
                                  })),
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: DotsIndicator(
                                  dotsCount: imgList.length,
                                  position: _current.toDouble(),
                                  decorator: DotsDecorator(
                                    color: Colors.white,
                                    activeColor: CustomColors.appColors,
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  )))
                        ]),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.access_time_outlined,
                                size: 20,
                                color: CustomColors.appColors,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                data['created_at'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: CustomColors.appColors,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.visibility_sharp,
                                size: 20,
                                color: CustomColors.appColors,
                              ),
                              SizedBox(width: 10),
                              Text(
                                data['viewed'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: CustomColors.appColors,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    if (store_name != '')
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(store_name.toString(),
                            style: TextStyle(
                                color: CustomColors.appColors, fontSize: 20)),
                      ),
                    if (data['location'] != '' && data['location'] != null)
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Row(children: [
                            Icon(Icons.location_on,
                                color: CustomColors.appColors, size: 25),
                            SizedBox(width: 5),
                            Text(data['location']['name'].toString(),
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontSize: 14))
                          ])),
                    if (data['customer'] != '' && data['customer'] != null)
                      GestureDetector(
                          onTap: () {
                            Provider.of<UserInfo>(context, listen: false)
                                .set_user_customer_name(
                                    data['customer']['name']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPages(
                                        user_customer_id: data['customer']['id']
                                            .toString())));
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: Row(children: [
                                Icon(Icons.person,
                                    color: CustomColors.appColors, size: 25),
                                SizedBox(width: 5),
                                Text(data['customer']['name'].toString(),
                                    style: TextStyle(
                                        color: CustomColors.appColors,
                                        fontSize: 14))
                              ]))),
                    if (data['open_at'] != null &&
                        data['open_at'] != '' &&
                        data['close_at'] != null &&
                        data['close_at'] != '')
                      Container(
                          margin: EdgeInsets.only(left: 7, top: 10),
                          child: Row(children: [
                            Icon(Icons.lock_clock,
                                color: CustomColors.appColors, size: 25),
                            SizedBox(width: 5),
                            Text(data['open_at'].toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.appColors)),
                            SizedBox(width: 10),
                            Text(data['close_at'].toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.appColors))
                          ])),
                    Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          for (var i = 0; i < data['contacts'].length; i++)
                            GestureDetector(
                              onTap: () async {
                                if (data['contacts'][i]['type'] == 'phone') {
                                  final call = Uri.parse(
                                      'tel:' + data['contacts'][i]['value']);
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      height: 25,
                                      child: Image.network(
                                        data['contacts'][i]['icon'],
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(width: 5),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Text(
                                        data['contacts'][i]['value'].toString(),
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontSize: 14)),
                                  )
                                ],
                              ),
                            )
                        ]),
                    if (data['body_tm'] != null && data['body_tm'] != '')
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            hintMaxLines: 10,
                            hintStyle: TextStyle(
                                fontSize: 14, color: CustomColors.appColors),
                            hintText: data['body_tm'].toString(),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    TabBar(
                      onTap: (value) {
                        var lists = [];
                        if (modules['products'] > 0) {
                          lists.add('0');
                        }
                        if (modules['cars'] > 0) {
                          lists.add('1');
                        }
                        if (modules['parts'] > 0) {
                          lists.add('2');
                        }
                        if (modules['flats'] > 0) {
                          lists.add('3');
                        }
                        if (modules['materials'] > 0) {
                          lists.add('4');
                        }
                        if (modules['services'] > 0) {
                          lists.add('5');
                        }

                        setState(() {
                          modul = lists[value];
                          if (value.toString() == '0') {
                            modul_name = 'Harytlar';
                          }
                          if (value.toString() == '1') {
                            modul_name = 'Awtoulaglar';
                          }
                          if (value.toString() == '2') {
                            modul_name = 'Awtoşaýlar';
                          }
                          if (value.toString() == '3') {
                            modul_name = 'Emläkler';
                          }
                          if (value.toString() == '4') {
                            modul_name = 'Gurluşyk harytlar';
                          }
                          if (value.toString() == '5') {
                            modul_name = 'Hyzmatlar';
                          }
                        });
                      },
                      controller: _tabController,
                      indicatorColor: CustomColors.appColors,
                      unselectedLabelColor: Colors.black,
                      isScrollable: true,
                      tabs: <Widget>[
                        if (data['modules']['products'] > 0)
                          Tab(
                            child: GestureDetector(
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Harytlar",
                                    style: TextStyle(
                                        color: CustomColors.appColors,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (data['modules']['cars'] > 0)
                          Tab(
                              child: GestureDetector(
                            child: Row(children: const <Widget>[
                              Icon(
                                Icons.settings_applications_sharp,
                                color: CustomColors.appColors,
                              ),
                              Text(
                                "Awtoulaglar",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ]),
                          )),
                        if (data['modules']['parts'] > 0)
                          Tab(
                              child: GestureDetector(
                            child: Row(children: const <Widget>[
                              Icon(
                                Icons.storefront_outlined,
                                color: CustomColors.appColors,
                              ),
                              Text(
                                "Awtoşaýlar",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ]),
                          )),
                        if (data['modules']['flats'] > 0)
                          Tab(
                              child: GestureDetector(
                            child: Row(children: const <Widget>[
                              Icon(
                                Icons.holiday_village,
                                color: CustomColors.appColors,
                              ),
                              Text(
                                "Emläkler",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ]),
                          )),
                        if (data['modules']['materials'] > 0)
                          Tab(
                              child: GestureDetector(
                            child: Row(children: const <Widget>[
                              Icon(
                                Icons.shopify,
                                color: CustomColors.appColors,
                              ),
                              Text(
                                "Gurluşyk harytlar",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ]),
                          )),
                        if (data['modules']['services'] > 0)
                          Tab(
                              child: GestureDetector(
                            child: Row(children: const <Widget>[
                              Icon(
                                Icons.shopify,
                                color: CustomColors.appColors,
                              ),
                              Text(
                                "Hyzmatlar",
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ]),
                          ))
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 130,
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          if (data['modules']['products'] > 0)
                            StoreProducts(
                                id: widget.id,
                                refresh_item_count: refresh_item_count,
                                isTopList: isTopList),
                          if (data['modules']['cars'] > 0)
                            StoreCars(id: widget.id, isTopList: isTopList),
                          if (data['modules']['services'] > 0)
                            StoreServices(id: widget.id, isTopList: isTopList),
                          if (data['modules']['flats'] > 0)
                            StoreFlats(id: widget.id, isTopList: isTopList),
                          if (data['modules']['parts'] > 0)
                            StoreParts(id: widget.id, isTopList: isTopList),
                          if (data['modules']['materials'] > 0)
                            StoreMaterials(id: widget.id, isTopList: isTopList),
                        ],
                      ),
                    )
                  ],
                )
              : Center(child: CircularProgressIndicator(color: CustomColors.appColors)),
        ));
  }

  void getsinglemarkets({required id, required title}) async {
    var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: id);
    for (final row in shoping_cart) {
      shoping_carts.add(row);
    }

    if (shoping_carts.length == 0) {
      Map<String, dynamic> row = {'store_id': int.parse(id)};
      var shoping_cart = await dbHelper.shoping_cart_inser(row);
    }
    var test = await dbHelper.get_shoping_cart_by_store(id: id);
    var array = [];
    for (final row in test) {
      array.add(row);
    }

    var count = await dbHelper.get_shoping_cart_items(
        soping_cart_id: array[0]['id'].toString());
    var array1 = [];
    for (final row in count) {
      array1.add(row);
    }
    setState(() {
      item_count = array1.length;
    });

    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/markets/' + id;

    if (title == "Dükanlar") {
      url = server_url.get_server_url() + '/mob/stores/' + id;
    }
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      var i;
      imgList = [];
      data = json;

      delivery_price_str = json['delivery_price'];
      if (delivery_price_str == '0' || delivery_price_str == '0 TMT') {
        delivery_price_str = 'tölegsiz';
      }
      baseurl = server_url.get_server_url();
      data_tel = json['phones'];
      store_name = data['name_tm'];
      modules = json['modules'];

      var s = 0;
      if (modules['services'] > 0) {
        s = s + 1;
        modul = '5';
      }
      if (modules['materials'] > 0) {
        s = s + 1;
        modul = '4';
      }
      if (modules['flats'] > 0) {
        s = s + 1;
        modul = '3';
      }
      if (modules['parts'] > 0) {
        s = s + 1;
        modul = '2';
      }
      if (modules['cars'] > 0) {
        s = s + 1;
        modul = '1';
      }
      if (modules['products'] > 0) {
        s = s + 1;
        modul = '0';
      }

      _tabController = TabController(length: s, vsync: this, initialIndex: 0);

      if (json['phones'].length != 0) {
        telefon = json['phones'][0];
      }
      for (i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }
      _tabCount = s;
      determinate = true;
      if (imgList.length == 0) {
        imgList.add('x');
      }
    });
  }

  void isTopList() {
    double position = 0.0;
    _scrollController.position.animateTo(position,
        duration: Duration(milliseconds: 100), curve: Curves.easeInCirc);
  }
}
