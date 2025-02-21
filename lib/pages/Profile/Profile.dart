import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Profile/Car/list.dart';
import 'package:my_app/pages/Profile/Products/list.dart';
import 'package:my_app/pages/Profile/Aksiya/List.dart';
import 'package:my_app/pages/Profile/ProfilEdit.dart';
import 'package:my_app/pages/Profile/ProfileImages.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:my_app/pages/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dB/textStyle.dart';
import 'Orders/Orders.dart';

class Profile extends StatefulWidget {
  final String user_customer_id;
  Profile({Key? key, this.user_customer_id = ''}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user_id = '';

  String carCount = '';
  String partCount = '';
  String flatCount = '';
  String productCount = '';
  String orderCount = '';
  String lentaCount = '';

  String name = '';
  String imgUrl = '';
  String phone = '';
  String email = '';

  String? location_name = '';
  int? location_id;

  String? tc_name = '';
  int? tc_id;

  String? category_name = '';
  int? category_id;

  late Function callbackFunc;

  double fontSize = 16;
  double iconSize = 30;

  var images = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final pref = SharedPreferences.getInstance();
    pref.then((value) {
      user_id = value.getInt('user_id').toString();
    });
    getData();
  }

  logout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
              "Profil",
              style: CustomText.appBarText,
            ),
            actions: [
              MaterialButton(
                  minWidth: 10,
                  elevation: 0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfil(
                                  callback: getData,
                                  customer_id: this.user_id,
                                  locationName: location_name,
                                  locationId: location_id.toString(),
                                  category_id: category_id.toString(),
                                  category_name: category_name,
                                  email: this.email,
                                  name: this.name,
                                  phone: this.phone.toString(),
                                  img: serverIp + this.imgUrl.toString(),
                                  tcId: this.tc_id.toString(),
                                  tcName: this.tc_name.toString(),
                                )));
                  },
                  child: Container(
                    child: Icon(
                      Icons.settings_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                  ))
            ]),
        body: RefreshIndicator(
          onRefresh: () async {
            this.getData();
          },
          child: ListView(children: [
            if (this.isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProgresBar(),
              ),
            if (this.isLoading == false)
              Container(
                  height: 170,
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: imgUrl != ''
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    serverIp + this.imgUrl,
                                  ))
                              : Image.asset(defaulImageUrl),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              SizedBox(height: 40),
                              if (this.name != '')
                                Text(this.name.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: CustomColors.appColor)),
                              SizedBox(height: 5),
                              Text(
                                '+993' + this.phone.toString(),
                                style: TextStyle(
                                    fontSize: 16, color: CustomColors.appColor),
                              ),
                              SizedBox(height: 5),
                              if (this.email != '')
                                Text(this.email.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.appColor)),
                            ])))
                  ])),
            if (this.isLoading == false)
              Container(
                  padding: EdgeInsets.all(10),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withOpacity(0.1)),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCars(
                                      customer_id: user_id,
                                    )));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200))),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(children: [
                            Icon(
                              Icons.time_to_leave_outlined,
                              size: iconSize,
                              color: CustomColors.appColor,
                            ),
                            SizedBox(width: 10),
                            Text("Awtoulaglar",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: fontSize)),
                            Spacer(),
                            Text(this.carCount,
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 18)),
                            Icon(Icons.navigate_next,
                                color: CustomColors.appColor)
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileProducts(
                                    customer_id: this.user_id,
                                    callbackFunc: getData,
                                    user_customer_id:
                                        widget.user_customer_id)));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200))),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(children: [
                            Icon(
                              Icons.card_giftcard_sharp,
                              size: iconSize,
                              color: CustomColors.appColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Harytlar",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: fontSize)),
                            Spacer(),
                            Text(productCount.toString(),
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 18)),
                            Icon(Icons.navigate_next,
                                color: CustomColors.appColor)
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Orders(
                                    customer_id: this.user_id,
                                    callbackFunc: getData)));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200))),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: iconSize,
                              color: CustomColors.appColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Sargytlar",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: fontSize)),
                            Spacer(),
                            Text(orderCount.toString(),
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 18)),
                            Icon(Icons.navigate_next,
                                color: CustomColors.appColor)
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LentaList(
                                    customer_id: this.user_id,
                                    callbackFunc: getData,
                                    user_customer_id:
                                        widget.user_customer_id)));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200))),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(children: [
                            Icon(
                              Icons.bookmark_border_outlined,
                              size: iconSize,
                              color: CustomColors.appColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Aksiýalar",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: fontSize)),
                            Spacer(),
                            Text(lentaCount,
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 18)),
                            Icon(Icons.navigate_next,
                                color: CustomColors.appColor)
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileImages(
                                      customer_id: this.user_id,
                                      callbackFunc: getData,
                                    )));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200))),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(children: [
                            Icon(
                              Icons.image_outlined,
                              size: iconSize,
                              color: CustomColors.appColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Suratlar",
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: fontSize)),
                            Spacer(),
                            Text(images.length.toString(),
                                style: TextStyle(
                                    color: CustomColors.appColor,
                                    fontSize: 18)),
                            Icon(Icons.navigate_next,
                                color: CustomColors.appColor)
                          ])),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                        textColor: Colors.white,
                        padding: EdgeInsets.all(10),
                        color: Colors.red.shade400,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_outlined),
                              Text('Çykmak')
                            ],
                          ),
                        ),
                        onPressed: () {
                          showLogoutConfirmDialog(context);
                        })
                  ])),
          ]),
        ));
  }

  showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogout();
      },
    );
  }

  getData() async {
    final pref = await SharedPreferences.getInstance();
    final uri = Uri.parse(serverIp + '/profile');
    global_headers['token'] = await get_access_token();
    print(global_headers);
    final response = await http.get(uri, headers: global_headers);

    if (response.statusCode == 403) {
      await pref.setBool('login', false);
      await pref.setString('logo_url', '');
      await pref.setString('user_id', '');
      await pref.setString('username', '');
      await pref.setString('name', '');
      await pref.setString('phone', '');
      await pref.setString('access_token', '');
      await pref.setString('refresh_token', '');
      await pref.setString('token', '');
      global_headers['token'] = '';
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;

      try {
        category_id = json['category']['id'];
        category_name = json['category']['name'];
      } catch (err) {}
      try {
        tc_id = json['center']['id'];
        tc_name = json['center']['name'];
      } catch (err) {}

      try {
        location_id = json['location']['id'];
        location_name = json['location']['name'];
      } catch (err) {}

      try {
        name = json['name'];
        phone = json['phone'];
        email = json['email'];
        images = json['images'];

        carCount = json['stats']['cars'].toString();
        productCount = json['stats']['products'].toString();
        partCount = json['stats']['parts'].toString();
        lentaCount = json['stats']['lenta'].toString();
        orderCount = json['stats']['orders'].toString();
        flatCount = json['stats']['flats'].toString();
        imgUrl = json['logo'];
        pref.setString('logo_url', imgUrl);
      } catch (err) {}
    });
  }
}

class CustomDialogLogout extends StatefulWidget {
  @override
  _CustomDialogLogoutState createState() => _CustomDialogLogoutState();
}

class _CustomDialogLogoutState extends State<CustomDialogLogout> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.logout,
        size: 40,
      ),
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Text(
        'Ulagamdan çykmaga ynamyňyz barmy?',
        style: TextStyle(color: CustomColors.appColor, fontSize: 20),
        maxLines: 3,
      ),
      content: Row(
        children: [
          Expanded(
              child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: CustomColors.appColor,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Ýok'),
          )),
          SizedBox(width: 3),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                await pref.setBool('login', false);
                await pref.setString('logo_url', '');
                await pref.setString('user_id', '');
                await pref.setString('username', '');
                await pref.setString('name', '');
                await pref.setString('phone', '');
                await pref.setString('access_token', '');
                await pref.setString('refresh_token', '');
                await pref.setString('token', '');
                global_headers.remove('token');

                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text('Hawa'),
            ),
          )
        ],
      ),
      actions: <Widget>[],
    );
  }
}
