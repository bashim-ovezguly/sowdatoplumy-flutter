// ignore_for_file: unused_local_variable
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:my_app/pages/Store/OrderConfirm.dart';

import '../../dB/constants.dart';
import '../../main.dart';
import '../progressIndicator.dart';

class Order extends StatefulWidget {
  final String store_name;
  final int store_id;
  final Function refresh;
  final int delivery_price;
  final List<dynamic> products;

  Order(
      {Key? key,
      required this.store_name,
      required this.store_id,
      required this.products,
      required this.refresh,
      required this.delivery_price})
      : super(key: key);

  @override
  State<Order> createState() => _OrderState(
        store_name: store_name,
        store_id: store_id,
        products: products,
      );
}

class _OrderState extends State<Order> {
  bool determinate = true;
  final String store_name;
  final int store_id;
  double total_price = 0;
  int item_count = 0;
  bool status = true;
  List<dynamic> products;

  void initState() {
    super.initState();
    this.calc_total();
  }

  calc_total() {
    double total = 0;
    products.forEach((element) {
      total = total + (double.parse(element['price']) * element['amount']);
    });

    this.setState(() {
      total_price = total;
      item_count = products.length;
    });
  }

  remove_item(item) {
    this.setState(() {
      this.products.remove(item);
    });
    calc_total();
  }

  increment(item) {
    var index = widget.products.indexOf(item);
    this.setState(() {
      this.products[index]['amount'] = this.products[index]['amount'] + 1;
    });
    calc_total();
  }

  decrement(item) {
    var index = widget.products.indexOf(item);

    if (this.products[index]['amount'] > 1) {
      this.setState(() {
        this.products[index]['amount'] = this.products[index]['amount'] - 1;
      });
      calc_total();
    }
  }

  _OrderState({
    required this.store_name,
    required this.store_id,
    required this.products,
  });
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
            body: Container(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: [
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(store_name,
                                    style: TextStyle(
                                        color: CustomColors.appColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              Text("Jemi:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.appColor,
                                      fontSize: 18)),
                              Text(this.total_price.toString() + ' TMT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.appColor,
                                      fontSize: 18)),
                            ]),
                          ])),
                  Column(
                    children: widget.products.map((item) {
                      int index = widget.products.indexOf(item);
                      return Container(
                          clipBehavior: Clip.hardEdge,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [appShadow],
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300)),
                          margin: EdgeInsets.all(8),
                          child: Row(children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                    child: Image.network(
                                        serverIp +
                                            widget.products[index]['img'],
                                        height: double.infinity,
                                        fit: BoxFit.cover))),
                            Expanded(
                                flex: 4,
                                child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    height: 20,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        widget.products[index]
                                                            ['name'],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: CustomColors
                                                                .appColor)))),
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    widget.products[index]
                                                                ['price']
                                                            .toString() +
                                                        ' TMT',
                                                    style: CustomText.size_16)),
                                            Expanded(
                                                child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        this.decrement(item);
                                                      },
                                                      child: Container(
                                                          height: 35,
                                                          width: 35,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          155,
                                                                          154,
                                                                          154))),
                                                          child: Icon(
                                                              Icons.remove,
                                                              color: Colors.green,
                                                              size: 20)),
                                                    ),
                                                    Padding(
                                                        child: Text(
                                                            widget
                                                                .products[index]
                                                                    ['amount']
                                                                .toString(),
                                                            style: CustomText
                                                                .size_16),
                                                        padding:
                                                            EdgeInsets.all(8)),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          this.increment(item);
                                                        },
                                                        child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border: Border.all(
                                                                    color: Color.fromARGB(
                                                                        255,
                                                                        155,
                                                                        154,
                                                                        154))),
                                                            child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .green,
                                                                size: 20)))
                                                  ]),
                                            ))
                                          ]),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    child: GestureDetector(
                                        onTap: () async {
                                          this.remove_item(item);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ))))
                          ]));
                    }).toList(),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            floatingActionButton: item_count > 0
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      final Map<String, dynamic> dict = {
                        'products': [],
                      };

                      dict['store'] = store_id;
                      var allRows = await dbHelper.queryAllRows();
                      var data1 = [];
                      for (final row in allRows) {
                        data1.add(row);
                      }

                      if (widget.products.length == 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }

                      dict['accepter'] = this.store_id;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderConfirm(
                                  total_price: total_price,
                                  accepter: widget.store_id,
                                  products: this.products,
                                  refresh: widget.refresh)));
                    },
                    label: const Text('Sargydy tassyklamak',
                        style: TextStyle(color: CustomColors.appColorWhite)),
                    backgroundColor: Colors.green,
                  )
                : Container())
        : CustomProgressIndicator(funcInit: initState);
  }
}
