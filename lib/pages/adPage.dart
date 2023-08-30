import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Awtoparts/awtoPartsDetail.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dB/providers.dart';
import '../dB/textStyle.dart';
import 'Customer/myPages.dart';
import 'fullScreenImage.dart';

class AdPage extends StatefulWidget {
  AdPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<AdPage> createState() => _AdPageState(id: id);
}

class _AdPageState extends State<AdPage> {
  final String id;
  List<String> imgList = [];
  var data = {};
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  @override
  initState() {
    timers();
    getsinglecar(id: id);
    super.initState();
  }

  timers() async {
    setState(() {
      status = true;
    });
    final completer = Completer();
    final t = Timer(Duration(seconds: 5), () => completer.complete());
    await completer.future;
    setState(() {
      if (determinate == false) {
        status = false;
      }
    });
  }

  _AdPageState({required this.id});
  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            appBar: AppBar(
                title: data['title_tm'] != null && data['title_tm'] != ''
                    ? Text(data['title_tm'].toString(),
                        style: CustomText.appBarText)
                    : Text('')),
            body: determinate
                ? ListView(children: [
                    if (imgList.length > 0)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImage(img: imgList[0])));
                        },
                        child: Container(
                          color: Color.fromARGB(221, 182, 181, 181),
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            imgList[0],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for (var i = 1; i < imgList.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImage(img: imgList[i])));
                              },
                              child: Container(
                                  color: Color.fromARGB(255, 201, 201, 201),
                                  margin: i % 2 == 1
                                      ? EdgeInsets.only(
                                          left: 10, right: 5, top: 10)
                                      : EdgeInsets.only(
                                          left: 5, right: 10, top: 10),
                                  height: 180,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  child: Image.network(imgList[i],
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: CustomColors.appColors,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ));
                                  })),
                            )
                        ]),

                    if (data['title_tm'] != '' && data['title_tm'] != null)
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(data['title_tm'].toString(),
                            style: TextStyle(
                                color: CustomColors.appColors, fontSize: 20)),
                      ),

                    if (data['location'] != '' && data['location'] != null)
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Row(children: [
                            Icon(Icons.location_on,
                                color: CustomColors.appColors, size: 25),
                            SizedBox(width: 5),
                            Text(data['location'].toString(),
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontSize: 14))
                          ])),

                    if (data['body_tm'] != null && data['body_tm'] != '')
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
                                  hintText: data['body_tm'].toString(),
                                  fillColor: Colors.white))),

                    if (data['customer'] != '' &&
                        data['customer'] != null &&
                        data['customer_id'] != '' &&
                        data['customer_id'] != null)
                      GestureDetector(
                          onTap: () {
                            Provider.of<UserInfo>(context, listen: false)
                                .set_user_customer_name(data['customer']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPages(
                                        user_customer_id:
                                            data['customer_id'].toString())));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                              child: Row(children: [
                            Icon(Icons.person,
                                color: CustomColors.appColors, size: 25),
                            SizedBox(width: 5),
                            Text(data['customer'].toString(),
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontSize: 14))
                          ]))),

                    if (data['store'] != '' &&
                        data['store'] != null &&
                        data['store_id'] != '' &&
                        data['store_id'] != null)

                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MarketDetail(
                                        id: data['store_id'].toString(),
                                        title: 'Söwda nokatlar')));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                              child: Row(children: [
                            Icon(Icons.store,
                                color: CustomColors.appColors, size: 25),
                            SizedBox(width: 5),
                            Text(data['store'].toString(),
                                style: TextStyle(
                                    color: CustomColors.appColors,
                                    fontSize: 14))
                          ]))),

                    Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          for (var i = 0; i < data['contacts'].length; i++)
                            GestureDetector(
                              onTap: () async {
                                if(data['contacts'][i]['type']=='phone'){

                                  final call = Uri.parse('tel:'+ data['contacts'][i]['value']);
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);}
                                  else {
                                    throw 'Could not launch $call';
                                    }
                                }
                              },
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 10, top: 10),
                                      height: 25,
                                      child: Image.network(
                                        data['contacts'][i]['icon'],
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(width: 5),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Text(data['contacts'][i]['value'].toString(),
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontSize: 14)),
                                  )
                                ],
                              ),
                            )
                        ]),
                    Container(
                      height: 10,
                    )
                  ])
                : Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.appColors)))
        : CustomProgressIndicator(funcInit: initState);
  }

  void getsinglecar({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/ads/' + id;
    final uri = Uri.parse(url);
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      baseurl = server_url.get_server_url();
      var i;
      imgList = [];
      for (i in data['images']) {
        imgList.add(baseurl + i['img']);
      }
      determinate = true;
    });
  }
}
