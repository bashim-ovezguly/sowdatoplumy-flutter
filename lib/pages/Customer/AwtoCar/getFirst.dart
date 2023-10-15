import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/AwtoCar/edit.dart';
import 'package:provider/provider.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../Car/carStore.dart';
import '../../fullScreenSlider.dart';
import '../deleteAlert.dart';
import '../../../dB/colors.dart';

class GetCarFirst extends StatefulWidget {
  GetCarFirst(
      {Key? key,
      required this.id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final String id;
  final Function refreshFunc;
  final String user_customer_id;
  @override
  State<GetCarFirst> createState() => _GetCarFirstState(id: id);
}

class _GetCarFirstState extends State<GetCarFirst> {
  final String id;
  String name_title = '';
  final String number = '+99364334578';
  var baseurl = "";
  var data = {};
  int _current = 0;
  List<String> imgList = [];
  bool determinate = false;

  void initState() {
    widget.refreshFunc();
    if (imgList.length == 0) {
      imgList.add('x');
    }
    getsinglecar(id: id);
    super.initState();
  }

  bool status = false;
  callbackStatus() {
    getsinglecar(id: id);
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetCarFirstState({required this.id});
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
                                      builder: (context) => EditCar(
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
                                  Text(' Üýtgetmek')
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteAlert(
                                      action: 'cars',
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
                        padding: const EdgeInsets.all(10),
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
                        margin: EdgeInsets.only(bottom: 5),
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
                  SizedBox(
                    height: 10,
                  ),
                  if (data['status'] == 'canceled' &&
                      data['error_reason'] != '')
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(data['error_reason'].toString(),
                            maxLines: 10, style: TextStyle(color: Colors.red))),
                  Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            name_title,
                            style: TextStyle(
                              color: CustomColors.appColors,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.auto_graph_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child:
                                    const TextKeyWidget(text: "id", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(text: this.id, size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                      height: 30,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.store,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Dükan", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        if (data['store'] != null && data['store'] != '')
                          Expanded(
                              child: SizedBox(
                                  child: TextValueWidget(
                                      text: data['store']['name'].toString(),
                                      size: 16.0)))
                      ])),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.car_crash_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Marka", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['mark'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.model_training_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Modeli", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['model'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Ýerleşýän ýeri", size: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                                child: TextValueWidget(
                                    text: data['location'].toString(),
                                    size: 16.0)))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Ýyly", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['year'].toString() + ' ý', size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Geçen ýoly", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['millage'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Bahasy", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextValueWidget(
                              text: data['price'].toString(), size: 16.0),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.color_lens_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Reňki", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['color'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.format_color_fill_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Reňki üýtgedilen", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: data['recolored'] != null &&
                                  data['recolored'] == true
                              ? TextValueWidget(text: "howwa", size: 17.0)
                              : TextValueWidget(text: "ýok", size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.energy_savings_leaf,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Matory", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['engine'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.monetization_on_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
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
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.library_add_check_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Çalyşyk", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.topLeft,
                          child: data['swap'] == null
                              ? MyCheckBox(type: true)
                              : MyCheckBox(type: data['swap']),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.credit_card,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Nagt däl töleg", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.topLeft,
                          child: data['none_cash_pay'] == null
                              ? MyCheckBox(type: true)
                              : MyCheckBox(type: data['none_cash_pay']),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.phone_callback,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Telefon", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['phone'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.qr_code,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Vin kody", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['vin'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.car_crash_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Karobka görnüşi", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['transmission'].toString(),
                              size: 16.0),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.car_crash_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 100,
                                child: const TextKeyWidget(
                                    text: "Kuzow görnüşi", size: 16.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          child: TextValueWidget(
                              text: data['body_type'].toString(), size: 16.0),
                        ))
                      ],
                    ),
                  ),
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
                        hintText: data['detail'].toString(),
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

  void getsinglecar({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/cars/' + id;
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
      // ignore: unused_local_variable
      var i;
      imgList = [];
      for (i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }
      name_title = '';

      if (data['mark'] != '' && data['mark'] != null) {
        name_title = name_title + data['mark'].toString();
      }
      if (data['model'] != '' && data['model'] != null) {
        name_title = name_title + " " + data['model'].toString();
      }

      if (data['year'] != '' && data['year'] != null) {
        name_title = name_title + " " + data['year'].toString();
      }

      determinate = true;
      if (imgList.length == 0) {
        imgList.add('x');
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
            style: TextStyle(color: CustomColors.appColors),
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
                            Border.all(color: CustomColors.appColors, width: 2),
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
