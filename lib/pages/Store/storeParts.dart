// ignore_for_file: unused_local_variable, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:convert';

import '../../dB/constants.dart';
import '../../main.dart';
import '../Products/ProductDetail.dart';
import 'package:http/http.dart' as http;

class StoreParts extends StatefulWidget {
  StoreParts({
    Key? key,
    required this.id,
    required this.storeName,
  }) : super(key: key);

  final String id;
  final String storeName;
  late Function refresh_item_count;
  late Function isTopList;

  @override
  State<StoreParts> createState() =>
      _StorePartsState(id: id, storeName: storeName);
}

class _StorePartsState extends State<StoreParts> {
  @override
  final String id;
  var shoping_cart_items = [];
  var products = [];
  var keyword = TextEditingController();
  var baseurl = '';
  var storeName = '';
  bool buttonTop = false;
  int item_count = 0;
  var shoping_carts = [];

  // final ScrollController _controller = ScrollController();
  String delivery_price_str = "";
  var data = {};
  late ScrollController _scrollController = ScrollController();

  void isTopList() {
    double position = 0.0;
    _scrollController.position.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
  }

  refresh_item_count(value) async {
    var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: id);
    var array = [];
    for (final row in shoping_cart) {
      array.add(row);
    }
    setState(() {
      item_count = value;
    });
  }

  @override
  void initState() {
    getParts(id);
    _scrollController.addListener(_controllListener);
    // getsinglemarkets(id: widget.id, title: "");

    super.initState();
  }

  _StorePartsState({required this.id, required this.storeName});

  Widget build(BuildContext context) {
    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Haryt sebede goşuldy.',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColor,
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
          confirmBtnColor: CustomColors.appColor,
          type: QuickAlertType.warning,
          onConfirmBtnTap: () {
            Navigator.pop(context);
          });
    }

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
        SizedBox(height: 10),
        FloatingActionButton.small(
            backgroundColor: CustomColors.appColor,
            onPressed: () {
              isTopList();
            },
            child: Icon(Icons.north, color: CustomColors.appColorWhite))
      ]),
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextFormField(
              controller: keyword,
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      getParts(id);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        keyword.text = '';
                      });
                      getParts(id);
                    },
                  ),
                  hintText: 'Gözleg...',
                  border: InputBorder.none),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: ListView(
            controller: _scrollController,
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
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ]),
                          child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width / 3 - 10,
                              child: Column(children: [
                                Container(
                                    alignment: Alignment.topCenter,
                                    child: item['img'] != null &&
                                            item['img'] != ""
                                        ? Image.network(
                                            baseurl + item['img'].toString(),
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3 -
                                                10,
                                            height: 120,
                                          )
                                        : Image.asset(
                                            'assets/images/default.jpg',
                                            height: 120,
                                          )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (item['name'] != null &&
                                            item['name'] != '')
                                          Text(
                                            item['name'].toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: CustomColors.appColor,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        if (item['price'] != null &&
                                            item['price'] != '')
                                          Text(
                                            item['price'].toString() + ' TMT',
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
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

  void getParts(id) async {
    Urls server_url = new Urls();
    var param = 'products';
    String url = partsUrl + '?store=' + id;

    if (keyword.text != '') {
      url = partsUrl + '?store=' + id + "&name=" + keyword.text;
    }
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      products = json['data'];
      baseurl = server_url.get_server_url();
    });
  }

  void _controllListener() {
    if (_scrollController.offset <= 0) {
      isTopList();
    }
  }
}
