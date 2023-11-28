// ignore_for_file: nullable_type_in_catch_clause

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/widgets/inputText.dart';
import 'package:my_app/widgets/multiSelect.dart';
import 'package:provider/provider.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../success.dart';
import '../../dB/colors.dart';
import 'loadingWidget.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class NewStore extends StatefulWidget {
  NewStore({Key? key, required this.customer_id, required this.refreshFunc})
      : super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<NewStore> createState() => _NewStoreState(customer_id: customer_id);
}

class _NewStoreState extends State<NewStore> {
  var data = {};
  var categoryController = {};
  var locationController = {};
  var streetController = {};
  var sizeController = {};

  List<dynamic> categories = [];
  List<File> images = [];
  List<File> selectedImages = [];

  final picker = ImagePicker();
  final String customer_id;
  final nameController = TextEditingController();
  final body_tmController = TextEditingController();
  final phoneController = TextEditingController();
  final delivery_priceController = TextEditingController();

  callbackPhone(new_value) {
    setState(() {
      if (phoneController.text == '') {
        phoneController.text = new_value;
      } else {
        phoneController.text = phoneController.text + ", " + new_value;
      }
    });
  }

  callbackStatus() {
    Navigator.pop(context);
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

  setName(new_value) {
    setState(() {
      nameController.text = new_value;
    });
  }

  setDeliveryPrice(new_value) {
    setState(() {
      delivery_priceController.text = new_value;
    });
  }

  setDescription(new_value) {
    setState(() {
      body_tmController.text = new_value;
    });
  }

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
    // refreshFunc();
    get_store_index();
    super.initState();
  }

  _NewStoreState({required this.customer_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      key: _scaffoldKey,
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
            child: Text("Dükan goşmak",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.appColors)),
          ),
          InputText(title: "Ady", height: 40.0, callFunc: setName),
          
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
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CategorySelect(
                          categories: categories,
                          callbackFunc: callbackCategory);
                    },
                  );
                },
                child: categoryController['name_tm'] != null
                    ? Container(
                      margin: EdgeInsets.only(top: 10),
                        child: Text(
                          categoryController['name_tm'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Text(""),
              )
              // MyDropdownButton(
              //     items: categories, callbackFunc: callbackCategory)
              ),
        ),
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
          InputText(
              title: "Eltip bermek bahasy",
              height: 40.0,
              callFunc: setDeliveryPrice),
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
                        border:
                            Border.all(color: CustomColors.appColors, width: 1),
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 12))))
              ])),
          InputText(
              title: "Giňişleýin maglumat",
              height: 100.0,
              callFunc: setDescription),
          SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedImages.map((country) {
                  return Stack(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(
                              left: 10, bottom: 10, right: 10),
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
                    backgroundColor: CustomColors.appColors,
                    foregroundColor: Colors.white),
                onPressed: () async {
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
                  request.fields['customer'] = customer_id.toString();

                  for (var i in selectedImages) {
                    var multiport = await http.MultipartFile.fromPath(
                      'images',
                      i.path,
                      contentType: MediaType('image', 'jpeg'),
                    );
                    request.files.add(multiport);
                  }
                  print(request.fields);
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
          action: 'store',
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

  showConfirmationDialogAddphone(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AddPhone(
          callbackFunc: callbackPhone,
        );
      },
    );
  }

  void get_store_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/store';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      categories = json['categories'];
    });
  }
}

class AddPhone extends StatefulWidget {
  AddPhone({Key? key, required this.callbackFunc}) : super(key: key);

  final Function callbackFunc;

  _AddPhoneState createState() => _AddPhoneState(callbackFunc: callbackFunc);
}

class _AddPhoneState extends State<AddPhone> {
  final Function callbackFunc;
  final phoneController1 = TextEditingController();

  _AddPhoneState({required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text(
            'Telefon belgi',
            style: TextStyle(color: CustomColors.appColors),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 25,
            ),
          )
        ],
      ),
      content: Container(
        alignment: Alignment.center,
        height: 35,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: CustomColors.appColors)),
        child: TextFormField(
          controller: phoneController1,
          decoration: const InputDecoration(
              hintText: 'Telefon',
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
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                callbackFunc(phoneController1.text);
              });

              Navigator.pop(context, 'Close');
            },
            child: const Text('Goşmak'),
          ),
        )
      ],
    );
  }
}
