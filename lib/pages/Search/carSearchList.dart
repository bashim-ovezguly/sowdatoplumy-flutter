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

// ignore: must_be_immutable
class CarSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  CarSearchList({Key? key, required this.params}) : super(key: key);
  @override
  State<CarSearchList> createState() => _CarSearchListState(params: params);
}

class _CarSearchListState extends State<CarSearchList> {
  Map<String, dynamic> params;
  List<dynamic> dataSlider = [
    {"img": "", 'name': "", 'price': "", 'location': ''}
  ];
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  var keyword = TextEditingController();
  final ScrollController _controller = ScrollController();
  int total_price = 0;

  bool filter = false;
  callbackFilter() {
    setState(() {
      timers();
      _pageNumber = 1;
      _isLastPage = false;
      _error = false;
      data = [];
      determinate = false;
      getproductlist();
    });
  }

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
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
  final int _numberOfPostPerRequest = 12;
  final int _nextPageTriger = 3;

  _CarSearchListState({required this.params});

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
                    _error = false;
                    data = [];
                    determinate = false;
                    getproductlist();
                  });
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: determinate
                    ? Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              child: Row(children: <Widget>[
                                Text(
                                    "Awtoulaglaryn - " + total_price.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: CustomColors.appColors)),
                                const Spacer(),
                                Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                        onTap: () {
                                          showConfirmationDialog(context);
                                        },
                                        child:
                                            const Icon(Icons.sort, size: 25)))
                              ])),
                          Container(
                            height: MediaQuery.of(context).size.height - 135,
                            child: ListView.builder(
                                controller: _controller,
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
                                  return Container(
                                      child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherGoodsDetail(
                                                    id: data[index]['id']
                                                        .toString(),
                                                    title: 'Harytlar',
                                                  )));
                                    },
                                    child: Container(
                                      height: 110,
                                      child: Card(
                                        color: CustomColors.appColorWhite,
                                        shadowColor: const Color.fromARGB(
                                            255, 200, 198, 198),
                                        surfaceTintColor:
                                            CustomColors.appColorWhite,
                                        elevation: 5,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                                          child: data[index][
                                                                          'img'] !=
                                                                      '' &&
                                                                  data[index][
                                                                          'img'] !=
                                                                      null
                                                              ? Image.network(
                                                                  baseurl +
                                                                      data[index]
                                                                              [
                                                                              'img']
                                                                          .toString(),
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/default.jpg',
                                                                ),
                                                        ),
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    color:
                                                        CustomColors.appColors,
                                                    margin: EdgeInsets.only(
                                                        left: 2),
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        if (data[index]
                                                                    ['name'] !=
                                                                null &&
                                                            data[index]
                                                                    ['name'] !=
                                                                '')
                                                          Expanded(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                data[index]
                                                                    ['name'],
                                                                maxLines: 1,
                                                                style: CustomText
                                                                    .itemTextBold,
                                                              ),
                                                            ),
                                                          ),
                                                        if (data[index][
                                                                    'location'] !=
                                                                null &&
                                                            data[index][
                                                                    'location'] !=
                                                                '')
                                                          Expanded(
                                                              child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: <Widget>[
                                                                Text(
                                                                    data[index][
                                                                            'location']
                                                                        .toString(),
                                                                    style: CustomText
                                                                        .itemText)
                                                              ],
                                                            ),
                                                          )),
                                                        Expanded(
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Row(
                                                                    children: <Widget>[
                                                                      Text(
                                                                          data[index]['delta_time']
                                                                              .toString(),
                                                                          style:
                                                                              CustomText.itemText),
                                                                      Spacer(),
                                                                      Text(
                                                                          data[index]['price']
                                                                              .toString(),
                                                                          style:
                                                                              CustomText.itemText),
                                                                    ]))),
                                                        if (data[index][
                                                                    'store_id'] ==
                                                                null ||
                                                            data[index][
                                                                    'store_id'] ==
                                                                '')
                                                          Expanded(
                                                              child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: <Widget>[
                                                                Text('Kredit',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12)),
                                                                data[index][
                                                                        'credit']
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text('Obmen',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12)),
                                                                data[index]
                                                                        ['swap']
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text('Nagt däl',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12)),
                                                                data[index][
                                                                        'none_cash_pay']
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                              ],
                                                            ),
                                                          ))
                                                        else
                                                          Expanded(
                                                              child: Container(
                                                                  height: 25,
                                                                  child: Text(
                                                                    data[index][
                                                                        'store_name'],
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: CustomText
                                                                        .itemText,
                                                                  )))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                                }),
                          )
                        ],
                      )
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
    String url = server_url.get_server_url() + '/mob/cars?';
    if (params['model'] != 'null') {
      url = url + 'model=' + params['model'] + "&";
    }
    if (params['mark'] != 'null') {
      url = url + 'mark=' + params['mark'] + "&";
    }
    if (params['body_type'] != 'null') {
      url = url + 'body_type=' + params['body_type'] + "&";
    }
    if (params['color'] != 'null') {
      url = url + 'color=' + params['color'] + "&";
    }
    if (params['fuel'] != 'null') {
      url = url + 'fuel=' + params['fuel'] + "&";
    }
    if (params['transmission'] != 'null') {
      url = url + 'transmission=' + params['transmission'] + "&";
    }
    if (params['wd'] != 'null') {
      url = url + 'wd=' + params['wd'] + "&";
    }
    if (params['vin'] != null) {
      url = url + 'vin=' + params['vin'] + "&";
    }
    if (params['id'] != null) {
      url = url + 'id=' + params['id'] + "&";
    }
    if (params['location'] != 'null') {
      url = url + 'location=' + params['location'] + "&";
    }

    if (params['yearStart'] != null) {
      url = url + 'yearStart=' + params['yearStart'] + "&";
    }
    if (params['yearEnd'] != null) {
      url = url + 'yearEnd=' + params['yearEnd'] + "&";
    }
    if (params['price_min'] != null) {
      url = url + 'price_min=' + params['price_min'] + "&";
    }
    if (params['price_max'] != null) {
      url = url + 'price_max=' + params['price_max'] + "&";
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
    if (params['recolored'] != null && params['recolored'] == 'on') {
      url = url + 'recolored=' + params['recolored'] + "&";
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
        _pageNumber = _pageNumber + 1;
        data.addAll(postList);
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void isTopList() {
    double position = 0.0;
    _controller.position.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
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
