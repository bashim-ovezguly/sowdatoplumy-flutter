// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Profile/Products/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../dB/textStyle.dart';
import '../../progressIndicator.dart';

class ProfileProducts extends StatefulWidget {
  ProfileProducts(
      {Key? key,
      required this.customer_id,
      required this.callbackFunc,
      required this.user_customer_id})
      : super(key: key);
  final String customer_id;
  final String user_customer_id;
  final Function callbackFunc;
  @override
  State<ProfileProducts> createState() =>
      _ProfileProductsState(customer_id: customer_id);
}

class _ProfileProductsState extends State<ProfileProducts> {
  final String customer_id;
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  void initState() {
    get_my_products(customer_id: customer_id);
    super.initState();
  }

  refreshFunc() async {
    widget.callbackFunc();
    get_my_products(customer_id: customer_id);
  }

  _ProfileProductsState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: Text(
                "Harytlar",
                style: CustomText.appBarText,
              ),
              actions: [
                if (widget.user_customer_id == '')
                  PopupMenuButton<String>(
                    color: CustomColors.appColorWhite,
                    surfaceTintColor: CustomColors.appColorWhite,
                    shadowColor: CustomColors.appColorWhite,
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> menuEntries2 = [
                        PopupMenuItem<String>(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddDatasPage(
                                                index: 0,
                                              )));
                                },
                                child: Container(
                                    color: Colors.white,
                                    height: 40,
                                    width: double.infinity,
                                    child: Row(children: [
                                      Icon(Icons.add, color: Colors.green),
                                      Text(' Goşmak')
                                    ])))),
                      ];
                      return menuEntries2;
                    },
                  ),
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColor,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate
                    ? Column(
                        children: <Widget>[
                          Expanded(
                            flex: 14,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String name = data[index]['name'];
                                  String price = data[index]['price'] + ' TMT';
                                  String status = '';
                                  if (data[index]['status'] == 'pending') {
                                    status = 'Garaşylýar';
                                  }
                                  String created_at =
                                      data[index]['created_at'].split(' ')[0];

                                  String img = data[index]['img'];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyOtherGoodsDetail(
                                                      id: data[index]['id']
                                                          .toString(),
                                                      user_customer_id: widget
                                                          .user_customer_id,
                                                      refreshFunc:
                                                          refreshFunc)));
                                    },
                                    child: Container(
                                      child: Card(
                                        color: CustomColors.appColorWhite,
                                        shadowColor: const Color.fromARGB(
                                            255, 200, 198, 198),
                                        surfaceTintColor:
                                            CustomColors.appColorWhite,
                                        elevation: 5,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          child: Container(
                                            height: 110,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 1,
                                                    child: ClipRect(
                                                      child: Container(
                                                        height: 110,
                                                        child: FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: img != '' &&
                                                                  img != null
                                                              ? Image.network(
                                                                  serverIp +
                                                                      img,
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/default.jpg',
                                                                ),
                                                        ),
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    color: CustomColors
                                                        .appColorWhite,
                                                    margin: EdgeInsets.only(
                                                        left: 2),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              maxLines: 2,
                                                              softWrap: false,
                                                              style: CustomText
                                                                  .itemTextBold,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Row(
                                                                    children: <Widget>[
                                                                      Flexible(
                                                                          child:
                                                                              new Container(
                                                                        child: Text(
                                                                            price,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.blue)),
                                                                      ))
                                                                    ]))),
                                                        Expanded(
                                                            child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              created_at,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: CustomColors
                                                                      .appColor)),
                                                        )),
                                                        Expanded(
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  status,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .orange),
                                                                ))),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColor))))
        : CustomProgressIndicator(funcInit: initState);
  }

  void get_my_products({required customer_id}) async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getInt('user_id').toString();

    String url = productsUrl + '?store=$user_id';
    final uri = Uri.parse(url);

    Map<String, String> headers = {
      'Token': prefs.getString('access_token').toString()
    };

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['data'];
      determinate = true;
    });
  }
}
