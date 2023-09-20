import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/Services/add.dart';
import 'package:my_app/pages/Customer/Services/getFirst.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../progressIndicator.dart';

class MyServiceList extends StatefulWidget {
  MyServiceList(
      {Key? key,
      required this.customer_id,
      required this.callbackFunc,
      required this.user_customer_id})
      : super(key: key);
  final String customer_id;
  final Function callbackFunc;
  final String user_customer_id;
  @override
  State<MyServiceList> createState() =>
      _MyServiceListState(customer_id: customer_id);
}

class _MyServiceListState extends State<MyServiceList> {
  final String customer_id;
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  void initState() {
    timers();
    widget.callbackFunc();
    get_my_parts(customer_id: customer_id);
    super.initState();
  }

  refreshFunc() async {
    timers();
    widget.callbackFunc();
    get_my_parts(customer_id: customer_id);
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

  _MyServiceListState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    var user_customer_name =
        Provider.of<UserInfo>(context, listen: false).user_customer_name;
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
                  PopupMenuButton<String>(
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> menuEntries2 = [
                        PopupMenuItem<String>(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ServiceAdd(
                                              customer_id: customer_id,
                                              refreshFunc: refreshFunc)));
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
                backgroundColor: CustomColors.appColors,
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
                              flex: 1,
                              child: Row(
                                children: [
                                  if (data.length > 0)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Text(
                                          "Hyzmatlar sany " +
                                              data.length.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.appColors),
                                        ),
                                      ),
                                    ),
                                  if (data.length == 0)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Text(
                                          "Hyzmatlar sany 0",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: CustomColors.appColors),
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                          Expanded(
                            flex: 12,
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ServiceDetail(
                                                      id: data[index]
                                                              ['id']
                                                          .toString(),
                                                      user_customer_id:
                                                          widget
                                                              .user_customer_id,
                                                      refreshFunc:
                                                          refreshFunc)));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        elevation: 2,
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
                                                        child: data[index][
                                                                        'img'] !=
                                                                    '' &&
                                                                data[index][
                                                                        'img'] !=
                                                                    null
                                                            ? Image.network(
                                                                baseurl +
                                                                    data[index][
                                                                            'img']
                                                                        .toString(),
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
                                                  color: CustomColors.appColors,
                                                  margin:
                                                      EdgeInsets.only(left: 2),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            data[index]['name'],
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
                                                            Icon(
                                                              Icons.place,
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Flexible(
                                                                child:
                                                                    new Container(
                                                              child: Text(
                                                                  data[index][
                                                                          'location']
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: CustomText
                                                                      .itemText),
                                                            ))
                                                          ],
                                                        ),
                                                      )),
                                                      Expanded(
                                                          child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  if (data[index]['status'] != null && widget.user_customer_id == '' &&
                                                                      data[index]['status'] !=
                                                                          '' &&
                                                                      data[index]['status'] ==
                                                                          'pending')
                                                                    Text("Garşylyar".toString(),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .amber))
                                                                  else if (data[index]['status'] !=
                                                                          null && widget.user_customer_id == '' &&
                                                                      data[index]['status'] !=
                                                                          '' &&
                                                                      data[index]['status'] ==
                                                                          'accepted')
                                                                    Text(
                                                                        "Tassyklanyldy"
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors
                                                                                    .green))
                                                                  else if (data[index]['status'] != null && widget.user_customer_id == '' &&
                                                                      data[index]['status'] != '' &&
                                                                      data[index]['status'] == 'canceled')
                                                                    Text("Gaýtarylan".toString(), style: TextStyle(color: Colors.red))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  data[index][
                                                                          'price']
                                                                      .toString(),
                                                                  style: CustomText
                                                                      .itemText),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(child: CircularProgressIndicator(color: CustomColors.appColors))))
        : CustomProgressIndicator(funcInit: initState);
  }

  void get_my_parts({required customer_id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/services?customer=$customer_id';
    final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['data'];
      baseurl = server_url.get_server_url();
      determinate = true;
    });
  }
}
