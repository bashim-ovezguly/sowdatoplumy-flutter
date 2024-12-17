// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/main.dart';

import 'package:my_app/pages/Profile/deleteImage.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:provider/provider.dart';

import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';

class AutoPartsEdit extends StatefulWidget {
  final Function callbackFunc;
  AutoPartsEdit({Key? key, required this.old_data, required this.callbackFunc})
      : super(key: key);
  var old_data;
  @override
  State<AutoPartsEdit> createState() =>
      _AutoPartsEditState(old_data: old_data, callbackFunc: callbackFunc);
}

class _AutoPartsEditState extends State<AutoPartsEdit> {
  var data = {};
  final Function callbackFunc;
  var old_data = {};

  List<dynamic> categories = [];
  List<dynamic> made_in_countries = [];
  List<dynamic> fuels = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  List<dynamic> models = [];
  List<dynamic> marks = [];

  List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  bool status = false;
  callbackStatus() {
    setState(() {
      status = true;
    });
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final descrController = TextEditingController();

  String markName = '';
  String markId = '';
  String modelName = '';
  String modelId = '';
  String categoryName = '';
  String categoryId = '';

  callbackMarka(new_value) async {
    setState(() {
      markName = new_value['name'];
      markId = new_value['id'];
    });

    String url = serverIp + '/mob/index/car?mark=' + markId.toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));
    setState(() {
      models = jsons['models'];
    });
  }

  callbackModel(new_value) {
    setState(() {
      modelName = new_value['name'];
      modelId = new_value['id'];
    });
  }

  callbackCategory(new_value) {
    setState(() {
      markName = new_value['name'];
      markId = new_value['id'];
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

  remove_image(value) {
    setState(() {
      old_data['images'].remove(value);
    });
  }

  void initState() {
    this.nameController.text = old_data['name'];
    this.priceController.text = old_data['price'];
    this.descrController.text = old_data['description'];

    try {
      this.categoryName = old_data['category']['name'];
      this.categoryId = old_data['category']['id'];
    } catch (err) {}

    try {
      this.markName = old_data['mark']['name'];
      this.markId = old_data['mark']['id'];
    } catch (err) {}
    try {
      this.modelName = old_data['model']['name'];
      this.modelId = old_data['model']['id'];
    } catch (err) {}

    getIndexData();
    get_userinfo();
    super.initState();
  }

  setName(new_value) {
    setState(() {
      nameController.text = new_value;
    });
  }

  setPhone(new_value) {
    setState(() {
      phoneController.text = new_value;
    });
  }

  setPrice(new_value) {
    setState(() {
      priceController.text = new_value;
    });
  }

  setDescription(new_value) {
    setState(() {
      descrController.text = new_value;
    });
  }

  _AutoPartsEditState({required this.old_data, required this.callbackFunc});
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: Text(
          "Düzediş",
          style: CustomText.appBarText,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Ady',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  suffixText: 'TMT',
                  labelText: 'Bahasy',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5)),
            ),
            Stack(children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomColors.appColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle),
                  child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: MyDropdownButton(
                          oldData: markName,
                          items: marks,
                          callbackFunc: callbackMarka))),
              Positioned(
                  left: 10,
                  top: 12,
                  child: Container(
                      color: Colors.white,
                      child: Text('Marka',
                          style: TextStyle(color: Colors.black, fontSize: 12))))
            ]),
            Stack(children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomColors.appColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle),
                  child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: MyDropdownButton(
                          oldData: modelName,
                          items: models,
                          callbackFunc: callbackModel))),
              Positioned(
                  left: 10,
                  top: 12,
                  child: Container(
                      color: Colors.white,
                      child: Text('Model',
                          style: TextStyle(color: Colors.black, fontSize: 12))))
            ]),
            Stack(children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomColors.appColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle),
                  child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: MyDropdownButton(
                          oldData: categoryName,
                          items: categories,
                          callbackFunc: callbackCategory))),
              Positioned(
                  left: 10,
                  top: 12,
                  child: Container(
                      color: Colors.white,
                      child: Text('Kategoriýasy',
                          style: TextStyle(color: Colors.black, fontSize: 12))))
            ]),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 10,
              controller: descrController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Giňişleýin',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5)),
            ),
            const SizedBox(height: 10),
            if (old_data['images'].length > 0)
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Suratlar",
                            style: TextStyle(
                                color: CustomColors.appColor, fontSize: 16)),
                        Row(children: [
                          for (var country in old_data['images'])
                            Column(children: [
                              Stack(children: [
                                Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    height: 100,
                                    width: 100,
                                    alignment: Alignment.topLeft,
                                    child: Image.network(
                                        serverIp + country['img_m'],
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100, errorBuilder:
                                            (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                              color: CustomColors.appColor));
                                    })),
                                GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteImage(
                                                action: 'parts',
                                                image: country,
                                                callbackFunc: remove_image);
                                          });
                                    },
                                    child: Container(
                                        height: 100,
                                        width: 110,
                                        alignment: Alignment.topRight,
                                        child: Icon(Icons.close,
                                            color: Colors.red)))
                              ]),
                            ])
                        ])
                      ])),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selectedImages.map((country) {
                    return Stack(children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
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
                  }).toList(),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () {
                  getImages();
                },
                child: const Text('Surat goş',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.appColor,
                  foregroundColor: Colors.white),
              onPressed: () async {
                String url = partsUrl + '/' + old_data['id'].toString();
                final uri = Uri.parse(url);
                var request = new http.MultipartRequest("PUT", uri);
                var token =
                    Provider.of<UserInfo>(context, listen: false).access_token;

                Map<String, String> headers = {};
                for (var i in global_headers.entries) {
                  headers[i.key] = i.value.toString();
                }
                headers['token'] = token;
                request.headers.addAll(headers);

                if (storesController['id'] != null) {
                  request.fields['store'] = storesController['id'].toString();
                }

                if (modelId != '') {
                  request.fields['model'] = modelId.toString();
                }

                if (markId != '') {
                  request.fields['mark'] = markId.toString();
                }

                if (priceController.text != '') {
                  request.fields['price'] = priceController.text.toString();
                }

                if (nameController.text != '') {
                  request.fields['name'] = nameController.text.toString();
                }

                if (phoneController.text != '') {
                  request.fields['phone'] = phoneController.text.toString();
                }

                if (categoryId != '') {
                  request.fields['category'] = categoryId;
                }

                if (descrController.text != '') {
                  request.fields['description'] =
                      descrController.text.toString();
                }

                if (selectedImages.length != 0) {
                  for (var i in selectedImages) {
                    var multiport = await http.MultipartFile.fromPath(
                      'images',
                      i.path,
                      contentType: MediaType('image', 'jpeg'),
                    );
                    request.files.add(multiport);
                  }
                }
                showLoaderDialog(context);
                final response = await request.send();
                if (response.statusCode == 200) {
                  callbackFunc();
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  showConfirmationDialogError(context);
                }
              },
              child: const Text(
                'Ýatda sakla',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  showConfirmationDialogSuccess(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessAlert(
          action: 'parts',
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

  void getIndexData() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/part';
    final uri = Uri.parse(url);
    // create request headers
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      categories = json['categories'];
      fuels = json['fuels'];
      transmissions = json['transmissions'];
      wheel_drives = json['wheel_drives'];
      models = json['models'];
      marks = json['marks'];
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
    String url = storesUrl + '/' + data[0]['userId'].toString();
    final uri = Uri.parse(url);
    // create request headers
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    headers['token'] = data[0]['name'];
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      // stores = json['data']['stores'];
    });
    Provider.of<UserInfo>(context, listen: false)
        .setAccessToken(data[0]['name'], data[0]['age']);
  }
}
