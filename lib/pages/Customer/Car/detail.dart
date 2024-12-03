import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/Car/edit.dart';
import '../../../dB/textStyle.dart';
import '../../fullScreenSlider.dart';
import '../deleteAlert.dart';

class GetCarFirst extends StatefulWidget {
  GetCarFirst({
    Key? key,
    required this.id,
    required this.refreshFunc,
  }) : super(key: key);
  final int id;
  final Function refreshFunc;
  @override
  State<GetCarFirst> createState() => _GetCarFirstState(id: id);
}

class _GetCarFirstState extends State<GetCarFirst> {
  final int id;
  String name_title = '';
  final String number = '';
  var data = {};
  int _current = 0;
  List<String> imgList = [];

  bool determinate = false;
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
    widget.refreshFunc();
    if (imgList.length == 0) {
      imgList.add('x');
    }
    getCar();
    super.initState();
  }

  bool status = false;
  callbackStatus() {
    getCar();
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetCarFirstState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Awtoulag",
            style: CustomText.appBarText,
          ),
          actions: [
            PopupMenuButton(
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
                                    builder: (context) => EditCar(
                                        initData: this.data,
                                        callbackFunc: this.getCar)));
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
                                Text('Düzetmek')
                              ])))),
                  PopupMenuItem<String>(
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteAlert(
                                    action: 'cars',
                                    id: id.toString(),
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
        body: RefreshIndicator(
          onRefresh: () async {
            this.getCar();
          },
          child: Container(
              color: CustomColors.appColorWhite,
              child: ListView(children: [
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
                                    height: MediaQuery.of(context).size.width,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll:
                                        imgList.length > 1 ? true : false,
                                    reverse: false,
                                    autoPlay: imgList.length > 1 ? true : false,
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
                                items: imgList
                                    .map((item) => Container(
                                          color: Colors.white,
                                          child: Center(
                                            child: ClipRect(
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                width: double.infinity,
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: Image.network(
                                                    item.toString(),
                                                    errorBuilder: (a, b, c) {
                                                      return Image.asset(
                                                          defaulImageUrl);
                                                    },
                                                  ),
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
                                        builder: (context) => FullScreenSlider(
                                            imgList: imgList)));
                              })),
                      if (imgList.length > 0)
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
                                            BorderRadius.circular(15.0))))),
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
                        margin: EdgeInsets.symmetric(horizontal: 10),
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
                          this.mark + ' ' + this.model + ' ' + this.year,
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.appColor),
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
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
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
                            child: data['swap'] == true
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
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
                            child: data['credit'] == true
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
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
                              data['phone'].toString(),
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
                              data['vin'].toString(),
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
              ])),
        ));
  }

  void getCar() async {
    String url = carsUrl + '/' + this.id.toString();
    final uri = Uri.parse(url);

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
        millage = data['millage'].toString();
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
        storeId = data['store']['id'];
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

      var i;
      imgList = [];

      for (i in data['images']) {
        imgList.add(serverIp + i['img_m']);
      }

      if (data['mark'] != '' && data['mark'] != null) {
        name_title = name_title + data['mark'].toString();
      }
      if (data['model'] != '' && data['model'] != null) {
        name_title = name_title + " " + data['model'].toString();
      }

      if (data['year'] != '' && data['year'] != null) {
        name_title = name_title + " " + data['year'].toString();
      }
    });
  }
}

class EditAlert extends StatefulWidget {
  EditAlert({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;

  @override
  State<EditAlert> createState() =>
      _EditAlertState(title: this.title, value: this.value);
}

class _EditAlertState extends State<EditAlert> {
  bool isChecked = false;
  final String title;
  final String value;

  _EditAlertState({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: CustomColors.appColor),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
          )
        ],
      ),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black26)),
              child: TextField(
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  hintText: value,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: CustomColors.appColor, width: 2),
                      ),
                      child: Container(
                          width: 20,
                          height: 20,
                          child: isChecked
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green),
                                )
                              : Container()),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Text(
                      "Tassyklayaryn",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Ýatda sakla'),
          ),
        )
      ],
    );
  }
}
