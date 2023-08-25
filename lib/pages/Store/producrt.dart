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
  StoreProducts({Key? key, required this.id, required this.refresh_item_count})
      : super(key: key);
  final String id;
  final Function refresh_item_count;

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

  @override
  void initState() {
    get_products_modul(id);
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

    return ListView(
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

                  // if (modul == '1') {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               CarStore(id: item['id'].toString())));
                  // }
                  // if (modul == '2') {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               AutoPartsDetail(id: item['id'].toString())));
                  // }
                  // if (modul == '3') {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               PropertiesDetail(id: item['id'].toString())));
                  // }
                  // if (modul == '4') {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               ConstructionDetail(id: item['id'].toString())));
                  // }
                },
                child: Card(
                    elevation: 2,
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
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          10,
                                      height: 130,
                                    )
                                  : Image.asset(
                                      'assets/images/default.jpg',
                                      height: 200,
                                    )),
                          Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'].toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.appColors,
                                        overflow: TextOverflow.clip),
                                  ),
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
                                              color: CustomColors.appColorWhite,
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

                                          var shoping_cart_item = await dbHelper
                                              .get_shoping_cart_item(
                                                  soping_cart_id:
                                                      array[0]['id'].toString(),
                                                  product_id:
                                                      item['id'].toString());
                                          for (final row in shoping_cart_item) {
                                            shoping_cart_items.add(row);
                                          }
                                          if (shoping_cart_items.length == 0) {
                                            Map<String, dynamic> row = {
                                              'soping_cart_id': array[0]['id'],
                                              'product_id': item['id'],
                                              'product_img': item['img'],
                                              'product_name': item['name'],
                                              'product_price':
                                                  item['price'].toString(),
                                              'count': 1
                                            };
                                            var shoping_cart = await dbHelper
                                                .add_product_shoping_cart(row);
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
    );
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
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      products = json['data'];
      baseurl = server_url.get_server_url();
    });
  }
}
