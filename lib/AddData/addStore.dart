import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Customer/editStore.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/pages/homePageLocation.dart';
import 'package:my_app/pages/select.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddStore extends StatefulWidget {
  const AddStore({super.key});

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  List<dynamic> categories = [];
  List<File> selectedImages = [];

  var categoryController = {};
  var locationController = {};

  final delivery_priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final body_tmController = TextEditingController();
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
    get_store_index();
    super.initState();
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

  callbackPhone(new_value) {
    setState(() {
      if (phoneController.text == '') {
        phoneController.text = new_value;
      } else {
        phoneController.text = phoneController.text + ", " + new_value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Dükan goşuldy. Operatoryň tassyklamagyna garaşyň',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColors,
          type: QuickAlertType.success,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDatasPage(index: 0)));
          });
    }

    return ListView(children: [
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
                child: MyDropdownButton(
                    items: categories, callbackFunc: callbackCategory))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Kategoriýasy',
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
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: delivery_priceController,
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
                child: Text('Eltip bermek bahasy',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      GestureDetector(
          onTap: () {
            showConfirmationDialogAddphone(context);
          },
          child: Stack(children: <Widget>[
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
                        enabled: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusColor: Colors.white,
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 14)),
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
          ])),
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
                    controller: body_tmController,
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
      SizedBox(height: 30),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: selectedImages.map((country) {
            return Stack(children: [
              Container(
                  margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
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
          height: 45,
          padding: const EdgeInsets.all(8),
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColors,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    getImages();
                  },
                  child: const Text('Surat goş', style: TextStyle())))),
      Container(
          height: 45,
          padding: const EdgeInsets.all(8),
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColors,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    Urls server_url = new Urls();
                    String url = server_url.get_server_url() + '/mob/stores';
                    final uri = Uri.parse(url);
                    var request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false)
                        .access_token;

                    request.headers.addAll({
                      'Content-Type': 'application/x-www-form-urlencoded',
                      'token': token
                    });
                    request.fields['name'] = nameController.text;
                    request.fields['category'] =
                        categoryController['id'].toString();
                    request.fields['delivery_price'] =
                        delivery_priceController.text;
                    request.fields['phones'] = phoneController.text;
                    request.fields['description'] = body_tmController.text;
                    request.fields['location'] =
                        locationController['id'].toString();

                    for (var i in selectedImages) {
                      var multiport = await http.MultipartFile.fromPath(
                          'images', i.path,
                          contentType: MediaType('image', 'jpeg'));
                      request.files.add(multiport);
                    }
                    print(request.fields);
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
                  child: const Text('Ýatda sakla', style: TextStyle())))),
      SizedBox(height: 200)
    ]);
  }

  void get_store_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/store';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      categories = json['categories'];
    });
  }

  showConfirmationDialogAddphone(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AddPhone(callbackFunc: callbackPhone);
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
