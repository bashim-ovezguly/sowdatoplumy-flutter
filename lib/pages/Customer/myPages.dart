import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Customer/AutoParts/list.dart';
import 'package:my_app/pages/Customer/AwtoCar/list.dart';
import 'package:my_app/pages/Customer/Construction/list.dart';
import 'package:my_app/pages/Customer/OtherGoods/list.dart';
import 'package:my_app/pages/Customer/RealEstate/list.dart';
import 'package:my_app/pages/Customer/Ribbon/list.dart';
import 'package:my_app/pages/Customer/Services/list.dart';
import 'package:my_app/pages/Customer/editProfil.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/myStores.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../../main.dart';
import 'package:quickalert/quickalert.dart';
import '../progressIndicator.dart';
import 'Orders/arrivedOrders.dart';
import 'Orders/goneOrder.dart';

var user_data = [];

class MyPages extends StatefulWidget {
  final String user_customer_id;
  MyPages({Key? key, this.user_customer_id = ''}) : super(key: key);

  @override
  State<MyPages> createState() => _MyPagesState();
}

class _MyPagesState extends State<MyPages> {
  var user = {};
  var baseurl = "";
  bool determinate = false;
  String user_id = '';
  bool status = true;
  List<dynamic> stores = [];

  void initState() {
    timers();
    get_userinfo();
    super.initState();
  }

  refreshFunc() async {
    get_userinfo();
  }

