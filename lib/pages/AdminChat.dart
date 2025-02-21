import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminChat extends StatefulWidget {
  const AdminChat({super.key});

  @override
  State<AdminChat> createState() => _AdminChatState();
}

final ScrollController _controller = ScrollController();
final textController = TextEditingController();

class _AdminChatState extends State<AdminChat> {
  List<dynamic> data = [];
  @override
  void initState() {
    get_messages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(title: Text("Admine ýaz", style: CustomText.appBarText)),
        body: Stack(children: <Widget>[
          ListView.builder(
              reverse: true,
              controller: _controller,
              itemCount: data.length,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                var time = data[index]['created_at']
                    .toString()
                    .split('T')[1]
                    .substring(0, 8);
                var date = data[index]['created_at'].toString().split('T')[0];
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Align(
                        alignment: (data[index]['sender'] != "customer"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                            child: Column(
                                crossAxisAlignment:
                                    (data[index]['sender'] == 'customer'
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start),
                                children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (data[index]['sender'] == "customer"
                                        ? Colors.blue
                                        : data[index]['sender'] == 'customer1'
                                            ? Colors.white
                                            : Colors.grey.shade200),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(data[index]['msg'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: (data[index]['sender'] ==
                                                  'customer'
                                              ? Colors.white
                                              : Colors.blue)))),
                              Text(
                                date + ', ' + time,
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              )
                            ]))));
              }),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: CustomColors.appColorWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, spreadRadius: 1)
                      ]),
                  child: SizedBox(
                      width: double.infinity,
                      child: Row(children: <Widget>[
                        SizedBox(width: 15),
                        Expanded(
                            child: TextField(
                                controller: textController,
                                maxLines: 2,
                                minLines: 1,
                                decoration: InputDecoration(
                                    hintText: "Şu ýere ýaz...",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none))),
                        SizedBox(width: 15),
                        FloatingActionButton(
                            backgroundColor: CustomColors.appColorWhite,
                            focusColor: CustomColors.appColorWhite,
                            splashColor: CustomColors.appColorWhite,
                            onPressed: () async {
                              if (textController.text.length != 0) {
                                String url = serverIp + '/mail/admin';

                                Map<String, String> headers = {};
                                for (var i in global_headers.entries) {
                                  headers[i.key] = i.value.toString();
                                }
                                final uri = Uri.parse(url);
                                final response = await http.post(uri,
                                    headers: headers,
                                    body: {"msg": textController.text});

                                if (response.statusCode == 200) {
                                  setState(() {
                                    textController.text = '';
                                  });
                                  get_messages();
                                }
                              }
                            },
                            child: Icon(Icons.send,
                                color: CustomColors.appColor, size: 18),
                            elevation: 0)
                      ]))))
        ]));
  }

  void get_messages() async {
    String url = serverIp + '/mail/admin';

    Map<String, String> headers = global_headers;

    final pref = await SharedPreferences.getInstance();
    headers['Device-Id'] = await pref.getString('device_id').toString();

    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);
    print(headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (json['data'] != null) {
      setState(() {
        data = json['data'];
      });
    }

    List<dynamic> reversedNumbers = data.reversed.toList();
    data = reversedNumbers;
    data.insert(0, {
      "msg": "",
      "created_at": "2023-10-31T18:07:11.049428",
      "sender": "customer1"
    });
  }
}
