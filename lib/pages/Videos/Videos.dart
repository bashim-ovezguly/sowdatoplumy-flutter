import 'package:flutter/material.dart';

import 'package:my_app/pages/News/NewsDetail.dart';
import 'dart:convert';
import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

class VideoList extends StatefulWidget {
  const VideoList({super.key});
  @override
  State<VideoList> createState() => VideoListState();
}

class VideoListState extends State<VideoList> {
  late bool isLastPage;
  late int currentPage;
  late int totalCount;
  late int categoryCount;

  late bool loading;
  String baseurl = "";
  late ScrollController scrollController;

  final int _numberOfPostPerRequest = 10;
  List<dynamic> data = [];
  List<dynamic> categories = [];

  @override
  void initState() {
    scrollController = ScrollController();
    totalCount = 0;
    categoryCount = 0;
    // isLastPage = false;
    // loading = true;
    currentPage = 1;
    getNewslist();
    getNewsCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
          title: Text('Habarlar',
              style: TextStyle(color: CustomColors.appColorWhite))),
      body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColor,
          onRefresh: () async {
            setState(() {
              loading = true;
              initState();
            });
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListView.builder(
                      itemCount: categoryCount,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, elevation: 0),
                            child: Text(categories[index]['name_tm']),
                          ),
                        );
                      })),
              Expanded(
                child: ListView.builder(
                  itemCount: totalCount,
                  itemBuilder: (context, index) {
                    return Container(
                        child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 330,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      // color: CustomColors.appColorWhite,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewsDetailPage(
                                                      id: data[index]['id']
                                                          .toString())));
                                    },
                                    child: Column(
                                      children: [
                                        Image.network(
                                          'http://216.250.9.45:8000' +
                                              data[index]['img'],
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(
                                          data[index]['title_tm'].toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(10, 35, 98, 1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          data[index]['body_tm'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .remove_red_eye_sharp,
                                                      size: 23,
                                                      color: Colors.black54),
                                                  Text(
                                                    data[index]['view']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => {},
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  foregroundColor: Colors.grey),
                                              child: Icon(Icons.share,
                                                  size: 23,
                                                  color: Colors.black54),
                                            ),
                                            ElevatedButton(
                                                onPressed: () => {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    foregroundColor:
                                                        Colors.grey),
                                                child: Row(
                                                  children: [
                                                    data[index]['liked'] == true
                                                        ? Icon(Icons.favorite,
                                                            size: 23,
                                                            color: Colors
                                                                .blueAccent)
                                                        : Icon(
                                                            Icons
                                                                .favorite_border,
                                                            size: 23,
                                                            color: Colors
                                                                .blueAccent),
                                                    Text(
                                                      data[index]['like_count']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors
                                                              .blueAccent),
                                                    )
                                                  ],
                                                )),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.date_range_sharp,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                    data[index]['created_at']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ));
                  },
                ),
              ),
            ],
          )),
    );
  }

  void getNewslist() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/news';

    url = url + "?page=$currentPage&page_size=$_numberOfPostPerRequest";

    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      loading = false;
      currentPage = currentPage + 1;
      data = json['data'];
      totalCount = json['data'].length;
    });
  }

  void getNewsCategories() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/news';

    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      categories = [
        {'id': 0, 'name_tm': 'Hemmesi'}
      ];
      categories.addAll(json['categories']);
      categoryCount = json['categories'].length;
    });
  }
}
