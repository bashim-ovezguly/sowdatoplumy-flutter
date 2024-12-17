// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FullScreenImage.dart';

class AdPage extends StatefulWidget {
  AdPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<AdPage> createState() => _AdPageState(id: id);
}

class _AdPageState extends State<AdPage> {
  final String id;
  var data = {};
  var phones = [];
  var websites = [];
  var images = [];
  String title = '';
  String body = '';
  String location = '';
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getData(id: id);
  }

  _AdPageState({required this.id});
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
                title: Text(
              title,
              style: TextStyle(color: Colors.white),
            )),
            body: ListView(children: [
              Column(
                children: this
                    .images
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                        img: serverIp + e['img'])));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            child: Image.network(serverIp + e['img']),
                          ),
                        ))
                    .toList(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(this.title.toString(),
                    style:
                        TextStyle(color: CustomColors.appColor, fontSize: 20)),
              ),
              if (this.location.length > 0)
                Container(
                    padding: EdgeInsets.all(5),
                    child: Row(children: [
                      Icon(Icons.location_on,
                          color: CustomColors.appColor, size: 25),
                      Expanded(
                        child: Text(this.location,
                            maxLines: 10,
                            style: TextStyle(
                                color: CustomColors.appColor, fontSize: 17)),
                      )
                    ])),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: this
                      .phones
                      .map((e) => MaterialButton(
                            onPressed: () {
                              launchUrl(Uri.parse('tel:' + e['value']));
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Text(
                                e['value'],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          hintMaxLines: 10,
                          hintStyle: TextStyle(
                              fontSize: 14, color: CustomColors.appColor),
                          hintText: body,
                          fillColor: Colors.white))),
              Container(
                height: 10,
              )
            ]))
        : CustomProgressIndicator(funcInit: initState);
  }

  void getData({required id}) async {
    String url = serverIp + '/ads/' + id;
    final uri = Uri.parse(url);

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      try {
        title = json['title_tm'];
        location = json['location']['name'];
        images = json['images'];
        phones = json['phones'];
      } catch (err) {}
    });
  }
}
