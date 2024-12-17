import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Profile/loadingWidget.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import '../error.dart';
import '../success.dart';

class NewProduct extends StatefulWidget {
  const NewProduct(
      {Key? key,
      required this.title,
      required this.customer_id,
      required this.id,
      required this.action,
      required this.storeRefresh})
      : super(key: key);
  final String title;
  final String customer_id, id, action;
  final Function storeRefresh;
  @override
  State<NewProduct> createState() => _NewProductState(
      title: title, customer_id: customer_id, id: id, action: action);
}

class _NewProductState extends State<NewProduct> {
  List<String> img = [
    "https://www.southernliving.com/thmb/dvvxHbEnU5yOTSV1WKrvvyY7clY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1205217071-2000-2a26022fe10b4ec8923b109197ea5a69.jpg",
  ];
  final String customer_id, id, action;
  String title;
  List<File> images = [];

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

  callbackStatus() {
    Navigator.pop(context);
  }

  final name_tmController = TextEditingController();
  final priceController = TextEditingController();

  _NewProductState(
      {required this.title,
      required this.customer_id,
      required this.id,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: Text(
          "Meniň sahypam",
          style: CustomText.appBarText,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text("Haryt goşmak",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.appColor)),
          ),
          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: CustomColors.appColor)),
            child: TextFormField(
              controller: name_tmController,
              decoration: const InputDecoration(
                  hintText: 'Ady :',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: CustomColors.appColor)),
            child: TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                  hintText: 'Bahasy :',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 300,
          ),
          if (selectedImages.length == 0) SizedBox(height: 100),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedImages.map((country) {
                  return Stack(
                    children: [
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
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )),
          Container(
            height: 45,
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () {
                  getImages();
                },
                child: const Text(
                  'Surat goş',
                  style: TextStyle(),
                ),
              ),
            ),
          ),
          Container(
            height: 45,
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColor,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  Urls server_url = new Urls();
                  String url = server_url.get_server_url() + '/mob/products';
                  final uri = Uri.parse(url);
                  var request = new http.MultipartRequest("POST", uri);

                  request.headers.addAll({
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'token': await get_access_token()
                  });
                  request.fields['name_tm'] = name_tmController.text;
                  request.fields['price'] = priceController.text;
                  request.fields['customer'] = customer_id.toString();

                  if (action == 'store') {
                    request.fields['store'] = id;
                  }
                  if (action == 'factory') {
                    request.fields['factory'] = id;
                  }

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
                    widget.storeRefresh();
                    Navigator.pop(context);
                    showConfirmationDialogSuccess(context);
                  } else {
                    Navigator.pop(context);
                    showConfirmationDialogError(context);
                  }
                },
                child: const Text(
                  'Ýatda sakla',
                  style: TextStyle(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showConfirmationDialogSuccess(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessAlert(
          action: 'factories',
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
}
