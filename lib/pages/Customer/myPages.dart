// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Customer/AutoParts/list.dart';
import 'package:my_app/pages/Customer/AwtoCar/list.dart';
import 'package:my_app/pages/Customer/OtherGoods/list.dart';
import 'package:my_app/pages/Customer/RealEstate/list.dart';
import 'package:my_app/pages/Customer/Ribbon/list.dart';
import 'package:my_app/pages/Customer/editProfil.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/myCustomerList.dart';
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
    print(t);
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
            backgroundColor: CustomColors.appColorWhite,
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
                ? ListView(children: [
                    Container(
                        height: 170,
                        color: CustomColors.appColors,
                        child: Row(children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: user['img'] != ''
                                    ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(
                                            baseurl + user['img'].toString()))
                                    : Image.asset('assets/images/default.jpg'),
                              )),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 40),
                                        if (user['name'] != null &&
                                            user['name'] != '')
                                          Text(user['name'].toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: CustomColors
                                                      .appColorWhite)),
                                        SizedBox(height: 5),
                                        if (user['phone'] != null &&
                                            user['phone'] != '')
                                          Text(
                                            user['phone'].toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    CustomColors.appColorWhite),
                                          ),
                                        SizedBox(height: 5),
                                        if (user['email'] != null &&
                                            user['email'] != '')
                                          Text(user['email'].toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: CustomColors
                                                      .appColorWhite)),
                                        if (widget.user_customer_id == '')
                                          Container(
                                              alignment: Alignment.centerRight,
                                              child: MaterialButton(
                                                color:
                                                    CustomColors.appColorWhite,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => EditProfil(
                                                              customer_id: user[
                                                                      'id']
                                                                  .toString(),
                                                              email: user[
                                                                      'email']
                                                                  .toString(),
                                                              name: user[
                                                                  'name'
                                                                      .toString()],
                                                              phone: user[
                                                                      'phone']
                                                                  .toString(),
                                                              img: baseurl +
                                                                  user['img']
                                                                      .toString(),
                                                              callbackFunc:
                                                                  refreshFunc,
                                                              showSuccessAlert:
                                                                  showSuccessAlert)));
                                                },
                                                elevation: 2.0,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                shape: const CircleBorder(),
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: CustomColors.appColors,
                                                ),
                                              ))
                                      ])))
                        ])),
                    GestureDetector(
                      onTap: () async {
                        String id = "";
                        if (widget.user_customer_id != '') {
                          id = widget.user_customer_id;
                        } else {
                          var data = [];
                          var allRows = await dbHelper.queryAllRows();
                          for (final row in allRows) {
                            data.add(row);
                          }
                          id = data[0]['userId'].toString();
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerList(customer_id: id)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        height: 50,
                        child: Card(
                          surfaceTintColor: CustomColors.appColorWhite,
                          color: CustomColors.appColorWhite,
                          shadowColor: Colors.black,
                          elevation: 5,
                          child: Row(
                            children: [
                              Text("  Müşderiler",
                                  style: TextStyle(
                                      color: CustomColors.appColors,
                                      fontSize: 18)),
                              if (widget.user_customer_id != '')
                                TextButton(
                                    onPressed: () async {
                                      final allRows =
                                          await dbHelper.queryAllRows();
                                      print(allRows);
                                      print(allRows.length);
                                      if (allRows.length == 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()));
                                      } else {
                                        Urls server_url = new Urls();
                                        String url =
                                            server_url.get_server_url() +
                                                '/mob/subscribe/' +
                                                widget.user_customer_id;
                                        final uri = Uri.parse(url);
                                        var responsess = Provider.of<UserInfo>(
                                                context,
                                                listen: false)
                                            .update_tokenc();
                                        if (await responsess) {
                                          var token = Provider.of<UserInfo>(
                                                  context,
                                                  listen: false)
                                              .access_token;
                                          Map<String, String> headers = {};
                                          for (var i
                                              in global_headers.entries) {
                                            headers[i.key] = i.value.toString();
                                          }
                                          headers['token'] = token;
                                          final response = await http.post(uri,
                                              headers: headers);
                                          get_userinfo();
                                        }
                                      }
                                    },
                                    child: Text("+ Ýazylmak",
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18))),
                              Spacer(),
                              Text(user['followers_count'].toString() + "  ",
                                  style: TextStyle(
                                      color: CustomColors.appColors,
                                      fontSize: 18))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Text("  Bildirişler",
                            style: TextStyle(
                                color: CustomColors.appColors, fontSize: 18))),
//_______________________________________________________________________________________________________
                    GestureDetector(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          height: 250,
                          child: Card(
                              surfaceTintColor: CustomColors.appColorWhite,
                              color: CustomColors.appColorWhite,
                              shadowColor: Colors.black,
                              elevation: 5,
                              child: Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyStores(
                                                user_customer_id:
                                                    widget.user_customer_id,
                                                customer_id:
                                                    user['id'].toString(),
                                                callbackFunc: refreshFunc)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/store.png',
                                          color: CustomColors.appColors,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text("  Dükanlar",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['room']['store'].toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),

//_______________________________________________________________________________________________________
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyCars(
                                                customer_id:
                                                    user['id'].toString(),
                                                user_customer_id:
                                                    widget.user_customer_id)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/car.png',
                                          color: CustomColors.appColors,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text("  Awtoulaglar",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['room']['cars'].toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),

//_______________________________________________________________________________________________________
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AutoPartsList(
                                                user_customer_id:
                                                    widget.user_customer_id,
                                                customer_id:
                                                    user['id'].toString(),
                                                callbackFunc: refreshFunc)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/parts.png',
                                          color: CustomColors.appColors,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text("  Awtoşaýlar",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['room']['parts'].toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),

//_______________________________________________________________________________________________________
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RealEstateList(
                                                    customer_id:
                                                        user['id'].toString(),
                                                    callbackFunc: refreshFunc,
                                                    user_customer_id: widget
                                                        .user_customer_id)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/flats.png',
                                          color: CustomColors.appColors,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text("  Gozgalmaýan emläkler",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['room']['flats'].toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),

//_______________________________________________________________________________________________________
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyOtherGoodsList(
                                                    customer_id:
                                                        user['id'].toString(),
                                                    callbackFunc: refreshFunc,
                                                    user_customer_id: widget
                                                        .user_customer_id)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/products.png',
                                          color: CustomColors.appColors,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text("  Beýleki bildirişler",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['room']['products']
                                                    .toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),

//_______________________________________________________________________________________________________
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyRibbonList(
                                                customer_id:
                                                    user['id'].toString(),
                                                callbackFunc: refreshFunc,
                                                user_customer_id:
                                                    widget.user_customer_id)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/lenta.png',
                                          color: CustomColors.appColors,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text("  Lenta",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['room']['lenta'].toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),
                              ]))),
                    ),

                    if (widget.user_customer_id == '')
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Text("  Sargytlar",
                              style: TextStyle(
                                  color: CustomColors.appColors,
                                  fontSize: 18))),
                    if (widget.user_customer_id == '')
                      Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          height: 80,
                          child: Card(
                              surfaceTintColor: CustomColors.appColorWhite,
                              color: CustomColors.appColorWhite,
                              shadowColor: Colors.black,
                              elevation: 5,
                              child: Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ArrivedOrders(
                                                customer_id:
                                                    user['id'].toString(),
                                                callbackFunc: refreshFunc)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/orders_in.png',
                                          color: CustomColors.appColors,
                                          width: 23,
                                          height: 23,
                                        ),
                                        Text("  Gelen sargytlar",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['orders_in'].toString() + "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GoneOrders(
                                                customer_id:
                                                    user['id'].toString(),
                                                callbackFunc: refreshFunc)));
                                  },
                                  child: Container(
                                      color: CustomColors.appColorWhite,
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/images/orders_out.png',
                                          color: CustomColors.appColors,
                                          width: 23,
                                          height: 23,
                                        ),
                                        Text("  Giden sargytlar",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Spacer(),
                                        Text(
                                            user['orders_out'].toString() +
                                                "  ",
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 18)),
                                        Icon(Icons.navigate_next,
                                            color: CustomColors.appColors)
                                      ])),
                                )
                              ]))),
                  ])
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
    var data = [];
    final response;
    String url;
    Urls server_url = new Urls();

    var allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      data.add(row);
    }
    if (widget.user_customer_id == '') {
      if (data.length == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
      url = server_url.get_server_url() +
          '/mob/customer/' +
          data[0]['userId'].toString();
      final uri = Uri.parse(url);
      Map<String, String> headers = {};
      for (var i in global_headers.entries) {
        headers[i.key] = i.value.toString();
      }
      headers['token'] = data[0]['name'];
      response = await http.get(uri, headers: headers);
    } else {
      url = server_url.get_server_url() +
          '/mob/customer/' +
          widget.user_customer_id;
      final uri = Uri.parse(url);
      Map<String, String> headers = {};
      for (var i in global_headers.entries) {
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
      if (widget.user_customer_id == '') {
        Provider.of<UserInfo>(context, listen: false)
            .set_user_info(json['data']);
      }
    });
    Provider.of<UserInfo>(context, listen: false)
        .setAccessToken(data[0]['name'], data[0]['age']);
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
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
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
          Expanded(
              child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Goý bolsun', style: TextStyle(fontSize: 12)),
          )),
          SizedBox(width: 3),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () async {
                final deleteallRows = await dbHelper.deleteAllRows();
                final deleteallRows1 = await dbHelper.deleteAllRows1();
                Provider.of<UserInfo>(context, listen: false).set_user_info({});
                Provider.of<UserInfo>(context, listen: false)
                    .setAccessToken("", "");
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                'Ulgamdan çyk',
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[],
    );
  }
}
