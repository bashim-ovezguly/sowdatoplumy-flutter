import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/providers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dB/textStyle.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';
import '../progressIndicator.dart';

class PharmacieFirst extends StatefulWidget {
  PharmacieFirst({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<PharmacieFirst> createState() => _PharmacieFirstState(id: id);
}

class _PharmacieFirstState extends State<PharmacieFirst> {
  final String id;
  int _current = 0;
  var baseurl = "";
  var telefon = {};
  var data = {};
  var data_tel = [];
  var data_array = [];
  List<dynamic> products = [];
  List<String> imgList = [];
  bool slider_img = true;
  bool determinate = false;
  bool determinate1 = false;
  bool status = true;
  final ScrollController _controller = ScrollController();
  bool buttonTop = false;
  late int total_page;
  late int current_page;
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  bool _getRequest = false;
  final int _numberOfPostPerRequest = 12;
  var keyword = TextEditingController();

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
  
    timers();
    if (imgList.length == 0) {
      imgList.add(
          'https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-building-under-construction-image_1141142.jpg');
    }
    getsinglepharmacies(id: id);
    get_products_modul(id);
    super.initState();
  }

  timers() async {
    _controller.addListener(_controllListener);
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

  _PharmacieFirstState({required this.id});
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
              actions: [],
            ),
            body: RefreshIndicator(
                color: Colors.white,
                backgroundColor: CustomColors.appColors,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                    determinate1 = false;
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: determinate && determinate1
                    ? SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                                alignment: Alignment.bottomCenter,
                                textDirection: TextDirection.rtl,
                                fit: StackFit.loose,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  Container(
                                      height: 220,
                                      child: GestureDetector(
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                                height: 220,
                                                viewportFraction: 1,
                                                initialPage: 0,
                                                enableInfiniteScroll: true,
                                                reverse: false,
                                                autoPlay: imgList.length > 1
                                                    ? true
                                                    : false,
                                                autoPlayInterval:
                                                    const Duration(seconds: 4),
                                                autoPlayAnimationDuration:
                                                    const Duration(
                                                        milliseconds: 800),
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enlargeCenterPage: true,
                                                enlargeFactor: 0.3,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    _current = index;
                                                  });
                                                }),
                                            items: imgList
                                                .map((item) => Container(
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: ClipRect(
                                                          child: Container(
                                                            height: 220,
                                                            width:
                                                                double.infinity,
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: item != 'x'
                                                                  ? Image
                                                                      .network(
                                                                      item.toString(),
                                                                    )
                                                                  : Image.asset(
                                                                      'assets/images/default16x9.jpg'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          onTap: () {
                                            if (imgList.length == 1 &&
                                                imgList[0] == 'x') {
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenSlider(
                                                              imgList:
                                                                  imgList)));
                                            }
                                          })),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: DotsIndicator(
                                          dotsCount: imgList.length,
                                          position: _current.toDouble(),
                                          decorator: DotsDecorator(
                                            color: Colors.white,
                                            activeColor: CustomColors.appColors,
                                            activeShape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          )))
                                ]),
                            Container(
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.access_time_outlined,
                                          size: 20,
                                          color: CustomColors.appColors,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data['created_at'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Raleway',
                                            color: CustomColors.appColors,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.visibility_sharp,
                                          size: 20,
                                          color: CustomColors.appColors,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data['viewed'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Raleway',
                                            color: CustomColors.appColors,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (data['name_tm'] != '' &&
                                data['name_tm'] != null)
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(data['name_tm'].toString(),
                                    style: TextStyle(
                                        color: CustomColors.appColors,
                                        fontSize: 20)),
                              ),
                            if (data['location_name'] != '' &&
                                data['location_name'] != null)
                              SizedBox(
                                  child: Row(children: [
                                SizedBox(width: 5, height: 5),
                                Icon(Icons.location_on,
                                    color: CustomColors.appColors, size: 25),
                                SizedBox(width: 5),
                                Text(data['location_name'].toString(),
                                    maxLines: 5,
                                    style: TextStyle(
                                        color: CustomColors.appColors,
                                        fontSize: 14)),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                )
                              ])),
                            if (data['contacts'] != null)
                              Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    for (var i = 0;
                                        i < data['contacts'].length;
                                        i++)
                                      GestureDetector(
                                        onTap: () async {
                                          if (data['contacts'][i]['type'] ==
                                              'phone') {
                                            final call = Uri.parse('tel:' +
                                                data['contacts'][i]['value']);
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                height: 25,
                                                child: Image.network(
                                                  data['contacts'][i]['icon'],
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.cover,
                                                )),
                                            SizedBox(width: 5),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                  data['contacts'][i]['value']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: CustomColors
                                                          .appColors,
                                                      fontSize: 14)),
                                            )
                                          ],
                                        ),
                                      )
                                  ]),
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
                                            data_array = [];
                                          });
                                          get_products_modul(id);
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
                                            data_array = [];
                                            keyword.text = '';
                                          });
                                          get_products_modul(id);
                                        },
                                      ),
                                      hintText: 'Gözleg...',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: data_array.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtherGoodsDetail(
                                                  id: item['id'].toString(),
                                                  title: 'Dermanhanalar',
                                                )));
                                  },
                                  child: Container(
                                    height: 220,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Card(
                                      color: CustomColors.appColorWhite,
                                      shadowColor: const Color.fromARGB(
                                          255, 200, 198, 198),
                                      surfaceTintColor:
                                          CustomColors.appColorWhite,
                                      elevation: 5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              height: 150,
                                              child: item['img'] != ''
                                                  ? Image.network(
                                                      baseurl +
                                                          item['img']
                                                              .toString(),
                                                      fit: BoxFit.cover,
                                                      height: 150,
                                                      width: double.infinity,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/default.jpg',
                                                    ),
                                            ),
                                            Container(
                                                color: Colors.white,
                                                child: Text(
                                                  item['name'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: CustomColors
                                                          .appColors),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            Container(
                                              color: Colors.white,
                                              child: Text(
                                                item['price'].toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.green),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
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
                            color: CustomColors.appColors))))
        : CustomProgressIndicator(funcInit: initState);
  }

  void getsinglepharmacies({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/pharmacies/' + id;
    final uri = Uri.parse(url);

       Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        baseurl =  server_url.get_server_url();
        data_tel = json['phones'];
        products = json['products'];
        if (json['phones'].length != 0) {
          telefon = json['phones'][0];
        }
        var i;
        imgList = [];
        for (i in data['images']) {
          imgList.add(baseurl + i['img_m']);
        }
        if (imgList.length == 0) {
          slider_img = false;
          imgList.add(
              'https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-building-under-construction-image_1141142.jpg');
        }
        determinate = true;
      });
    }
  

  void get_products_modul(id) async {
    Urls server_url = new Urls();
    var param = 'products';
    String url = server_url.get_server_url() + '/mob/' + param + '?store=' + id;

    if (keyword.text != '') {
      url = server_url.get_server_url() +
          '/mob/' +
          param +
          '?store=' +
          id +
          "&name=" +
          keyword.text;
    }
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    if (_getRequest == false) {
      print(url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest");
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
        _loading = false;
        _pageNumber = _pageNumber + 1;
        data_array.addAll(postList);
        _getRequest = false;
        determinate1 = true;
      });
    }
  }

  void _controllListener() {
    if (_controller.offset > 600) {
      setState(() {
        buttonTop = true;
      });
    } else {
      setState(() {
        buttonTop = false;
      });
    }
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
      get_products_modul(id);
      setState(() {
        _getRequest = true;
      });
    }
  }
}
