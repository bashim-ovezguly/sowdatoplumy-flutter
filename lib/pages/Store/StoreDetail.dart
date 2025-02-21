import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/FullScreenImage.dart';
import 'package:my_app/pages/Store/StoreImages.dart';
import 'package:my_app/pages/Store/StoreAksiya.dart';
import 'package:my_app/pages/Store/StoreCars.dart';
import 'package:my_app/pages/Store/StoreProducts.dart';
import 'package:share_plus/share_plus.dart';
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
  var created_at = '';
  var viewed = '';
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
        this.created_at = data['created_at'];
        this.viewed = data['viewed'].toString();
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

  menuButton(icon, text, count, NextPage) {
    if (count == 0) {
      return SizedBox(
        height: 0,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            boxShadow: [appShadow],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: MaterialButton(
          splashColor: Colors.white,
          hoverColor: CustomColors.appColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textColor: CustomColors.appColor,
          padding: EdgeInsets.all(10),
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NextPage))
          },
          child: Row(children: [
            Container(
                child: Container(
                    margin: EdgeInsets.only(right: 10), child: Icon(icon))),
            Text(
              text + ' ' + count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_right),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        name,
        style: CustomText.appBarText,
      )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FullScreenImage(img: serverIp + this.logo);
                    }));
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    margin: EdgeInsets.all(5),
                    height: MediaQuery.sizeOf(context).width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.red,
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
              ),
            Center(
              child: Text(
                this.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            if (this.category != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Icon(
                      Icons.window,
                      color: CustomColors.appColor,
                      size: 17,
                    ),
                  ),
                  Text(
                    this.category,
                    style: TextStyle(fontSize: 15),
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
                    size: 17,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                    child: Text(
                      textAlign: TextAlign.center,
                      this.location,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 15, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ]),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Text(
                    this.viewed,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Text(
                    this.created_at,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  MaterialButton(
                      elevation: 0,
                      minWidth: 0,
                      onPressed: () {
                        Share.share('http://business-complex.com.tm/stores/' +
                            widget.id.toString());
                      },
                      child: Icon(
                        Icons.share,
                        color: Colors.grey,
                        size: 20,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                menuButton(Icons.time_to_leave, 'Awtoulaglar', this.carCount,
                    StoreCars(id: id.toString(), storeName: this.name)),
                menuButton(
                    Icons.card_giftcard_sharp,
                    'Harytlar',
                    this.productCount,
                    StoreProducts(
                        id: id,
                        storeName: this.name,
                        delivery_price: delivery_price)),
                menuButton(
                    Icons.image_outlined,
                    'Suratlar',
                    this.images.length,
                    StoreImages(
                      customer_id: id.toString(),
                      callbackFunc: fetch,
                    )),
                menuButton(
                    Icons.bookmark_border_outlined,
                    'Aksiýalar',
                    this.lentaCount,
                    StoreAksiya(
                      storeId: id.toString(),
                    )),
              ]),
            ),
            if (this.description != '')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(this.description),
                ),
              ),
            if (this.phones.length > 0)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habarlaşmak üçin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: this
                          .phones
                          .map((e) => Container(
                                // margin: EdgeInsets.symmetric(vertical: 2),
                                // padding: EdgeInsets.all(8),
                                // decoration: BoxDecoration(
                                //     color: Colors.green,
                                //     borderRadius: BorderRadius.circular(10)),
                                child: GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse('tel:' + e['phone']));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Icon(
                                            Icons.phone,
                                            size: 22,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          e['phone'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            if (this.links.length > 0)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Linkler',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: this
                          .links
                          .map((item) => Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    String url = item['link'];
                                    if (!url.startsWith('http')) {
                                      url = 'https://' + url;
                                    }
                                    launchUrl(Uri.parse(url));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(
                                            Icons.link,
                                            size: 22,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Text(
                                          item['link'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
