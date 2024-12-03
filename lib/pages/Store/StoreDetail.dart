import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/Images.dart';
import 'package:my_app/pages/Store/StoreCars.dart';
import 'package:my_app/pages/Store/StoreProducts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dB/textStyle.dart';
import 'package:http/http.dart' as http;

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<StoreDetail> createState() => StoreDetailState(id: id);
}

class StoreDetailState extends State<StoreDetail>
    with TickerProviderStateMixin {
  StoreDetailState({
    required this.id,
  });
  var id;
  var name = '';
  var location = '';
  var logo = '';
  var category = '';
  var description = '';
  var data = {};
  var phones = [];
  var links = [];
  var modules = {};

  var images = [];

  var carCount = 0;
  var lentaCount = 0;
  var productCount = 0;
  var flatCount = 0;
  var partCount = 0;
  var orderCount = 0;
  var delivery_price = 0;

  bool isLoading = true;

  @override
  initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    Uri uri = Uri.parse(storesUrl + '/' + id.toString());
    var response = await http.get(uri);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;
      try {
        this.name = data['name'];
      } catch (e) {}

      try {
        this.description = data['description'];
      } catch (err) {}
      try {
        this.category = data['category']['name'];
      } catch (err) {}
      try {
        this.location = data['location']['name'];
      } catch (err) {}
      try {
        this.phones = data['phones'];
      } catch (err) {}
      try {
        this.links = data['websites'];
      } catch (err) {}
      try {} catch (err) {}
      try {
        this.images = data['images'];
      } catch (err) {}
      try {
        this.modules = data['stats'];
        this.carCount = this.modules['cars'];
        this.lentaCount = this.modules['lenta'];
        this.productCount = this.modules['products'];
      } catch (err) {}
      try {
        this.logo = data['logo'];
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (this.isLoading)
              Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (this.isLoading == false)
              Center(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  margin: EdgeInsets.all(5),
                  height: MediaQuery.sizeOf(context).width * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(400.0),
                  ),
                  child: Image.network(
                    fit: BoxFit.cover,
                    serverIp + this.logo,
                    errorBuilder: (c, e, s) {
                      return Text('');
                    },
                  ),
                ),
              ),
            Text(
              this.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            if (this.category != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Icon(
                      Icons.window,
                      color: CustomColors.appColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    this.category,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            if (this.location != '')
              Container(
                width: MediaQuery.sizeOf(context).width - 20,
                child: Wrap(alignment: WrapAlignment.center, children: [
                  Icon(
                    Icons.location_pin,
                    color: CustomColors.appColor,
                    size: 20,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                    child: Text(
                      textAlign: TextAlign.center,
                      this.location,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ]),
              ),
            Column(
              children: this
                  .phones
                  .map((e) => Container(
                        child: GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse('tel:' + e['phone']));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(
                                    Icons.phone,
                                    size: 22,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  e['phone'],
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                if (this.carCount > 0)
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreCars(
                                    storeName: name,
                                    id: id.toString(),
                                  )))
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(children: [
                        Container(
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.time_to_leave,
                                  color: CustomColors.appColor,
                                  size: 30,
                                ))),
                        Text('Awtoulaglar ' + this.carCount.toString(),
                            style: TextStyle(
                                fontSize: 20, color: CustomColors.appColor)),
                        Icon(
                          Icons.chevron_right,
                          color: CustomColors.appColor,
                          size: 35,
                        )
                      ]),
                    ),
                  ),
                if (this.productCount > 0)
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreProducts(
                                    storeName: name,
                                    id: id,
                                    delivery_price: this.delivery_price,
                                  )))
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(children: [
                        Container(
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.card_giftcard_sharp,
                                  size: 30,
                                  color: CustomColors.appColor,
                                ))),
                        Text(
                          'Harytlar ' + this.productCount.toString(),
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.appColor),
                        ),
                      ]),
                    ),
                  ),
                if (this.images.length > 0)
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreImages(
                                    customer_id: id.toString(),
                                    callbackFunc: fetch,
                                  )))
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(children: [
                        Container(
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.image,
                                  size: 30,
                                  color: CustomColors.appColor,
                                ))),
                        Text(
                          'Suratlar ' + this.images.length.toString(),
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.appColor),
                        ),
                      ]),
                    ),
                  ),
                if (this.lentaCount > 0)
                  GestureDetector(
                    onTap: () => {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => StoreImages(
                      //               customer_id: id,
                      //               callbackFunc: fetch,
                      //             )))
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(children: [
                        Container(
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.newspaper,
                                  size: 30,
                                  color: CustomColors.appColor,
                                ))),
                        Text(
                          'Lenta ' + this.lentaCount.toString(),
                          style: TextStyle(
                              color: CustomColors.appColor, fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
              ]),
            ),
            if (this.description != '')
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(this.description),
              ),
          ],
        ),
      ),
    );
  }
}
