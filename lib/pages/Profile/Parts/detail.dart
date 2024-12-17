import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Profile/Parts/edit.dart';
import 'package:my_app/pages/FullScreenSlider.dart';

import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../deleteAlert.dart';

class GetAutoParthFirst extends StatefulWidget {
  GetAutoParthFirst(
      {Key? key,
      required this.customer_id,
      required this.id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final String id;
  final String customer_id;
  final String user_customer_id;
  final Function refreshFunc;

  @override
  State<GetAutoParthFirst> createState() =>
      _GetAutoParthFirstState(id: id, customer_id: customer_id);
}

class _GetAutoParthFirstState extends State<GetAutoParthFirst> {
  final String id;
  final String customer_id;
  final number = '';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  List<String> imgList = [];

  String mark = '';
  String model = '';
  String price = '';
  String name = '';
  String location = '';
  String category = '';
  String phone = '';
  String status = '';
  String description = '';

  void initState() {
    widget.refreshFunc();
    if (imgList.length == 0) {
      imgList.add('x');
    }
    getPart(id: id);
    super.initState();
  }

  callbackStatus() {
    getPart(id: id);
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetAutoParthFirstState({required this.customer_id, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Awtoşaý",
            style: CustomText.appBarText,
          ),
          actions: [
            if (widget.user_customer_id == '')
              PopupMenuButton<String>(
                surfaceTintColor: CustomColors.appColorWhite,
                shadowColor: CustomColors.appColorWhite,
                color: CustomColors.appColorWhite,
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AutoPartsEdit(
                                          old_data: data,
                                          callbackFunc: callbackStatus)));
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
                                        action: "parts",
                                        id: id,
                                        callbackFunc: callbackStatusDelete);
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
                                  Text('Bozmak')
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenSlider(imgList: imgList)));
                          },
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
                                .map((item) => Expanded(
                                    child: item != '' && item != 'x'
                                        ? Image.network(
                                            item,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : Image.asset(
                                            'assets/images/default16x9.jpg',
                                            fit: BoxFit.cover,
                                          )))
                                .toList(),
                          ),
                        ),
                      ),
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
                                fontFamily: 'Raleway',
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
                  SizedBox(
                    height: 10,
                  ),
                  if (data['status'] == 'canceled' &&
                      data['error_reason'] != '')
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(data['error_reason'].toString(),
                            maxLines: 10, style: TextStyle(color: Colors.red))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          price + ' TMT',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Text(
                          description,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
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
    Urls server_url = new Urls();
    String url = partsUrl + '/' + id;
    final uri = Uri.parse(url);
    // create request headers
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      try {
        mark = data['mark']['name'];
      } catch (e) {}
      try {
        model = data['model']['name'];
      } catch (e) {}
      try {
        price = data['price'];
      } catch (e) {}
      try {
        phone = data['phone'];
      } catch (e) {}
      try {
        name = data['name'];
      } catch (e) {}
      try {
        description = data['description'];
      } catch (e) {}

      try {
        location = data['location']['name'];
      } catch (e) {}
      try {
        category = data['category']['name'];
      } catch (e) {}

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

class TextKeyWidget extends StatelessWidget {
  const TextKeyWidget({Key? key, required this.text, required this.size})
      : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 3, style: TextStyle(fontSize: 14, color: Colors.black26));
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
