import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';

// ignore: must_be_immutable
class StoreSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  StoreSearchList({Key? key, required this.params}) : super(key: key);
  @override
  State<StoreSearchList> createState() => _StoreSearchListState(params: params);
}

class _StoreSearchListState extends State<StoreSearchList> {
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
      _loading = true;
      _error = false;
      data = [];
      determinate = false;
      getStores();
    });
  }

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    getStores();
    super.initState();
  }

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  // ignore: unused_field
  late bool _loading;
  final int _numberOfPostPerRequest = 12;
  final int _nextPageTriger = 3;

  _StoreSearchListState({required this.params});

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.sort),
                )
              ],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gözleg',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  Text(
                    'Dükanlar ' + this.total_count.toString(),
                    style: CustomText.appBarText,
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
                    _loading = true;
                    _error = false;
                    data = [];
                    determinate = false;
                    getStores();
                  });
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: determinate
                    ? ListView.builder(
                        itemCount: data.length + (_isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == data.length - _nextPageTriger &&
                              data.length != total_count) {
                            getStores();
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreDetail(
                                              id: data[index]['id'],
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Card(
                                  shadowColor: CustomColors.appColorWhite,
                                  surfaceTintColor: CustomColors.appColorWhite,
                                  color: CustomColors.appColorWhite,
                                  elevation: 5,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Container(
                                      height: 110,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: ClipRect(
                                                child: Container(
                                                  height: 110,
                                                  child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: Image.network(
                                                        serverIp +
                                                            data[index]['logo']
                                                                .toString(),
                                                        errorBuilder:
                                                            (c, o, s) {
                                                          return Image.asset(
                                                              defaulImageUrl);
                                                        },
                                                      )),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      data[index]['name']
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          color: CustomColors
                                                              .appColor,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  if (data[index]['location'] !=
                                                      '')
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: CustomColors
                                                                .appColor,
                                                            size: 20,
                                                          ),
                                                          Text(
                                                            data[index]
                                                                ['location'],
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: CustomColors
                                                                    .appColor),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  if (data[index]['category'] !=
                                                          null &&
                                                      data[index]['category'] !=
                                                          '')
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons
                                                                .layers_rounded,
                                                            size: 20,
                                                            color: CustomColors
                                                                .appColor,
                                                          ),
                                                          Text(
                                                            data[index]
                                                                ['category'],
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: CustomColors
                                                                    .appColor),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        })
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColor))),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  void getStores() async {
    // var sort = Provider.of<UserInfo>(context, listen: false).sort;
    // var sort_value = "";
    // print(sort_value);

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
    var url = storesUrl + '?';

    if (params['category'] != 'null') {
      url = url + 'category=' + params['category'] + "&";
    }

    try {
      url = url + 'name=' + params['name'] + "&";
    } catch (err) {}

    if (params['location'] != 'null') {
      url = url + 'location=' + params['location'] + "&";
    }

    print(url);
    final response = await get(
      Uri.parse(url + "page=$_pageNumber&page_size=$_numberOfPostPerRequest"),
    );

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    var postList = [];
    for (var i in json['data']) {
      postList.add(i);
    }
    setState(() {
      total_count = json['count'];
      determinate = true;
      _isLastPage = data.length < _numberOfPostPerRequest;
      _loading = false;
      _pageNumber = _pageNumber + 1;
      data.addAll(postList);
    });
    // setState(() {
    //   _loading = false;
    //   _error = true;
    // });
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
