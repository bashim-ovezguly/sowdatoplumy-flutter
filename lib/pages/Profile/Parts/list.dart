import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Profile/Parts/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool determinate = false;
  bool is_loading = true;

  refreshFunc() async {
    widget.callbackFunc();
    get_my_parts(customer_id: customer_id);
  }

  @override
  void initState() {
    super.initState();
    get_my_parts(customer_id: customer_id);
  }

  _AutoPartsListState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return is_loading
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: widget.user_customer_id == ''
                  ? Text(
                      "Meniň sahypam",
                      style: CustomText.appBarText,
                    )
                  : Text(
                      'Awtoşaýlar',
                      style: CustomText.appBarText,
                    ),
              actions: [
                if (widget.user_customer_id == '')
                  PopupMenuButton<String>(
                    surfaceTintColor: CustomColors.appColorWhite,
                    shadowColor: CustomColors.appColorWhite,
                    color: CustomColors.appColorWhite,
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> menuEntries2 = [
                        PopupMenuItem<String>(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddDatasPage(
                                                index: 2,
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
                              flex: 1,
                              child: Row(
                                children: [
                                  if (data.length > 0)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Awtoşaylar " +
                                              data.length.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.appColor),
                                        ),
                                      ),
                                    ),
                                  if (data.length == 0)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Awtoşaylar yok ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: CustomColors.appColor),
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
                                    height: 110,
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
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: ClipRect(
                                                  child: Container(
                                                    height: 110,
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: data[index]
                                                                      ['img'] !=
                                                                  '' &&
                                                              data[index]
                                                                      ['img'] !=
                                                                  null
                                                          ? Image.network(
                                                              serverIp +
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
                                                margin:
                                                    EdgeInsets.only(left: 2),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                color:
                                                    CustomColors.appColorWhite,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          data[index]
                                                                  ['location']
                                                              .toString(),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          maxLines: 2,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: CustomColors
                                                                  .appColor),
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
                                                                      .toString() +
                                                                  ' TMT',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: CustomColors
                                                                      .appColor))),
                                                    ])),
                                                    Expanded(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 5),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    if (data[index]['status'] != null &&
                                                                        widget
                                                                                .user_customer_id ==
                                                                            '' &&
                                                                        data[index]['status'] !=
                                                                            '' &&
                                                                        data[index]['status'] ==
                                                                            'pending')
                                                                      Text(
                                                                          "Garşylyar"
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                                  fontSize:
                                                                                      12,
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
                                                                              fontSize:
                                                                                  12,
                                                                              color: Colors
                                                                                  .green))
                                                                    else if (data[index]['status'] != null &&
                                                                        data[index]['status'] != '' &&
                                                                        widget.user_customer_id == '' &&
                                                                        data[index]['status'] == 'canceled')
                                                                      Text("Gaýtarylan".toString(), style: TextStyle(color: Colors.red, fontSize: 12))
                                                                  ],
                                                                ),
                                                              ),
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
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColor))))
        : CustomProgressIndicator(funcInit: initState);
  }

  void get_my_parts({required customer_id}) async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getInt('user_id').toString();
    String url = partsUrl + '?customer=$user_id';
    final uri = Uri.parse(url);

    // create request headers
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
