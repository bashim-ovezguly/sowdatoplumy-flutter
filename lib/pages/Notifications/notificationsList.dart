// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Notifications/notificationsDetail.dart';
import 'package:my_app/pages/Store/fistStore.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:provider/provider.dart';

import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import '../Search/search.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

// ignore: must_be_immutable
class Notifications extends StatefulWidget {
  Notifications({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  State<Notifications> createState() => _NotificationsState(title: title);
}

class _NotificationsState extends State<Notifications> {
  late List<String> imgList = [];
  String title;
  List<dynamic> dataSlider = [
    {"img": "", 'name': "", 'location': ''}
  ];
  List<dynamic> data = [];
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool determinate1 = false;
  bool _getRequest = false;
  bool status = true;
  bool filter = false;
  bool buttonTop = false;
  final int _nextPageTriger = 3;
  var keyword = TextEditingController();
  var sort_value = "";

  callbackFilter() {
    timers();
    setState(() {
      determinate = false;
      determinate1 = false;
      var sort = Provider.of<UserInfo>(context, listen: false).sort;
      var sort_value = "";

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
      getmarketslist(sort_value);
      getmarkets_slider();
    });
  }

  @override
  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;

    timers();
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
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

    getmarketslist(sort_value);
    getmarkets_slider();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  timers() async {
    _controller.addListener(_controllListener);

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

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostPerRequest = 12;
  final ScrollController _controller = ScrollController();
  final double _height = 100.0;

  late int total_page;
  late int current_page;

  void _animateToIndex(int index) {
    _controller.animateTo(
      index * 1,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  _NotificationsState({required this.title});

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: Text(title, style: CustomText.appBarText),
              actions: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search(index: 4)));
                        },
                        child:
                            Icon(Icons.search, color: Colors.white, size: 25)))
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    _pageNumber = 1;
                    _isLastPage = false;
                    _loading = true;
                    _error = false;
                    data = [];
                    determinate = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: TextFormField(
                                controller: keyword,
                                decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        determinate = false;
                                        _pageNumber = 1;
                                        _isLastPage = false;
                                        _loading = true;
                                        _error = false;
                                        data = [];
                                        getmarketslist(sort_value);
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          determinate = false;
                                          _pageNumber = 1;
                                          _isLastPage = false;
                                          _loading = true;
                                          _error = false;
                                          data = [];
                                          keyword.text = '';
                                        });
                                        getmarketslist(sort_value);
                                      },
                                    ),
                                    hintText: 'Ady boýunça gözleg...',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 125,
                            child: ListView.builder(
                                itemCount: data.length + (_isLastPage ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index == data.length - _nextPageTriger) {
                                    getmarketslist(sort_value);
                                  }
                                  if (index == data.length) {
                                    if (_error) {
                                      return Center(
                                          child: errorDialog(size: 15));
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    }
                                  }

                                  return Container(
                                      child: index == 0
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {},
                                                    child: Stack(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10),
                                                              height: 220,
                                                              color:
                                                                  Colors.white,
                                                              child: CarouselSlider(
                                                                  options: CarouselOptions(
                                                                      height: 220,
                                                                      viewportFraction: 1,
                                                                      initialPage: 0,
                                                                      enableInfiniteScroll: dataSlider.length > 1 ? true : false,
                                                                      reverse: false,
                                                                      autoPlay: dataSlider.length > 1 ? true : false,
                                                                      autoPlayInterval: const Duration(seconds: 4),
                                                                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                                                      autoPlayCurve: Curves.fastOutSlowIn,
                                                                      enlargeCenterPage: true,
                                                                      enlargeFactor: 0.3,
                                                                      scrollDirection: Axis.horizontal,
                                                                      onPageChanged: (index, reason) {
                                                                        setState(
                                                                            () {
                                                                          _current =
                                                                              index;
                                                                        });
                                                                      }),
                                                                  items: dataSlider
                                                                      .map((item) => GestureDetector(
                                                                          onTap: () {
                                                                            if (item['id'] != null &&
                                                                                item['id'] != '') {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => OtherGoodsDetail(
                                                                                            id: item['id'].toString(),
                                                                                            title: 'Harytlar',
                                                                                          )));
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                              color: Colors.white,
                                                                              child: Center(
                                                                                  child: Stack(children: [
                                                                                ClipRect(child: Container(height: 220, width: double.infinity, child: FittedBox(fit: BoxFit.cover, child: item['img'] != null && item['img'] != '' ? Image.network(baseurl + item['img'].toString()) : Image.asset('assets/images/default16x9.jpg')))),
                                                                              ])))))
                                                                      .toList())),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          7),
                                                              child: DotsIndicator(
                                                                  dotsCount:
                                                                      dataSlider
                                                                          .length,
                                                                  position:
                                                                      _current
                                                                          .toDouble(),
                                                                  decorator: DotsDecorator(
                                                                      color: Colors
                                                                          .white,
                                                                      activeColor:
                                                                          CustomColors
                                                                              .appColors,
                                                                      activeShape:
                                                                          RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15.0)))))
                                                        ])),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OtherGoodsDetail(
                                                                  id: data[index]
                                                                          ['id']
                                                                      .toString(),
                                                                  title:
                                                                      'Harytlar',
                                                                )));
                                                  },
                                                  child: Container(
                                                    height: 110,
                                                    child: Card(
                                                      color: CustomColors
                                                          .appColorWhite,
                                                      shadowColor:
                                                          Color.fromARGB(255,
                                                              200, 198, 198),
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
                                                                  child:
                                                                      ClipRect(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          110,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        child: data[index]['img'] != '' &&
                                                                                data[index]['img'] != null
                                                                            ? Image.network(
                                                                                baseurl + data[index]['img'].toString(),
                                                                              )
                                                                            : Image.asset(
                                                                                'assets/images/default.jpg',
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  color: CustomColors
                                                                      .appColorWhite,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <Widget>[
                                                                      if (data[index]['name'] !=
                                                                              null &&
                                                                          data[index]['name'] !=
                                                                              '')
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              data[index]['name'],
                                                                              maxLines: 1,
                                                                              style: CustomText.itemTextBold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (data[index]['location'] !=
                                                                              null &&
                                                                          data[index]['location'] !=
                                                                              '')
                                                                        Expanded(
                                                                            child:
                                                                                Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Text(data[index]['location'].toString(), style: CustomText.itemText)
                                                                            ],
                                                                          ),
                                                                        )),
                                                                      Expanded(
                                                                          child: Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(data[index]['price'].toString(), style: CustomText.itemText))),
                                                                      Expanded(
                                                                          child: Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Row(children: <Widget>[
                                                                                Text(data[index]['delta_time'].toString(), style: CustomText.itemText),
                                                                                Spacer(),
                                                                              ]))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OtherGoodsDetail(
                                                              id: data[index]
                                                                      ['id']
                                                                  .toString(),
                                                              title: 'Harytlar',
                                                            )));
                                              },
                                              child: Container(
                                                height: 110,
                                                child: Card(
                                                  color: CustomColors
                                                      .appColorWhite,
                                                  shadowColor:
                                                      const Color.fromARGB(
                                                          255, 200, 198, 198),
                                                  surfaceTintColor: CustomColors
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
                                                              child: ClipRect(
                                                                child:
                                                                    Container(
                                                                  height: 110,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    child: data[index]['img'] !=
                                                                                '' &&
                                                                            data[index]['img'] !=
                                                                                null
                                                                        ? Image
                                                                            .network(
                                                                            baseurl +
                                                                                data[index]['img'].toString(),
                                                                          )
                                                                        : Image
                                                                            .asset(
                                                                            'assets/images/default.jpg',
                                                                          ),
                                                                  ),
                                                                ),
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              color: CustomColors
                                                                  .appColorWhite,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 2),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  if (data[index]
                                                                              [
                                                                              'name'] !=
                                                                          null &&
                                                                      data[index]
                                                                              [
                                                                              'name'] !=
                                                                          '')
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          data[index]
                                                                              [
                                                                              'name'],
                                                                          maxLines:
                                                                              1,
                                                                          style:
                                                                              CustomText.itemTextBold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (data[index]
                                                                              [
                                                                              'location'] !=
                                                                          null &&
                                                                      data[index]
                                                                              [
                                                                              'location'] !=
                                                                          '')
                                                                    Expanded(
                                                                        child:
                                                                            Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          Text(
                                                                              data[index]['location'].toString(),
                                                                              style: CustomText.itemText)
                                                                        ],
                                                                      ),
                                                                    )),
                                                                  Expanded(
                                                                      child: Align(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Row(children: <Widget>[
                                                                            Text(data[index]['delta_time'].toString(),
                                                                                style: CustomText.itemText),
                                                                            Spacer(),
                                                                            Text(data[index]['price'].toString(),
                                                                                style: CustomText.itemText),
                                                                          ]))),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ));
                                }),
                          )
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColors))),
            drawer: MyDraver(),
            floatingActionButton: buttonTop
                ? FloatingActionButton.small(
                    backgroundColor: CustomColors.appColors,
                    onPressed: () {
                      isTopList();
                    },
                    child: Icon(
                      Icons.north,
                      color: CustomColors.appColorWhite,
                    ),
                  )
                : Container())
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

  void getmarketslist(sort_value) async {
    try {
      Urls server_url = new Urls();
      String url = server_url.get_server_url() + '/mob/announcements?' + sort_value.toString();

      if (keyword.text != '') {
        url = server_url.get_server_url() +
            '/mob/announcements?' +
            sort_value.toString() +
            "&name=" +
            keyword.text;
      }

      Map<String, String> headers = {};
      for (var i in global_headers.entries) {
        headers[i.key] = i.value.toString();
      }
      if (_getRequest == false) {
        final response = await http.get(
            Uri.parse(
                url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"),
            headers: headers);
        final json = jsonDecode(utf8.decode(response.bodyBytes));

        var postList = [];
        for (var i in json['data']) {
          postList.add(i);
        }
        setState(() {
          current_page = json['current_page'];
          total_page = json['total_page'];
          baseurl = server_url.get_server_url();
          determinate = true;
          _isLastPage = data.length < _numberOfPostPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _getRequest = false;
          data.addAll(postList);
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void isTopList() {
    double position = 0.0;
    _controller.position.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
  }

  void getmarkets_slider() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/announcements?on_slider=1';
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
          {"img": "", 'name': "", 'location': ''}
        ];
      }
      determinate1 = true;
    });
  }

  Widget errorDialog({required double size}) {
    return GestureDetector(
        onTap: () {
          _animateToIndex(1);
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(color: CustomColors.appColors)),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_upward,
                color: CustomColors.appColors,
              )
            ]));
  }

  void _controllListener() {
    if (_controller.offset > 600) {
      setState(() {
        buttonTop = true;
      });
    } else {
      setState(() {
        buttonTop = false;
      });
    }

    if (_controller.offset > _controller.position.maxScrollExtent - 1000 &&
        total_page > current_page &&
        _getRequest == false) {
      var sort_value = "";
      var sort = Provider.of<UserInfo>(context, listen: false).sort;
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
      getmarketslist(sort_value);
      setState(() {
        _getRequest = true;
      });
    }
  }
}
