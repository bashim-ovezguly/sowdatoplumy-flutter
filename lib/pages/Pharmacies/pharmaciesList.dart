// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Pharmacies/pharmacieFirst.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

class PharmaciesList extends StatefulWidget {
  const PharmaciesList({Key? key}) : super(key: key);

  @override
  State<PharmaciesList> createState() => _PharmaciesListState();
}

class _PharmaciesListState extends State<PharmaciesList> {
  List<dynamic> data = [];
  var baseurl = "";
  int _current = 0;
  late int total_page;
  late int current_page;
  bool _getRequest = false;
  bool determinate = false;
  bool status = true;
  bool determinate1 = true;
  List<dynamic> dataSlider = [
    {"img": "", 'name': "", 'location': ''}
  ];
  final ScrollController _controller = ScrollController();
  bool filter = false;
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  var keyword = TextEditingController();
  late bool _loading;
  final int _numberOfPostPerRequest = 12;

  callbackFilter() {
    timers();
    setState(() {
      determinate = false;
      getpharmacieslist();
    });
  }

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    _controller.addListener(_controllListener);
    timers();
    getpharmacieslist();
    getslider_shopping_centers();
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

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            appBar: AppBar(
              title: const Text(
                "Dermanhanalar",
                style: CustomText.appBarText,
              ),
              actions: [
                Row(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                            onTap: () {
                              showConfirmationDialog(context);
                            },
                            child: const Icon(
                              Icons.sort,
                              size: 25,
                            ))),
                  ],
                )
              ],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                    initState();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              textDirection: TextDirection.rtl,
                              fit: StackFit.loose,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  height: 220,
                                  color: Colors.white,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: 220,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: dataSlider.length>1 ? true: false,
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
                                                if (item['id'] != null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PharmacieFirst(
                                                                  id: item['id']
                                                                      .toString())));
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 220,
                                                    width: double.infinity,
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: item['img'] != ''
                                                          ? Image.network(
                                                              baseurl +
                                                                  item['img']
                                                                      .toString(),
                                                            )
                                                          : Image.asset(
                                                              'assets/images/default16x9.jpg'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 7),
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
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 228, 228, 228),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: TextFormField(
                                  controller: keyword,
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () {
                                          setState(() {
                                            _pageNumber = 1;
                                            _isLastPage = false;
                                            _loading = true;
                                            _error = false;
                                            data = [];
                                          });
                                          var sort = Provider.of<UserInfo>(
                                                  context,
                                                  listen: false)
                                              .sort;
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

                                          getpharmacieslist();
                                          getslider_shopping_centers();
                                        },
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _pageNumber = 1;
                                            _isLastPage = false;
                                            _loading = true;
                                            _error = false;
                                            data = [];
                                            keyword.text = '';
                                          });
                                          var sort = Provider.of<UserInfo>(context, listen: false).sort;
                                          var sort_value = "";

                                          if (int.parse(sort) == 2) { sort_value = 'sort=price'; }
                                          if (int.parse(sort) == 3) { sort_value = 'sort=-price'; }
                                          if (int.parse(sort) == 4) { sort_value = 'sort=id'; }
                                          if (int.parse(sort) == 4) { sort_value = 'sort=-id'; }
                                          getpharmacieslist();
                                          getslider_shopping_centers();
                                        },
                                      ),
                                      hintText: 'Ady boýunça gözleg...',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: data.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PharmacieFirst(
                                                    id: item['id']
                                                        .toString())));
                                  },
                                  child: Container(
                                    height: 160,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              height: 120,
                                              child: item['img'] != ''
                                                  ? Image.network(
                                                      baseurl +
                                                          item['img']
                                                              .toString(),
                                                      fit: BoxFit.cover,
                                                      height: 120,
                                                      width: double.infinity,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/default.jpg',
                                                    ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                item['name'].toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        CustomColors.appColors),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (total_page > current_page &&
                                _getRequest == true)
                              Container(
                                height: 100,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: CustomColors.appColors)),
                              )
                          ],
                        ),
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
        return CustomDialog(
          sort_value: sort,
          callbackFunc: callbackFilter,
        );
      },
    );
  }

  void getpharmacieslist() async {
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
    try {
      if (_getRequest == false) {
        Urls server_url = new Urls();
        String url = server_url.get_server_url() +
            '/mob/pharmacies?' +
            sort_value.toString();
        if (keyword.text != '') {
          url = server_url.get_server_url() +
              '/mob/pharmacies?' +
              sort_value.toString() +
              "&name=" +
              keyword.text;
        }

        Map<String, String> headers = {};
        for (var i in global_headers.entries) {
          headers[i.key] = i.value.toString();
        }
        print(Uri.parse(
            url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));
        final response = await http.get(
            Uri.parse(
                url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"),
            headers: headers);

        final json = jsonDecode(utf8.decode(response.bodyBytes));
        var postList = [];
        for (var i in json['data']) {
          postList.add(i);
        }

        setState(() {
          current_page = json['current_page'];
          total_page = json['total_page'];
          baseurl = server_url.get_server_url();
          determinate = true;
          determinate = true;
          _isLastPage = data.length < _numberOfPostPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          data.addAll(postList);
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void getslider_shopping_centers() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/pharmacies?on_slider=1';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider = json['data'];
      baseurl = server_url.get_server_url();
      determinate1 = true;
    });
  }

  void _controllListener() {
    if (_controller.offset > _controller.position.maxScrollExtent - 1000 &&
        total_page > current_page &&
        _getRequest == false) {
      var sort_value = "";
      var sort = Provider.of<UserInfo>(context, listen: false).sort;
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
      getpharmacieslist();
      setState(() {
        _getRequest = true;
      });
    }
  }
}
