import 'package:flutter/material.dart';
import 'package:my_app/pages/FullScreenSlider.dart';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreImages extends StatefulWidget {
  final String customer_id;
  final Function callbackFunc;
  const StoreImages({
    Key? key,
    required this.customer_id,
    required this.callbackFunc,
  }) : super(key: key);

  @override
  State<StoreImages> createState() => _StoreImagesState();
}

class _StoreImagesState extends State<StoreImages> {
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
    Uri uri = Uri.parse(storesUrl + '/' + widget.customer_id.toString());
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
        body: SingleChildScrollView(
          child: Center(
            child: Wrap(
              children: this.images.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FullScreenSlider(
                        current: images.indexOf(item),
                        imgList: this
                            .images
                            .map((e) => serverIp + e['img_m'].toString())
                            .toList(),
                      );
                    }));
                  },
                  child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
