import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Customer/Orders/Orders.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderDetail extends StatefulWidget {
  final String order_id;
  final Function refresh;
  OrderDetail({Key? key, required this.order_id, required this.refresh})
      : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool determinate = false;
  int itemCount = 0;
  var shopingCarts = [];
  var array = [];
  var order = {};
  var products = [];
  int deliveryPrice = 0;
  var status;
  final newDeliveryPrice = TextEditingController();

  var store_name = '';
  var store_id = '';
  var logoUrl = '';
  var store_phone = '';
  var orderType = '';

  bool isLoading = true;

  void setOrderStatus(value) {
    setState(() {
      status = value;
    });
  }

  void initState() {
    super.initState();
    getData(widget.order_id);
  }

  @override
  Widget build(BuildContext context) {
    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Sargydyň ýagdaýy üýtgedildi!',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColor,
          type: QuickAlertType.success,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            getData(widget.order_id);
          });
    }

    showErrorAlert(String text) {
      QuickAlert.show(
          text: text,
          title: "Ýalňyşlyk!",
          confirmBtnColor: Colors.green,
          confirmBtnText: 'Dowam et',
          context: context,
          type: QuickAlertType.error);
    }

    showWarningAlert(String text, String id) {
      QuickAlert.show(
          title: 'Sebet ID: $id',
          text: text,
          context: context,
          confirmBtnText: 'Tassyklaýaryn',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            final uri = Uri.parse(serverIp + '/mob/orders/delete/$id');

            Map<String, String> headers = global_headers;

            headers['Token'] = await get_access_token();

            final response = await http.post(uri, headers: headers);
            if (response.statusCode == 200) {
              widget.refresh();
              // Navigator.pop(context);
              // Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Orders(
                          customer_id: this.store_id, callbackFunc: () {})));
            } else {
              Navigator.pop(context);
              showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
            }
            setState(() {
              determinate = false;
            });
          },
          type: QuickAlertType.info);
    }

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
              'Sargyt: ' + widget.order_id.toString(),
              style: TextStyle(color: CustomColors.appColorWhite),
            ),
            actions: [
              PopupMenuButton<String>(
                shadowColor: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                color: CustomColors.appColorWhite,
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    if (this.orderType == 'gelen')
                      PopupMenuItem<String>(
                          child: GestureDetector(
                              onTap: () async {
                                var id = widget.order_id;
                                String url = ordersUrl + '/$id';
                                final uri = Uri.parse(url);

                                Map<String, String> headers = {};
                                for (var i in global_headers.entries) {
                                  headers[i.key] = i.value.toString();
                                }

                                final response = await http.put(uri,
                                    headers: headers,
                                    body: {'status': 'accepted'});
                                if (response.statusCode == 200) {
                                  showSuccessAlert();
                                  widget.refresh();
                                } else {
                                  Navigator.pop(context);
                                  showErrorAlert(
                                      'Bagyşlaň ýalňyşlyk ýüze çykdy!');
                                }
                              },
                              child: Container(
                                  color: Colors.white,
                                  height: 40,
                                  width: double.infinity,
                                  child: Row(children: [
                                    Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                    Text('Kabul etmek',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.green))
                                  ])))),
                    if (this.orderType == 'gelen')
                      PopupMenuItem<String>(
                          child: GestureDetector(
                              onTap: () async {
                                var id = widget.order_id;
                                String url = ordersUrl + '/$id';
                                final uri = Uri.parse(url);
                                Map<String, String> headers = {};
                                for (var i in global_headers.entries) {
                                  headers[i.key] = i.value.toString();
                                }
                                headers['token'] = await get_access_token();
                                final response = await http.put(uri,
                                    headers: headers,
                                    body: {'status': 'canceled'});
                                if (response.statusCode == 200) {
                                  showSuccessAlert();
                                  widget.refresh();
                                } else {
                                  Navigator.pop(context);
                                  showErrorAlert(
                                      'Bagyşlaň ýalňyşlyk ýüze çykdy!');
                                }
                              },
                              child: Container(
                                  color: Colors.white,
                                  height: 40,
                                  width: double.infinity,
                                  child: Row(children: [
                                    Icon(
                                      Icons.close,
                                      size: 15,
                                      color: Color.fromARGB(255, 201, 159, 31),
                                    ),
                                    Text('Gaýtarmak',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 201, 159, 31)))
                                  ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showWarningAlert('Sargydy pozmagy tassyklaň!',
                                  order['id'].toString());
                            },
                            child: Container(
                              color: Colors.white,
                              height: 40,
                              width: double.infinity,
                              child: Row(children: [
                                Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                Text('Bozmak',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.red))
                              ]),
                            ))),
                  ];
                  return menuEntries2;
                },
              )
            ]),
        body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: CustomColors.appColor,
            onRefresh: () async {
              setState(() {
                getData(widget.order_id);
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView(children: [
                Container(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoreDetail(
                                      id: int.parse(this.store_id),
                                    )));
                      },
                      child: Card(
                        color: CustomColors.appColorWhite,
                        surfaceTintColor: CustomColors.appColorWhite,
                        shadowColor: CustomColors.appColorWhite,
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 5),
                          child: Row(children: [
                            if (this.logoUrl.length > 0)
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.network(
                                  serverIp + this.logoUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (e, o, c) {
                                    return Image.asset(
                                      defaulImageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    this.store_name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: CustomColors.appColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '+993 ' + this.store_phone,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: CustomColors.appColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton.small(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  backgroundColor: Colors.green,
                                  onPressed: () async {
                                    final call = Uri.parse(
                                        'tel: +993' + this.store_phone);
                                    if (await canLaunchUrl(call)) {
                                      launchUrl(call);
                                    } else {
                                      throw 'Could not launch $call';
                                    }
                                  },
                                  child: Icon(Icons.phone_enabled,
                                      color: Colors.white)),
                            )),
                          ]),
                        ),
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  if (order['status'] == 'accepted')
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        child: const Text("Kabul edilen",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 160, 121, 3)))),
                                  Spacer(),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                          order['created_at'].toString(),
                                          style: TextStyle(
                                              color: CustomColors.appColor)))
                                ])
                              ]),
                        ])),
                Column(
                  children: products.map((item) {
                    return Container(
                        height: 110,
                        child: Card(
                            color: CustomColors.appColorWhite,
                            shadowColor:
                                const Color.fromARGB(255, 200, 198, 198),
                            surfaceTintColor: CustomColors.appColorWhite,
                            elevation: 4,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Row(children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        child: Image.network(
                                      serverIp + item['img'].toString(),
                                      height: 110,
                                      fit: BoxFit.cover,
                                      errorBuilder: (e, o, c) {
                                        return Image.asset(
                                          defaulImageUrl,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ))),
                                Expanded(
                                    flex: 5,
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    item['name'].toString(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: CustomColors
                                                            .appColor),
                                                  )),
                                              Text(
                                                  'Bahasy: ' +
                                                      item['price'].toString() +
                                                      ' TMT',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              Text(
                                                  item['amount'].toString() +
                                                      ' sany',
                                                  style: TextStyle(
                                                      color: Colors.black54)),
                                              Text(
                                                  item['total'].toString() +
                                                      ' TMT',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ]))),
                              ]),
                            )));
                  }).toList(),
                ),
                Container(
                    margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                    alignment: Alignment.centerRight,
                    child: Text(
                        order['product_count'].toString() + " sany haryt",
                        style: TextStyle(
                            color: CustomColors.appColor, fontSize: 15))),
                Container(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Row(children: [
                          Text("Jemi:",
                              style: TextStyle(
                                  color: CustomColors.appColor, fontSize: 17)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                                order['product_total'].toString() + " TMT",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.appColor,
                                    fontSize: 17)),
                          )
                        ]),
                        Row(children: [
                          Text("Statusy:",
                              style: TextStyle(
                                  color: CustomColors.appColor, fontSize: 17)),
                          if (order['status'] == 'canceled')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Gaýtarylan",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17)),
                            ),
                          if (order['status'] == 'accepted')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Kabul edilen",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 17)),
                            ),
                          if (order['status'] == 'pending')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Garaşylýar",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.orange)),
                            ),
                        ]),
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text("Bellik: " + order['note'].toString(),
                        style: TextStyle(
                            color: CustomColors.appColor, fontSize: 17))),
              ]),
            )));
  }

  getData(String order_id) async {
    String url = ordersUrl + '/$order_id';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    var user_id = await get_store_id();

    setState(() {
      this.isLoading = false;
      order = json['data'];
      products = json['data']['products'];
      itemCount = products.length;

      if (user_id.toString() == order['sender']['id'].toString()) {
        orderType = 'giden';
        this.store_name = order['accepter']['name'];
        this.store_id = order['accepter']['id'].toString();
        this.store_phone = order['accepter']['phone'].toString();
        this.logoUrl = order['accepter']['logo'];
      }
      if (user_id.toString() == order['accepter']['id'].toString()) {
        orderType = 'gelen';
        this.store_name = order['sender']['name'];
        this.store_id = order['sender']['id'].toString();
        this.store_phone = order['sender']['phone'].toString();
        this.logoUrl = order['sender']['logo'];
      }
    });
  }
}
