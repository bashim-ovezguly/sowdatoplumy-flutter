import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:my_app/pages/ribbon/ribbonDetail.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

class RibbonList extends StatefulWidget {
  const RibbonList({super.key});
  @override
  State<RibbonList> createState() => _RibbonListState();
}

class _RibbonListState extends State<RibbonList> {
  
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  String baseurl = "";
  final int _numberOfPostPerRequest = 100;
  final int _nextPageTriger = 3;
  List<dynamic> data = [];

  @override
  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    get_ribbonlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Söwda lentasy')),
      body: ListView.builder(
        itemCount: data.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == data.length - _nextPageTriger) {
            get_ribbonlist();
          }
          if (index == data.length) {
            if (_error) {
              return Center(child: errorDialog(size: 15));
            } else {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          return Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            color: CustomColors.appColorWhite,
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Row(children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<UserInfo>(context, listen: false)
                              .set_user_customer_name(data[index]['customer']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPages(
                                      user_customer_id: data[index]
                                              ['customer_id']
                                          .toString())));
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 206, 204, 204),
                          radius: 20,
                          backgroundImage: NetworkImage(baseurl+ data[index]['customer_photo'],
                          ),
                        )
                        
                        
                        
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Provider.of<UserInfo>(context, listen: false)
                              .set_user_customer_name(data[index]['customer']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPages(
                                      user_customer_id: data[index]
                                              ['customer_id']
                                          .toString())));
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                      data[index]['customer'].toString(),
                                      style: TextStyle(
                                          color: CustomColors.appColors,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text(
                                      data[index]['created_at'].toString(),
                                      style: TextStyle(
                                          color: CustomColors.appColors,
                                          fontWeight: FontWeight.bold)))
                            ]),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            var url = 'http://business-complex.com.tm/lenta/' +
                                data[index]['id'].toString();
                            Share.share(url, subject: 'Söwda Toplumy');
                          },
                          child: Image.asset('assets/images/send_link.png',
                              width: 30,
                              height: 30,
                              color: CustomColors.appColors)),
                      SizedBox(width: 10)
                    ])),
                SizedBox(height: 5),
                Expanded(
                    flex: 7,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RibbonDetail(
                                      id: data[index]['id'].toString())));
                        },
                        child: Container(
                            height: 180,
                            color: Colors.black12,
                            child: ImageSlideshow(
                                width: double.infinity,
                                initialPage: 0,
                                indicatorColor: CustomColors.appColors,
                                indicatorBackgroundColor: Colors.grey,
                                autoPlayInterval: null,
                                isLoop: false,
                                children: [
                                  if (data[index]['images'].length == 0)
                                    ClipRect(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RibbonDetail(
                                                          id: data[index]['id']
                                                              .toString())));
                                        },
                                        child: Container(
                                          height: 200,
                                          width: double.infinity,
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Image.asset(
                                                'assets/images/default.jpg'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  for (var item in data[index]['images'])
                                    if (item['img'] != null &&
                                        item['img'] != '')
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RibbonDetail(
                                                            id: data[index]
                                                                    ['id']
                                                                .toString())));
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
                                ])))),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                if (data[index]['like'])
                                  Row(
                                    children: [
                                      Icon(Icons.favorite, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text(data[index]['like_count'].toString(),
                                          style: TextStyle(
                                              color: CustomColors.appColors)),
                                    ],
                                  )
                                else
                                  GestureDetector(
                                      onTap: () async {
                                        var allRows =
                                            await dbHelper.queryAllRows();
                                        var datar = [];
                                        for (final row in allRows) {
                                          datar.add(row);
                                        }
                                        Urls server_url = new Urls();
                                        String url =
                                            server_url.get_server_url() +
                                                "/mob/lenta/" +
                                                data[index]['id'].toString() +
                                                '/like';

                                        final uri = Uri.parse(url);
                                            var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
                                        var request =
                                            http.MultipartRequest("POST", uri);

                                        request.headers.addAll({
                                          'Content-Type':'application/x-www-form-urlencoded',
                                          'device_id': device_id,
                                          'token': datar[0]['name']
                                        });

                                        final response = await request.send();
                                        if (response.statusCode == 200) {
                                          setState(() {
                                            data[index]['like'] = true;
                                            data[index]['like_count'] =
                                                data[index]['like_count'] + 1;
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.favorite_border,
                                              color: CustomColors.appColors),
                                          SizedBox(width: 5),
                                          Text(
                                              data[index]['like_count']
                                                  .toString(),
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.appColors)),
                                        ],
                                      )),
                                Spacer(),
                                Icon(Icons.visibility_sharp,
                                    size: 20, color: CustomColors.appColors),
                                SizedBox(width: 5),
                                Text(data[index]['view'].toString(),
                                    style: TextStyle(
                                        color: CustomColors.appColors)),
                                SizedBox(width: 10),
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Text(
                                data[index]['text'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: CustomColors.appColors),
                                maxLines: 3,
                              ),
                            ))
                      ],
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  void get_ribbonlist() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/lenta';
    var responsess =
        Provider.of<UserInfo>(context, listen: false).update_tokenc();
    if (await responsess) {
      var allRows = await dbHelper.queryAllRows();
      var datas = [];

      for (final row in allRows) {
        datas.add(row);
      }
      if (datas.length == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
      url = url + "?page=$_pageNumber&page_size=$_numberOfPostPerRequest";
      final uri = Uri.parse(url);
        Map<String, String> headers = {};  
          for (var i in global_headers.entries){
            headers[i.key] = i.value.toString(); 
          }
        headers['token'] = datas[0]['name'];
      final response = await http.get(uri, headers: headers);
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      var postList = [];
      for (var i in json['data']) {
        postList.add(i);
      }

      setState(() {
        baseurl = server_url.get_server_url();
        _isLastPage = data.length < _numberOfPostPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        data.addAll(postList);
      });
    }
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  get_ribbonlist();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }
}
