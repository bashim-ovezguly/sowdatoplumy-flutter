// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/Customer/RealEstate/edit.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
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

  final number = '+99364334578';
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
    setState(() {
      status = true;
    });
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetRealEstateFirstState({required this.id});
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
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
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
                                  Text(' Üýtgetmek')
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
                                "Emläkler",
                                style: TextStyle(
                                  color: CustomColors.appColors,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )),
                      Stack(
                        children: [
                          Container(
                            height:220,
                            margin: const EdgeInsets.all(10),
                            child: ImageSlideshow(
                              indicatorColor: CustomColors.appColors,
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                    Icons.auto_graph_outlined,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Id",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['id'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['category'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['store'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    Icons.drive_file_rename_outline_outlined,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Ýerleşýän köçesi",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['street'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['price'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                  SizedBox(
                                    width: 10,
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
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['location'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    Icons.person,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Eýesinden",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topLeft,
                              child: data['own'] == null
                                  ? MyCheckBox(type: true)
                                  : MyCheckBox(type: data['own']),
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
                                    Icons.phone_callback,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            if (data['customer'] != '' &&
                                data['customer'] != null)
                              Expanded(
                                  child: Text(
                                      data['customer']['name'].toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: CustomColors.appColors)))
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
                                    Icons.home_work_outlined,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    Icons.numbers_sharp,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    Icons.home_work,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    Icons.change_circle_outlined,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.assignment,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Ipoteka",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
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
                                    Icons.credit_card,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.auto_awesome_mosaic,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Remondy",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['remont_state'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.broadcast_on_personal_sharp,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Ýazgydaky adam sany",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Text(data['people'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColors)))
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
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.document_scanner_outlined,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Resminama ýagdaýy",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topLeft,
                              child: data['documents_ready'] == null
                                  ? MyCheckBox(type: true)
                                  : MyCheckBox(type: data['documents_ready']),
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
                  shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
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
                                builder: (context) => GetRealEstateFirst(
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
