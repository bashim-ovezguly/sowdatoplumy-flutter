import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Customer/Orders/OrderDetail.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:quickalert/quickalert.dart';
import '../../../dB/constants.dart';

final List<String> entries = <String>[];

class Orders extends StatefulWidget {
  final String customer_id;
  final Function callbackFunc;
  Orders({Key? key, required this.customer_id, required this.callbackFunc})
      : super(key: key);

  @override
  State<Orders> createState() => _OrdersState(customer_id: this.customer_id);
}

class _OrdersState extends State<Orders> {
  bool determinate = false;
  bool is_loading = true;
  String customer_id;

  var orders = [];

  _OrdersState({required this.customer_id});

  @override
  void initState() {
    super.initState();
    get_orders(widget.customer_id);
  }

  refresh() {
    get_orders(widget.customer_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text('Sargytlar',
              style: TextStyle(color: CustomColors.appColorWhite)),
        ),
        extendBody: true,
        body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: CustomColors.appColor,
            onRefresh: () async {
              setState(() {
                determinate = false;
                get_orders(widget.customer_id);
              });
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            child: determinate
                ? Column(children: [
                    Expanded(
                      child: Container(
                          child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          String type = '';
                          if (orders[index]['type'] == 'in') {
                            type = 'Gelen sargyt';
                          } else {
                            type = 'Giden sargyt';
                          }

                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetail(
                                            order_id:
                                                orders[index]['id'].toString(),
                                            refresh: refresh)));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                height: 140,
                                child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    surfaceTintColor:
                                        CustomColors.appColorWhite,
                                    elevation: 5,
                                    child: Container(
                                        child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        color: Colors.blue,
                                        child: Row(children: [
                                          Text(
                                              '#' +
                                                  orders[index]['id']
                                                      .toString() +
                                                  ' ' +
                                                  type,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                          Spacer(),
                                          Text(
                                              orders[index]['created_at']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white))
                                        ]),
                                      ),
                                      Container(height: 1),
                                      Expanded(
                                          flex: 4,
                                          child: Row(children: [
                                            Container(
                                                width: 100,
                                                margin: EdgeInsets.only(
                                                    left: 5, top: 5, bottom: 5),
                                                child: Icon(
                                                  Icons.shopping_bag_outlined,
                                                  size: 50,
                                                  color: Colors.grey,
                                                )),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                      SizedBox(height: 5),
                                                      Expanded(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                  orders[index][
                                                                              'total']
                                                                          .toString() +
                                                                      " TMT",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: CustomColors
                                                                          .appColor)))),
                                                      Expanded(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                  orders[index][
                                                                              'product_count']
                                                                          .toString() +
                                                                      " haryt",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: CustomColors
                                                                          .appColor)))),
                                                      Expanded(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Row(
                                                                  children: [
                                                                    if (orders[index]
                                                                            [
                                                                            'status'] ==
                                                                        'pending')
                                                                      Container(
                                                                          child: Text(
                                                                              'Garaşylýar',
                                                                              style: TextStyle(fontSize: 14, color: Colors.orange))),
                                                                    if (orders[index]
                                                                            [
                                                                            'status'] ==
                                                                        'canceled')
                                                                      Container(
                                                                          child: Text(
                                                                              'Gaýtarylan',
                                                                              style: TextStyle(fontSize: 14, color: Colors.red))),
                                                                    if (orders[index]
                                                                            [
                                                                            'status'] ==
                                                                        'accepted')
                                                                      Container(
                                                                          child: Text(
                                                                              'Kabul edilen',
                                                                              style: TextStyle(fontSize: 14, color: Colors.green))),
                                                                  ]))),
                                                    ])))
                                          ]))
                                    ]))),
                              ));
                        },
                        // separatorBuilder:
                        //     (BuildContext context, int index) =>
                        //         const Divider(),
                      )),
                    )
                  ])
                : Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.appColor))));
  }

  get_orders(String customer_id) async {
    String user_id = await get_store_id();

    String url = ordersUrl + '?store=$user_id';
    final uri = Uri.parse(url);

    Map<String, String> headers = global_headers;
    headers['Token'] = await get_access_token();
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 403) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }

    setState(() {
      try {
        orders = json['data'];
      } catch (err) {}
      determinate = true;
      try {} catch (err) {
        QuickAlert.show(
            context: context, type: QuickAlertType.error, text: 'Error');
      }

      is_loading = true;
    });
  }
}
