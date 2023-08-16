import 'package:flutter/material.dart';
import 'package:my_app/pages/Customer/Ribbon/edit.dart';
import 'package:my_app/pages/Customer/deleteAlert.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../dB/providers.dart';

class MyRibbonDetail extends StatefulWidget {
  final String id;
  final String user_customer_id;
  final Function refreshListFunc;
  MyRibbonDetail(
      {Key? key,
      required this.id,
      required this.refreshListFunc,
      required this.user_customer_id})
      : super(key: key);
  @override
  State<MyRibbonDetail> createState() => _MyRibbonDetailState();
}

class _MyRibbonDetailState extends State<MyRibbonDetail> {
  var data = {};
  var baseurl = '';
  bool determinate = false;

  @override
  void initState() {
    get_ribbon_by_id(id: widget.id);
    super.initState();
  }

  callbackStatusDelete() {
    widget.refreshListFunc();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Söwda lenta - " + widget.id.toString()),
          actions: [
            if (widget.user_customer_id == '')
              PopupMenuButton<String>(itemBuilder: (context) {
                List<PopupMenuEntry<String>> menuEntries2 = [
                  PopupMenuItem<String>(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyRibbonEdit(
                                        id: widget.id,
                                        refreshListFunc:
                                            widget.refreshListFunc)));
                          },
                          child: Container(
                              color: Colors.white,
                              height: 40,
                              width: double.infinity,
                              child: Row(children: [
                                Icon(
                                  Icons.edit_road,
                                  color: Colors.green,
                                ),
                                Text(' Üýtgetmek')
                              ])))),
                  PopupMenuItem<String>(
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteAlert(
                                    action: 'lenta',
                                    id: widget.id,
                                    callbackFunc: callbackStatusDelete,
                                  );
                                });
                          },
                          child: Container(
                              color: Colors.white,
                              height: 40,
                              width: double.infinity,
                              child: Row(children: [
                                Icon(Icons.delete, color: Colors.red),
                                Text('Pozmak')
                              ]))))
                ];
                return menuEntries2;
              })
          ],
        ),
        body: determinate
            ? ListView(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text("Tekst",
                        style: TextStyle(
                            color: CustomColors.appColors,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      height: 250,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: CustomColors.appColors)),
                      child: TextFormField(
                        enabled: false,
                          maxLines: 10,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: data['text'].toString(),
                              border: InputBorder.none,
                              focusColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 14)),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          })),
                  Wrap(direction: Axis.horizontal, children: [
                    for (var i in data['images'])
                      Container(
                          margin: EdgeInsets.only(left: 3, right: 3, top: 5),
                          height: 160,
                          width: MediaQuery.of(context).size.width / 3 - 10,
                          child: Card(
                              elevation: 2,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Image.network(
                                  baseurl + i['img'],
                                  fit: BoxFit.cover,
                                ),
                              )))
                  ])
                ],
              )
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColors)));
  }

  void get_ribbon_by_id({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/lenta/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['msg'];
      determinate = true;
      baseurl = server_url.get_server_url();
    });
  }
}
