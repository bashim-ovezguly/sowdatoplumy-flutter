import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/constants.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Customer/Car/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../dB/textStyle.dart';

class MyCars extends StatefulWidget {
  MyCars({Key? key, required this.customer_id}) : super(key: key);
  final String customer_id;
  @override
  State<MyCars> createState() => _MyCarsState(customer_id: customer_id);
}

class _MyCarsState extends State<MyCars> {
  final String customer_id;
  List<dynamic> data = [];
  bool is_loading = true;

  @override
  void initState() {
    super.initState();
    getData(customer_id: customer_id);
  }

  refreshFunc() async {
    getData(customer_id: customer_id);
  }

  _MyCarsState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Awtoulaglar",
            style: CustomText.appBarText,
          ),
          actions: [
            PopupMenuButton<String>(
              shadowColor: CustomColors.appColorWhite,
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
                                    builder: (context) =>
                                        AddDatasPage(index: 1)));
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
                is_loading = true;
              });
              getData(customer_id: customer_id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  if (is_loading)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
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
                                    builder: (context) => GetCarFirst(
                                        id: data[index]['id'],
                                        refreshFunc: refreshFunc)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            height: 110,
                            child: Card(
                              shadowColor: CustomColors.appColorWhite,
                              surfaceTintColor: CustomColors.appColorWhite,
                              color: CustomColors.appColorWhite,
                              elevation: 5,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
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
                                                child: data[index]['img'] != ''
                                                    ? Image.network(
                                                        serverIp +
                                                            data[index]['img']
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
                                          color: CustomColors.appColorWhite,
                                          margin: EdgeInsets.only(left: 2),
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    data[index]['mark']
                                                            .toString() +
                                                        " " +
                                                        data[index]['model']
                                                            .toString() +
                                                        " " +
                                                        data[index]['year']
                                                            .toString(),
                                                    style:
                                                        CustomText.itemTextBold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 14,
                                                    ),
                                                    Text(
                                                        data[index]['location']
                                                            .toString(),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: CustomColors
                                                                .appColor)),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  Container(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          data[index]['price']
                                                                  .toString() +
                                                              ' TMT',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.blue)),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: <Widget>[
                                                              if (data[index]['status'] != null &&
                                                                  data[index]['status'] !=
                                                                      '' &&
                                                                  data[index]['status'] ==
                                                                      'pending')
                                                                Text(
                                                                    "Garşylyar"
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .amber))
                                                              else if (data[index]['status'] != null &&
                                                                  data[index]['status'] !=
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  void getData({required customer_id}) async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getInt('user_id').toString();

    String url = carsUrl + '?customer=$user_id';
    final uri = Uri.parse(url);

    Map<String, String> headers = {
      'Token': prefs.getString('access_token').toString()
    };

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (mounted) {
      setState(() {
        data = json['data'];
        is_loading = false;
      });
    }
  }
}
