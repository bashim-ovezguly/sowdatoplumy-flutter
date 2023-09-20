import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/AutoParts/add.dart';
import 'package:my_app/pages/Customer/AutoParts/getFirst.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../progressIndicator.dart';

class AutoPartsList extends StatefulWidget {
  AutoPartsList(
      {Key? key,
      required this.customer_id,
      required this.callbackFunc,
      required this.user_customer_id})
      : super(key: key);
  final String customer_id;
  final String user_customer_id;
  final Function callbackFunc;
  @override
  State<AutoPartsList> createState() =>
      _AutoPartsListState(customer_id: customer_id);
}

class _AutoPartsListState extends State<AutoPartsList> {
  final String customer_id;

  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  refreshFunc() async {
    widget.callbackFunc();
    get_my_parts(customer_id: customer_id);
  }

  void initState() {
    timers();
    widget.callbackFunc();
    get_my_parts(customer_id: customer_id);
    super.initState();
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

  _AutoPartsListState({required this.customer_id});
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
                                          builder: (context) => AutoPartsAdd(
                                              customer_id:
                                                  customer_id.toString(),
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
                                          "Awtoşaylar sany " +
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
                                          "Sizde şu wagtlykça Awtoşaylar yok ",
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
                                                GetAutoParthFirst(
                                                    customer_id: customer_id,
                                                    id:
                                                        data[index]['id']
                                                            .toString(),
                                                    user_customer_id:
                                                        widget.user_customer_id,
                                                    refreshFunc: refreshFunc)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB( 255, 153, 153, 153),
                                            blurRadius: 2,
                                            offset: Offset(0.0, 0.75)
                                          ),
                                      ],
                                    ),
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
                                                    child: data[index]['img'] !=
                                                                '' &&
                                                            data[index]
                                                                    ['img'] !=
                                                                null
                                                        ? Image.network(
                                                            baseurl +
                                                                data[index]
                                                                        ['img']
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
                                              margin: EdgeInsets.only(left: 2),
                                              padding: const EdgeInsets.all(10),
                                              color: CustomColors.appColors,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        data[index]['name_tm']
                                                            .toString(),
                                                        style: CustomText
                                                            .itemTextBold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        data[index]['location']
                                                            .toString(),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                        style:
                                                            CustomText.itemText,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Row(children: [
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            data[index]['price']
                                                                .toString(),
                                                            style: CustomText
                                                                .itemText)),
                                                    Spacer(),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .star_outline_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            if (data[index]['status'] != null &&
                                                                widget.user_customer_id ==
                                                                    '' &&
                                                                data[index]['status'] !=
                                                                    '' &&
                                                                data[index]['status'] ==
                                                                    'pending')
                                                              Text("Garşylyar".toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .amber))
                                                            else if (data[index]['status'] != null &&
                                                                data[index]['status'] !=
                                                                    '' &&
                                                                widget.user_customer_id ==
                                                                    '' &&
                                                                data[index]['status'] ==
                                                                    'accepted')
                                                              Text("Tassyklanyldy".toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green))
                                                            else if (data[index]['status'] != null &&
                                                                data[index]['status'] != '' &&
                                                                widget.user_customer_id == '' &&
                                                                data[index]['status'] == 'canceled')
                                                              Text("Gaýtarylan".toString(), style: TextStyle(color: Colors.red))
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ])),
                                                  Expanded(
                                                      child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text('Kredit',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12)),
                                                        data[index]['credit']
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text('Obmen',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12)),
                                                        data[index]['swap']
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text('Nagt däl',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12)),
                                                        data[index][
                                                                'none_cash_pay']
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColors))))
        : CustomProgressIndicator(funcInit: initState);
  }

  void get_my_parts({required customer_id}) async {
    Urls server_url = new Urls();
    String url =
        server_url.get_server_url() + '/mob/parts?customer=$customer_id';
    final uri = Uri.parse(url);

    // create request headers
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
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
