import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';
import 'package:my_app/pages/SliderDetail.dart';
import 'package:my_app/pages/call.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../FullScreenSlider.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<ProductDetail> createState() => _ProductDetailState(id: id);
}

class _ProductDetailState extends State<ProductDetail> {
  List<String> imgList = [];

  final String id;
  var baseurl = "";
  var data = {};
  int _current = 0;
  bool determinate = false;
  bool slider_img = true;
  bool status = true;
  String titleAppBar = "";

  String name = '';
  String price = '';
  String? category = '';
  String created_at = '';
  String viewed = '';
  String? phone = '';
  String description = '';
  String location = '';
  String advUrl = '';
  String advId = '';
  String shareLink = '';

  String storeName = '';
  int storeId = 0;
  String storeLogoUrl = '';

  void dispose() {
    super.dispose();
  }

  void initState() {
    getProduct(id: id);
    super.initState();
  }

  _ProductDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: RefreshIndicator(
                color: CustomColors.appColor,
                onRefresh: () async {
                  setState(() {
                    determinate = false;
                  });
                },
                child: determinate
                    ? ListView(children: <Widget>[
                        Stack(
                            alignment: Alignment.bottomCenter,
                            textDirection: TextDirection.rtl,
                            fit: StackFit.loose,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            viewportFraction: 1,
                                            initialPage: 0,
                                            enableInfiniteScroll:
                                                this.imgList.length > 1
                                                    ? true
                                                    : false,
                                            reverse: false,
                                            autoPlay: this.imgList.length > 1
                                                ? true
                                                : false,
                                            autoPlayInterval:
                                                const Duration(seconds: 4),
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 0.3,
                                            scrollDirection: Axis.horizontal,
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
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: item != '' &&
                                                                  slider_img ==
                                                                      true
                                                              ? Image.network(
                                                                  item.toString(),
                                                                )
                                                              : Image.asset(
                                                                  defaulImageUrl),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenSlider(
                                                        imgList: imgList)));
                                      })),
                              if (this.imgList.length > 0)
                                Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: DotsIndicator(
                                        dotsCount: this.imgList.length,
                                        position: _current.toDouble(),
                                        decorator: DotsDecorator(
                                            color: Colors.white,
                                            activeColor: CustomColors.appColor,
                                            activeShape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0))))),
                              Positioned(
                                  top: 1,
                                  right: 10,
                                  child: PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert,
                                          size: 30,
                                          shadows: <Shadow>[
                                            Shadow(
                                                color: Color.fromARGB(
                                                    255, 113, 113, 113),
                                                blurRadius: 15.0)
                                          ]),
                                      iconColor: CustomColors.appColorWhite,
                                      surfaceTintColor:
                                          CustomColors.appColorWhite,
                                      shadowColor: CustomColors.appColorWhite,
                                      color: CustomColors.appColorWhite,
                                      itemBuilder: (context) {
                                        List<PopupMenuEntry<String>>
                                            menuEntries2 = [
                                          PopupMenuItem<String>(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Share.share(this.shareLink,
                                                        subject:
                                                            'Söwda Toplumy');
                                                  },
                                                  child: Container(
                                                      color: Colors.white,
                                                      height: 30,
                                                      width: double.infinity,
                                                      child: Row(children: [
                                                        Icon(Icons.share),
                                                        Text('  Paýlaş')
                                                      ]))))
                                        ];
                                        return menuEntries2;
                                      })),
                              Positioned(
                                  top: 10,
                                  left: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back,
                                        color: CustomColors.appColorWhite,
                                        size: 30,
                                        shadows: <Shadow>[
                                          Shadow(
                                              color: Color.fromARGB(
                                                  255, 113, 113, 113),
                                              blurRadius: 15.0)
                                        ]),
                                  ))
                            ]),
                        // DATE AND VIEW
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_month,
                                size: 20,
                                color: CustomColors.appColor,
                              ),
                              Text(
                                this.created_at,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColors.appColor,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.remove_red_eye,
                                size: 20,
                                color: CustomColors.appColor,
                              ),
                              Text(
                                this.viewed,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColors.appColor,
                                ),
                              )
                            ],
                          ),
                        ),

                        // ////////////////////////////////////////

                        Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  this.name,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              if (this.category != '' && this.category != null)
                                Container(
                                  child: Text(
                                    this.category.toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              Container(
                                child: Text(
                                  this.price + ' TMT',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                              Container(
                                child: Text(
                                  this.description,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (this.storeName != '')
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoreDetail(
                                            id: this.storeId,
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Row(children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2, color: Colors.grey),
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.network(
                                      serverIp + this.storeLogoUrl),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dükan',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        this.storeName,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        if (this.phone != 'null')
                          GestureDetector(
                            onTap: () {
                              final uri =
                                  Uri.parse('tel:' + this.phone.toString());
                              launchUrl(uri);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Jaň et ' + this.phone.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (this.advUrl != '')
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdPage(
                                            id: this.advId.toString(),
                                          )));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Reklama hyzmaty",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(

                                          // fontSize: 17,
                                          color: CustomColors.appColor,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(serverIp + this.advUrl,
                                        fit: BoxFit.cover,
                                        height: 180,
                                        width: double.infinity),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ])
                    : Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.appColor)))));
  }

  void getProduct({required id}) async {
    String url = productsUrl + '/' + id;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Request error'),
            );
          });
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      try {
        price = json['price'].toString();
      } catch (err) {}
      try {
        this.name = json['name'].toString();
      } catch (err) {}
      try {
        phone = json['phone'].toString();
      } catch (err) {}
      try {
        description = json['description'].toString();
      } catch (err) {}
      try {
        category = json['category']['name'].toString();
      } catch (err) {}
      try {
        created_at = json['created_at'].toString();
      } catch (err) {}
      try {
        viewed = json['viewed'].toString();
      } catch (err) {}
      try {
        shareLink = json['share_link'].toString();
      } catch (err) {}
      try {
        advUrl = json['ad']['img'].toString();
        advId = json['ad']['id'].toString();
      } catch (err) {}
      try {
        storeName = json['store']['name'].toString();
        storeId = json['store']['id'];
        storeLogoUrl = json['store']['logo'];
      } catch (err) {}

      var i;
      for (i in json['images']) {
        this.imgList.add(serverIp + i['img_m']);
      }
      if (this.imgList.length == 0) {
        slider_img = false;
      }
      determinate = true;
    });
  }
}

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({Key? key, required this.type}) : super(key: key);
  final bool type;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: type
          ? const Icon(Icons.check, color: Colors.green, size: 25)
          : Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
    );
  }
}

class TextKeyWidget extends StatelessWidget {
  const TextKeyWidget({Key? key, required this.text, required this.size})
      : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 3,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ));
  }
}

class TextValueWidget extends StatelessWidget {
  const TextValueWidget({Key? key, required this.text, required this.size})
      : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(fontSize: 14, color: CustomColors.appColor));
  }
}
