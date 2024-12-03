import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';
import 'package:my_app/pages/advertiseDetail.dart';
import 'package:my_app/pages/call.dart';
import 'package:share_plus/share_plus.dart';
import '../fullScreenSlider.dart';

import '../progressIndicator.dart';

class CarDetail extends StatefulWidget {
  CarDetail({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<CarDetail> createState() => _CarDetailState(id: id);
}

class _CarDetailState extends State<CarDetail> {
  List<String> imgList = [];

  final String number = '';
  final int id;

  var data = {};
  int _current = 0;
  bool determinate = false;
  bool slider_img = true;
  bool status = true;
  String titleAppBar = "";

  String bodyType = '';
  String wheelDrive = '';
  String location = '';
  String storeId = '';
  String storeName = '';
  String storeLogoUrl = '';
  String mark = '';
  String model = '';
  String year = '';
  String fuel = '';
  String transmission = '';
  String description = '';
  String price = '';
  String millage = '';
  String phone = '';
  String motor = '';
  String color = '';
  String vin = '';
  bool obmen = false;
  bool credit = false;

  var images = [];

  void initState() {
    getsinglecar(id: id);
    super.initState();
  }

  _CarDetailState({required this.id});
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
                    },
                    child: determinate
                        ? Container(
                            color: CustomColors.appColorWhite,
                            child: ListView(children: <Widget>[
                              Stack(
                                  alignment: Alignment.bottomCenter,
                                  textDirection: TextDirection.rtl,
                                  fit: StackFit.loose,
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
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
                                                      const Duration(
                                                          seconds: 4),
                                                  autoPlayAnimationDuration:
                                                      const Duration(
                                                          milliseconds: 800),
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  enlargeCenterPage: true,
                                                  enlargeFactor: 0.3,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  onPageChanged:
                                                      (index, reason) {
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
                                                              width: double
                                                                  .infinity,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
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
                                                              imgList:
                                                                  imgList)));
                                            })),
                                    Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: DotsIndicator(
                                            dotsCount: imgList.length,
                                            position: _current.toDouble(),
                                            decorator: DotsDecorator(
                                                color: Colors.white,
                                                activeColor: CustomColors
                                                    .appColor,
                                                activeShape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
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
                                            iconColor:
                                                CustomColors.appColorWhite,
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
                                                            child:
                                                                Row(children: [
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
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_month,
                                          size: 20,
                                          color: CustomColors.appColor,
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
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.remove_red_eye,
                                            size: 20,
                                            color: CustomColors.appColor,
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
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        this.mark +
                                            ' ' +
                                            this.model +
                                            ' ' +
                                            this.year,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: CustomColors.appColor),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        this.price,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700]),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: CustomColors.appColor,
                                            size: 20,
                                          ),
                                          Text(
                                            this.location,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                color: CustomColors.appColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'Doly häsiýetnamasy',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: CustomColors.appColor),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Marka',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.mark,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Model',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.model,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Ýyly',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.year,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Geçen ýoly',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.millage + ' km',
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Bahasy',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.price,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Korobka',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.transmission,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Kuzow görnüşi',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.bodyType,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Ýörediji görnüşi',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.wheelDrive,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Ýangyjy',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.fuel,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Reňki',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.color,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Motory',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.motor,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Çalşyk',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: this.obmen == true
                                              ? Text(
                                                  'Bar',
                                                  style: TextStyle(),
                                                )
                                              : Text(
                                                  'Ýok',
                                                  style: TextStyle(),
                                                ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Kredit',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: this.credit == true
                                              ? Text(
                                                  'Hawa',
                                                  style: TextStyle(),
                                                )
                                              : Text(
                                                  'Ýok',
                                                  style: TextStyle(),
                                                ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Telefon belgisi',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.phone,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'VIN kody',
                                            style: TextStyle(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            this.vin.toString(),
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (this.description != '')
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    this.description,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        color: CustomColors.appColor),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StoreDetail(
                                                id: data['store']['id'],
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
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 2,
                                                color: Colors.grey),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                              if (data['ad'] != null && data['ad'] != '')
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdPage(
                                                  id: data['ad']['id']
                                                      .toString(),
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            "Reklama hyzmaty",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: CustomColors.appColor,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.network(
                                              serverIp +
                                                  data['ad']['img'].toString(),
                                              fit: BoxFit.cover,
                                              height: 180,
                                              width: double.infinity),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ]))
                        : Center(
                            child: CircularProgressIndicator(
                                color: CustomColors.appColor))),
                floatingActionButton: Call(phone: data['phone'].toString())),
          )
        : CustomProgressIndicator(funcInit: initState);
  }

  void getsinglecar({required id}) async {
    final uri = Uri.parse(carsUrl + '/' + id.toString());
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
      } catch (error) {}
      try {
        model = data['model']['name'];
      } catch (error) {}
      try {
        price = data['price'] + ' TMT';
      } catch (error) {}
      try {
        year = data['year'].toString();
      } catch (error) {}
      try {
        vin = data['vin'];
      } catch (error) {}

      try {
        year = data['year'].toString();
      } catch (error) {}
      try {
        description = data['description'];
      } catch (error) {}
      try {
        bodyType = data['body_type']['name'];
      } catch (error) {}
      try {
        wheelDrive = data['wd']['name'];
      } catch (error) {}

      try {
        transmission = data['transmission']['name'];
      } catch (error) {}
      try {
        fuel = data['fuel']['name'];
      } catch (error) {}
      try {
        color = data['color']['name'];
      } catch (error) {}
      try {
        motor = data['engine'].toString();
      } catch (error) {}
      try {
        location = data['location']['name'];
      } catch (error) {}

      try {
        storeId = data['store']['id'].toString();
      } catch (error) {}
      try {
        storeName = data['store']['name'];
      } catch (error) {}
      try {
        storeLogoUrl = data['store']['logo'];
      } catch (error) {}
      try {
        obmen = data['swap'];
      } catch (error) {}
      try {
        credit = data['credit'];
      } catch (error) {}

      var tempImages = [];
      try {
        tempImages = data['images'];
      } catch (error) {}

      var i;
      for (i in tempImages) {
        try {
          this.imgList.add(serverIp + i['img_m']);
        } catch (error) {}
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
