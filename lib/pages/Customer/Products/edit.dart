// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/widgets/multiSelect.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../dB/textStyle.dart';
import '../deleteImage.dart';
import '../loadingWidget.dart';

class ProductEdit extends StatefulWidget {
  var old_data;
  final Function callbackFunc;
  ProductEdit({
    Key? key,
    required this.old_data,
    required this.callbackFunc,
  }) : super(key: key);

  @override
  State<ProductEdit> createState() =>
      _ProductEditState(old_data: old_data, callbackFunc: callbackFunc);
}

class _ProductEditState extends State<ProductEdit> {
  final Function callbackFunc;
  var data = {};
  var baseurl = "";
  List<dynamic> categories = [];
  List<dynamic> stores = [];

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final descrController = TextEditingController();

  String name = '';
  String categoryName = '';
  String categoryId = '';
  String description = '';
  String created_at = '';
  String viewed = '';
  String price = '';

  var locationController = {};
  var categoryController = {};
  int _mainImg = 0;

  bool status = false;
  callbackStatus() {
    setState(() {
      status = true;
    });
  }

  callbackLocation(new_value) {
    setState(() {
      locationController = new_value;
    });
  }

  callbackCategory(new_value) {
    setState(() {
      categoryController = new_value;
      this.categoryName = new_value['name_tm'].toString();
      this.categoryId = new_value['id'].toString();
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
    try {
      this.name = old_data['name'];
      this.categoryName = old_data['category']['name'];
      this.categoryId = old_data['category']['id'].toString();
      this.price = old_data['price'].toString();
      this.description = old_data['description'].toString();
    } catch (err) {}

    nameController.text = this.name;

    priceController.text = this.price;
    descrController.text = this.description;

    get_product_index();
    super.initState();
  }

  setName(new_value) {
    setState(() {
      nameController.text = new_value;
    });
  }

  setDescription(new_value) {
    setState(() {
      descrController.text = new_value;
    });
  }

  var old_data;
  _ProductEditState({
    required this.old_data,
    required this.callbackFunc,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: const Text(
          "Haryt düzediş",
          style: CustomText.appBarText,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Ady',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CategorySelect(
                        categories: categories, callbackFunc: callbackCategory);
                  },
                );
              },
              readOnly: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  labelText: 'Kategoriýasy',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: this.categoryName),
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
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(5)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descrController,
              maxLines: 10,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  labelText: 'Giňişleýin',
                  hintText: this.description,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5)),
            ),
            SizedBox(height: 10),
            if (old_data['images'].length > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Suratlar",
                              style: TextStyle(color: CustomColors.appColor)),
                          Row(children: [
                            for (var country in old_data['images'])
                              Column(children: [
                                Stack(children: [
                                  Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      margin: const EdgeInsets.all(2),
                                      height: 100,
                                      width: 100,
                                      alignment: Alignment.topLeft,
                                      child: Image.network(
                                          baseurl + country['img_m'],
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
                                                  action: 'products',
                                                  image: country,
                                                  callbackFunc: remove_image);
                                            });
                                      },
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.close,
                                              color: Colors.red)))
                                ]),
                              ])
                          ])
                        ])),
              ),
            if (selectedImages.length > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Saýlanan suratlar"),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedImages.map((country) {
                      return Stack(
                        children: [
                          Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              margin: const EdgeInsets.all(2),
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
                              width: 100,
                              alignment: Alignment.topRight,
                              child: Icon(Icons.close, color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColor,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    getImages();
                  },
                  child: const Text(
                    'Surat goş',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColor,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    Urls server_url = new Urls();
                    String url = server_url.get_server_url() +
                        '/mob/products/' +
                        old_data['id'].toString();
                    final uri = Uri.parse(url);
                    var request = new http.MultipartRequest("PUT", uri);

                    Map<String, String> headers = {};
                    for (var i in global_headers.entries) {
                      headers[i.key] = i.value.toString();
                    }
                    headers['token'] = await get_access_token();

                    request.headers.addAll(headers);

                    if (nameController.text != '') {
                      request.fields['name'] = nameController.text;
                    }

                    if (categoryController['id'] != null) {
                      request.fields['category'] =
                          categoryController['id'].toString();
                    }

                    if (priceController.text != '') {
                      request.fields['price'] = priceController.text;
                    }

                    if (phoneController.text != '') {
                      request.fields['phone'] = phoneController.text;
                    }

                    if (descrController.text != '') {
                      request.fields['detail'] = descrController.text;
                    }
                    if (descrController.text != '') {
                      request.fields['description'] = descrController.text;
                    }

                    if (locationController['id'] != null) {
                      request.fields['location'] =
                          locationController['id'].toString();
                    }

                    if (_mainImg != 0) {
                      request.fields['img'] = _mainImg.toString();
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
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: '',
                          confirmBtnText: 'Dowam et',
                          text: 'Ýatda saklandy');
                    } else {
                      Navigator.pop(context);
                      showConfirmationDialogError(context);
                    }
                  },
                  child: const Text(
                    'Ýatda sakla',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
      baseurl = server_url.get_server_url();
      data = json;
      categories = json['categories'];
    });
  }
}
