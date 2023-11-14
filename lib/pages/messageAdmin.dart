import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/main.dart';

class AdminMessage extends StatefulWidget {
  final Map<dynamic, dynamic> user;
  AdminMessage({super.key, required this.user});

  @override
  State<AdminMessage> createState() => _AdminMessageState();
}

class _AdminMessageState extends State<AdminMessage> {
  List<dynamic> data = [];
  bool status = false;
  @override
  void initState() {
    get_messages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text('Habarnamalar', style: TextStyle(color: Colors.white))),
        body: status
            ? data.length > 0
                ? ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.all(5),
                          child: Card(
                              surfaceTintColor: CustomColors.appColorWhite,
                              color: CustomColors.appColorWhite,
                              shadowColor: CustomColors.appColorWhite,
                              elevation: 5,
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (data[index]['read'] == "False")
                                          Container(
                                              child: PhysicalModel(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.blue,
                                                  elevation: 5,
                                                  shadowColor: Colors.black,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 25,
                                                      width: 50,
                                                      child: Text('Täze',
                                                          style: TextStyle(
                                                              color: CustomColors
                                                                  .appColorWhite,
                                                              fontSize: 12))))),
                                        SizedBox(height: 5),
                                        if (data[index]['name'] != '' &&
                                            data[index]['name'] != null)
                                          SizedBox(
                                              child: Text(
                                                  data[index]['name']
                                                      .toString(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: CustomColors
                                                          .appColors,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        SizedBox(height: 5),
                                        if (data[index]['msg'] != '' &&
                                            data[index]['msg'] != null)
                                          SizedBox(
                                              child: Text(
                                                  data[index]['msg'].toString(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: CustomColors
                                                          .appColors,
                                                      fontSize: 15))),
                                        if (data[index]['created_at'] != '' &&
                                            data[index]['created_at'] != null)
                                          Container(
                                              margin: EdgeInsets.only(top: 5),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                  data[index]['created_at']
                                                      .toString(),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      color: CustomColors
                                                          .appColors,
                                                      fontSize: 15)))
                                      ]))));
                    })
                : Center(
                    child: Text("Habarnama ýok!",
                        style: TextStyle(
                            color: CustomColors.appColors,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)))
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColors)));
  }

  void get_messages() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/notifs';

    var data1 = [];
    var allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      data1.add(row);
    }
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    if (data1.length > 0) {
      headers['Token'] = data1[0]['name'];
    }

    print("");
    print(headers);
    print("");
    
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      status = true;
    });
  }
}
