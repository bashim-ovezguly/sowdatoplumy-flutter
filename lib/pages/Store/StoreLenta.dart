import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/pages/fullScreenImage.dart';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreLenta extends StatefulWidget {
  final String store_id;
  final Function callbackFunc;
  const StoreLenta({
    Key? key,
    required this.store_id,
    required this.callbackFunc,
  }) : super(key: key);

  @override
  State<StoreLenta> createState() => _StoreLentaState();
}

class _StoreLentaState extends State<StoreLenta> {
  bool isLoading = false;

  var images = [];

  @override
  void initState() {
    super.initState();
    getImages();
  }

  refreshListFunc() {
    getImages();
  }

  void getImages() async {
    Uri uri = Uri.parse(storesUrl + '/' + widget.store_id.toString());
    var response = await http.get(uri);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;
      this.images = data['images'];

      try {} catch (err) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
              "Suratlar " + this.images.length.toString(),
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
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDatasPage(
                                  index: 2,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Icon(Icons.add, size: 35, color: Colors.white)),
                  )),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Wrap(
              children: this.images.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FullScreenImage(img: serverIp + item['img_m']);
                    }));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200)),
                      width: MediaQuery.sizeOf(context).width / 3 - 5,
                      height: MediaQuery.sizeOf(context).width / 3 - 5,
                      margin: EdgeInsets.all(1),
                      child: Image.network(
                        serverIp + item['img_m'],
                        fit: BoxFit.cover,
                        errorBuilder: (e, o, c) {
                          return Image.asset(defaulImageUrl);
                        },
                      )),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
