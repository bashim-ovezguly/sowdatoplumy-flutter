import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Profile/Profile.dart';
import 'package:share_plus/share_plus.dart';
import '../call.dart';
import '../FullScreenSlider.dart';

import '../progressIndicator.dart';

class NotificationsDetail extends StatefulWidget {
  NotificationsDetail({Key? key, required this.id, required this.title})
      : super(key: key);
  final String id, title;
  @override
  State<NotificationsDetail> createState() =>
      _NotificationsDetailState(id: id, title: title);
}

class _NotificationsDetailState extends State<NotificationsDetail> {
  final String id, title;
  String number = '';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  bool slider_img = true;
  bool status = true;
  List<String> imgList = [];

  void initState() {
    if (imgList.length == 0) {
      imgList.add(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsingleproduct(id: id);
    super.initState();
  }

  _NotificationsDetailState({required this.id, required this.title});
  @override
  Widget build(BuildContext context) {
    return status
        ? SafeArea(
            child: Scaffold(
                backgroundColor: CustomColors.appColorWhite,
                body: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: CustomColors.appColor,
                    onRefresh: () async {
                      setState(() {
                        determinate = false;
                        initState();
                      });
                      return Future<void>.delayed(const Duration(seconds: 3));
                    },
                    child: determinate
                        ? ListView(
                            children: <Widget>[
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
                                                imgList.length > 1
                                                    ? true
                                                    : false,
                                            reverse: false,
                                            autoPlay: imgList.length > 1
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
                                                          fit: BoxFit.cover,
                                                          child: item != '' &&
                                                                  slider_img ==
                                                                      true
                                                              ? Image.network(
                                                                  item.toString(),
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/default .jpg'),
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
                                        activeColor: CustomColors.appColor,
                                        activeShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 1,
                                      right: 10,
                                      child: PopupMenuButton<String>(
                                          iconColor: CustomColors.appColorWhite,
                                          surfaceTintColor:
                                              CustomColors.appColorWhite,
                                          shadowColor:
                                              CustomColors.appColorWhite,
                                          color: CustomColors.appColorWhite,
                                          itemBuilder: (context) {
                                            List<PopupMenuEntry<String>>
                                                menuEntries2 = [
                                              PopupMenuItem<String>(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        var url =
                                                            data['share_link']
                                                                .toString();
                                                        Share.share(url,
                                                            subject:
                                                                'Söwda Toplumy');
                                                      },
                                                      child: Container(
                                                          color: Colors.white,
                                                          height: 30,
                                                          width:
                                                              double.infinity,
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
                                            size: 30),
                                      ))
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
                                            fontFamily: 'Raleway',
                                            color: CustomColors.appColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              if (data['name_tm'] != '' &&
                                  data['name_tm'] != null)
                                SizedBox(
                                    child: Row(children: [
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 10,
                                    child: Text(data['name_tm'].toString(),
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: CustomColors.appColor,
                                            fontSize: 18)),
                                  )
                                ])),
                              if (data['location'] != '' &&
                                  data['location'] != null)
                                SizedBox(
                                    child: Row(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.location_on,
                                        color: CustomColors.appColor, size: 25),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 10,
                                    child: Text(data['location'].toString(),
                                        style: TextStyle(
                                            color: CustomColors.appColor,
                                            fontSize: 14)),
                                  )
                                ])),
                              if (data['category'] != null &&
                                  data['category'] != '')
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 35,
                                    child: Row(children: [
                                      Icon(
                                        Icons.layers,
                                        color: const Color.fromARGB(
                                            255, 170, 170, 170),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(data['category'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 170, 170, 170),
                                          ))
                                    ])),
                              if (data['price'] != '' && data['price'] != null)
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 30,
                                    child: Text(
                                        data['price'].toString() + " TMT",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: CustomColors.appColor,
                                            fontWeight: FontWeight.bold))),
                              if (data['store_name'] != null &&
                                  data['store_name'] != '')
                                GestureDetector(
                                    onTap: () {
                                      if (data['store'] != null &&
                                          data['store_id'] != '') {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             MarketDetail(
                                        //                 id: data['store_id']
                                        //                     .toString(),
                                        //                 title: 'Dükanlar')));
                                      }
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Image.asset(
                                            'assets/images/store.png',
                                            color: CustomColors.appColor,
                                            width: 25,
                                            height: 25,
                                          ),
                                          Text(data['store_name'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: CustomColors.appColor))
                                        ])),
                              if (data['customer_name'] != null &&
                                  data['customer_name'] != '')
                                GestureDetector(
                                    onTap: () {
                                      if (data['customer_id'] != null &&
                                          data['customer_id'] != '') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Profile(
                                                    user_customer_id:
                                                        data['customer_id']
                                                            .toString())));
                                      }
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            height: 20,
                                          ),
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              baseurl +
                                                  data['customer_photo']
                                                      .toString(),
                                            ),
                                            radius: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(data['customer_name'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: CustomColors.appColor))
                                        ])),
                              if (data['phone'] != '' && data['phone'] != null)
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 35,
                                    child: Row(children: [
                                      Icon(Icons.phone,
                                          color: CustomColors.appColor),
                                      SizedBox(width: 10),
                                      Text(data['phone'].toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: CustomColors.appColor))
                                    ])),
                              if (data['body_tm'] != null &&
                                  data['body_tm'] != '')
                                SizedBox(
                                    width: double.infinity,
                                    child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          hintMaxLines: 10,
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: CustomColors.appColor),
                                          hintText: data['body_tm'].toString(),
                                          fillColor: Colors.white,
                                        ))),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                color: CustomColors.appColor))),
                floatingActionButton: status
                    ? Call(phone: data['phone'].toString())
                    : Container()),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  void getsingleproduct({required id}) async {
    String url = serverIp + '/announcements/' + id;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;

      print(json);

      imgList = [];
      baseurl = serverIp;
      if (data['phone'] != null && data['phone'] != '') {
        number = data['phone'].toString();
      }

      for (var i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }
      if (imgList.length == 0) {
        slider_img = false;
        imgList.add(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
      }
      determinate = true;
    });
  }
}
