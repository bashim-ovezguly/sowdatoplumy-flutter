import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/widgets/inputText.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../../main.dart';
import '../../error.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';

class OtherGoodsAdd extends StatefulWidget {
  OtherGoodsAdd(
      {Key? key, required this.customer_id, required this.refreshFunc})
      : super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<OtherGoodsAdd> createState() =>
      _OtherGoodsAddState(customer_id: customer_id);
}

class _OtherGoodsAddState extends State<OtherGoodsAdd> {
  var data = {};
  List<dynamic> categories = [];
  List<dynamic> brands = [];
  List<dynamic> units = [];
  List<dynamic> countries = [];

  List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  final String customer_id;
  final name_tmController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final amountController = TextEditingController();
  final unitController = TextEditingController();

  var locationController = {};
  var categoryController = {};
  var barndController = {};
  var madeInController = {};

  callbackStatus() {
    Navigator.pop(context);
  }

  callbackLocation(new_value) {
    setState(() {
      locationController = new_value;
    });
  }

  callbackCategory(new_value) {
    setState(() {
      categoryController = new_value;
    });
  }

  setDescription(new_value) {
    setState(() {
      detailController.text = new_value;
    });
  }

  callbackBrand(new_value) {
    setState(() {
      barndController = new_value;
    });
  }

  callbackMadein(new_value) {
    setState(() {
      madeInController = new_value;
    });
  }

  List<File> selectedImages = [];
  final picker = ImagePicker();

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Surat saýlamadyňyz!')));
        }
      },
    );
  }

  void initState() {
    get_product_index();
    get_userinfo();
    super.initState();
  }

  setName(new_value) {
    setState(() {
      name_tmController.text = new_value;
    });
  }

  setPrice(new_value) {
    setState(() {
      priceController.text = new_value;
    });
  }

  setPhone(new_value) {
    setState(() {
      phoneController.text = new_value;
    });
  }

  _OtherGoodsAddState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: const Text("Meniň sahypam", style: CustomText.appBarText)),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: const Text("Bildiriş goşmak",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.appColors))),
          InputText(title: "Ady", height: 40.0, callFunc: setName),
          InputSelectText(
              title: "Dükan",
              height: 40.0,
              callFunc: callbackStores,
              items: stores),
          InputText(title: "Bahasy", height: 40.0, callFunc: setPrice),
          InputText(title: "Telefon", height: 40.0, callFunc: setPhone),
          Stack(children: <Widget>[
            GestureDetector(
                child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomColors.appColors, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: locationController['name_tm'] != null
                            ? Text(locationController['name_tm'],
                                style: TextStyle(
                                  fontSize: 16,
                                ))
                            : Text(''))),
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return LocationWidget(callbackFunc: callbackLocation);
                      });
                }),
            Positioned(
                left: 25,
                top: 12,
                child: Container(
                    color: Colors.white,
                    child: Text('Ýerleşýän ýeri',
                        style: TextStyle(color: Colors.black, fontSize: 12))))
          ]),
          InputSelectText(
              title: "Kategoriýa",
              height: 40.0,
              callFunc: callbackCategory,
              items: categories),
          InputText(
              title: "Giňişleýin maglumat",
              height: 100.0,
              callFunc: setDescription),
          SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: selectedImages.map((country) {
                return Stack(children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 10),
                      height: 100,
                      width: 100,
                      alignment: Alignment.topLeft,
                      child: Image.file(
                        country,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImages.remove(country);
                        });
                      },
                      child: Container(
                          height: 100,
                          width: 110,
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close, color: Colors.red)))
                ]);
              }).toList())),
          Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.appColors,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        getImages();
                      },
                      child: const Text('Surat goş',
                          style: TextStyle(fontWeight: FontWeight.bold))))),
          Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.appColors,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        Urls server_url = new Urls();
                        String url =
                            server_url.get_server_url() + '/mob/products';
                        final uri = Uri.parse(url);
                        var request = new http.MultipartRequest("POST", uri);
                        var token =
                            Provider.of<UserInfo>(context, listen: false)
                                .access_token;
                        Map<String, String> headers = {};
                        for (var i in global_headers.entries) {
                          headers[i.key] = i.value.toString();
                        }
                        headers['token'] = token;

                        request.headers.addAll(headers);
                        if (storesController['id'] != null) {
                          request.fields['store'] =
                              storesController['id'].toString();
                        }
                        request.fields['name'] = name_tmController.text;
                        request.fields['category'] =
                            categoryController['id'].toString();
                        request.fields['price'] = priceController.text;
                        request.fields['phone'] = phoneController.text;
                        request.fields['description'] = detailController.text;
                        request.fields['amount'] = amountController.text;
                        request.fields['brand'] =
                            barndController['id'].toString();
                        request.fields['made_in'] =
                            madeInController['id'].toString();
                        request.fields['unit'] = unitController.text;
                        request.fields['location'] =
                            locationController['id'].toString();
                        request.fields['customer'] = customer_id.toString();

                        for (var i in selectedImages) {
                          var multiport = await http.MultipartFile.fromPath(
                            'images',
                            i.path,
                            contentType: MediaType('image', 'jpeg'),
                          );
                          request.files.add(multiport);
                        }
                        showLoaderDialog(context);
                        final response = await request.send();
                        if (response.statusCode == 200) {
                          widget.refreshFunc();
                          Navigator.pop(context);
                          showConfirmationDialogSuccess(context);
                        } else {
                          Navigator.pop(context);
                          showConfirmationDialogError(context);
                        }
                      },
                      child: const Text('Ýatda sakla',
                          style: TextStyle(fontWeight: FontWeight.bold)))))
        ]));
  }

  showConfirmationDialogSuccess(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessAlert(
          action: 'othergoods',
          callbackFunc: callbackStatus,
        );
      },
    );
  }

  showConfirmationDialogError(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();
      },
    );
  }

  void get_product_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/product';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      categories = json['categories'];
      brands = json['brands'];
      units = json['units'];
      countries = json['countries'];
    });
  }

  void get_userinfo() async {
    var allRows = await dbHelper.queryAllRows();
    var data = [];
    for (final row in allRows) {
      data.add(row);
    }
    if (data.length == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    Urls server_url = new Urls();
    String url = server_url.get_server_url() +
        '/mob/customer/' +
        data[0]['userId'].toString();
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    headers['token'] = data[0]['name'];
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      stores = json['data']['stores'];
    });
    Provider.of<UserInfo>(context, listen: false)
        .setAccessToken(data[0]['name'], data[0]['age']);
  }
}
