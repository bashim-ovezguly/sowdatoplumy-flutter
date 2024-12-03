import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/Products/edit.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
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

  String name = '';
  String price = '';
  String description = '';
  String category = '';

  int _current = 0;

  var data = {};
  bool try_again = false;
  List<String> imgList = [];

  void initState() {
    getPart(id: id);
    super.initState();
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  bool status = false;
  callbackStatus() {
    getPart(id: id);
  }

  _MyOtherGoodsDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Haryt",
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
                                      builder: (context) => ProductEdit(
                                            old_data: data,
                                            callbackFunc: callbackStatus,
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
                                  Text(' Düzetmek')
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
        body: try_again
            ? ListView(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    textDirection: TextDirection.rtl,
                    fit: StackFit.loose,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        child: GestureDetector(
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 300,
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
                                              child: Image.network(item,
                                                  fit: BoxFit.cover,
                                                  height: 320,
                                                  width: double.infinity,
                                                  errorBuilder: (a, b, c) {
                                        return Image.asset(defaulImageUrl);
                                      }))),
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
                      if (this.imgList.length > 0)
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: DotsIndicator(
                            dotsCount: imgList.length,
                            position: _current.toDouble(),
                            decorator: DotsDecorator(
                              color: Colors.white,
                              activeColor: CustomColors.appColor,
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
                              color: CustomColors.appColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['created_at'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.appColor,
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
                              color: CustomColors.appColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['viewed'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.appColor,
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
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: CustomColors.appColor,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            category,
                            style: TextStyle(
                              color: CustomColors.appColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            price + ' TMT',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(description, style: TextStyle(fontSize: 17)),
                        ]),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: CustomColors.appColor,
                ),
              ));
  }

  void getPart({required id}) async {
    String url = productsUrl + '/' + id.toString();
    final uri = Uri.parse(url);

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      data = json;
      try {
        name = data['name'].toString();
      } catch (err) {}
      try {
        category = data['category']['name'].toString();
      } catch (err) {}
      try {
        price = data['price'].toString();
      } catch (err) {}
      try {
        description = data['description'].toString();
      } catch (err) {}
      var i;
      imgList = [];

      try {
        for (i in data['images']) {
          imgList.add(serverIp + i['img_m']);
        }
      } catch (err) {}

      try_again = true;
    });
  }
}
