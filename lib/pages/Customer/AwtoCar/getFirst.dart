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
      imgList.add(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsinglecar(id: id);
    super.initState();
  }

  bool status = false;
  callbackStatus() {
    setState(() {
      status = true;
    });
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetCarFirstState({required this.id});
  @override
  Widget build(BuildContext context) {
    var user_customer_name = Provider.of<UserInfo>(context, listen: false).user_customer_name;
    return Scaffold(
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
        body: status == false
            ? determinate
                ? ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(left: 20, right: 10),
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
                      Stack(
                        alignment: Alignment.bottomCenter,
                        textDirection: TextDirection.rtl,
                        fit: StackFit.loose,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: GestureDetector(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    height: 200,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: imgList.length>1 ? true: false,
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
                                              child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Image border
                                            child: Image.network(
                                              item,
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: double.infinity,
                                            ),
                                          )),
                                        ))
                                    .toList(),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullScreenSlider(
                                            imgList: imgList)));
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
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10, top: 10),
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
                                    child: const TextKeyWidget(
                                        text: "id", size: 16.0),
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
                                        text: "Söwda nokat", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            if (data['store'] != null && data['store'] != '')
                              Expanded(
                                  child: SizedBox(
                                      child: TextValueWidget(
                                          text:
                                              data['store']['name'].toString(),
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
                                  text: data['year'].toString() + ' ý',
                                  size: 16.0),
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
                                  text: data['millage'].toString() + ' mil',
                                  size: 16.0),
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
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['price'].toString(), size: 16.0),
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
                      if (data['customer'] != '' && data['customer'] != null)
                        Container(
                          height: 30,
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.center,
                                      height: 100,
                                      child: const TextKeyWidget(
                                          text: "Satyjy", size: 16.0),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: SizedBox(
                                    child: TextValueWidget(
                                        text:
                                            data['customer']['name'].toString(),
                                        size: 16.0)),
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
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.invert_colors_on_sharp,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Ýangyjyň görnüşi", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['fuel'].toString(), size: 16.0),
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
                                        text: "Görnüşi", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['body_type'].toString(),
                                  size: 16.0),
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
                  )
            : Container(
                child: AlertDialog(
                content: Container(
                  width: 200,
                  height: 100,
                  child: Text(
                      'Maglumat üýtgedildi operatoryň tassyklamagyna garaşyň'),
                ),
                actions: <Widget>[
                  Align(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        setState(() {
                          callbackStatus();
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetCarFirst(
                                      user_customer_id: widget.user_customer_id,
                                      id: id,
                                      refreshFunc: widget.refreshFunc,
                                    )));
                      },
                      child: const Text('Dowam et'),
                    ),
                  )
                ],
              )));
  }

  void getsinglecar({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/cars/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);

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
      if (data['mark'] != '' && data['mark'] != null) {
        name_title = name_title + data['mark'].toString();
      }
      if (data['model'] != '' && data['model'] != null) {
        name_title = name_title + " " + data['model'].toString();
      }

      if (data['year'] != '' && data['year'] != null) {
        name_title = name_title + " " + data['year'].toString();
      }

      print(data);
      determinate = true;
      if (imgList.length == 0) {
        imgList.add(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
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
