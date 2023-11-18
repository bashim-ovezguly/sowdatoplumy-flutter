import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Propertie/propertiesDetail.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

const List<String> list = <String>[
  'Ulgama gir',
  'ulgamda cyk',
  'bilemok',
  'ozin karar'
];

class Properties extends StatefulWidget {
  Properties({Key? key}) : super(key: key);
  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  String dropdownValue = list.first;
  List<dynamic> dataSlider = [
    {"img": "", 'name': "", 'price': "", 'location': ''}
  ];

  List<dynamic> data = [];
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool determinate1 = false;
  bool status = true;

  bool filter = false;
  callbackFilter() {
    setState(() {
      timers();
      determinate = false;
      determinate1 = false;
      getflatslist();
      getconstruction_slider();
    });
  }

  void initState() {
    timers();
    getflatslist();
    getconstruction_slider();
    super.initState();
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
      if (determinate == false) {
        status = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: const Text(
                "Emläkler",
                style: CustomText.appBarText,
              ),
              actions: [
                Row(
                  children: <Widget>[
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              showConfirmationDialog(context);
                            },
                            child: const Icon(Icons.sort, size: 25))),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search(index: 3)));
                            },
                            child: Icon(Icons.search,
                                color: Colors.white, size: 25)))
                  ],
                )
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                    determinate1 = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            childCount: 1,
                            (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    textDirection: TextDirection.rtl,
                                    fit: StackFit.loose,
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        height: 220,
                                        color: Colors.white,
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                              height: 220,
                                              viewportFraction: 1,
                                              initialPage: 0,
                                              enableInfiniteScroll:
                                                  dataSlider.length > 1
                                                      ? true
                                                      : false,
                                              reverse: false,
                                              autoPlay: dataSlider.length > 1
                                                  ? true
                                                  : false,
                                              autoPlayInterval:
                                                  const Duration(seconds: 4),
                                              autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              enlargeFactor: 0.3,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _current = index;
                                                });
                                              }),
                                          items: dataSlider
                                              .map((item) => GestureDetector(
                                                    onTap: () {
                                                      if (item['id'] != null &&
                                                          item['id'] != '') {
                                                        Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              type: PageTransitionType
                                                                  .leftToRight,
                                                              child: PropertiesDetail(
                                                                  id: item['id']
                                                                      .toString())),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Center(
                                                          child: Stack(
                                                        children: [
                                                          ClipRect(
                                                            child: Container(
                                                              height: 220,
                                                              width: double
                                                                  .infinity,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
                                                                child: item['img'] !=
                                                                            null &&
                                                                        item['img'] !=
                                                                            ''
                                                                    ? Image
                                                                        .network(
                                                                        baseurl +
                                                                            item['img'].toString(),
                                                                      )
                                                                    : Image.asset(
                                                                        'assets/images/default16x9.jpg'),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 7),
                                        child: DotsIndicator(
                                          dotsCount: dataSlider.length,
                                          position: _current.toDouble(),
                                          decorator: DotsDecorator(
                                            color: Colors.white,
                                            activeColor: CustomColors.appColors,
                                            activeShape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                            },
                          )),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: data.length,
                              (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.leftToRight,
                                            child: PropertiesDetail(
                                                id: data[index]['id']
                                                    .toString())),
                                      );
                                    },
                                    child: Container(
                                        height: 110,
                                        child: Card(
                                            color: CustomColors.appColorWhite,
                                            shadowColor: const Color.fromARGB(
                                                255, 200, 198, 198),
                                            surfaceTintColor:
                                                CustomColors.appColorWhite,
                                            elevation: 5,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                child: Container(
                                                    height: 110,
                                                    child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                              flex: 1,
                                                              child: ClipRect(
                                                                  child: Container(
                                                                      height:
                                                                          110,
                                                                      child: FittedBox(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          child: data[index]['img'] != ''
                                                                              ? Image.network(baseurl + data[index]['img'].toString())
                                                                              : Image.asset('assets/images/default.jpg'))))),
                                                          Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  color: CustomColors
                                                                      .appColorWhite,
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                            child:
                                                                                Container(alignment: Alignment.centerLeft, child: Text(data[index]['name'].toString(), style: CustomText.itemTextBold))),
                                                                        Expanded(
                                                                            child:
                                                                                Container(alignment: Alignment.centerLeft, child: Text(data[index]['location'].toString(), overflow: TextOverflow.clip, maxLines: 2, softWrap: false, style: CustomText.itemText))),
                                                                        Expanded(
                                                                            child:
                                                                                Row(children: [
                                                                          Expanded(
                                                                              child: Align(
                                                                                  alignment: Alignment
                                                                                      .topCenter,
                                                                                  child: Row(children: <Widget>[
                                                                                    Text(data[index]['price'].toString(), style: CustomText.itemText)
                                                                                  ]))),
                                                                          Expanded(
                                                                              child: Align(
                                                                                  alignment: Alignment.topCenter,
                                                                                  child: Row(children: <Widget>[
                                                                                    SizedBox(width: 10),
                                                                                    Text('otag sany: ', style: CustomText.itemText),
                                                                                    Text(data[index]['room_count'].toString(), style: CustomText.itemText)
                                                                                  ])))
                                                                        ])),
                                                                        if (data[index]['store_id'] !=
                                                                                null &&
                                                                            data[index]['store_id'] !=
                                                                                '')
                                                                          Expanded(
                                                                              child: Align(alignment: Alignment.centerLeft, child: ElevatedButton(onPressed: () {}, child: Text(data[index]['store_name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: CustomText.itemText))))
                                                                        else
                                                                          Expanded(
                                                                              child: Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Text(data[index]['delta_time'].toString(),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: CustomText.itemText),
                                                                          ))
                                                                      ])))
                                                        ]))))));
                              },
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColors))),
            drawer: MyDraver(),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context) {
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          sort_value: sort,
          callbackFunc: callbackFilter,
        );
      },
    );
  }

  void getflatslist() async {
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    print(sort_value);

    if (int.parse(sort) == 2) {
      sort_value = 'sort=price';
    }

    if (int.parse(sort) == 3) {
      sort_value = 'sort=-price';
    }

    if (int.parse(sort) == 4) {
      sort_value = 'sort=id';
    }

    if (int.parse(sort) == 4) {
      sort_value = 'sort=-id';
    }
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/flats';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      print(json['data']);
      data = json['data'];
      baseurl = server_url.get_server_url();
      determinate = true;
    });
  }

  void getconstruction_slider() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/flats?on_slider=1';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider = json['data'];
      baseurl = server_url.get_server_url();
      if (dataSlider.length == 0) {
        dataSlider = [
          {"img": "", 'name_tm': "", 'price': "", 'location': ''}
        ];
      }
      determinate1 = true;
    });
  }
}
