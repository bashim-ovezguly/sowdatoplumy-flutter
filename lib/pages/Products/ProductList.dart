// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Products/ProductDetail.dart';
import 'package:my_app/pages/Drawer.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';

class ProductList extends StatefulWidget {
  ProductList({Key? key}) : super(key: key);
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> dataSlider = [];
  List<dynamic> data = [];
  int currentPage = 1;
  int pageSize = 48;
  int totalCount = 0;
  bool isLoading = false;
  bool tryFetchAgain = false;
  bool status = true;
  var keyword = TextEditingController();
  late bool isLastPage;
  late int _pageNumber;
  late bool error;
  late bool _loading;
  final int numberOfPostPerRequest = 100;
  final int nextPageTriger = 3;
  var sort = '';
  var category = '';
  var categories = [];
  late ScrollController scrollController = ScrollController();

  bool filter = false;
  callbackFilter() {
    setState(() {
      setData();
    });
  }

  void initState() {
    scrollController.addListener(scrollControllerEvent);
    currentPage = 1;
    isLastPage = false;
    setData();
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: const Text("Harytlar", style: CustomText.appBarText),
        actions: [
          Row(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.sort,
                        size: 25,
                      ))),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(index: 1)));
                      },
                      child: Icon(Icons.search, color: Colors.white, size: 25)))
            ],
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              setData();
            });
          },
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                controller: keyword,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    prefixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          this.data = [];
                          isLoading = true;
                        });
                        setData();
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        keyword.text = '';
                        setState(() {
                          isLoading = true;
                          this.data = [];
                        });

                        setData();
                      },
                    ),
                    hintText: 'Ady boýunça gözleg...',
                    border: InputBorder.none),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: this
                      .categories
                      .map((item) => MaterialButton(
                          onPressed: () {
                            setState(() {
                              this.category = item['id'].toString();
                              setData();
                            });
                          },
                          padding: EdgeInsets.all(5),
                          child: Text(
                            item['name_tm'],
                            style: TextStyle(color: Colors.grey),
                          )))
                      .toList()),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: []),
            ),
            if (isLoading == true)
              Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    color: CustomColors.appColor,
                  )),
            Expanded(
                child: SingleChildScrollView(
              controller: scrollController,
              child: Wrap(
                children: data.map((item) {
                  return GestureDetector(
                    onTap: () {
                      int id = item['id'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetail(id: id.toString())));
                    },
                    child: Container(
                        margin: EdgeInsets.all(5),
                        clipBehavior: Clip.hardEdge,
                        width: MediaQuery.sizeOf(context).width / 3 - 10,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 0,
                                  blurRadius: 5)
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              serverIp + item['img'],
                              height: 150,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    item['price'] + ' TMT',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    item['store_name'].toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  );
                }).toList(),
              ),
            )),
          ])),
      drawer: MyDrawer(),
    );
  }

  void scrollControllerEvent() {
    if (scrollController.offset / scrollController.position.maxScrollExtent >
        0.9) {
      addMoreItems();
    }
  }

  void addMoreItems() async {
    if (this.isLoading == true) {
      return null;
    }
    setState(() {
      currentPage++;
    });

    String url = productsUrl +
        "?page=$currentPage&page_size=$pageSize&category=$category";
    final uri = Uri.parse(url);
    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;
      data.addAll(json['data']);
      totalCount = data.length;
    });
  }

  getCategories() async {
    String url = serverIp + '/index/product';

    final response = await get(Uri.parse(url));
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      categories.add({'id': '', 'name_tm': 'Hemmesi'});
      categories.addAll(json['categories']);
    });
  }

  void setData() async {
    if (this.isLoading == true) {
      return null;
    }
    setState(() {
      isLoading = true;
      this.data = [];
    });

    print('request');
    String keywordText = keyword.text;
    String url = productsUrl +
        '?name=$keywordText&page_size=$pageSize&sort=$sort&category=$category';

    final response = await get(Uri.parse(url));

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    var postList = [];
    for (var i in json['data']) {
      postList.add(i);
    }

    setState(() {
      tryFetchAgain = false;
      isLoading = false;
      data.addAll(postList);
    });
  }
}
