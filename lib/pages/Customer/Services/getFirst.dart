import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/Services/edit.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import '../deleteAlert.dart';

class ServiceDetail extends StatefulWidget {
  ServiceDetail(
      {Key? key,
      required this.id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final String id;
  final String user_customer_id;
  final Function refreshFunc;
  @override
  State<ServiceDetail> createState() => _ServiceDetailState(id: id);
}

class _ServiceDetailState extends State<ServiceDetail> {
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
      imgList.add(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsingleproduct(id: id);
    super.initState();
  }

  callbackStatusDelete() { widget.refreshFunc(); Navigator.pop(context); Navigator.pop(context); }

  bool status = false;
  callbackStatus() {
    setState(() { status = true;
    });
  }

  _ServiceDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hyzmatlar",
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
                                      builder: (context) => ServiceEdit(
                                            old_data: data,
                                            callbackFunc: callbackStatus,
                                            title: 'Hyzmat',
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
                                      action: 'services',
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
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, right: 10),
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
                                    height: 200,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
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
                                              child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Image border
                                            child: Image.network(
                                              item,
                                              fit: BoxFit.fill,
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
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                            Expanded(
                                child: Text(data['store'].toString(),
                                    style: CustomText.size_16))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                                    Icons.drive_file_rename_outline_outlined,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Ady",
                                    style: CustomText.size_16_black54,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['name_tm'].toString(),
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
                      if (data['location'] != null && data['location'] != '')
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
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
                                  child: Text(
                                      data['location'].toString(),
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
                                    Icons.drive_file_rename_outline,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Eýesiniň ady",
                                    style: CustomText.size_16_black54,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['customer'].toString(),
                                    style: CustomText.size_16))
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
                            hintText: data['description'].toString(),
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
                                builder: (context) => ServiceDetail(
                                    id: id,
                                    refreshFunc: widget.refreshFunc,
                                    user_customer_id:
                                        widget.user_customer_id)));
                      },
                      child: const Text('Dowam et'),
                    ),
                  )
                ],
              )));
  }

  void getsingleproduct({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/services/' + id;
    final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
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
        imgList.add(baseurl + i['img_m']);
      }
      determinate = true;
      if (imgList.length == 0) {
        imgList.add(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
      }
    });
  }
}
