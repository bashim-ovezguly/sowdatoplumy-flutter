import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../dB/constants.dart';
import 'dart:convert';

class LocationWidget extends StatefulWidget {
  final Function callbackFunc;
  LocationWidget({Key? key, required this.callbackFunc}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  var data = [];
  int index1 = 0;
  bool determinate = false;
  callbackSwap() {}

  void initState() {
    determinate = false;
    get_locations(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return determinate
        ? AlertDialog(
            shadowColor: CustomColors.appColorWhite,
            backgroundColor: CustomColors.appColorWhite,
            surfaceTintColor: CustomColors.appColorWhite,
            title: Container(
              color: CustomColors.appColorWhite,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Ýerleşýän ýeriňizi saýlaň",
                        style: TextStyle(
                            fontSize: 17, color: CustomColors.appColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  if (data[0] != null &&
                      data[0]['parent'] != '' &&
                      data[0]['parent'] != null)
                    Row(children: [
                      if (data.length > 0 && data[0]['back_id'] == '' ||
                          data[0]['have_parent'] == true)
                        Container(
                            child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: CustomColors.appColor),
                          onPressed: () {
                            get_locations(data[0]['back_id']);
                          },
                        )),
                      GestureDetector(
                        onTap: () {
                          get_locations(data[0]['back_id']);
                        },
                        child: Text(data[0]['parent']['name'],
                            style: TextStyle(
                                fontSize: 18, color: CustomColors.appColor)),
                      )
                    ])
                ],
              ),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(top: 5),
                              height: 35,
                              decoration: BoxDecoration(
                                  // border: Border(
                                  //   bottom: BorderSide(
                                  //     color: CustomColors.appColor,
                                  //     width: 1.0,
                                  //   ),
                                  // ),
                                  ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: GestureDetector(
                                          child: Container(
                                              child: Row(children: [
                                        if (data[index]['id'] == index1)
                                          GestureDetector(
                                            onTap: () {
                                              widget.callbackFunc(data[index]);
                                              setState(() {
                                                if (index1 ==
                                                    data[index]['id']) {
                                                  index1 = 0;
                                                  widget.callbackFunc({});
                                                } else {
                                                  index1 = data[index]['id'];
                                                }
                                              });
                                            },
                                            child: Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          CustomColors.appColor,
                                                      width: 1),
                                                ),
                                                child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60)),
                                                    child: Icon(Icons.check,
                                                        size: 22,
                                                        color: Colors.green))),
                                          )
                                        else
                                          GestureDetector(
                                            onTap: () {
                                              widget.callbackFunc(data[index]);
                                              setState(() {
                                                if (index1 ==
                                                    data[index]['id']) {
                                                  index1 = 0;
                                                  widget.callbackFunc({});
                                                } else {
                                                  index1 = data[index]['id'];
                                                }
                                              });
                                            },
                                            child: Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          CustomColors.appColor,
                                                      width: 1),
                                                ),
                                                child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60)),
                                                    child: Container())),
                                          ),
                                        Container(
                                            child: Flexible(
                                                child: GestureDetector(
                                          onTap: () {
                                            if (data[index]['childs'] != 0) {
                                              get_locations(data[index]['id']);
                                            }
                                          },
                                          child: Text(
                                              " " +
                                                  data[index]['name_tm'] +
                                                  "                                              ",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1),
                                        )))
                                      ])))),
                                  if (data[index]['childs'] != 0)
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(" " +
                                                data[index]['childs']
                                                    .toString())))
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.appColor,
                                    shadowColor: Colors.white),
                                child: Text(
                                  'Saýlanmadyk',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  widget.callbackFunc({});
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.appColor,
                                    shadowColor: Colors.white),
                                child: Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ))
                  ],
                )),
          )
        : Center(
            child: CircularProgressIndicator(color: CustomColors.appColor));
  }

  void get_locations(parent) async {
    setState(() {
      determinate = false;
    });
    String url = serverIp + '/index/locations/all';
    if (parent != null) {
      url = url + "?parent=" + parent.toString();
    }

    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      determinate = true;
    });
  }
}