  timers() async {
    setState(() {
      status = true;
    });
    final completer = Completer();
    final t = Timer(Duration(seconds: 5), () => completer.complete());
    await completer.future;
    setState(() {
      if (determinate == false) {
        status = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var user_customer_name =
        Provider.of<UserInfo>(context, listen: false).user_customer_name;

    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Siziň maglumatyňyz üýtgedildi !',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColors,
          type: QuickAlertType.success);
    }

    return status
        ? Scaffold(
            appBar: AppBar(
                title: widget.user_customer_id == ''
                    ? Text(
                        "Meniň sahypam",
                        style: CustomText.appBarText,
                      )
                    : Text(
                        user_customer_name.toString() + " şahsy otag",
                        style: CustomText.appBarText,
                      ),
                actions: [
                  if (widget.user_customer_id == '')
                    GestureDetector(
                        onTap: () {
                          showConfirmationDialog(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.login_outlined),
                        ))
                ]),
            body: determinate
                ? Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: user['img'] != ''
                                    ? CircleAvatar(
                                        radius: 48, // Image radius
                                        backgroundImage: NetworkImage(
                                            baseurl + user['img'].toString()))
                                    : Image.asset('assets/images/default.jpg')),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: user['name'] != null
                                              ? Text(
                                                  user['name'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: CustomColors
                                                          .appColors),
                                                )
                                              : Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: CustomColors
                                                          .appColors),
                                                ))),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: user['phone'] != null
                                              ? Text(
                                                  user['phone'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: CustomColors
                                                          .appColors),
                                                )
                                              : Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: CustomColors
                                                          .appColors),
                                                ))),
                                  if (user['email'] != '' &&
                                      user['email'] != null)
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: user['email'] != null
                                                ? Text(
                                                    user['email'].toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: CustomColors
                                                            .appColors),
                                                  )
                                                : Text(
                                                    '',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors
                                                            .appColors),
                                                  ))),
                                  Expanded(
                                      child: Row(
                                    children: [
                                      Container(
                                          child: user['id'] != null
                                              ? Text(
                                                  user['id'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: CustomColors
                                                          .appColors),
                                                )
                                              : Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: CustomColors
                                                          .appColors),
                                                )),
                                    ],
                                  )),
                                  if (widget.user_customer_id == '')
                                    Expanded(child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfil(
                                                        customer_id: user['id']
                                                            .toString(),
                                                        email: user['email']
                                                            .toString(),
                                                        name: user[
                                                            'name'.toString()],
                                                        phone: user['phone']
                                                            .toString(),
                                                        img: baseurl +
                                                            user['img']
                                                                .toString(),
                                                        callbackFunc:
                                                            refreshFunc,
                                                        showSuccessAlert:
                                                            showSuccessAlert)));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 120,
                                        color: CustomColors.appColors,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Sazlamalar",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: CustomColors
                                                        .appColorWhite)),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.settings,
                                              color: CustomColors.appColorWhite,
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: Column(children: <Widget>[
                            Container(
                                height: 115,
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MyStores(
                                                            user_customer_id: widget
                                                                .user_customer_id,
                                                            customer_id:
                                                                user['id']
                                                                    .toString(),
                                                            callbackFunc:
                                                                refreshFunc)));
                                              },
                                              child: Column(children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        user['room']['store']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: CustomColors
                                                                .appColors,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                         textAlign: TextAlign.center,
                                                    maxLines: 2)),
                                                Expanded(
                                                    flex: 2,
                                                    child: Image.asset(
                                                      'assets/images/store.png',
                                                      color: CustomColors
                                                          .appColors,
                                                      width: 50,
                                                      height: 50,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        'Söwda nokatlary',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: CustomColors
                                                                .appColors)))
                                              ]))),
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) => MyCars(
                                                                  customer_id:
                                                                      user['id']
                                                                          .toString(),
                                                                  user_customer_id:
                                                                      widget
                                                                          .user_customer_id,
                                                                )));
                                              },
                                              child: Column(children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        user['room']['cars']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: CustomColors
                                                                .appColors,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                Expanded(
                                                    flex: 2,
                                                    child: Image.asset(
                                                      'assets/images/car.png',
                                                      color: CustomColors
                                                          .appColors,
                                                      width: 50,
                                                      height: 50,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text('Awtoulaglar',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: CustomColors
                                                                .appColors)))
                                              ]))),
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AutoPartsList(
                                                                  user_customer_id:
                                                                      widget
                                                                          .user_customer_id,
                                                                  customer_id:
                                                                      user['id']
                                                                          .toString(),
                                                                  callbackFunc:
                                                                      refreshFunc,
                                                                )));
                                              },
                                              child: Column(children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        user['room']['parts']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: CustomColors
                                                                .appColors,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                Expanded(
                                                    flex: 2,
                                                    child: Image.asset(
                                                      'assets/images/parts.png',
                                                      color: CustomColors
                                                          .appColors,
                                                      width: 50,
                                                      height: 50,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text('Awtoşaýlar',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: CustomColors
                                                                .appColors)))
                                              ])))
                                    ])),
                            Container(
                                height: 115,
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(children: [
                                  Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RealEstateList(
                                                          customer_id:
                                                              user['id']
                                                                  .toString(),
                                                          callbackFunc:
                                                              refreshFunc,
                                                          user_customer_id: widget
                                                              .user_customer_id,
                                                        )));
                                          },
                                          child: Column(children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    user['room']['flats']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: CustomColors
                                                            .appColors,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/flats.png',
                                                  color: CustomColors.appColors,
                                                  width: 50,
                                                  height: 50,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                    'Gozgalmaýan emläkler',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors
                                                            .appColors),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2))
                                          ]))),
                                  Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConstructionList(
                                                          customer_id:
                                                              user['id']
                                                                  .toString(),
                                                          callbackFunc:
                                                              refreshFunc,
                                                          user_customer_id: widget
                                                              .user_customer_id,
                                                        )));
                                          },
                                          child: Column(children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    user['room']['materials']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: CustomColors
                                                            .appColors,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/material.png',
                                                  color: CustomColors.appColors,
                                                  width: 50,
                                                  height: 50,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text('Gurluşuk harytlar',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors
                                                            .appColors),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2))
                                          ]))),
                                  Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyOtherGoodsList(
                                                            customer_id:
                                                                user['id']
                                                                    .toString(),
                                                            callbackFunc:
                                                                refreshFunc,
                                                            user_customer_id: widget
                                                                .user_customer_id)));
                                          },
                                          child: Column(children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    user['room']['products']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: CustomColors
                                                            .appColors,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/products.png',
                                                  color: CustomColors.appColors,
                                                  width: 50,
                                                  height: 50,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text('Harytlar',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors
                                                            .appColors)))
                                          ])))
                                ])),
                            Container(
                                height: 115,
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(children: [
                                  Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MyServiceList(
                                                        customer_id: user['id']
                                                            .toString(),
                                                        callbackFunc:
                                                            refreshFunc,
                                                        user_customer_id: widget
                                                            .user_customer_id)));
                                          },
                                          child: Column(children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  user['room']['services']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: CustomColors
                                                          .appColors,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/service.png',
                                                  color: CustomColors.appColors,
                                                  width: 50,
                                                  height: 50,
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Hyzmatlar',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: CustomColors
                                                          .appColors),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ))
                                          ]))),
                                  if (widget.user_customer_id == '')
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ArrivedOrders(
                                                              customer_id: user[
                                                                      'id']
                                                                  .toString(),
                                                              callbackFunc:
                                                                  refreshFunc)));
                                            },
                                            child: Column(children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      user['orders_in']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: CustomColors
                                                              .appColors,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              Expanded(
                                                  flex: 2,
                                                  child: Image.asset(
                                                    'assets/images/orders_in.png',
                                                    color:
                                                        CustomColors.appColors,
                                                    width: 50,
                                                    height: 50,
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text('Gelen sargytlar',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: CustomColors
                                                              .appColors)))
                                            ])))
                                  else
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyRibbonList(
                                                              customer_id: user[
                                                                      'id']
                                                                  .toString(),
                                                              callbackFunc:
                                                                  refreshFunc,
                                                              user_customer_id:
                                                                  widget
                                                                      .user_customer_id)));
                                            },
                                            child: Column(children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    user['room']['lenta']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: CustomColors
                                                            .appColors,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Image.asset(
                                                    'assets/images/lenta.png',
                                                    color:
                                                        CustomColors.appColors,
                                                    width: 50,
                                                    height: 50,
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Söwda lentasy',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors
                                                            .appColors),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                  ))
                                            ]))),
                                  if (widget.user_customer_id == '')
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GoneOrders(
                                                              customer_id: user[
                                                                      'id']
                                                                  .toString(),
                                                              callbackFunc:
                                                                  refreshFunc)));
                                            },
                                            child: Column(children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      user['orders_out']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: CustomColors
                                                              .appColors,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              Expanded(
                                                  flex: 2,
                                                  child: Image.asset(
                                                    'assets/images/orders_out.png',
                                                    color:
                                                        CustomColors.appColors,
                                                    width: 50,
                                                    height: 50,
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text('Giden sargytlar',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: CustomColors
                                                              .appColors)))
                                            ])))
                                ])),
                            if (widget.user_customer_id == '')
                              Container(
                                  height: 115,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(children: [
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyRibbonList(
                                                              customer_id: user[
                                                                      'id']
                                                                  .toString(),
                                                              callbackFunc:
                                                                  refreshFunc,
                                                              user_customer_id:
                                                                  widget
                                                                      .user_customer_id)));
                                            },
                                            child: Column(children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    user['room']['lenta']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: CustomColors
                                                            .appColors,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Image.asset(
                                                    'assets/images/lenta.png',
                                                    color:
                                                        CustomColors.appColors,
                                                    width: 50,
                                                    height: 50,
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Söwda lentasy',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors
                                                            .appColors),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                  ))
                                            ])))
                                  ]))
                          ]))
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.appColors)))
        : CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogout();
      },
    );
  }

  void get_userinfo() async {
    var allRows = await dbHelper.queryAllRows();
    var data = [];
    final response;
    String url;
    Urls server_url = new Urls();

    for (final row in allRows) {
      data.add(row);
    }
    if (widget.user_customer_id == '') {
      if (data.length == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
      url = server_url.get_server_url() +'/mob/customer/' + data[0]['userId'].toString();
      final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
      headers['token'] = data[0]['name'];
      response = await http.get(uri, headers: headers);
    } else {
      url = server_url.get_server_url() +'/mob/customer/' + widget.user_customer_id;
      final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
      response = await http.get(uri, headers: headers);
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      user = json['data'];
      determinate = true;
      stores = json['data']['stores'];
      baseurl = server_url.get_server_url();
    });
    Provider.of<UserInfo>(context, listen: false).setAccessToken(data[0]['name'], data[0]['age']);
  }
}

class CustomDialogLogout extends StatefulWidget {
  @override
  _CustomDialogLogoutState createState() => _CustomDialogLogoutState();
}

class _CustomDialogLogoutState extends State<CustomDialogLogout> {
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ulagamdan çykmak',
            style: TextStyle(color: CustomColors.appColors),
            maxLines: 3,
          ),
        ],
      ),
      content: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.appColors,
              foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Goý bolsun'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () async {
              final deleteallRows = await dbHelper.deleteAllRows();
              final deleteallRows1 = await dbHelper.deleteAllRows();
              Provider.of<UserInfo>(context, listen: false).set_user_info({});
              Navigator.pop(context);
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: const Text('Ulgamdan çyk'),
          ),
        ],
      ),
      actions: <Widget>[],
    );
  }
}
