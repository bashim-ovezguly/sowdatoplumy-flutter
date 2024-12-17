import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Profile/locationWidget.dart';
import 'package:my_app/pages/Search/storeSearchList.dart';
import 'package:my_app/widgets/multiSelect.dart';
import '../../dB/constants.dart';

class StoreSearch extends StatefulWidget {
  final Function callbackFunc;
  StoreSearch({Key? key, required this.callbackFunc}) : super(key: key);

  @override
  State<StoreSearch> createState() =>
      _StoreSearchState(callbackFunc: callbackFunc);
}

class _StoreSearchState extends State<StoreSearch> {
  final Function callbackFunc;
  _StoreSearchState({required this.callbackFunc});

  final idController = TextEditingController();
  final nameCodeController = TextEditingController();
  var data = {};

  List<dynamic> categories = [];
  List<dynamic> sizes = [];

  var categoryController = {};
  var sizeController = {};

  bool credit = false;
  bool none_cash_pay = false;

  callbackCredit() {
    setState(() {
      credit = !credit;
    });
  }

  callbackNone_cash_pay() {
    setState(() {
      none_cash_pay = !none_cash_pay;
    });
  }

  callbackSize(new_value) {
    setState(() {
      sizeController = new_value;
    });
  }

  callbackCategory(new_value) {
    setState(() {
      categoryController = new_value;
    });
  }

  var locationController = {};
  callbackLocation(new_value) {
    setState(() {
      locationController = new_value;
    });
  }

  void initState() {
    get_store_index();
    callbackFunc(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                ),
                child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: nameCodeController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusColor: Colors.white,
                          contentPadding:
                              EdgeInsets.only(left: 10, bottom: 14)),
                    ))),
            Positioned(
                left: 25,
                top: 12,
                child: Container(
                    color: Colors.white,
                    child: Text('Ady',
                        style: TextStyle(color: Colors.black, fontSize: 12))))
          ]),
          Stack(children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CategorySelect(
                              categories: categories,
                              callbackFunc: callbackCategory);
                        },
                      );
                    },
                    child: categoryController['name_tm'] != null
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              categoryController['name_tm'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Text(""),
                  )),
            ),
            Positioned(
                left: 25,
                top: 12,
                child: Container(
                    color: Colors.white,
                    child: Text('Kategoriýasy',
                        style: TextStyle(color: Colors.black, fontSize: 12))))
          ]),
          Stack(
            children: <Widget>[
              GestureDetector(
                child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomColors.appColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: locationController['name_tm'] != null
                            ? Text(locationController['name_tm'],
                                style: TextStyle(
                                  fontSize: 16,
                                ))
                            : Text(''))),
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return LocationWidget(callbackFunc: callbackLocation);
                    },
                  );
                },
              ),
              Positioned(
                left: 25,
                top: 12,
                child: Container(
                  color: Colors.white,
                  child: Text(
                    'Ýerleşýän ýeri',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 45,
        width: 45,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromARGB(255, 182, 210, 196), width: 2.0),
              color: Colors.blue[900],
              shape: BoxShape.circle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(500.0),
              onTap: () {
                Map<String, dynamic> params = {};
                if (categoryController != {}) {
                  params['category'] = categoryController['id'].toString();
                }
                if (nameCodeController.text != '') {
                  params['name'] = nameCodeController.text.toString();
                }
                if (idController.text != '') {
                  params['id'] = idController.text.toString();
                }
                if (locationController != {}) {
                  params['location'] = locationController['id'].toString();
                }

                if (credit == true) {
                  params['credit'] = 'on';
                }
                if (none_cash_pay == true) {
                  params['none_cash'] = 'on';
                }

                print(params);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreSearchList(params: params)));
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
                //size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void get_store_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/store';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      categories = json['categories'];
    });
  }
}
