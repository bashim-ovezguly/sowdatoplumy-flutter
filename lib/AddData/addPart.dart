import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';

import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/pages/homePageLocation.dart';
import 'package:my_app/pages/select.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddParth extends StatefulWidget {
  const AddParth({super.key});

  @override
  State<AddParth> createState() => _AddParthState();
}

class _AddParthState extends State<AddParth> {
  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> categories = [];
  List<File> selectedImages = [];
  List<dynamic> stores = [];

  var storesController = {};
  var locationController = {};
  var markaController = {};
  var modelController = {};
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
    get_parts_index();
    super.initState();
  }

  callbackModel(new_value) {
    setState(() {
      modelController = new_value;
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

  callbackMarka(new_value) async {
    setState(() {
      markaController = new_value;
    });
    Urls server_url = new Urls();
    String url = server_url.get_server_url() +
        '/mob/index/car?mark=' +
        markaController['id'].toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));
    setState(() {
      modelController = {};
      models = jsons['models'];
    });
  }

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Awtoulag goşuldy. Operatoryň tassyklamagyna garaşyň',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.success,
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddDatasPage(index: 0)));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(scrollDirection: Axis.vertical, children: [
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Ady'),
              contentPadding: EdgeInsets.all(10)),
        ),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: categories, callbackFunc: callbackCategory))),
          Positioned(
              left: 10,
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
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: marks, callbackFunc: callbackMarka))),
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
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: models, callbackFunc: callbackModel))),
          Positioned(
              left: 10,
              top: 12,
              child: Container(
                  color: Colors.white,
                  child: Text('Model',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        Stack(children: <Widget>[
          GestureDetector(
              child: Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.appColor, width: 1),
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
              left: 10,
              top: 12,
              child: Container(
                  color: Colors.white,
                  child: Text('Ýerleşýän ýeri',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        SizedBox(
          height: 20,
        ),
        TextFormField(
            keyboardType: TextInputType.number,
            controller: priceController,
            decoration: const InputDecoration(
                hintText: 'Bahasy',
                suffixText: 'TMT',
                border: OutlineInputBorder(),
                focusColor: CustomColors.appColor,
                contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }),
        SizedBox(
          height: 20,
        ),
        TextFormField(
            keyboardType: TextInputType.phone,
            controller: phoneController,
            decoration: const InputDecoration(
                prefixText: '+993',
                labelText: 'Telefon belgisi',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                focusColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }),
        SizedBox(
          height: 20,
        ),
        TextFormField(
            maxLines: 10,
            controller: detailController,
            decoration: const InputDecoration(
                hintText: 'Goşmaça maglumat',
                border: OutlineInputBorder(),
                focusColor: Colors.white,
                contentPadding: EdgeInsets.all(5)),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }),
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
                        backgroundColor: CustomColors.appColor,
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
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.appColor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      savePart();
                    },
                    child: const Text('Ýatda sakla',
                        style: TextStyle(fontWeight: FontWeight.bold))))),
        SizedBox(height: 200)
      ]),
    );
  }

  savePart() async {
    if (nameController.text == '') {
      showErrorAlert('Adyny hökman girizmeli');
      return null;
    }

    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/parts';
    final uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    var token = await get_access_token();

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    headers['token'] = token;
    request.headers.addAll(headers);

    final pref = await SharedPreferences.getInstance();
    request.fields['store'] = pref.getInt('user_id').toString();

    request.fields['model'] = modelController['id'].toString();
    request.fields['mark'] = markaController['id'].toString();
    request.fields['price'] = priceController.text.toString();
    request.fields['phone'] = phoneController.text.toString();
    request.fields['name'] = nameController.text.toString();
    request.fields['category'] = categoryController['id'].toString();
    request.fields['location'] = locationController['id'].toString();
    request.fields['detail'] = detailController.text.toString();

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

  void get_parts_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/part';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      categories = json['categories'];
      models = json['models'];
      marks = json['marks'];
    });
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
