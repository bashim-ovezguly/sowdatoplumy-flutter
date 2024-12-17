import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/News/NewsDetail.dart';
import 'package:my_app/pages/success.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  const NewsList({super.key});
  @override
  State<NewsList> createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  late bool isLastPage;
  late int currentPage;
  late int totalCount;
  late int categoryCount;
  late String category_id;

  late bool loading;
  String baseurl = "";
  late ScrollController scrollController;

  final int pageSize = 4;
  List<dynamic> data = [];
  List<dynamic> categories = [];

  void scrollControllerEvent() {
    if (scrollController.offset * 0.7 <=
        scrollController.position.maxScrollExtent) {
      setState(() {
        currentPage++;
      });
      addMoreItems();
    }
  }

  void addMoreItems() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/news';

    url = url + "?page=$currentPage&page_size=$pageSize&category=$category_id";

    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (mounted) {
      setState(() {
        loading = false;
        data.addAll(json['data']);
        totalCount = data.length;
      });
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollControllerEvent);
    totalCount = 0;
    categoryCount = 0;
    currentPage = 1;
    category_id = '';
    loading = true;
    setNewslist();
    setCategories();
    super.initState();
  }

  clickLike(index) async {
    String url = serverIp + "/news/" + index.toString();

    final uri = Uri.parse(url);
    var device_id = await get_store_id();
    var request = http.MultipartRequest("PUT", uri);

    request.fields['like'] = '1';

    request.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
      'device-id': device_id
    });

    final response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        // setNewslist();
      });
    }
  }

  void setCategories() async {
    String url = serverIp + '/index/news';

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

  void setNewslist() async {
    String url = serverIp + '/news';

    url = url + "?page=$currentPage&page_size=$pageSize&category=$category_id";

    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      loading = false;
      data = json['data'];
      totalCount = json['data'].length;
    });
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
          },
          child: Column(
            children: [
              Expanded(
                child: loading == true
                    ? ProgresBar()
                    : SingleChildScrollView(
                        controller: scrollController,
                        child: Row(
                          children: data.map((item) {
                            return Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [appShadow]),
                              height: 330,
                              width: double.infinity,
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
                                                              id: item['id']
                                                                  .toString())));
                                            },
                                            child: Column(
                                              children: [
                                                Image.network(
                                                  'http://216.250.9.45:8000' +
                                                      item['img'],
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
                                                  item['title_tm'].toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          CustomColors.appColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  item['body_tm'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .date_range_sharp,
                                                            size: 20,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                            item['created_at']
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              size: 20,
                                                              color:
                                                                  Colors.grey),
                                                          Text(
                                                            item['view']
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () => {
                                                              clickLike(
                                                                  item['id'])
                                                            },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            elevation: 0,
                                                            foregroundColor:
                                                                Colors.grey),
                                                        child: Row(
                                                          children: [
                                                            item['liked'] ==
                                                                    true
                                                                ? Icon(
                                                                    Icons
                                                                        .favorite,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .blueAccent)
                                                                : Icon(
                                                                    Icons
                                                                        .favorite_border,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .blueAccent),
                                                            Text(
                                                              item['like_count']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .blueAccent),
                                                            )
                                                          ],
                                                        )),
                                                    ElevatedButton(
                                                      onPressed: () => {
                                                        Share.share(
                                                            'http://business-complex.com.tm/news/' +
                                                                item['id']
                                                                    .toString())
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              elevation: 0,
                                                              foregroundColor:
                                                                  Colors.grey),
                                                      child: Icon(Icons.share,
                                                          size: 20,
                                                          color:
                                                              Colors.black54),
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
                            );
                          }).toList(),
                        )),
              ),
            ],
          )),
    );
  }
}
