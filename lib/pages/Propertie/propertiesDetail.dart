import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../dB/textStyle.dart';
import '../call.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';

class PropertiesDetail extends StatefulWidget {
  PropertiesDetail({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<PropertiesDetail> createState() => _PropertiesDetailState(id: id);
}

class _PropertiesDetailState extends State<PropertiesDetail> {
  final String id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  bool slider_img = true;
  List<String> imgList = [];
  bool status = true;

  void initState() {
    timers();
    if (imgList.length == 0) {
      imgList.add(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_kT38o_6efgNspm1kIxkRiw6clWQ5s0D7m9qKCZKu53v8x9pIKjdxbJuhlOqlyhpBtYA&usqp=CAU');
    }
    getsingleparts(id: id);
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

  _PropertiesDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return status
        ? SafeArea(
            child: Scaffold(
                backgroundColor: CustomColors.appColorWhite,
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
                                                            Image.asset(
                                                                'assets/images/send_link.png',
                                                                width: 20,
                                                                height: 20,
                                                                color: CustomColors
                                                                    .appColors),
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
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  height: 35,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.category_outlined,
                                          color: Colors.black26),
                                      SizedBox(width: 10),
                                      Text("Kategoriýa",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(data['category'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 35,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.person, color: Colors.black26),
                                      SizedBox(width: 10),
                                      Text("Ady",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(data['name'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              if (data['store_name'] != '' &&
                                  data['store_id' != ''])
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.store,
                                              color: Colors.black26,
                                              size: 18,
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
                                      Expanded(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        CustomColors.appColors,
                                                    textStyle: TextStyle(
                                                        fontSize: 13,
                                                        color: CustomColors
                                                            .appColorWhite)),
                                                onPressed: () {
                                                  if (data['store_id'] !=
                                                          null &&
                                                      data['store_id'] != '') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MarketDetail(
                                                                    id: data[
                                                                            'store_id']
                                                                        .toString(),
                                                                    title:
                                                                        'Dükanlar')));
                                                  }
                                                },
                                                child: Text(
                                                  data['store'].toString(),
                                                ),
                                              )))
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
                                            Icons
                                                .drive_file_rename_outline_outlined,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Ýerleşýän köçesi",
                                            style: CustomText.size_16_black54,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(data['street'].toString(),
                                            style: CustomText.size_16))
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 30,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.price_change_rounded,
                                          color: Colors.black26),
                                      SizedBox(width: 10),
                                      Text("Bahasy",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(data['price'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              SizedBox(height: 5),
                              SizedBox(
                                  child: Row(children: [
                                Expanded(
                                    child: Row(children: [
                                  SizedBox(width: 20),
                                  Icon(Icons.location_on,
                                      color: Colors.black26),
                                  SizedBox(width: 10),
                                  Text("Ýerleşýän ýeri",
                                      style: CustomText.size_16_black54)
                                ])),
                                if (data['location'] != null &&
                                    data['location'] != '')
                                  Expanded(
                                      child: Text(data['location'].toString(),
                                          style: CustomText.size_16))
                              ])),
                              SizedBox(height: 5),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 30,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.phone_callback,
                                        color: Colors.black26,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Telefon",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(data['phone'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 30,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.home_work_outlined,
                                          color: Colors.black26),
                                      SizedBox(width: 10),
                                      Text("Binadaky gat sany",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(data['floor'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 30,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.numbers_sharp,
                                          color: Colors.black26),
                                      SizedBox(width: 10),
                                      Text("Ýerleşýan gaty",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(data['at_floor'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 30,
                                  child: Row(children: [
                                    Expanded(
                                        child: Row(children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.home_work,
                                          color: Colors.black26),
                                      SizedBox(width: 10),
                                      Text("Otag any",
                                          style: CustomText.size_16_black54)
                                    ])),
                                    Expanded(
                                        child: Text(
                                            data['room_count'].toString(),
                                            style: CustomText.size_16))
                                  ])),
                              GestureDetector(
                                  onTap: () {
                                    if (data['customer'] != "" &&
                                        data['customer'] != null) {
                                      Provider.of<UserInfo>(context,
                                              listen: false)
                                          .set_user_customer_name(
                                              data['customer']['name']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyPages(
                                                  user_customer_id:
                                                      data['customer']['id']
                                                          .toString())));
                                    }
                                  },
                                  child: Container(
                                      height: 30,
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Row(children: <Widget>[
                                          const Icon(
                                            Icons.person_outline_outlined,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              alignment: Alignment.center,
                                              height: 100,
                                              child: const TextKeyWidget(
                                                  text: "Satyjy", size: 16.0))
                                        ])),
                                        Expanded(
                                            child: SizedBox(
                                                child: TextValueWidget(
                                                    text: data['customer_name']
                                                        .toString(),
                                                    size: 16.0)))
                                      ]))),
                              Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Row(children: <Widget>[
                                      SizedBox(width: 10),
                                      const Icon(Icons.change_circle_outlined,
                                          color: Colors.black26, size: 20),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          height: 100,
                                          child: const TextKeyWidget(
                                              text: "Eýesinden", size: 16.0))
                                    ])),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            child: data['own'] == null
                                                ? MyCheckBox(type: true)
                                                : MyCheckBox(
                                                    type: data['own'])))
                                  ])),
                              Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Row(children: <Widget>[
                                      SizedBox(width: 10),
                                      const Icon(Icons.change_circle_outlined,
                                          color: Colors.black26, size: 20),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          height: 100,
                                          child: const TextKeyWidget(
                                              text: "Çalşyk", size: 16.0))
                                    ])),
                                    Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(right: 5),
                                            alignment: Alignment.centerLeft,
                                            child: data['swap'] == null
                                                ? MyCheckBox(type: true)
                                                : MyCheckBox(
                                                    type: data['swap'])))
                                  ])),
                              Container(
                                height: 30,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.assignment,
                                            color: Colors.black26,
                                            size: 20,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            alignment: Alignment.center,
                                            height: 100,
                                            child: const TextKeyWidget(
                                                text: "Ipoteka", size: 16.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.topLeft,
                                      child: data['ipoteka'] == null
                                          ? MyCheckBox(type: true)
                                          : MyCheckBox(type: data['ipoteka']),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.monetization_on_sharp,
                                            color: Colors.black26,
                                            size: 20,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            alignment: Alignment.center,
                                            height: 100,
                                            child: const TextKeyWidget(
                                                text: "Kredit", size: 16.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.topLeft,
                                      child: data['credit'] == null
                                          ? MyCheckBox(type: true)
                                          : MyCheckBox(type: data['credit']),
                                    ))
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
                                            Icons.auto_awesome_mosaic,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Meýdany",
                                            style: CustomText.size_16_black54,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(data['square'].toString(),
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
                                            Icons.collections,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Remondy",
                                            style: CustomText.size_16_black54,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                            data['remont_state'].toString(),
                                            style: CustomText.size_16))
                                  ],
                                ),
                              ),
                              if (data['ad'] != null && data['ad'] != '')
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        " Reklama hyzmaty",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: CustomColors.appColors,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        color:
                                            Color.fromARGB(96, 214, 214, 214),
                                        child: Image.network(
                                            baseurl +
                                                data['ad']!['img'].toString(),
                                            fit: BoxFit.fitHeight,
                                            height: 160,
                                            width: double.infinity),
                                      ),
                                    ],
                                  ),
                                ),
                              if (data['detail'] != null &&
                                  data['detail'] != '')
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
                                          color: CustomColors.appColors),
                                      hintText: data['detail'].toString(),
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 70,
                              ),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                color: CustomColors.appColors))),
                floatingActionButton: Call(phone: data['phone'].toString())),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  void getsingleparts({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/flats/' + id;
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
      imgList = [];
      for (i in data['images']) {
        imgList.add(baseurl + i['img']);
      }
      if (imgList.length == 0) {
        slider_img = false;
        imgList.add(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_kT38o_6efgNspm1kIxkRiw6clWQ5s0D7m9qKCZKu53v8x9pIKjdxbJuhlOqlyhpBtYA&usqp=CAU');
      }
      determinate = true;
    });
  }
}
