// ignore_for_file: unused_local_variable, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/OtherGoods/otherGoodsDetail.dart';
import 'package:my_app/pages/Store/order.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../../main.dart';
import '../Customer/login.dart';
import '../Customer/myPages.dart';
import '../fullScreenSlider.dart';
import 'package:badges/badges.dart' as badges;

class RestaurantDetail extends StatelessWidget {
  RestaurantDetail({Key? key, required this.id, required this.title})
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
  int tab_control = 0;
  List<dynamic> products = [];
  List<dynamic> data_tel = [];
  List<String> imgList = [];
  late int total_page;
  late int current_page;
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  bool _getRequest = false;
  final int _numberOfPostPerRequest = 12;
  final ScrollController _controller = ScrollController();
  var shoping_cart_items = [];
  bool buttonTop = false;

  int item_count = 0;
  int _current = 0;

  String modul_name = "Harytlar";
  String modul = "0";
  String store_name = '';
  String delivery_price_str = "";

  bool determinate = false;
  bool determinate1 = false;
  bool status = true;

  var keyword = TextEditingController();
  var shoping_carts = [];
  var data = {};
  var data_array = [];
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

  @override
  void initState() {
    timers();
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    tab_control = 1;

    get_products_modul(widget.id);
    getsinglemarkets(id: widget.id, title: widget.title);
    if (imgList.length == 0) {
      imgList.add('x');
    }

    super.initState();
    
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

  @override
  Widget build(BuildContext context) {
    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Haryt sebede goşuldy.',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColors,
          type: QuickAlertType.success,
          onConfirmBtnTap: () {
            Navigator.pop(context);
          });
    }

    showWarningAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Haryt sebetde bar.',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColors,
          type: QuickAlertType.warning,
          onConfirmBtnTap: () {
            Navigator.pop(context);
          });
    }

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            store_name.toString(),
            style: CustomText.appBarText,
          ),
          actions: [
            badges.Badge(
              badgeColor: Colors.green,
              badgeContent: Text(
                item_count.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              position: BadgePosition(start: 30, bottom: 25),
              child: IconButton(
                onPressed: () async {
                  var allRows = await dbHelper.queryAllRows();
                  var data1 = [];
                  for (final row in allRows) {
                    data1.add(row);
                  }
                  if (data1.length == 0) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Order(
                                store_name: data['name_tm'].toString(),
                                store_id: widget.id,
                                refresh: refresh,
                                delivery_price: delivery_price_str)));
                  }
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
          ],
        ),
        body: determinate && determinate1
            ? SingleChildScrollView(
                controller: _controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                        alignment: Alignment.bottomCenter,
                        textDirection: TextDirection.rtl,
                        fit: StackFit.loose,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Container(
                              height: 220,
                              child: GestureDetector(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: 220,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: imgList.length>1 ? true: false,
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
                                                    height: 220,
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
                      SizedBox(
                          child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.location_on,
                              color: CustomColors.appColors, size: 25),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 10,
                          child: Text(data['location']['name'].toString(),
                              style: TextStyle(
                                  color: CustomColors.appColors, fontSize: 14)),
                        )
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
                    if (data['contacts'] != null)
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
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text(
                                          data['contacts'][i]['value']
                                              .toString(),
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
                    Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 228, 228, 228),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: TextFormField(
                          controller: keyword,
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    _pageNumber = 1;
                                    _isLastPage = false;
                                    _loading = true;
                                    _error = false;
                                    tab_control = 1;
                                    data_array = [];
                                  });
                                  get_products_modul(widget.id);
                                },
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _pageNumber = 1;
                                    _isLastPage = false;
                                    _loading = true;
                                    _error = false;
                                    tab_control = 1;
                                    data_array = [];
                                    keyword.text = '';
                                  });
                                  get_products_modul(widget.id);
                                },
                              ),
                              hintText: 'Gözleg...',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    if (data_array.length > 0)
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: data_array.map((item) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtherGoodsDetail(
                                            id: item['id'].toString(),
                                            title: 'Harytlar',
                                          )));
                            },
                            child: Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Card(
                                color: CustomColors.appColorWhite,
                                shadowColor:
                                    const Color.fromARGB(255, 200, 198, 198),
                                surfaceTintColor: CustomColors.appColorWhite,
                                elevation: 5,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0)),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height: 150,
                                        child: item['img'] != ''
                                            ? Image.network(
                                                baseurl +
                                                    item['img'].toString(),
                                                fit: BoxFit.cover,
                                                height: 150,
                                                width: double.infinity,
                                              )
                                            : Image.asset(
                                                'assets/images/default.jpg',
                                              ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: tab_control != 2
                                            ? Text(
                                                item['name'].toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        CustomColors.appColors),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Text(item['mark'].toString() +
                                                item['model'] +
                                                item['year'].toString()),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: Text(
                                          item['price'].toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (tab_control == 1)
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              height: 20),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green[700]),
                                            child: Text('Sebede goş',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: CustomColors
                                                        .appColorWhite,
                                                    overflow:
                                                        TextOverflow.clip)),
                                            onPressed: () async {
                                              var allRows =
                                                  await dbHelper.queryAllRows();
                                              var data = [];
                                              for (final row in allRows) {
                                                data.add(row);
                                              }
                                              if (data.length == 0) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()));
                                              } else {
                                                setState(() {
                                                  shoping_cart_items = [];
                                                });

                                                var shoping_cart = await dbHelper
                                                    .get_shoping_cart_by_store(
                                                        id: widget.id);
                                                var array = [];
                                                for (final row
                                                    in shoping_cart) {
                                                  array.add(row);
                                                }
                                                var shoping_cart_item =
                                                    await dbHelper
                                                        .get_shoping_cart_item(
                                                            soping_cart_id:
                                                                array[0]['id']
                                                                    .toString(),
                                                            product_id: item[
                                                                    'id']
                                                                .toString());
                                                for (final row
                                                    in shoping_cart_item) {
                                                  shoping_cart_items.add(row);
                                                }
                                                if (shoping_cart_items.length ==
                                                    0) {
                                                  Map<String, dynamic> row = {
                                                    'soping_cart_id': array[0]
                                                        ['id'],
                                                    'product_id': item['id'],
                                                    'product_img': item['img'],
                                                    'product_name':
                                                        item['name'],
                                                    'product_price':
                                                        item['price']
                                                            .toString(),
                                                    'count': 1
                                                  };
                                                  var shoping_cart = await dbHelper
                                                      .add_product_shoping_cart(
                                                          row);
                                                  showSuccessAlert();
                                                  var count = await dbHelper
                                                      .get_shoping_cart_items(
                                                          soping_cart_id:
                                                              array[0]['id']
                                                                  .toString());
                                                  var array1 = [];
                                                  for (final row in count) {
                                                    array1.add(row);
                                                  }

                                                  refresh_item_count(
                                                      array1.length);
                                                } else {
                                                  showWarningAlert();
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      SizedBox(height: 600),
                    if (total_page > current_page && _getRequest == true)
                      Container(
                        height: 100,
                        child: Center(
                            child: CircularProgressIndicator(
                                color: CustomColors.appColors)),
                      )
                  ],
                ),
              )
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColors)),
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

  void get_products_modul(id) async {
    Urls server_url = new Urls();
    var param = 'products';
    String url =
        server_url.get_server_url() + '/mob/' + param + '?store=' + id;

    if (keyword.text != '') {
      url = server_url.get_server_url() +
          '/mob/' +
          param +
          '?store=' +
          id +
          "&name=" +
          keyword.text;
    }
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    print(Uri.parse(url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));

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
    String url = server_url.get_server_url() + '/mob/restaurants/' + id;

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

      if (json['phones'].length != 0) {
        telefon = json['phones'][0];
      }

      for (i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }

      determinate = true;
      if (imgList.length == 0) {
        imgList.add('x');
      }
    });
  }

  void isTopList() {
    double position = 0.0;
    _controller.position.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
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
      if (tab_control == 1) {
        get_products_modul(widget.id);
      }
      setState(() {
        _getRequest = true;
      });
    }
  }
}
