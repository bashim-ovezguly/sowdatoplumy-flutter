import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';

import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Profile/loadingWidget.dart';
import 'package:my_app/pages/LoadinError.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:my_app/widgets/multiSelect.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<dynamic> categories = [];
  List<dynamic> categoriesList = [];
  List<File> selectedImages = [];
  List<dynamic> stores = [];

  var storesController = {};
  var locationController = {};
  var categoryController = {};
  var storeId = '';
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

  showErrorAlert(text) {
    QuickAlert.show(
        context: context,
        title: '',
        text: text,
        confirmBtnText: 'OK',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.error,
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Bildiriş goşuldy. Operatoryň tassyklamagyna garaşyň',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.success,
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddDatasPage(index: 0)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Ady'),
                  contentPadding: EdgeInsets.all(10)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Bahasy'),
                  suffixText: 'TMT',
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(10)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
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
                  hintText: categoryController['name_tm']),
            ),

            SizedBox(height: 20),
            TextFormField(
              controller: detailController,
              decoration: InputDecoration(
                  hintText: 'Goşmaça', border: OutlineInputBorder()),
              maxLines: 5,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: selectedImages.map((country) {
                  return Stack(children: [
                    Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 2)
                        ], borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
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
                            padding: EdgeInsets.all(5),
                            width: 110,
                            alignment: Alignment.topRight,
                            child: Icon(Icons.close, color: Colors.red)))
                  ]);
                }).toList())),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () {
                  getImages();
                },
                child: const Text('Surat goş',
                    style: TextStyle(fontWeight: FontWeight.w300))),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  saveProduct();
                },
                child: const Text('Ýatda sakla',
                    style: TextStyle(fontWeight: FontWeight.w300))),
            // SizedBox(height: 200)
          ],
        ));
  }

  void saveProduct() async {
    if (nameController.text == '') {
      showErrorAlert('Adyny hökman ýazmaly');
      return null;
    }

    final uri = Uri.parse(productsUrl);
    var request = new http.MultipartRequest("POST", uri);

    final pref = await SharedPreferences.getInstance();

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    headers['token'] = pref.getString('access_token').toString();

    request.headers.addAll(headers);
    request.fields['name'] = nameController.text;
    request.fields['category'] = categoryController['id'].toString();
    request.fields['price'] = priceController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['description'] = detailController.text;
    request.fields['store'] = pref.get('user_id').toString();
    request.fields['location'] = locationController['id'].toString();

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
  }

  void get_product_index() async {
    final pref = await SharedPreferences.getInstance();

    print(pref.get('user_id').toString());

    String url = serverIp + '/mob/index/product';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      categories = json['categories'];
      categories.map((e) => () => {categoriesList.add(e['name_tm'])});
    });
  }

  showConfirmationDialogError(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return LoadingErrorAlert();
      },
    );
  }

  showErrorDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.error),
        );
      },
    );
  }
}
