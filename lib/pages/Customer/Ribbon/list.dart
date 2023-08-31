import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/pages/Customer/Ribbon/add.dart';
import 'package:my_app/pages/Customer/Ribbon/ribbonDetail.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../../main.dart';
import '../login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyRibbonList extends StatefulWidget {
  final String customer_id;
  final String user_customer_id;
  final Function callbackFunc;
  const MyRibbonList(
      {Key? key,
      required this.customer_id,
      required this.callbackFunc,
      required this.user_customer_id})
      : super(key: key);

  @override
  State<MyRibbonList> createState() => _MyRibbonListState();
}

class _MyRibbonListState extends State<MyRibbonList> {
  bool determinate = false;
  var baseurl = '';
  var datas = [];

  @override
  void initState() {
    get_my_constructions(customer_id: widget.customer_id);
    super.initState();
  }

  refreshListFunc() {
    get_my_constructions(customer_id: widget.customer_id);
  }

  @override
  Widget build(BuildContext context) {
    var user_customer_name =
        Provider.of<UserInfo>(context, listen: false).user_customer_name;
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
                PopupMenuButton<String>(itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RibbonListAdd(
                                          refreshListFunc: refreshListFunc)));
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(Icons.add, color: Colors.green),
                                  Text(' Goşmak')
                                ]))))
                  ];
                  return menuEntries2;
                })
            ]),
        body: determinate
            ? Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Text(
                          "Söwda lentasy - : " + datas.length.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.appColors))),
                  Container(
                    height: MediaQuery.of(context).size.height - 120,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            for (var i in datas)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyRibbonDetail(
                                              id: i['id'].toString(),
                                              user_customer_id:
                                                  widget.user_customer_id,
                                              refreshListFunc:
                                                  refreshListFunc)));
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 10),
                                    height: 220,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Card(
                                      elevation: 2,
                                      child: Column(children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 2, right: 2, top: 2),
                                          height: 180,
                                          width: double.infinity,
                                          child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                    height: 180,
                                                    color: Colors.black12,
                                                    child: ImageSlideshow(
                                                        width: double.infinity,
                                                        initialPage: 0,
                                                        indicatorColor:
                                                            CustomColors
                                                                .appColors,
                                                        indicatorBackgroundColor:
                                                            Colors.grey,
                                                        onPageChanged:
                                                            (value) {},
                                                        autoPlayInterval: null,
                                                        isLoop: false,
                                                        children: [
                                                          if (i['images']
                                                                  .length ==
                                                              0)
                                                            ClipRect(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => MyRibbonDetail(
                                                                              id: i['id'].toString(),
                                                                              user_customer_id: widget.user_customer_id,
                                                                              refreshListFunc: refreshListFunc)));
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 200,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/images/default.jpg'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          for (var item
                                                              in i['images'])
                                                            if (item['img'] !=
                                                                    null &&
                                                                item['img'] !=
                                                                    '')
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => MyRibbonDetail(
                                                                                  id: i['id'].toString(),
                                                                                  refreshListFunc: refreshListFunc,
                                                                                  user_customer_id: widget.user_customer_id,
                                                                                )));
                                                                  },
                                                                  child: ClipRect(
                                                                      child: Container(
                                                                          height: 200,
                                                                          width: double.infinity,
                                                                          child: FittedBox(
                                                                              fit: BoxFit.cover,
                                                                              child: Image.network(
                                                                                baseurl + item['img'],
                                                                                fit: BoxFit.cover,
                                                                              )))))
                                                        ])),
                                              ]),
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.schedule,
                                                color: CustomColors.appColors),
                                            SizedBox(width: 5),
                                            Text(i['created_at'].toString(),
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors),
                                                maxLines: 1,
                                                overflow: TextOverflow.clip)
                                          ],
                                        )
                                      ]),
                                    )),
                              )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            : Center(
                child:
                    CircularProgressIndicator(color: CustomColors.appColors)));
  }

  void get_my_constructions({required customer_id}) async {
    var allRows = await dbHelper.queryAllRows();

    var data = [];
    for (final row in allRows) {
      data.add(row);
    }

    if (data.length == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    Urls server_url = new Urls();
    String url =
        server_url.get_server_url() + '/mob/lenta?customer=$customer_id';
    final uri = Uri.parse(url);

      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
      headers['token'] = data[0]['name'];
    final response = await http.get(uri, headers: headers);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      datas = json['data'];
      determinate = true;
      baseurl = server_url.get_server_url();
    });
  }
}
