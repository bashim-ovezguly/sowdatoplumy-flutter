// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/widgets/inputText.dart';
import 'package:my_app/widgets/multiSelect.dart';
import 'package:provider/provider.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../success.dart';
import '../../dB/colors.dart';
import 'loadingWidget.dart';

class EditStore extends StatefulWidget {
  var old_data;
  final Function callbackFunc;
  EditStore({Key? key, required this.old_data, required this.callbackFunc})
      : super(key: key);

  @override
  State<EditStore> createState() =>
      _EditStoreState(old_data: old_data, callbackFunc: callbackFunc);
}

class _EditStoreState extends State<EditStore> {
  var old_data;
  var data = {};
  var baseurl = "";
  final Function callbackFunc;
  List<dynamic> categories = [];
  List<dynamic> sizes = [];
  List<dynamic> trade_centers = [];
  List<dynamic> streets = [];
  List<File> images = [];
  bool desible = false;
  int _mainImg = 0;

  final nameController = TextEditingController();
  final body_tmController = TextEditingController();
  final delivery_priceController = TextEditingController();
  final phoneController = TextEditingController();

  bool status = false;
  callbackStatus() {
    setState(() {
      status = true;
      initState();
    });
  }

  var categoryController = {};
  var locationController = {};
  var streetController = {};
  var sizeController = {};

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
    if (status == true) {
      Navigator.pop(context);
    }
    get_store_index();
    setName(old_data['name_tm']);

    if (old_data['location'] != '') {
      setState(() {
        locationController = old_data['location'];
      });
    }
    super.initState();
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

  _EditStoreState({required this.old_data, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar:
          AppBar(title: Text("Meniň sahypam", style: CustomText.appBarText)),
      body: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text("Dükan üýtgetmek",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.appColors))),
          InputText(
              title: "Ady",
              height: 40.0,
              callFunc: setName,
              oldData: old_data['name_tm']),
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
                          : Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                old_data['category'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ))
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
                        child: locationController['name'] != null
                            ? Text(locationController['name'],
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
              callFunc: setDeliveryPrice,
              oldData: old_data['delivery_price']),
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
              callFunc: setDescription,
              oldData: old_data['body_tm']),
          SizedBox(height: 15),
          if (old_data['images'].length > 0)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "    Suratlar",
                        style: TextStyle(
                            color: CustomColors.appColors, fontSize: 16),
                      ),
                      Row(children: [
                        for (var country in old_data['images'])
                          Column(children: [
                            Stack(children: [
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.topLeft,
                                  child: Image.network(
                                    baseurl + country['img_m'],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: CustomColors.appColors,
                                        ),
                                      );
                                    },
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DeleteImage(
                                              action: 'stores',
                                              image: country,
                                              callbackFunc: remove_image);
                                        });
                                  },
                                  child: Container(
                                      height: 100,
                                      width: 110,
                                      alignment: Alignment.topRight,
                                      child:
                                          Icon(Icons.close, color: Colors.red)))
                            ]),
                            if (_mainImg == country['id'])
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: OutlinedButton(
                                      child: Text("Esasy img",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 15, 138, 19),
                                          side:
                                              BorderSide(color: Colors.green)),
                                      onPressed: () {
                                        setState(() {
                                          _mainImg = country['id'];
                                        });
                                      }))
                            else
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: OutlinedButton(
                                      child: Text("Esasy img"),
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.red,
                                          side: BorderSide(color: Colors.red)),
                                      onPressed: () {
                                        setState(() {
                                          _mainImg = country['id'];
                                        });
                                      }))
                          ])
                      ])
                    ])),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: selectedImages.map((country) {
                return Stack(children: [
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
                  String url = server_url.get_server_url() +
                      '/mob/stores/' +
                      old_data['id'].toString();
                  final uri = Uri.parse(url);
                  var request = new http.MultipartRequest("PUT", uri);
                  var token = Provider.of<UserInfo>(context, listen: false)
                      .access_token;
                  Map<String, String> headers = {};
                  for (var i in global_headers.entries) {
                    headers[i.key] = i.value.toString();
                  }
                  headers['token'] = token;
                  request.headers.addAll(headers);

                  if (nameController.text != '') {
                    request.fields['name'] = nameController.text;
                  }

                  if (categoryController['id'] != null) {
                    request.fields['category'] =
                        categoryController['id'].toString();
                  }

                  if (_mainImg != 0) {
                    request.fields['img'] = _mainImg.toString();
                  }

                  if (locationController['id'] != null) {
                    request.fields['location'] =
                        locationController['id'].toString();
                  }

                  if (phoneController != '' && phoneController != 'Telefon') {
                    request.fields['phone'] = phoneController.text;
                  }

                  if (delivery_priceController.text != '') {
                    request.fields['delivery_price'] =
                        delivery_priceController.text;
                  }

                  if (body_tmController.text != '') {
                    request.fields['description'] = body_tmController.text;
                  }
                  if (selectedImages.length != 0) {
                    for (var i in selectedImages) {
                      var multiport = await http.MultipartFile.fromPath(
                          'images', i.path,
                          contentType: MediaType('image', 'jpeg'));
                      request.files.add(multiport);
                    }
                  }
                  showLoaderDialog(context);
                  final response = await request.send();
                  if (response.statusCode == 200) {
                    callbackFunc();
                    Navigator.pop(context);

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              shadowColor: CustomColors.appColorWhite,
                              surfaceTintColor: CustomColors.appColorWhite,
                              backgroundColor: CustomColors.appColorWhite,
                              content: Container(
                                  width: 200,
                                  height: 100,
                                  child: Text(
                                      'Maglumat üýtgedildi operatoryň tassyklamagyna garaşyň')),
                              actions: <Widget>[
                                Align(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Dowam et')))
                              ]);
                        });
                  } else {
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shadowColor: CustomColors.appColorWhite,
                          surfaceTintColor: CustomColors.appColorWhite,
                          backgroundColor: CustomColors.appColorWhite,
                          content: Container(
                            width: 70,
                            height: 70,
                            child: Text(
                                'Bagyşlaň maglumat üýtgetmede ýalñyşlyk ýüze çykdy täzeden synanşyp görüň!'),
                          ),
                          actions: <Widget>[
                            Align(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context, 'Close');
                                },
                                child: const Text('Dowam et'),
                              ),
                            )
                          ],
                        );
                      },
                    );
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
        return SuccessAlert(action: 'store', callbackFunc: callbackStatus);
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
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      baseurl = server_url.get_server_url();
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
