import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/OtherGoods/otherGoodsDetail.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

class OtherGoodsSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  OtherGoodsSearchList({Key? key, required this.params}) : super(key: key);
  @override
  State<OtherGoodsSearchList> createState() =>
      _OtherGoodsSearchListState(params: params);
}

class _OtherGoodsSearchListState extends State<OtherGoodsSearchList> {
  Map<String, dynamic> params;
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  var keyword = TextEditingController();
  int total_price = 0;

  bool filter = false;
  callbackFilter() {
    setState(() {
      timers();
      _pageNumber = 1;
      _isLastPage = false;
      _loading = true;
      _error = false;
      data = [];
      determinate = false;
      getproductlist();
    });
  }

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    timers();
    getproductlist();
    super.initState();
  }

  timers() async {
    setState(() {
      status = true;
    });
    final completer = Completer();
    final t = Timer(Duration(seconds: 5), () => completer.complete());
    print(t);
    await completer.future;
    setState(() {
      if (determinate == false) {
        status = false;
      }
    });
  }

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostPerRequest = 12;
  final int _nextPageTriger = 3;

  _OtherGoodsSearchListState({required this.params});

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: const Text(
                'Gözleg',
                style: CustomText.appBarText,
              ),
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    _pageNumber = 1;
                    _isLastPage = false;
                    _loading = true;
                    _error = false;
                    data = [];
                    determinate = false;
                    getproductlist();
                  });
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: determinate
                    ? Column(children: [
                        Container(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 10),
                            child: Row(children: <Widget>[
                              Text(
                                  "Beýleki bildirişler - " +
                                      total_price.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: CustomColors.appColors)),
                              const Spacer(),
                              Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                      onTap: () {
                                        showConfirmationDialog(context);
                                      },
                                      child: const Icon(Icons.sort, size: 25)))
                            ])),
                        Container(
                            height: MediaQuery.of(context).size.height - 135,
                            child: ListView.builder(
                                itemCount: data.length + (_isLastPage ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index == data.length - _nextPageTriger &&
                                      data.length != total_price) {
                                    getproductlist();
                                  }
                                  if (index == data.length) {
                                    if (_error || data.length == total_price) {
                                      return Center(
                                          child: errorDialog(size: 15));
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
                                                  builder: (context) =>
                                                      OtherGoodsDetail(
                                                        id: data[index]['id']
                                                            .toString(),
                                                        title: 'Harytlar',
                                                      )));
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Card(
                                              shadowColor:
                                                  CustomColors.appColorWhite,
                                              surfaceTintColor:
                                                  CustomColors.appColorWhite,
                                              color: CustomColors.appColorWhite,
                                              elevation: 5,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(Radius
                                                          .circular(10.0)),
                                                  child: Container(
                                                      height: 110,
                                                      child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                                flex: 1,
                                                                child: ClipRect(
                                                                    child: Container(
                                                                        height:
                                                                            110,
                                                                        child: FittedBox(
                                                                            fit: BoxFit
                                                                                .cover,
                                                                            child: data[index]['img'] != '' && data[index]['img'] != null
                                                                                ? Image.network(baseurl + data[index]['img'].toString())
                                                                                : Image.asset('assets/images/default.jpg'))))),
                                                            Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                        color: CustomColors
                                                                            .appColors,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                2),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Expanded(child: Container(alignment: Alignment.centerLeft, child: Text(data[index]['name'], style: CustomText.itemTextBold))),
                                                                              Expanded(
                                                                                  child: Align(
                                                                                      alignment: Alignment
                                                                                          .centerLeft,
                                                                                      child: Row(children: <Widget>[
                                                                                        Text(data[index]['location'].toString(), style: CustomText.itemText)
                                                                                      ]))),
                                                                              Expanded(
                                                                                  child: Align(
                                                                                      alignment: Alignment
                                                                                          .centerLeft,
                                                                                      child: Row(children: <Widget>[
                                                                                        Text(data[index]['delta_time'].toString(), style: CustomText.itemText)
                                                                                      ]))),
                                                                              Expanded(
                                                                                  child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Row(children: <Widget>[
                                                                                        Text('Kredit', style: TextStyle(color: Colors.white, fontSize: 12)),
                                                                                        data[index]['credit']
                                                                                            ? Icon(
                                                                                                Icons.check,
                                                                                                color: Colors.green,
                                                                                              )
                                                                                            : Icon(Icons.close, color: Colors.red),
                                                                                        SizedBox(width: 5),
                                                                                        Text('Obmen', style: TextStyle(color: Colors.white, fontSize: 12)),
                                                                                        data[index]['swap']
                                                                                            ? Icon(
                                                                                                Icons.check,
                                                                                                color: Colors.green,
                                                                                              )
                                                                                            : Icon(Icons.close, color: Colors.red),
                                                                                        SizedBox(width: 5),
                                                                                        Text('Nagt däl', style: TextStyle(color: Colors.white, fontSize: 12)),
                                                                                        data[index]['none_cash_pay']
                                                                                            ? Icon(
                                                                                                Icons.check,
                                                                                                color: Colors.green,
                                                                                              )
                                                                                            : Icon(Icons.close, color: Colors.red)
                                                                                      ])))
                                                                            ])))
                                                          ]))))));
                                }))
                      ])
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColors))),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context) {
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter);
      },
    );
  }

  void getproductlist() async {
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    print(sort_value);

    if (int.parse(sort) == 2) {
      sort_value = 'sort=price';
    }

    if (int.parse(sort) == 3) {
      sort_value = 'sort=-price';
    }

    if (int.parse(sort) == 4) {
      sort_value = 'sort=id';
    }

    if (int.parse(sort) == 4) {
      sort_value = 'sort=-id';
    }

    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/announcements?';

    if (params['category'] != 'null') {
      url = url + 'category=' + params['category'] + "&";
    }
    if (params['brand'] != 'null') {
      url = url + 'brand=' + params['brand'] + "&";
    }
    if (params['made_in'] != 'null') {
      url = url + 'made_in=' + params['made_in'] + "&";
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

    if (params['credit'] != null && params['credit'] == 'on') {
      url = url + 'credit=' + params['credit'] + "&";
    }
    if (params['swap'] != null && params['swap'] == 'on') {
      url = url + 'swap=' + params['swap'] + "&";
    }
    if (params['none_cash'] != null && params['none_cash'] == 'on') {
      url = url + 'none_cash=' + params['none_cash'] + "&";
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
        total_price = json['count'];
        baseurl = server_url.get_server_url();
        determinate = true;
        _isLastPage = data.length < _numberOfPostPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        data.addAll(postList);
      });
    } catch (e) {
      setState(() {
        _loading = false;
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
