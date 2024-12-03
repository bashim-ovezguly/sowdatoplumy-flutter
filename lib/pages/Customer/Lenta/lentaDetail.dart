import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/Lenta/edit.dart';
import 'package:my_app/pages/Customer/deleteAlert.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LentaDetail extends StatefulWidget {
  final String id;
  final String user_customer_id;
  final Function refreshListFunc;
  LentaDetail(
      {Key? key,
      required this.id,
      required this.refreshListFunc,
      required this.user_customer_id})
      : super(key: key);
  @override
  State<LentaDetail> createState() => _LentaDetailState();
}

class _LentaDetailState extends State<LentaDetail> {
  var data = {};
  var baseurl = '';
  bool determinate = false;
  List<String> imgList = [];

  @override
  void initState() {
    get_ribbon_by_id(id: widget.id);
    super.initState();
  }

  callbackStatusDelete() {
    widget.refreshListFunc();
    Navigator.pop(context);
  }

  refresh() {
    get_ribbon_by_id(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: Text("Lenta", style: CustomText.appBarText),
          actions: [
            PopupMenuButton<String>(
                shadowColor: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                color: CustomColors.appColorWhite,
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LentaEdit(
                                          id: widget.id,
                                          refreshListFunc: refresh)));
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
                                      action: 'lenta',
                                      id: widget.id,
                                      callbackFunc: callbackStatusDelete,
                                    );
                                  });
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  Text('Pozmak')
                                ]))))
                  ];
                  return menuEntries2;
                })
          ],
        ),
        body: determinate
            ? ListView(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 206, 204, 204),
                              radius: 20,
                              backgroundImage: NetworkImage(
                                baseurl + data['customer_photo'],
                              ),
                            ),
                            SizedBox(width: 5),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(data['customer'].toString(),
                                          style: TextStyle(
                                              color: CustomColors.appColor,
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text(data['created_at'].toString(),
                                          style: TextStyle(
                                              color: CustomColors.appColor,
                                              fontWeight: FontWeight.bold)))
                                ]),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  var url =
                                      'http://business-complex.com.tm/lenta/' +
                                          data['id'].toString();
                                  Share.share(url, subject: 'Business Complex');
                                },
                                child: Icon(Icons.share)),
                            SizedBox(width: 10)
                          ])),
                  Container(
                      margin: const EdgeInsets.all(10),
                      height: 220,
                      color: Colors.black12,
                      child: ImageSlideshow(
                          width: double.infinity,
                          initialPage: 0,
                          indicatorColor: CustomColors.appColor,
                          indicatorBackgroundColor: Colors.grey,
                          onPageChanged: (value) {},
                          autoPlayInterval: null,
                          isLoop: false,
                          children: [
                            if (data['images'].length == 0)
                              ClipRect(
                                child: Container(
                                  height: 220,
                                  width: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.asset(
                                        'assets/images/default.jpg'),
                                  ),
                                ),
                              ),
                            for (var item in data['images'])
                              if (item['img'] != null && item['img'] != '')
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenSlider(
                                                      imgList: imgList)));
                                    },
                                    child: ClipRect(
                                      child: Container(
                                        height: 220,
                                        width: double.infinity,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.network(
                                            baseurl + item['img'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ))
                          ])),
                  SizedBox(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {},
                          child: Icon(Icons.favorite, color: Colors.red),
                        ),
                        Text(data['like_count'].toString(),
                            style: TextStyle(color: CustomColors.appColor)),
                        Spacer(),
                        Icon(Icons.visibility_sharp,
                            size: 20, color: CustomColors.appColor),
                        SizedBox(width: 5),
                        Text(data['view'].toString(),
                            style: TextStyle(color: CustomColors.appColor)),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Text(
                      data['text'].toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: CustomColors.appColor),
                      maxLines: 100,
                    ),
                  )
                ],
              )
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColor)));
  }

  void get_ribbon_by_id({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/lenta/' + id;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['msg'];
      determinate = true;
      baseurl = server_url.get_server_url();
      imgList = [];
      for (var i in data['images']) {
        imgList.add(baseurl + i['img']);
      }
    });
  }
}
