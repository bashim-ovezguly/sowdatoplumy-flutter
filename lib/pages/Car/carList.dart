import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/Car/carDetail.dart';
import 'package:my_app/pages/Drawer.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:page_transition/page_transition.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

class Car extends StatefulWidget {
  const Car({Key? key}) : super(key: key);

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  List<dynamic> dataSlider = [
    {"img": "", 'name_tm': "", 'price': "", 'location': ''}
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
      determinate = false;
      determinate1 = false;
      getcarlist();
      getcars_slider();
    });
  }

  void initState() {
    getcarlist();
    getcars_slider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: const Text(
                "Awtoulaglar",
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
                            child: const Icon(
                              Icons.sort,
                              size: 25,
                            ))),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search(index: 0)));
                            },
                            child: Icon(Icons.search,
                                color: Colors.white, size: 25)))
                  ],
                ),
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColor,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                    determinate1 = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? CustomScrollView(slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          childCount: 1,
                          (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              textDirection: TextDirection.rtl,
                              fit: StackFit.loose,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Container(
                                  height: 220,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: 220,
                                        viewportFraction: 1,
                                        initialPage: 1,
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
                                    items: dataSlider
                                        .map((item) => GestureDetector(
                                              onTap: () {
                                                if (item['id'] != "") {
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .leftToRight,
                                                        child: CarDetail(
                                                          id: item['id'],
                                                        )),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                    child: Stack(
                                                  children: [
                                                    ClipRect(
                                                      child: Container(
                                                        height: 220,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: item['img'] !=
                                                                      null &&
                                                                  item['img'] !=
                                                                      ''
                                                              ? Image.network(
                                                                  baseurl +
                                                                      item['img']
                                                                          .toString(),
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
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: DotsIndicator(
                                    dotsCount: dataSlider.length,
                                    position: _current.toDouble(),
                                    decorator: DotsDecorator(
                                      color: Colors.white,
                                      activeColor: CustomColors.appColor,
                                      activeShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        )),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                childCount: data.length,
                                (BuildContext context, int index) {
                          String mark = data[index]['mark'];
                          String model = data[index]['model'];
                          String year = data[index]['year'].toString();
                          String markModelYear =
                              mark + ' ' + model + ' ' + year;
                          String price =
                              data[index]['price'].toString() + ' TMT';
                          String location = data[index]['location'].toString();
                          String created_at = data[index]['created_at']
                              .toString()
                              .split(' ')[0];
                          String imgUrl = baseurl + data[index]['img'];

                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      child: CarDetail(id: data[index]['id'])),
                                );
                              },
                              child: Container(
                                  height: 110,
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(2),
                                  child: Card(
                                      color: CustomColors.appColorWhite,
                                      shadowColor: Colors.grey,
                                      surfaceTintColor: Colors.white,
                                      elevation: 5,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Container(
                                              height: 110,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    flex: 1,
                                                    child: ClipRect(
                                                        child: Container(
                                                            height: 110,
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
                                                                child: imgUrl !=
                                                                        ''
                                                                    ? Image.network(
                                                                        imgUrl)
                                                                    : Image.asset(
                                                                        'assets/images/default.jpg'))))),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                        color: CustomColors
                                                            .appColorWhite,
                                                        margin: EdgeInsets.only(
                                                            left: 2),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      markModelYear,
                                                                      maxLines:
                                                                          1,
                                                                      style: TextStyle(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: CustomColors
                                                                              .appColor,
                                                                          fontSize:
                                                                              15))),
                                                              Row(children: [
                                                                Text(price,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Spacer(),
                                                              ]),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .location_on_outlined,
                                                                    size: 15,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                        location,
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontSize: 13)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    created_at,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey,
                                                                    )),
                                                              ),
                                                            ])))
                                              ]))))));
                        }))
                      ])
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColor))),
            drawer: MyDrawer())
        : CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context) {
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return CustomDialog(sort_value: sort, callbackFunc: callbackFilter);
    //   },
    // );
  }

  void getcarlist() async {
    var sort_value = "";
    // print(sort_value);
    // if (int.parse(sort) == 2) {
    //   sort_value = 'sort=price';
    // }
    // if (int.parse(sort) == 3) {
    //   sort_value = 'sort=-price';
    // }

    // if (int.parse(sort) == 4) {
    //   sort_value = 'sort=id';
    // }
    // if (int.parse(sort) == 4) {
    //   sort_value = 'sort=-id';
    // }

    Urls server_url = new Urls();
    String url = carsUrl + '?' + sort_value.toString();
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['data'];
      baseurl = server_url.get_server_url();
      determinate = true;
    });
  }

  void getcars_slider() async {
    Urls server_url = new Urls();
    String url = carsUrl + '?on_slider=1';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider = json['data'];
      if (dataSlider.length == 0) {
        dataSlider = [
          {"img": "", 'name_tm': "", 'price': "", 'location': ''}
        ];
      }
      baseurl = server_url.get_server_url();
      determinate1 = true;
    });
  }
}
