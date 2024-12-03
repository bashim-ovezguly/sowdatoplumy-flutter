import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/call.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import 'package:share_plus/share_plus.dart';

import '../../dB/constants.dart';
import '../progressIndicator.dart';

class AutoPartsDetail extends StatefulWidget {
  AutoPartsDetail({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<AutoPartsDetail> createState() => _AutoPartsDetailState(id: id);
}

class _AutoPartsDetailState extends State<AutoPartsDetail> {
  final String id;
  var number = '';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool slider_img = true;
  List<String> imgList = [];
  bool status = true;
  bool determinate = false;

  void initState() {
    getsingleparts(id: id);
    super.initState();
  }

  _AutoPartsDetailState({required this.id});
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
                                      height: MediaQuery.of(context).size.width,
                                      color: Colors.white,
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
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            width:
                                                                double.infinity,
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: item !=
                                                                          '' &&
                                                                      slider_img ==
                                                                          true
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullScreenSlider(
                                                            imgList: imgList)));
                                          })),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: DotsIndicator(
                                          dotsCount: imgList.length,
                                          position: _current.toDouble(),
                                          decorator: DotsDecorator(
                                              color: Colors.white,
                                              activeColor:
                                                  CustomColors.appColor,
                                              activeShape:
                                                  RoundedRectangleBorder(
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
                                                          ])))),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        data['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.appColor),
                                      ),
                                    ),
                                    if (data['mark'] != '')
                                      Container(
                                        child: Text(
                                          data['mark'] + ' ' + data['model'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: CustomColors.appColor),
                                        ),
                                      ),
                                    if (data['category'] != '')
                                      Container(
                                        child: Text(
                                          data['category']['name'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: CustomColors.appColor),
                                        ),
                                      ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              data['price'].toString(),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (data['location'] != '')
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: CustomColors.appColor,
                                              size: 20,
                                            ),
                                            Expanded(
                                                child: Text(
                                              data['location'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                  color: CustomColors.appColor),
                                            ))
                                          ],
                                        ),
                                      ),
                                    if (data['description'] != '')
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Expanded(
                                            child: Text(
                                          // 'Desription Desription Desription Desription',
                                          data['description'],
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                              color: CustomColors.appColor),
                                        )),
                                      ),
                                  ],
                                ),
                              ),
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

  void getsingleparts({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/parts/' + id;

    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      baseurl = server_url.get_server_url();
      var i;
      number = data['phone'].toString();
      imgList = [];
      for (i in data['images']) {
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
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: CustomColors.appColor),
      overflow: TextOverflow.clip,
      maxLines: 2,
      softWrap: false,
    );
  }
}
