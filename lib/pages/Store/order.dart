// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Store/checkout.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../main.dart';
import '../progressIndicator.dart';

class Order extends StatefulWidget {
  final String store_name;
  final String store_id;
  final Function refresh;
  final String delivery_price;

  Order(
      {Key? key,
      required this.store_name,
      required this.store_id,
      required this.refresh,
      required this.delivery_price})
      : super(key: key);

  @override
  State<Order> createState() => _OrderState(
      store_name: store_name,
      store_id: store_id,
      delivery_price: delivery_price);
}

class _OrderState extends State<Order> {
  bool determinate = true;
  final String store_name;
  final String store_id;
  var total_price;
  int item_count = 0;
  var shoping_carts = [];
  var array = [];
  var baseurl = "";
  final String delivery_price;
  int delivery_price_int = 0;
  var data = [];
  bool status = true;

  void initState() {
    timers();
    if (delivery_price != 'tölegsiz') {
      setState(() {
        String sss = delivery_price.substring(0, delivery_price.length - 4);
        delivery_price_int = int.parse(sss);
      });
    }
    get_products();
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

  _OrderState(
      {required this.store_name,
      required this.store_id,
      required this.delivery_price});
  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: Text(
                'Sebet',
                style: TextStyle(color: CustomColors.appColorWhite),
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
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    get_products();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate
                    ? CustomScrollView(
                        slivers: [
                          if (store_name != '')
                            SliverList(
                                delegate:
                                    SliverChildBuilderDelegate(childCount: 1,
                                        (BuildContext context, int index) {
                              return Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 5),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Text(store_name,
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ]));
                            })),
                          SliverList(
                              delegate:
                                  SliverChildBuilderDelegate(childCount: 1,
                                      (BuildContext context, int index) {
                            return Container(
                                margin: EdgeInsets.only(top: 5, bottom: 10),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        Text("Harytlaryň bahasy:",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15)),
                                        Spacer(),
                                        Text(total_price.toString() + " TMT",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15))
                                      ]),
                                      Row(children: [
                                        Text("Eltip bermek bahasy:",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15)),
                                        Spacer(),
                                        Text(delivery_price.toString(),
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15))
                                      ]),
                                      Row(children: [
                                        Text("Umumy töleg:",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15)),
                                        Spacer(),
                                        Text(
                                            (total_price + delivery_price_int)
                                                    .toString() +
                                                " TMT",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15))
                                      ]),
                                    ]));
                          })),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  childCount: array.length,
                                  (BuildContext context, int index) {
                            return Container(
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
                                          Radius.circular(7.0)),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                                child: Image.network(
                                                    baseurl +
                                                        array[index]
                                                            ['product_img'],
                                                    height: 110,
                                                    fit: BoxFit.cover))),
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                              height: 60,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  array[index][
                                                                          'product_name'] +
                                                                      'erwekjlrgnerngelrwk ',
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: CustomColors
                                                                          .appColors)))),
                                                      Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              array[index][
                                                                      'product_price']
                                                                  .toString(),
                                                              style: CustomText
                                                                  .size_16)),
                                                      Expanded(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 5),
                                                        child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  if (array[index]
                                                                          [
                                                                          'count'] >
                                                                      1) {
                                                                    var decrement = await dbHelper.product_count_increment(
                                                                        item_id:
                                                                            array[index]['id']
                                                                                .toString(),
                                                                        count: array[index]['count'] -
                                                                            1);
                                                                    get_products();
                                                                  }
                                                                },
                                                                child: Container(
                                                                    height: 35,
                                                                    width: 35,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        border: Border.all(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                155,
                                                                                154,
                                                                                154))),
                                                                    child: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            20)),
                                                              ),
                                                              Text(
                                                                  "  " +
                                                                      array[index]
                                                                              [
                                                                              'count']
                                                                          .toString() +
                                                                      "  ",
                                                                  style: CustomText
                                                                      .size_16),
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    var increment = await dbHelper.product_count_increment(
                                                                        item_id:
                                                                            array[index]['id']
                                                                                .toString(),
                                                                        count: array[index]['count'] +
                                                                            1);
                                                                    setState(
                                                                        () {
                                                                      get_products();
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                      height:
                                                                          35,
                                                                      width: 35,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          border: Border.all(
                                                                              color: Color.fromARGB(255, 155, 154,
                                                                                  154))),
                                                                      child: Icon(
                                                                          Icons
                                                                              .add,
                                                                          color: Colors
                                                                              .green,
                                                                          size:
                                                                              20)))
                                                            ]),
                                                      ))
                                                    ]))),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: GestureDetector(
                                                    onTap: () async {
                                                      var delete_item =
                                                          await dbHelper.delete_item(
                                                              item_id: array[
                                                                          index]
                                                                      ['id']
                                                                  .toString());
                                                      widget.refresh();
                                                      setState(() {
                                                        get_products();
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ))))
                                      ]),
                                    )));
                          })),
                          SliverList(
                              delegate:
                                  SliverChildBuilderDelegate(childCount: 1,
                                      (BuildContext context, int index) {
                            return Container(height: 70);
                          }))
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColors))),
            floatingActionButton: item_count > 0
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      final Map<String, dynamic> dict = {
                        'products': [],
                      };
                      for (var i in array) {
                        dict['products']!.add(
                            {"product": i['product_id'], "amount": i['count']});
                      }
                      dict['store'] = store_id;
                      var allRows = await dbHelper.queryAllRows();
                      var data1 = [];
                      for (final row in allRows) {
                        data1.add(row);
                      }
                      setState(() {
                        data = data1;
                      });
                      if (data.length == 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }
                      for (final row in allRows) {
                        data.add(row);
                      }
                      dict['customer'] = data[0]['userId'];
                      dict['delivery_price'] = delivery_price_int;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Checkout(
                                  total_price: total_price + delivery_price_int,
                                  dict: dict,
                                  refresh: widget.refresh)));
                    },
                    label: const Text('Sargydy taýýarla',
                        style: TextStyle(color: CustomColors.appColorWhite)),
                    backgroundColor: Colors.green,
                  )
                : Container())
        : CustomProgressIndicator(funcInit: initState);
  }

  get_products() async {
    array = [];
    baseurl = "";
    shoping_carts = [];
    var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: store_id);
    for (final row in shoping_cart) {
      shoping_carts.add(row);
    }
    var count = await dbHelper.get_shoping_cart_items(
        soping_cart_id: shoping_carts[0]['id'].toString());
    var array1 = [];
    int total_price1 = 0;
    for (final row in count) {
      array1.add(row);
      String ss =
          row['product_price'].substring(0, row['product_price'].length - 4);
      ss = ss.replaceAll(RegExp(' '), '');
      int qq = row['count'] * int.parse(ss);
      total_price1 = total_price1 + qq;
    }
    Urls server_url = new Urls();
    setState(() {
      total_price = total_price1;
      item_count = array1.length;
      baseurl = server_url.get_server_url();
      array = array1;
    });
  }
}
