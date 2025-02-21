import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Car/carDetail.dart';
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
  List<dynamic> dataSlider = [];
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  var keyword = TextEditingController();
  final ScrollController _controller = ScrollController();
  int total_count = 0;

  bool filter = false;
  callbackFilter() {
    setState(() {
      _pageNumber = 1;
      _isLastPage = false;
      _error = false;
      data = [];
      determinate = false;
      getCars();
    });
  }

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _error = false;
    getCars();
    super.initState();
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
                    'Awtoulaglar ' + this.total_count.toString(),
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
                    _error = false;
                    data = [];
                    determinate = false;
                    getCars();
                  });
                  // return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: determinate
                    ? ListView.builder(
                        controller: _controller,
                        itemCount: data.length + (_isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == data.length - _nextPageTriger &&
                              data.length != total_count) {
                            getCars();
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
                          return Container(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CarDetail(
                                                id: data[index]['id'])));
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
                                                  child: Row(children: <Widget>[
                                                    Expanded(
                                                        flex: 1,
                                                        child: ClipRect(
                                                          child: Container(
                                                            height: 110,
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: data[index]
                                                                              [
                                                                              'img'] !=
                                                                          '' &&
                                                                      data[index]
                                                                              [
                                                                              'img'] !=
                                                                          null
                                                                  ? Image
                                                                      .network(
                                                                      baseurl +
                                                                          data[index]['img']
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
                                                            color: CustomColors
                                                                .appColorWhite,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 2),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          data[index]['mark'].toString() +
                                                                              " " +
                                                                              data[index]['model'].toString() +
                                                                              " " +
                                                                              data[index]['year'].toString(),
                                                                          style: CustomText.itemTextBold)),
                                                                  if (data[index]
                                                                              [
                                                                              'location'] !=
                                                                          null &&
                                                                      data[index]
                                                                              [
                                                                              'location'] !=
                                                                          '')
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.location_on_outlined,
                                                                                size: 16,
                                                                              ),
                                                                              Text(data[index]['location'].toString(), style: CustomText.itemText)
                                                                            ])),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Row(
                                                                          children: <Widget>[
                                                                            Icon(
                                                                              Icons.calendar_month,
                                                                              size: 16,
                                                                            ),
                                                                            Text(data[index]['delta_time'].toString(),
                                                                                style: CustomText.itemText),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            Text(data[index]['price'].toString() + ' TMT',
                                                                                style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold))
                                                                          ])),
                                                                  if (data[index]
                                                                          [
                                                                          'store'] !=
                                                                      '')
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .storefront_outlined,
                                                                          size:
                                                                              14,
                                                                        ),
                                                                        Text(
                                                                            data[index]['store'][
                                                                                'name'],
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: CustomText.itemText),
                                                                      ],
                                                                    )
                                                                ])))
                                                  ])))))));
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

  void getCars() async {
    // var sort = Provider.of<UserInfo>(context, listen: false).sort;
    // // ignore: unused_local_variable
    // var sort_value = "";

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

    String url = serverIp + '/mob/cars?';
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
        total_count = json['count'];
        baseurl = serverIp;
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
