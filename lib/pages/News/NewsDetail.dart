import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/main.dart';
import 'package:my_app/pages/FullScreenSlider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../dB/constants.dart';
import '../../dB/providers.dart';

class NewsDetailPage extends StatefulWidget {
  final String id;
  NewsDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  var images = [];
  var title_tm = '';
  var body_tm = '';
  var view = 0;
  var categoryName = '';
  var createdAt = '';
  var likeCount = '';

  var data = {};

  var baseurl = '';
  bool determinate = false;
  List<String> imgList = [];

  @override
  void initState() {
    getNewsById(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text('Giňişleýin',
                style: TextStyle(color: CustomColors.appColorWhite))),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              determinate = false;
              getNewsById(id: widget.id);
            });
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: determinate
              ? ListView(children: [
                  SizedBox(height: 20),
                  ImageSlideshow(height: 300, children: [
                    for (var item in data['images'])
                      Image.network('http://216.250.9.45:8000' + item['img'],
                          fit: BoxFit.cover)
                  ]),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 20,
                                  ),
                                  Text(
                                    data['view'].toString(),
                                    style: TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                                // categories.addAll(json['categories']) ;
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.grey,
                                ),
                                onPressed: () {},
                                child: Icon(
                                  Icons.share,
                                  size: 20,
                                )),
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.date_range_sharp,
                                    size: 20,
                                  ),
                                  Text(
                                    data['created_at'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () => {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    foregroundColor: Colors.grey),
                                child: Row(
                                  children: [
                                    data['liked'] == true
                                        ? Icon(Icons.favorite,
                                            size: 23, color: Colors.blueAccent)
                                        : Icon(Icons.favorite_border,
                                            size: 23, color: Colors.blueAccent),
                                    Text(
                                      data['like_count'].toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blueAccent),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(data['title_tm'].toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          child: Text(data['body_tm'].toString(),
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                  ),
                ])
              : Center(
                  child:
                      CircularProgressIndicator(color: CustomColors.appColor)),
        ));
  }

  void getNewsById({required id}) async {
    print(id);
    String url = serverIp + '/news/' + id;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      print(data['images']);
      baseurl = serverIp;
      determinate = true;
      // for (var i in data['images']) {
      //   imgList.add(baseurl + i['img']);
      // }
    });
  }
}
