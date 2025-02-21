// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'dart:convert';

import '../../dB/constants.dart';
import '../Car/carDetail.dart';
import 'package:http/http.dart' as http;

class StoreCars extends StatefulWidget {
  StoreCars({Key? key, required this.id, required this.storeName})
      : super(key: key);
  final String id;
  final String storeName;

  @override
  State<StoreCars> createState() =>
      _StoreCarsState(id: id, storeName: storeName);
}

class _StoreCarsState extends State<StoreCars> {
  @override
  final String id;
  var shoping_cart_items = [];
  var products = [];
  var keyword = TextEditingController();
  var storeName = '';

  // late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    get_products_modul(id);
    // _scrollController.addListener(_controllListener);
    super.initState();
  }

  _StoreCarsState({required this.id, required this.storeName});

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
            'Awtoulaglar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height - 80,
              child: ListView(
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: products.map((item) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CarDetail(id: item['id'])));
                          },
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.all(5),
                              height: 180,
                              width: MediaQuery.of(context).size.width / 3 - 10,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [appShadow]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    item['img'] != null && item['img'] != ""
                                        ? Image.network(
                                            serverIp + item['img'].toString(),
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
                                          ),
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item['mark'].toString() +
                                                  " " +
                                                  item['model'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: CustomColors.appColor,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Text(
                                              item['price'].toString() + ' TMT',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  overflow: TextOverflow.clip),
                                            ),
                                            Text(
                                              item['created_at']
                                                  .toString()
                                                  .split(' ')[0],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  overflow: TextOverflow.clip),
                                            ),
                                          ],
                                        ))
                                  ])));
                    }).toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void get_products_modul(id) async {
    String url = carsUrl + '?store=' + id;

    if (keyword.text != '') {
      url = url + '?store=' + id + "&name=" + keyword.text;
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
    });
  }

  // void _controllListener() {
  //   if (_scrollController.offset <= 0) {
  //     widget.isTopList();
  //   }
  // }
}
