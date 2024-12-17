// ignore_for_file: unused_local_variable, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Store/Order.dart';
import 'dart:convert';

import '../../dB/constants.dart';
import '../Profile/login.dart';
import '../Products/ProductDetail.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';

class StoreProducts extends StatefulWidget {
  StoreProducts(
      {Key? key,
      required this.id,
      required this.storeName,
      required this.delivery_price})
      : super(key: key);

  final int id;
  final String storeName;
  final int delivery_price;

  @override
  State<StoreProducts> createState() => _StoreProductsState(
      id: id, storeName: storeName, delivery_price: delivery_price);
}

class _StoreProductsState extends State<StoreProducts> {
  @override
  final int id;
  var shoping_cart_items = [];
  var products = [];
  var keyword = TextEditingController();
  var delivery_price = 0;
  var storeName = '';
  bool buttonTop = false;
  int basket_products_count = 0;

  bool isLoading = true;

  List<dynamic> basket = [];
  var data = {};
  late ScrollController _scrollController = ScrollController();

  void isTopList() {
    double position = 0.0;
    _scrollController.position.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
  }

  refreshBasketProducts(value) async {
    setState(() {
      basket_products_count = this.basket.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts(id);
    _scrollController.addListener(_controllListener);
  }

  _StoreProductsState(
      {required this.id,
      required this.storeName,
      required this.delivery_price});

  addToBasket(item) async {
    if (await login_state() == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    var result =
        this.basket.where((element) => element['id'] == item['id']).toList();
    if (result.length > 0) {
      return null;
    }
    this.basket.add({
      'id': item['id'],
      'name': item['name'],
      'price': item['price'].toString().replaceAll(' ', ''),
      'img': item['img'],
      'amount': 1,
    });

    this.setState(() {
      basket_products_count = basket.length;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.storeName,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            'Harytlar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      )),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.small(
          backgroundColor: CustomColors.appColor,
          heroTag: 'basket',
          onPressed: () {},
          child: badges.Badge(
              badgeColor: Colors.green,
              badgeContent: Text(
                this.basket_products_count.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              position: BadgePosition(start: 30, bottom: 25),
              child: IconButton(
                  onPressed: () async {
                    if (await login_state() == false) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Order(
                                  products: this.basket,
                                  store_name: this.storeName,
                                  store_id: this.id,
                                  refresh: () {},
                                  delivery_price: delivery_price)));
                    }
                  },
                  icon: const Icon(Icons.shopping_cart,
                      color: CustomColors.appColorWhite))),
        ),
        SizedBox(height: 10),
        FloatingActionButton.small(
            heroTag: 'scrollToTop',
            backgroundColor: CustomColors.appColor,
            onPressed: () {
              isTopList();
            },
            child: Icon(Icons.north, color: CustomColors.appColorWhite))
      ]),
      body: Column(children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              color: CustomColors.appColor,
            ),
          ),
        if (!isLoading)
          Container(
            margin: EdgeInsets.all(8),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              controller: keyword,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      getProducts(id);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        keyword.text = '';
                      });
                      getProducts(id);
                    },
                  ),
                  hintText: 'Gözleg...',
                  border: InputBorder.none),
            ),
          ),
        Expanded(
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: products.map((item) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                      id: item['id'].toString(),
                                    )));
                      },
                      child: Container(
                          margin: EdgeInsets.all(5),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [appShadow]),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: Column(children: [
                                item['img'] != null && item['img'] != ""
                                    ? Image.network(
                                        serverIp + item['img'].toString(),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height:
                                            MediaQuery.sizeOf(context).height /
                                                5,
                                      )
                                    : Image.asset(
                                        'assets/images/default.jpg',
                                        height: 120,
                                      ),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['name'].toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: CustomColors.appColor,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Text(
                                          item['price'].toString() + ' TMT',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: CustomColors.appColor,
                                              // fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        GestureDetector(
                                            child: Container(
                                              width: double.infinity,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 5),
                                              child: Text('Sebede goş',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                            onTap: () async {
                                              this.addToBasket(item);
                                            }),
                                      ],
                                    ))
                              ]))));
                }).toList(),
              )
            ],
          ),
        ),
      ]),
    );
  }

  void getProducts(id) async {
    // var params = {
    //   'store': id.toString(),
    // };

    String url = productsUrl + '?store=' + id.toString();

    if (keyword.text != '') {
      url = productsUrl + '?store=' + id.toString() + "&name=" + keyword.text;
    }

    Map<String, String> headers = global_headers;
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;
      try {
        products = json['data'];
      } catch (err) {}
    });
  }

  void _controllListener() {
    if (_scrollController.offset <= 0) {
      isTopList();
    }
  }
}
