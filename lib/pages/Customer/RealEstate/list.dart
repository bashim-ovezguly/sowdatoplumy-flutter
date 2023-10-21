import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/RealEstate/add.dart';
import 'package:my_app/pages/Customer/RealEstate/getFirst.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../progressIndicator.dart';

class RealEstateList extends StatefulWidget {
  RealEstateList(
      {Key? key,
      required this.customer_id,
      required this.callbackFunc,
      required this.user_customer_id})
      : super(key: key);
  final String customer_id;
  final String user_customer_id;

  final Function callbackFunc;
  @override
  State<RealEstateList> createState() =>
      _RealEstateListState(customer_id: customer_id);
}

class _RealEstateListState extends State<RealEstateList> {
  final String customer_id;

  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  void initState() {
    timers();
    widget.callbackFunc();
    get_my_flats(customer_id: customer_id);
    super.initState();
  }

  refreshFunc() async {
    widget.callbackFunc();
    get_my_flats(customer_id: customer_id);
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

  _RealEstateListState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    var user_customer_name =
        Provider.of<UserInfo>(context, listen: false).user_customer_name;
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
                  PopupMenuButton<String>(
                    surfaceTintColor: CustomColors.appColorWhite,
                    color: CustomColors.appColorWhite,
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> menuEntries2 = [
                        PopupMenuItem<String>(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RealEstateAdd(
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Emläkler " +
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Emläkler ",
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
                                                  GetRealEstateFirst(
                                                      id: data[index]['id']
                                                          .toString(),
                                                      user_customer_id: widget
                                                          .user_customer_id,
                                                      refreshFunc:
                                                          refreshFunc)));
                                    },
                                    child: Container(
                                      height: 110,
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        surfaceTintColor:
                                            CustomColors.appColorWhite,
                                        color: CustomColors.appColorWhite,
                                        shadowColor: CustomColors.appColorWhite,
                                        elevation: 3,
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
                                                          child: data[index]
                                                                      ['img'] !=
                                                                  ''
                                                              ? Image.network(
                                                                  baseurl +
                                                                      data[index]
                                                                              [
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
                                                    margin: EdgeInsets.only(
                                                        left: 2),
                                                    padding: EdgeInsets.all(10),
                                                    color:
                                                        CustomColors.appColors,
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
                                                                data[index]['name'].toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                maxLines: 1,
                                                                softWrap: false,
                                                                style: CustomText
                                                                    .itemTextBold,
                                                              )),
                                                        ),
                                                        Expanded(
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    data[index][
                                                                            'location']
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                    maxLines: 2,
                                                                    softWrap:
                                                                        false,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: CustomColors
                                                                            .appColorWhite),
                                                                  ),
                                                                ))),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: <Widget>[
                                                                Text(
                                                                    data[index][
                                                                            'price']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: CustomColors
                                                                            .appColorWhite)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Row(
                                                                        children: <Widget>[
                                                                          if (data[index]['status'] != null &&
                                                                              widget.user_customer_id == '' &&
                                                                              data[index]['status'] != '' &&
                                                                              data[index]['status'] == 'pending')
                                                                            Text("Garşylyar".toString(), style: TextStyle(color: Colors.amber, fontSize: 12))
                                                                          else if (data[index]['status'] != null && data[index]['status'] != '' && widget.user_customer_id == '' && data[index]['status'] == 'accepted')
                                                                            Text("Tassyklanyldy".toString(), style: TextStyle(color: Colors.green, fontSize: 12))
                                                                          else if (data[index]['status'] != null && data[index]['status'] != '' && widget.user_customer_id == '' && data[index]['status'] == 'canceled')
                                                                            Text("Gaýtarylan".toString(), style: TextStyle(color: Colors.red, fontSize: 12))
                                                                        ]))))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
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

  void get_my_flats({required customer_id}) async {
    Urls server_url = new Urls();
    String url =
        server_url.get_server_url() + '/mob/flats?customer=$customer_id';
    final uri = Uri.parse(url);
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
