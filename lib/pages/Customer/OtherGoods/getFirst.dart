import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/Customer/OtherGoods/edit.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import 'package:provider/provider.dart';

import '../../../dB/providers.dart';
import '../deleteAlert.dart';

class MyOtherGoodsDetail extends StatefulWidget {
  MyOtherGoodsDetail(
      {Key? key,
      required this.id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final String id;
  final String user_customer_id;
  final Function refreshFunc;
  @override
  State<MyOtherGoodsDetail> createState() => _MyOtherGoodsDetailState(id: id);
}

class _MyOtherGoodsDetailState extends State<MyOtherGoodsDetail> {
  final String id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  List<String> imgList = [];

  void initState() {
    widget.refreshFunc();
    if (imgList.length == 0) {
      imgList.add('x');
    }
    getsingleproduct(id: id);
    super.initState();
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  bool status = false;
  callbackStatus() {
    getsingleproduct(id: id);
  }

  _MyOtherGoodsDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    var user_customer_name =
        Provider.of<UserInfo>(context, listen: false).user_customer_name;
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: widget.user_customer_id == ''
              ? Text(
                  "Meniň sahypam",
                  style: CustomText.appBarText,
                )
              : Text(
                  user_customer_name.toString() + " şahsy otag",
                  style: CustomText.appBarText,
                ),
          actions: [
            if (widget.user_customer_id == '')
              PopupMenuButton<String>(
                color: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                shadowColor: CustomColors.appColorWhite,
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtherGoodsEdit(
                                            old_data: data,
                                            callbackFunc: callbackStatus,
                                            title: 'Bildiriş',
                                          )));
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.edit_road,
                                    color: Colors.green,
                                  ),
                                  Text(' Üýtgetmek')
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteAlert(
                                      action: 'products',
                                      id: id,
                                      callbackFunc: callbackStatusDelete,
                                    );
                                  });
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text('Pozmak')
                                ])))),
                  ];
                  return menuEntries2;
                },
              ),
          ],
        ),
        body: determinate
            ? ListView(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    textDirection: TextDirection.rtl,
                    fit: StackFit.loose,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 220,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll:
                                    imgList.length > 1 ? true : false,
                                reverse: false,
                                autoPlay: imgList.length > 1 ? true : false,
                                autoPlayInterval: const Duration(seconds: 4),
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
                            items: imgList
                                .map((item) => Container(
                                      color: Colors.white,
                                      child: Center(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Image border
                                              child: item != '' && item != 'x'
                                                  ? Image.network(
                                                      item,
                                                      fit: BoxFit.cover,
                                                      height: 220,
                                                      width: double.infinity,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/default16x9.jpg',
                                                      fit: BoxFit.cover,
                                                      height: 220,
                                                    ))),
                                    ))
                                .toList(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenSlider(imgList: imgList)));
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: DotsIndicator(
                          dotsCount: imgList.length,
                          position: _current.toDouble(),
                          decorator: DotsDecorator(
                            color: Colors.white,
                            activeColor: CustomColors.appColors,
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
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
                  SizedBox(height: 10),
                  if (data['status'] == 'canceled' &&
                      data['error_reason'] != '')
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(data['error_reason'].toString(),
                            maxLines: 10, style: TextStyle(color: Colors.red))),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            data['name_tm'].toString(),
                            style: TextStyle(
                              color: CustomColors.appColors,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 35,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.format_list_numbered,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Id",
                                style: CustomText.size_16_black54,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(data['id'].toString(),
                                style: CustomText.size_16))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 35,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.category_outlined,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Kategoriýa",
                                style: CustomText.size_16_black54,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(data['category'].toString(),
                                style: CustomText.size_16))
                      ],
                    ),
                  ),
                    Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 35,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.store,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Dükan",
                                style: CustomText.size_16_black54,
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Text(data['store'].toString(), style: CustomText.size_16))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.price_change_rounded,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Bahasy",
                                style: CustomText.size_16_black54,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(data['price'].toString(),
                                style: CustomText.size_16))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.location_on,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Ýerleşýän ýeri",
                                style: CustomText.size_16_black54,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(data['location'].toString(),
                                style: CustomText.size_16))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.phone_callback,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Telefon",
                                style: CustomText.size_16_black54,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(data['phone'].toString(),
                                style: CustomText.size_16))
                      ],
                    ),
                  ),

                  if (data['body_tm'] != '' && data['body_tm'] != null)
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 100,
                      width: double.infinity,
                      child: TextField(
                        enabled: false,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          hintText: data['body_tm'].toString(),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: CustomColors.appColors,
                ),
              ));
  }

  void getsingleproduct({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/products/' + id.toString();
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      baseurl = server_url.get_server_url();
      var i;
      imgList = [];
      for (i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }
      determinate = true;
      if (imgList.length == 0) {
        imgList.add('x');
      }
    });
  }
}
