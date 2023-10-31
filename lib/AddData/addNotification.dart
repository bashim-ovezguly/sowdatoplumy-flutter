import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/providers.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/pages/homePageLocation.dart';
import 'package:my_app/pages/select.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddNotifications extends StatefulWidget {
  const AddNotifications({super.key});

  @override
  State<AddNotifications> createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  List<dynamic> categories = [];
  List<File> selectedImages = [];
  List<dynamic> stores = [];

  var storesController = {};
  var locationController = {};
  var categoryController = {};

  final picker = ImagePicker();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();

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

  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  callbackCategory(new_value) {
    setState(() {
      categoryController = new_value;
    });
  }

  callbackLocation(new_value) {
    setState(() {
      locationController = new_value;
    });
  }

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Bildiriş goşuldy. Operatoryň tassyklamagyna garaşyň',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddDatasPage(index: 0)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(scrollDirection: Axis.vertical, children: [
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: stores, callbackFunc: callbackStores))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Dükan',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: categories, callbackFunc: callbackCategory))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Kategoriýa',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Ady',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Bahasy',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Telefon',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        GestureDetector(
            child: Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColors, width: 1),
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
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: detailController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Giňişleýin maglumat',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      SizedBox(height: 15),
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
                  child: Image.file(country,
                      fit: BoxFit.cover, height: 100, width: 100)),
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
                    String url = server_url.get_server_url() + '/mob/products';
                    final uri = Uri.parse(url);
                    var request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false)
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
                    request.fields['name'] = nameController.text;
                    request.fields['category'] = categoryController['id'].toString();
                    request.fields['price'] = priceController.text;
                    request.fields['phone'] = phoneController.text;
                    request.fields['description'] = detailController.text;
                    request.fields['location'] =
                        locationController['id'].toString();
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
                      Navigator.pop(context);
                      showSuccessAlert();
                    } else {
                      Navigator.pop(context);
                      showConfirmationDialogError(context);
                    }
                  },
                  child: const Text('Ýatda sakla',
                      style: TextStyle(fontWeight: FontWeight.bold))))),
      SizedBox(height: 200)
    ]);
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
      categories = json['categories'];
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

  showConfirmationDialogError(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();
      },
    );
  }
}
