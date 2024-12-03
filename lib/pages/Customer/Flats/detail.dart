// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Car/carDetail.dart';
import 'package:my_app/pages/Customer/Flats/Edit.dart';
import 'package:my_app/pages/Customer/StoreEdit.dart';
import 'package:provider/provider.dart';

import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../fullScreenSlider.dart';
import '../deleteAlert.dart';

class GetRealEstateFirst extends StatefulWidget {
  GetRealEstateFirst(
      {Key? key,
      required this.id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final Function refreshFunc;

  final String id;
  final String user_customer_id;

  @override
  State<GetRealEstateFirst> createState() => _GetRealEstateFirstState(id: id);
}

class _GetRealEstateFirstState extends State<GetRealEstateFirst> {
  final String id;

  final phone = '';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;

  List<String> imgList = [];

  void initState() {
    widget.refreshFunc();
    if (imgList.length == 0) {
      imgList.add('x');
    }
    getsingleparts(id: id);
    super.initState();
  }

  bool status = false;
  callbackStatus() {
    getsingleparts(id: id);
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetRealEstateFirstState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text(
            "Gozgalmaýan emläk",
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
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RealEstateEdit(
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
                                  Text('Düzetmek')
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteAlert(
                                      action: 'flats',
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
                                  Text('Bozmak')
                                ])))),
                  ];
                  return menuEntries2;
                },
              ),
          ],
        ),
        body: determinate
            ? ListView(children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: 220,
                      // margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                        child: ImageSlideshow(
                          disableUserScrolling:
                              imgList.length > 1 ? false : true,
                          indicatorColor: CustomColors.appColor,
                          indicatorBackgroundColor: Colors.grey,
                          onPageChanged: (value) {},
                          autoPlayInterval: 6666,
                          isLoop: true,
                          children: [
                            for (var item in imgList)
                              if (item != '' && item != 'x')
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenSlider(
                                                      imgList: imgList)));
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(item),
                                                fit: BoxFit.cover))))
                              else
                                Container(
                                    width: double.infinity,
                                    child: Image.asset(
                                        fit: BoxFit.cover,
                                        'assets/images/default16x9.jpg')),
                          ],
                        ),
                      ),
                    ),
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
                SizedBox(
                  height: 10,
                ),
                if (data['status'] == 'canceled' && data['error_reason'] != '')
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Text(data['error_reason'].toString(),
                          maxLines: 10, style: TextStyle(color: Colors.red))),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Ady",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['name'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Kategoriýa",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['category']['name'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Bahasy",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['price'].toString() + ' TMT',
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Ýerleşýän ýeri",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['location']['name'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Telefon",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['phone'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Binadaky gat sany",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['floor'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Ýerleşýan gaty",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['at_floor'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Otag any",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['room_count'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Çalşyk",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
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
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Kredit",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
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
                            Text(
                              "Meýdany",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['square'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
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
                            Text(
                              "Remont ýagdaýy",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(data['remont_state'].toString(),
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor)))
                    ],
                  ),
                ),
                if (data['description'] != null && data['description'] != '')
                  SizedBox(
                      width: double.infinity,
                      child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              hintMaxLines: 10,
                              hintStyle: TextStyle(
                                  fontSize: 14, color: CustomColors.appColor),
                              hintText: data['description'].toString(),
                              fillColor: Colors.white)))
              ])
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColor)));
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
        imgList.add('x');
      }
      determinate = true;
    });
  }
}
