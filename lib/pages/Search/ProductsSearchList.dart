// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Products/ProductDetail.dart';
import '../progressIndicator.dart';

class ProductsSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  ProductsSearchList({Key? key, required this.params}) : super(key: key);
  @override
  State<ProductsSearchList> createState() =>
      _ProductsSearchListState(params: params);
}

class _ProductsSearchListState extends State<ProductsSearchList> {
  Map<String, dynamic> params;
  List<dynamic> data = [];
  bool determinate = false;
  bool status = true;
  var keyword = TextEditingController();
  int total_count = 0;

  bool filter = false;
  callbackFilter() {
    setState(() {
      _pageNumber = 1;
      _isLastPage = false;
      _error = false;
      data = [];
      determinate = false;
      getProducts();
    });
  }

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _error = false;
    getProducts();
    super.initState();
  }

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  final int _numberOfPostPerRequest = 12;
  final int _nextPageTriger = 3;

  _ProductsSearchListState({required this.params});

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              actions: [],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gözleg',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    'Harytlar: ' + this.total_count.toString() + ' sany',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColor,
                onRefresh: () async {
                  setState(() {
                    _pageNumber = 1;
                    _isLastPage = false;
                    _error = false;
                    data = [];
                    determinate = false;
                    getProducts();
                  });
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: determinate
                    ? ListView.builder(
                        itemCount: data.length + (_isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == data.length - _nextPageTriger &&
                              data.length != total_count) {
                            getProducts();
                          }
                          if (index == data.length) {
                            if (_error || data.length == total_count) {
                              return Center(child: errorDialog(size: 15));
                            } else {
                              return Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ));
                            }
                          }
                          return GestureDetector(
                              onTap: () {
                                if (data[index]['id'] != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                                id: data[index]['id']
                                                    .toString(),
                                              )));
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Card(
                                      shadowColor: CustomColors.appColorWhite,
                                      surfaceTintColor:
                                          CustomColors.appColorWhite,
                                      color: CustomColors.appColorWhite,
                                      elevation: 5,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          child: Container(
                                              height: 110,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    flex: 1,
                                                    child: ClipRect(
                                                        child: Container(
                                                            height: 110,
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
                                                                child: data[index]['img'] !=
                                                                            '' &&
                                                                        data[index]['img'] !=
                                                                            null
                                                                    ? Image.network(serverIp +
                                                                        data[index]['img']
                                                                            .toString())
                                                                    : Image.asset(
                                                                        'assets/images/default.jpg'))))),
                                                Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    data[index][
                                                                        'name'],
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: CustomColors
                                                                            .appColor))),
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    data[index][
                                                                            'price'] +
                                                                        'TMT',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                    ))),
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Row(
                                                                    children: <Widget>[
                                                                      Text(
                                                                          data[index]['created_at']
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 14))
                                                                    ])),
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .store,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      Text(
                                                                        data[index]['store']
                                                                            [
                                                                            'name'],
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      )
                                                                    ]))
                                                          ]),
                                                    ))
                                              ]))))));
                        })
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColor))),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context) {
    // var sort = Provider.of<UserInfo>(context, listen: false).sort;
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return CustomDialog(sort_value: sort, callbackFunc: callbackFilter);
    //   },
    // );
  }

  void getProducts() async {
    // var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    print(sort_value);

    // if (int.parse(sort) == 2) {
    //   sort_value = 'sort=price';
    // }

    // if (int.parse(sort) == 3) {
    //   sort_value = 'sort=-price';
    // }

    // if (int.parse(sort) == 4) {
    //   sort_value = 'sort=id';
    // }

    // if (int.parse(sort) == 4) {
    //   sort_value = 'sort=-id';
    // }

    String url = serverIp + '/mob/products?';

    if (params['category'] != 'null') {
      url = url + 'category=' + params['category'] + "&";
    }
    if (params['name'] != null) {
      url = url + 'name=' + params['name'] + "&";
    }
    if (params['id'] != null) {
      url = url + 'id=' + params['id'] + "&";
    }
    if (params['location'] != 'null') {
      url = url + 'location=' + params['location'] + "&";
    }

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    try {
      final response = await get(
          Uri.parse(
              url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"),
          headers: headers);
      print(Uri.parse(
          url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      var postList = [];
      for (var i in json['data']) {
        postList.add(i);
      }
      setState(() {
        total_count = json['count'];
        determinate = true;
        _isLastPage = data.length < _numberOfPostPerRequest;
        _pageNumber = _pageNumber + 1;
        data.addAll(postList);
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Soňy !',
          style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
      const SizedBox(height: 10),
    ]));
  }
}
