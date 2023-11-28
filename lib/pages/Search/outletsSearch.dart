import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Search/outletsSearchList.dart';
import 'package:my_app/widgets/multiSelect.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../customCheckbox.dart';

class OutletsSearch extends StatefulWidget {
  final Function callbackFunc;
  OutletsSearch({Key? key, required this.callbackFunc}) : super(key: key);

  @override
  State<OutletsSearch> createState() =>
      _OutletsSearchState(callbackFunc: callbackFunc);
}

class _OutletsSearchState extends State<OutletsSearch> {
  final Function callbackFunc;
  _OutletsSearchState({required this.callbackFunc});

  final idController = TextEditingController();
  final nameCodeController = TextEditingController();
  final open_atController = TextEditingController();
  final close_atController = TextEditingController();
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
              border: Border.all(color: CustomColors.appColors, width: 1),
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
              )
              // MyDropdownButton(
              //     items: categories, callbackFunc: callbackCategory)
              ),
        ),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Kategoriýasy',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
          Stack(children: <Widget>[
            Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColors, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                ),
                child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusColor: Colors.white,
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 14)),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }))),
            Positioned(
                left: 25,
                top: 12,
                child: Container(
                    color: Colors.white,
                    child: Text('Id',
                        style: TextStyle(color: Colors.black, fontSize: 12))))
          ]),

          Stack(children: <Widget>[
            Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColors, width: 1),
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
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }))),
            Positioned(
                left: 25,
                top: 12,
                child: Container(
                    color: Colors.white,
                    child: Text('Ady',
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
                          Border.all(color: CustomColors.appColors, width: 1),
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

          //   Stack(
          //   children: <Widget>[
          //     Container(
          //       width: double.infinity,
          //       height: 40,
          //       margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          //       decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
          //         borderRadius: BorderRadius.circular(5),
          //         shape: BoxShape.rectangle,
          //       ),
          //       child: Container( margin: EdgeInsets.only(left: 15),
          //         child: MyDropdownButton(items: sizes, callbackFunc: callbackSize,),
          //       ),
          //     ),
          //     Positioned(
          //       left: 25,
          //       top: 12,
          //       child: Container(color: Colors.white,
          //         child: Text('Göwrümi', style: TextStyle(color: Colors.black, fontSize: 12),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          // Container(
          //   height: 50,
          //   margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //       Container(
          //         alignment: Alignment.center,
          //         height: 35,
          //         width: 150,
          //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
          //         child:  TextFormField(
          //           controller: open_atController,
          //           decoration: const InputDecoration(hintText: 'Açylýan wagty: ',
          //               border: InputBorder.none,
          //               focusColor: Colors.white,
          //               contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
          //               readOnly: true,
          //               onTap: () async {
          //                 TimeOfDay ? pickedTime =  await showTimePicker(
          //                   initialTime: TimeOfDay.now(),
          //                   context: context,
          //                   );
          //                 if(pickedTime != null ){
          //                   DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
          //                   String formattedTime = DateFormat('HH:mm').format(parsedTime);
          //                   setState(() {
          //                     open_atController.text = formattedTime;
          //                     });
          //                 }else{
          //                   print("Time is not selected");
          //                 }
          //             },),),
          //       Container(
          //         alignment: Alignment.center,
          //         height: 35,
          //         width: 150,
          //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
          //         child:  TextFormField(
          //           controller: close_atController,
          //           decoration: const InputDecoration(hintText: 'Ýapylyan wagty: ',
          //               border: InputBorder.none,
          //               focusColor: Colors.white,
          //               contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
          //               readOnly: true,
          //               onTap: () async {
          //                 TimeOfDay ? pickedTime =  await showTimePicker(
          //                   initialTime: TimeOfDay.now(),
          //                   context: context,
          //                   );
          //                 if(pickedTime != null ){
          //                   DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
          //                   String formattedTime = DateFormat('HH:mm').format(parsedTime);
          //                   setState(() {
          //                     close_atController.text = formattedTime;
          //                     });
          //                 }else{
          //                   print("Time is not selected");
          //                 }
          //             },),),
          //   ],
          // ),
          // ),

          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15, top: 15),
              height: 40,
              child: CustomCheckBox(
                  labelText: 'Nagt däl töleg',
                  callbackFunc: callbackNone_cash_pay,
                  status: false)),

          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15, top: 1),
              height: 40,
              child: CustomCheckBox(
                  labelText: 'Kredit',
                  callbackFunc: callbackCredit,
                  status: false)),
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
                  params['name_tm'] = nameCodeController.text.toString();
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

                // if (sizeController!={}){params['size'] = sizeController['id'].toString();}
                // if (open_atController.text!=''){params['open_at'] = open_atController.text.toString();}
                // if (close_atController.text!=''){params['close_at'] = close_atController.text.toString();}

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OutletsSearchList(params: params)));
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
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'device-id': device_id
    });
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      categories = json['categories'];
      print(categories);
    });
  }
}
