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
              //name
              Container(
                padding: EdgeInsets.all(10),
                child: Text(this.title.toString(),
                    style:
                        TextStyle(color: CustomColors.appColor, fontSize: 20)),
              ),

              //location
              if (this.location.length > 0)
                Container(
                    padding: EdgeInsets.all(5),
                    child: Row(children: [
                      Icon(Icons.location_on_outlined,
                          color: CustomColors.appColor, size: 20),
                      Expanded(
                        child: Text(this.location,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: CustomColors.appColor,
                                fontSize: 14)),
                      )
                    ])),
              //phones
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: this
                      .phones
                      .map((e) => MaterialButton(
                            padding: EdgeInsets.all(0),
                            elevation: 0,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            onPressed: () {
                              launchUrl(Uri.parse('tel:' + e['value']));
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(5),
                              child: Text(
                                e['value'],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),

//images
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
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Image.network(serverIp + e['img']),
                          ),
                        ))
                    .toList(),
              ),
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
      } catch (err) {}
      try {
        location = json['location']['name'];
      } catch (err) {}
      try {
        images = json['images'];
      } catch (err) {}
      try {
        phones = json['phones'];
      } catch (err) {}
    });
  }
}
