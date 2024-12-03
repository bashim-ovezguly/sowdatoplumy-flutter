import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/main.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';

class LentaDetail extends StatefulWidget {
  final String id;
  LentaDetail({Key? key, required this.id}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text('Lenta',
                style: TextStyle(color: CustomColors.appColorWhite))),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColor,
          onRefresh: () async {
            setState(() {
              determinate = false;
              get_ribbon_by_id(id: widget.id);
            });
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: determinate
              ? ListView(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: 50,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 206, 204, 204),
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  serverIp + data['store']['logo'],
                                ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            data['store']['name'].toString(),
                                            style: TextStyle(
                                                color: CustomColors.appColor,
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child:
                                            Text(data['created_at'].toString(),
                                                style: TextStyle(
                                                  color: CustomColors.appColor,
                                                )))
                                  ]),
                              Spacer(),
                              SizedBox(width: 10)
                            ])),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        color: Colors.black12,
                        child: ImageSlideshow(
                            disableUserScrolling:
                                data['images'].length > 1 ? false : true,
                            width: double.infinity,
                            initialPage: 0,
                            indicatorColor: CustomColors.appColor,
                            indicatorBackgroundColor: Colors.grey,
                            onPageChanged: (value) {},
                            autoPlayInterval: null,
                            isLoop: false,
                            children: [
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
                          if (data['liked'])
                            GestureDetector(
                              onTap: () async {},
                              child: Icon(Icons.favorite, color: Colors.red),
                            )
                          else
                            GestureDetector(
                                onTap: () async {
                                  var allRows = await dbHelper.queryAllRows();
                                  var data = [];
                                  for (final row in allRows) {
                                    data.add(row);
                                  }
                                  Urls server_url = new Urls();
                                  String url = server_url.get_server_url() +
                                      "/mob/lenta/" +
                                      widget.id +
                                      '/like';
                                  final uri = Uri.parse(url);
                                  var device_id = Provider.of<UserInfo>(context,
                                          listen: false)
                                      .device_id;
                                  var request =
                                      http.MultipartRequest("POST", uri);
                                  request.headers.addAll({
                                    'Content-Type':
                                        'application/x-www-form-urlencoded',
                                    'device-id': device_id,
                                  });

                                  final response = await request.send();
                                  if (response.statusCode == 200) {
                                    get_ribbon_by_id(id: widget.id);
                                  }
                                },
                                child: Icon(Icons.favorite_border)),
                          Text(data['like_count'].toString(),
                              style: TextStyle(color: CustomColors.appColor)),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                                onTap: () {
                                  var url =
                                      'http://business-complex.com.tm/lenta/' +
                                          data['id'].toString();
                                  Share.share(url, subject: 'Söwda Toplumy');
                                },
                                child: Icon(
                                  Icons.share,
                                  color: CustomColors.appColor,
                                )),
                          ),
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
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
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
                      CircularProgressIndicator(color: CustomColors.appColor)),
        ));
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
      baseurl = server_url.get_server_url();
      determinate = true;
      imgList = [];
      for (var i in data['images']) {
        imgList.add(baseurl + i['img']);
      }
    });
  }
}
