// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/editStore.dart';
import 'package:my_app/pages/Customer/productDetail.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../fullScreenSlider.dart';
import 'deleteAlert.dart';
import 'newProduct.dart';

class MyPage extends StatefulWidget {
  MyPage(
      {Key? key,
      required this.id,
      required this.customer_id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final String id;
  final String customer_id;
  final String user_customer_id;
  final Function refreshFunc;
  @override
  State<MyPage> createState() =>
      _MyPageState(id: id, customer_id: customer_id, refreshFunc: refreshFunc);
}

class _MyPageState extends State<MyPage> {
  final Function refreshFunc;
  final String id;
  final String customer_id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  List<dynamic> products = [];
  List<String> imgList = [];
  List<dynamic> data_tel = [];
  bool determinate = false;
  bool determinate1 = false;

  bool buttonTop = false;
  int item_count = 0;
  final int _numberOfPostPerRequest = 12;
  late int total_page;
  late int current_page;
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  bool _getRequest = false;
  var data_array = [];

  bool status = false;
  callbackStatus() {}

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    _controller.addListener(_controllListener);
    refreshFunc();
    if (imgList.length == 0) {
      imgList.add('x');
    }
    getsinglemarkets(id: id);
    get_products_modul(id);
    super.initState();
  }

  void storeRefresh() {
    setState(() {
      _pageNumber = 1;
      _isLastPage = false;
      _loading = true;
      _error = false;
      data_array = [];
    });
    getsinglemarkets(id: id);
    get_products_modul(id);
  }

  callbackStatusDelete() {
    refreshFunc();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  final ScrollController _controller = ScrollController();

  _MyPageState(
      {required this.id, required this.customer_id, required this.refreshFunc});
  @override
  Widget build(BuildContext context) {
    var user_customer_name =
        Provider.of<UserInfo>(context, listen: false).user_customer_name;
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.user_customer_id == ''
                  ? Text(
                      "Meniň sahypam",
                      style: CustomText.appBarText,
                    )
                  : Text(
                      user_customer_name.toString() + " şahsy otag",
                      style: CustomText.appBarText,
                    ),
              Text(
                'Söwda nokady',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: CustomColors.appColors),
              ),
            ],
          ),
          actions: [
            if (widget.user_customer_id == '')
              PopupMenuButton<String>(
                surfaceTintColor: CustomColors.appColorWhite,
                shadowColor: CustomColors.appColorWhite,
                color: CustomColors.appColorWhite,
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditStore(
                                          old_data: data,
                                          callbackFunc: storeRefresh)));
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                  Text(' Üýtgetmek')
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewProduct(
                                          title: "Haryt goşmak",
                                          customer_id: customer_id,
                                          id: id,
                                          action: 'store',
                                          storeRefresh: storeRefresh)));
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  Text(' Haryt goşmak')
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteAlert(
                                      action: 'stores',
                                      id: id,
                                      callbackFunc: callbackStatusDelete,
                                    );
                                  });
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text('Pozmak')
                                ])))),
                  ];
                  return menuEntries2;
                },
              ),
          ],
        ),
        body: status == false
            ? RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    _pageNumber = 1;
                    _isLastPage = false;
                    _loading = true;
                    _error = false;
                    data_array = [];
                    determinate = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 220,
                                    margin: const EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: Container(
                                        child: ImageSlideshow(
                                          disableUserScrolling:
                                              imgList.length > 1 ? false : true,
                                          indicatorColor:
                                              CustomColors.appColors,
                                          indicatorBackgroundColor: Colors.grey,
                                          onPageChanged: (value) {},
                                          autoPlayInterval: 6666,
                                          isLoop: true,
                                          children: [
                                            for (var item in imgList)
                                              if (item != '' && item != 'x')
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullScreenSlider(
                                                                      imgList:
                                                                          imgList)));
                                                    },
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                        item),
                                                                fit: BoxFit
                                                                    .cover))))
                                              else
                                                Container(
                                                    width: double.infinity,
                                                    child: Image.asset(
                                                        fit: BoxFit.cover,
                                                        'assets/images/default16x9.jpg')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                          width: 5,
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
                                        SizedBox(
                                          width: 10,
                                        ),
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
                              SizedBox(
                                height: 10,
                              ),
                              if (data['status'] == 'canceled' &&
                                  data['error_reason'] != '')
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(data['error_reason'].toString(),
                                        maxLines: 10,
                                        style: TextStyle(color: Colors.red))),
                              if (data['name_tm'] != '')
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(data['name_tm'].toString(),
                                      style: TextStyle(
                                          color: CustomColors.appColors,
                                          fontSize: 20)),
                                ),
                              if (data['body_tm'] != null &&
                                  data['body_tm'] != '')
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
                                          fontSize: 14,
                                          color: CustomColors.appColors),
                                      hintText: data['body_tm'].toString(),
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 5,
                              ),
                              if (data['location'] != '' &&
                                  data['location'] != null)
                                SizedBox(
                                    child: Row(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.location_on,
                                        color: CustomColors.appColors,
                                        size: 25),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                        data['location']['name'].toString(),
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontSize: 14)),
                                  )
                                ])),
                              SizedBox(
                                height: 5,
                              ),
                              if (data['category'] != '' &&
                                  data['category'] != null)
                                SizedBox(
                                    child: Row(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.layers,
                                        color: CustomColors.appColors,
                                        size: 25),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(data['category'].toString(),
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontSize: 14)),
                                  )
                                ])),
                              SizedBox(
                                height: 5,
                              ),
                              if (data['delivery_price'] != '' &&
                                  data['delivery_price'] != null)
                                SizedBox(
                                    child: Row(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.delivery_dining,
                                        color: CustomColors.appColors,
                                        size: 25),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                        data['delivery_price'].toString(),
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontSize: 14)),
                                  )
                                ])),
                              if (data['contacts'] != null)
                                Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      for (var i = 0;
                                          i < data['contacts'].length;
                                          i++)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                height: 25,
                                                child: Image.network(
                                                  data['contacts'][i]['icon'],
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.cover,
                                                )),
                                            SizedBox(width: 5),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                  data['contacts'][i]['value']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: CustomColors
                                                          .appColors,
                                                      fontSize: 14)),
                                            ),
                                            SizedBox(width: 5),
                                            if (widget.user_customer_id == '')
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return DeletePhoneAlert(
                                                          id: data['contacts']
                                                                  [i]['id']
                                                              .toString(),
                                                          callbackFunc:
                                                              storeRefresh,
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5),
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                    ]),
                              Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 30),
                                    child: Text(
                                      "HARYTLAR",
                                      style: TextStyle(
                                          color: CustomColors.appColors,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Container(
                                child: Wrap(
                                  alignment: WrapAlignment.spaceAround,
                                  children: data_array.map((item) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                        title: "Haryt",
                                                        id: item['id']
                                                            .toString())));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 180,
                                        child: Card(
                                          color: CustomColors.appColorWhite,
                                          shadowColor:
                                              Color.fromRGBO(200, 198, 198, 1),
                                          surfaceTintColor:
                                              CustomColors.appColorWhite,
                                          elevation: 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                            child: Column(
                                              children: [
                                                Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: item['img'] !=
                                                                null &&
                                                            item['img'] != ""
                                                        ? Image.network(
                                                            baseurl +
                                                                item['img']
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                            height: 130,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/default.jpg',
                                                            fit: BoxFit.cover,
                                                            height: 130,
                                                          )),
                                                Container(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          item['name']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: CustomColors
                                                                .appColors,
                                                          ),
                                                        ),
                                                        Text(
                                                          item['price']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: CustomColors
                                                                .appColors,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ]))
                    : Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.appColors,
                        ),
                      ))
            : Container(
                child: AlertDialog(
                shadowColor: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                backgroundColor: CustomColors.appColorWhite,
                content: Container(
                  width: 200,
                  height: 100,
                  child: Text(
                      'Maglumat üýtgedildi operatoryň tassyklamagyna garaşyň'),
                ),
                actions: <Widget>[
                  Align(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        setState(() {
                          callbackStatus();
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPage(
                                      id: id,
                                      customer_id: customer_id,
                                      user_customer_id: widget.user_customer_id,
                                      refreshFunc: widget.refreshFunc,
                                    )));
                      },
                      child: const Text('Dowam et'),
                    ),
                  )
                ],
              )),
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
            : Container());
  }

  void isTopList() {
    double position = 0.0;
    _controller.position.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
  }

  void getsinglemarkets({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/stores/' + id;
    print(url);
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      products = json['products'];
      baseurl = server_url.get_server_url();
      data_tel = json['phones'];
      var i;
      imgList = [];
      for (i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }
      if (imgList.length == 0) {
        imgList.add('x');
      }
      determinate = true;
    });
  }

  void get_products_modul(id) async {
    Urls server_url = new Urls();
    var param = 'products';

    var data1 = [];
    var allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      data1.add(row);
    }

    String url = server_url.get_server_url() + '/mob/' + param + '?store=' + id;

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    headers['token'] = data1[0]['name'];
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
        _loading = false;
        _pageNumber = _pageNumber + 1;
        data_array.addAll(postList);
        _getRequest = false;
        determinate1 = true;
      });
    }
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
      // ignore: unused_local_variable
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

      get_products_modul(widget.id);

      setState(() {
        _getRequest = true;
      });
    }
  }
}

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  int _value = 1;
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text(
            'Eltip bermek hyzmaty',
            style: TextStyle(color: CustomColors.appColors),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
          )
        ],
      ),
      content: Container(
          height: 150,
          width: 300,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                      splashRadius: 20.0,
                      activeColor: CustomColors.appColors,
                      value: 1,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 1;
                      });
                    },
                    child: Text("Eltip bermek hyzmaty bar"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      splashRadius: 20.0,
                      activeColor: CustomColors.appColors,
                      value: 2,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _value = 2;
                      });
                    },
                    child: Text("Eltip bermek hyzmaty yok"),
                  )
                ],
              ),
            ],
          )),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Gözle'),
          ),
        )
      ],
    );
  }
}
