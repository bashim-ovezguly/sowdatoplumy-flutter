import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:my_app/pages/Aksiya/Detail.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

class Lenta extends StatefulWidget {
  const Lenta({super.key});
  @override
  State<Lenta> createState() => _LentaState();
}

class _LentaState extends State<Lenta> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading = false;
  String baseurl = "";

  final int _numberOfPostPerRequest = 100;
  final int _nextPageTriger = 3;
  List<dynamic> data = [];

  @override
  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _error = false;
    get_lenta_list();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
          title: Text('Aksiýalar',
              style: TextStyle(color: CustomColors.appColorWhite))),
      body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColor,
          onRefresh: () async {
            setState(() {
              _loading = true;
              initState();
            });
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: _loading == false
              ? ListView.builder(
                  itemCount: data.length + (_isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == data.length - _nextPageTriger) {
                      get_lenta_list();
                    }
                    if (index == data.length) {
                      if (_error) {
                        return Center(child: errorDialog(size: 15));
                      } else {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ));
                      }
                    }
                    return Container(
                      height: 500,
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(color: Colors.grey))),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                child: Row(children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoreDetail(
                                                        id: data[index]['store']
                                                            ['id'],
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            serverIp +
                                                data[index]['store']['logo'],
                                          ),
                                        )),
                                  ),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StoreDetail(
                                                  id: data[index]['store']
                                                      ['id'])));
                                    },
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  data[index]['store']['name'],
                                                  style: TextStyle(
                                                      color:
                                                          CustomColors.appColor,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Text(
                                                  data[index]['created_at']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          CustomColors.appColor,
                                                      fontWeight:
                                                          FontWeight.normal)))
                                        ]),
                                  ),
                                  Spacer(),
                                  SizedBox(width: 10)
                                ]),
                              )),
                          SizedBox(height: 5),
                          Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LentaDetail(
                                                id: data[index]['id']
                                                    .toString())));
                                  },
                                  child: Container(
                                      height: 180,
                                      color: Colors.black12,
                                      child: ImageSlideshow(
                                          disableUserScrolling:
                                              data[index]['images'].length > 1
                                                  ? false
                                                  : true,
                                          width: double.infinity,
                                          initialPage: 0,
                                          indicatorColor: CustomColors.appColor,
                                          indicatorBackgroundColor: Colors.grey,
                                          autoPlayInterval: null,
                                          isLoop: false,
                                          children: [
                                            if (data[index]['images'].length ==
                                                0)
                                              ClipRect(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LentaDetail(
                                                                    id: data[index]
                                                                            [
                                                                            'id']
                                                                        .toString())));
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: Image.asset(
                                                          'assets/images/default.jpg'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            for (var item in data[index]
                                                ['images'])
                                              if (item['img'] != null &&
                                                  item['img'] != '')
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LentaDetail(
                                                                      id: data[index]
                                                                              [
                                                                              'id']
                                                                          .toString())));
                                                    },
                                                    child: ClipRect(
                                                        child: Container(
                                                            height: 220,
                                                            width:
                                                                double.infinity,
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
                                                                child: Image
                                                                    .network(
                                                                  baseurl +
                                                                      item[
                                                                          'img'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )))))
                                          ])))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                if (data[index]['like'])
                                  Row(
                                    children: [
                                      Icon(Icons.favorite, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text(data[index]['like_count'].toString(),
                                          style: TextStyle(
                                              color: CustomColors.appColor)),
                                    ],
                                  )
                                else
                                  GestureDetector(
                                      onTap: () async {
                                        clickLike(index);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.favorite_border,
                                              color: CustomColors.appColor),
                                          SizedBox(width: 5),
                                          Text(
                                              data[index]['like_count']
                                                  .toString(),
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.appColor)),
                                        ],
                                      )),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: GestureDetector(
                                      onTap: () {
                                        var url =
                                            'http://business-complex.com.tm/lenta/' +
                                                data[index]['id'].toString();
                                        Share.share(url,
                                            subject: 'Söwda Toplumy');
                                      },
                                      child: Icon(
                                        Icons.share,
                                        color: CustomColors.appColor,
                                      )),
                                ),
                                Spacer(),
                                Icon(Icons.visibility_sharp,
                                    size: 20, color: CustomColors.appColor),
                                SizedBox(width: 5),
                                Text(data[index]['view'].toString(),
                                    style: TextStyle(
                                        color: CustomColors.appColor)),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          if (data[index]['text'] != '')
                            Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Text(
                                    data[index]['text'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(color: CustomColors.appColor),
                                    maxLines: 3,
                                  ),
                                ))
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child:
                      CircularProgressIndicator(color: CustomColors.appColor))),
    );
  }

  clickLike(index) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() +
        "/lenta/" +
        data[index]['id'].toString() +
        '/like';

    final uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    print(request.headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        data[index]['like'] = true;
        data[index]['like_count'] = data[index]['like_count'] + 1;
      });
    }
  }

  void get_lenta_list() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/lenta';

    url = url + "?page=$_pageNumber&page_size=$_numberOfPostPerRequest";
    final uri = Uri.parse(url);

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    var postList = [];

    for (var i in json['data']) {
      postList.add(i);
    }

    setState(() {
      baseurl = server_url.get_server_url();
      _isLastPage = data.length < _numberOfPostPerRequest;
      _loading = false;

      _pageNumber = _pageNumber + 1;
      data.addAll(postList);
    });
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  get_lenta_list();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }
}
