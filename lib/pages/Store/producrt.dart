// ignore_for_file: unused_local_variable, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:convert';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../main.dart';
import '../Customer/login.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import 'package:http/http.dart' as http;

class StoreProducts extends StatefulWidget {
  StoreProducts(
      {Key? key,
      required this.id,
      required this.refresh_item_count,
      required this.isTopList})
      : super(key: key);
  final String id;
  final Function refresh_item_count;
  final Function isTopList;

  @override
  State<StoreProducts> createState() => _StoreProductsState(id: id);
}

class _StoreProductsState extends State<StoreProducts> {
  @override
  final String id;
  var shoping_cart_items = [];
  var products = [];
  var keyword = TextEditingController();
  var baseurl = '';
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    get_products_modul(id);
    _scrollController.addListener(_controllListener);
    super.initState();
  }

  _StoreProductsState({required this.id});

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

    return Column(children: [
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
                      get_products_modul(id);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        keyword.text = '';
                      });
                      get_products_modul(id);
                    },
                  ),
                  hintText: 'Gözleg...',
                  border: InputBorder.none),
            ),
          ),
        ),
      SizedBox(
        height: MediaQuery.of(context).size.height-200,
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
                              builder: (context) => OtherGoodsDetail(
                                    id: item['id'].toString(),
                                    title: 'Harytlar',
                                  )));
                    },
                    child: Card(
                      color: CustomColors.appColorWhite,
                                      shadowColor: const Color.fromARGB(255, 200, 198, 198),
                                      surfaceTintColor: CustomColors.appColorWhite,
                                      elevation: 5,

                        child: Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width / 3 - 10,
                            child: Column(children: [
                              Container(
                                  alignment: Alignment.topCenter,
                                  child: item['img'] != null && item['img'] != ""
                                      ? Image.network(
                                          baseurl + item['img'].toString(),
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width /
                                                      3 -
                                                  10,
                                          height: 120,
                                        )
                                      : Image.asset(
                                          'assets/images/default.jpg',
                                          height:120,
                                        )),
                              
                              Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (item['name']!=null && item['name']!='')
                                      Text(
                                        item['name'].toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: CustomColors.appColors,
                                            overflow: TextOverflow.clip),
                                      ),
                                      if (item['price']!=null && item['price']!='')
                                      Text(
                                        item['price'].toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: CustomColors.appColors,
                                            overflow: TextOverflow.clip),
                                      ),
                                      ConstrainedBox(
                                        constraints:
                                            BoxConstraints.tightFor(height: 20),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green[700]),
                                          child: Text('Sebede goş',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      CustomColors.appColorWhite,
                                                  overflow: TextOverflow.clip)),
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
                                                      id: id);
                                              var array = [];
                                              for (final row in shoping_cart) {
                                                array.add(row);
                                              }

                                              var shoping_cart_item =
                                                  await dbHelper
                                                      .get_shoping_cart_item(
                                                          soping_cart_id: array[0]
                                                                  ['id']
                                                              .toString(),
                                                          product_id: item['id']
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
                                                  'product_name': item['name'],
                                                  'product_price':
                                                      item['price'].toString(),
                                                  'count': 1
                                                };
                                                var shoping_cart = await dbHelper
                                                    .add_product_shoping_cart(
                                                        row);
                                                showSuccessAlert();
                                                var count = await dbHelper
                                                    .get_shoping_cart_items(
                                                        soping_cart_id: array[0]
                                                                ['id']
                                                            .toString());
                                                var array1 = [];
                                                for (final row in count) {
                                                  array1.add(row);
                                                }

                                                widget.refresh_item_count(
                                                    array1.length);
                                              } else {
                                                showWarningAlert();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                            ]))));
              }).toList(),
            )
          ],
        ),
      ),
    ]);
  }

  void get_products_modul(id) async {
    Urls server_url = new Urls();
    var param = 'products';
    String url = server_url.get_server_url() + '/mob/' + param + '?store=' + id;

    if (keyword.text != '') {
      url = server_url.get_server_url() +
          '/mob/' +
          param +
          '?store=' +
          id +
          "&name=" +
          keyword.text;
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
      widget.isTopList();
    }
  }
}
