import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/StoreDetail.dart';

import '../../dB/textStyle.dart';
import 'package:http/http.dart' as http;

class TradeCenterDetail extends StatefulWidget {
  const TradeCenterDetail({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<TradeCenterDetail> createState() => TradeCenterDetailState(id: id);
}

class TradeCenterDetailState extends State<TradeCenterDetail>
    with TickerProviderStateMixin {
  TradeCenterDetailState({
    required this.id,
  });
  var id;
  var name = '';
  var location = '';
  var img = '';
  var storeCount = 0;
  var stores = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    Uri uri = Uri.parse(tradeCenters + '/' + id.toString());
    var response = await http.get(uri);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;
      try {
        this.name = data['name_tm'];
      } catch (e) {}

      try {
        this.location = data['location'];
      } catch (err) {}
      try {
        this.img = data['img_m'];
      } catch (err) {}
      try {
        this.stores = data['stores'];
      } catch (err) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
          title: Text(
        name,
        style: CustomText.appBarText,
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (this.isLoading)
                Center(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (this.isLoading == false)
                Center(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).width / 1.7777777,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      fit: BoxFit.cover,
                      serverIp + this.img,
                      errorBuilder: (c, e, s) {
                        return Text('');
                      },
                    ),
                  ),
                ),
              Text(
                this.name,
                style: TextStyle(
                    fontSize: 20,
                    color: CustomColors.appColor,
                    fontWeight: FontWeight.bold),
              ),
              if (this.location != '')
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.left,
                            this.location,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ]),
                ),
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (var item in stores)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoreDetail(
                                      id: item['id'],
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 3 - 20,
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.network(
                                  serverIp + item['logo'],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item['name'].toString(),
                                style: TextStyle(
                                  color: CustomColors.appColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
