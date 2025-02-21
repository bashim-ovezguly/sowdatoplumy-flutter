import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/pages/Profile/Aksiya/Edit.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../dB/constants.dart';
import '../../../dB/textStyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LentaList extends StatefulWidget {
  final String customer_id;
  final String user_customer_id;
  final Function callbackFunc;
  const LentaList(
      {Key? key,
      required this.customer_id,
      required this.callbackFunc,
      required this.user_customer_id})
      : super(key: key);

  @override
  State<LentaList> createState() => _LentaListState();
}

class _LentaListState extends State<LentaList> {
  bool determinate = false;
  var datas = [];

  @override
  void initState() {
    super.initState();
    getData(customer_id: widget.customer_id);
  }

  refreshListFunc() {
    getData(customer_id: widget.customer_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
              "Aksiýalar",
              style: CustomText.appBarText,
            ),
            actions: []),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDatasPage(
                          index: 2,
                        )));
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 1)
            ]),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Icon(Icons.add, size: 35, color: Colors.white)),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (var i in datas)
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 3)
                        ]),
                    margin: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LentaEdit(
                                    id: i['id'].toString(),
                                    refreshListFunc: refreshListFunc)));
                      },
                      child: Column(children: [
                        ImageSlideshow(
                            disableUserScrolling:
                                i['images'].length > 1 ? false : true,
                            width: double.infinity,
                            initialPage: 0,
                            indicatorColor: CustomColors.appColor,
                            indicatorBackgroundColor: Colors.grey,
                            autoPlayInterval: null,
                            isLoop: false,
                            children: [
                              for (var item in i['images'])
                                if (item['img'] != null && item['img'] != '')
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LentaEdit(
                                                      id: i['id'].toString(),
                                                      refreshListFunc:
                                                          refreshListFunc,
                                                    )));
                                      },
                                      child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.network(
                                            serverIp + item['img'],
                                            fit: BoxFit.cover,
                                          )))
                            ]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.schedule,
                                  color: CustomColors.appColor),
                              SizedBox(width: 5),
                              Text(i['created_at'].toString(),
                                  style:
                                      TextStyle(color: CustomColors.appColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip),
                              SizedBox(width: 15),
                              Icon(Icons.remove_red_eye,
                                  color: CustomColors.appColor),
                              SizedBox(width: 5),
                              Text(i['view'].toString(),
                                  style:
                                      TextStyle(color: CustomColors.appColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip)
                            ],
                          ),
                        )
                      ]),
                    ),
                  )
              ],
            ),
          ),
        ));
  }

  void getData({required customer_id}) async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getInt('user_id').toString();

    String url = lentaUrl + '?store=$user_id';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    headers['token'] = await prefs.getString('access_token').toString();
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 403) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
    setState(() {
      datas = json['data'];
      determinate = true;
    });
  }
}
