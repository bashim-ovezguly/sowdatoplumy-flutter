import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:provider/provider.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';
import '../../dB/colors.dart';

const List<String> list = <String>[
  'Ulgama gir',
  'ulgamda cyk',
  'bilemok',
  'ozin karar'
];

class Car extends StatefulWidget {
  const Car({Key? key}) : super(key: key);

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  String dropdownValue = list.first;
  List<dynamic> dataSlider = [
    {"img": "", 'name_tm': "", 'price': "", 'location': ''}
  ];
  List<dynamic> data = [];
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool determinate1 = false;
  bool status = true;

  bool filter = false;
  callbackFilter() {
    setState(() {
      determinate = false;
      determinate1 = false;
      getcarlist();
      getcars_slider();
    });
  }

  void initState() {
    timers();
    getcarlist();
    getcars_slider();
    super.initState();
  }

  timers() async {
    setState(() {
      status = true;
    });
    final completer = Completer();
    final t = Timer(Duration(seconds: 5), () => completer.complete());
    await completer.future;
    setState(() {
      if (determinate == false) {
        status = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                "Awtoulaglar",
                style: CustomText.appBarText,
              ),
              actions: [
                Row(
                  children: <Widget>[
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              showConfirmationDialog(context);
                            },
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
                                      builder: (context) => Search(index: 0)));
                            },
                            child: Icon(Icons.search,
                                color: Colors.white, size: 25)))
                  ],
                ),
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                    determinate1 = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            childCount: 1,
                            (BuildContext context, int index) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                textDirection: TextDirection.rtl,
                                fit: StackFit.loose,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 200,
                                    color: Colors.black12,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                          height: 200,
                                          viewportFraction: 1,
                                          initialPage: 3,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: dataSlider.length > 1
                                              ? true
                                              : false,
                                          autoPlayInterval:
                                              const Duration(seconds: 4),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.3,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          }),
                                      items: dataSlider
                                          .map((item) => GestureDetector(
                                                onTap: () {
                                                  if (item['id'] != "") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    CarStore(
                                                                      id: item[
                                                                              'id']
                                                                          .toString(),
                                                                    )));
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Center(
                                                      child: Stack(
                                                    children: [
                                                      ClipRect(
                                                        child: Container(
                                                          height: 200,
                                                          width:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: item['img'] !=
                                                                        null &&
                                                                    item['img'] !=
                                                                        ''
                                                                ? Image.network(
                                                                    baseurl +
                                                                        item['img']
                                                                            .toString(),
                                                                  )
                                                                : Image.asset(
                                                                    'assets/images/default16x9.jpg'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: DotsIndicator(
                                      dotsCount: dataSlider.length,
                                      position: _current.toDouble(),
                                      decorator: DotsDecorator(
                                        color: Colors.white,
                                        activeColor: CustomColors.appColors,
                                        activeShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          )),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: data.length,
                              (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CarStore(
                                                  id: data[index]['id']
                                                      .toString())));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        elevation: 2,
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
                                                        child: data[index]
                                                                    ['img'] !=
                                                                ''
                                                            ? Image.network(
                                                                baseurl +
                                                                    data[index][
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
                                                  color: CustomColors.appColors,
                                                  margin:
                                                      EdgeInsets.only(left: 2),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            data[index]['mark']
                                                                    .toString() +
                                                                " " +
                                                                data[index][
                                                                        'model']
                                                                    .toString() +
                                                                " " +
                                                                data[index]
                                                                        ['year']
                                                                    .toString(),
                                                            style: CustomText
                                                                .itemTextBold,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  data[index][
                                                                          'location']
                                                                      .toString(),
                                                                  style: CustomText
                                                                      .itemText))),
                                                      Expanded(
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Row(
                                                                  children: [
                                                                    Text(
                                                                        data[index]['price']
                                                                            .toString(),
                                                                        style: CustomText
                                                                            .itemText),
                                                                    Spacer(),
                                                                    Text(
                                                                        data[index]['delta_time']
                                                                            .toString(),
                                                                        style: CustomText
                                                                            .itemText)
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
                                                              data[index]
                                                                      ['credit']
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
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                    data[index][
                                                                        'store_name'],
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: CustomText
                                                                        .itemText,
                                                                  ),
                                                                )))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColors))),
            drawer: MyDraver(),
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

  void getcarlist() async {
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
    String url = server_url.get_server_url() + '/mob/cars?' + sort_value.toString();
    final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['data'];
      baseurl = server_url.get_server_url();
      determinate = true;
    });
  }

  void getcars_slider() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/cars?on_slider=1';
    final uri = Uri.parse(url);
       Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider = json['data'];
      if (dataSlider.length == 0) {
        dataSlider = [
          {"img": "", 'name_tm': "", 'price': "", 'location': ''}
        ];
      }
      baseurl = server_url.get_server_url();
      determinate1 = true;
    });
  }
}
