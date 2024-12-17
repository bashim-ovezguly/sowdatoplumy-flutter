import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Profile/locationWidget.dart';
import 'package:my_app/pages/Profile/login.dart';
import 'package:my_app/widgets/TCSelector.dart';
import 'package:my_app/widgets/storeCatSelect.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dB/textStyle.dart';
import 'loadingWidget.dart';
import 'package:quickalert/quickalert.dart';

class EditProfil extends StatefulWidget {
  final String customer_id;
  final String email;
  final String name;
  final String phone;
  final String img;
  final String? locationName;
  final String? locationId;
  final String? tcName;
  final String? tcId;
  final String? category_name;
  final String? category_id;
  final String? description;
  final String? slogan;
  final Function callback;

  EditProfil(
      {Key? key,
      required this.customer_id,
      required this.callback,
      required this.email,
      required this.name,
      required this.img,
      required this.phone,
      this.tcName,
      this.tcId,
      this.category_name,
      this.description,
      this.slogan,
      this.category_id,
      this.locationName,
      this.locationId})
      : super(key: key);

  @override
  State<EditProfil> createState() => _EditProfilState(
      customer_id: customer_id,
      email: email,
      locationName: this.locationName.toString(),
      locationId: this.locationId.toString(),
      category_id: this.category_id,
      category_name: this.category_name,
      tc_id: this.tcId,
      tc_name: this.tcName,
      name: name,
      callback: callback,
      imgUrl: img,
      phone: phone);
}

class _EditProfilState extends State<EditProfil> {
  String customer_id;
  String email;
  String name;
  String imgUrl;
  String phone;
  String? locationName;
  String? locationId;
  String? tc_name;
  String? tc_id;
  String? category_name;
  String? category_id;
  String? description;
  String? slogan;

  var phones = [];
  var links = [];

  Function callback;

  var location = {};
  var newNameController = TextEditingController();
  var emailController = TextEditingController();
  var locationController = TextEditingController();
  var categoryController = TextEditingController();
  var tcController = TextEditingController();
  var newPhoneController = TextEditingController();
  var newLinkController = TextEditingController();
  var descrController = TextEditingController();

  _EditProfilState(
      {required this.customer_id,
      this.locationName,
      this.locationId,
      this.tc_name,
      this.tc_id,
      this.category_id,
      this.category_name,
      required this.email,
      required this.callback,
      required this.imgUrl,
      required this.name,
      required this.phone});

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
      await save();
      await getData();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  removePhone(item) async {
    this.phones.remove(item);
    Uri uri =
        Uri.parse(serverIp + '/stores/phone/delete/' + item['id'].toString());
    var response = await http.post(uri, headers: global_headers);
  }

  removeLink(item) async {
    this.links.remove(item);
    Uri uri =
        Uri.parse(serverIp + '/stores/link/delete/' + item['id'].toString());
    var response = await http.post(uri, headers: global_headers);
  }

  addPhone() async {
    final phone = newPhoneController.text;
    print(phone);
    Uri uri = Uri.parse(storeUrl + customer_id.toString());
    var fdata = {'phone': phone};
    var response = await http.put(uri, body: fdata, headers: global_headers);

    if (response.statusCode == 200) {
      this.getData();
      newPhoneController.text = '';
    }
  }

  addLink() async {
    final link = newLinkController.text;
    print(link);
    Uri uri = Uri.parse(storeUrl + customer_id.toString());
    var fdata = {'link': link};
    var response = await http.put(uri, body: fdata, headers: global_headers);

    if (response.statusCode == 200) {
      this.getData();
      newLinkController.text = '';
    }
  }

  getData() async {
    var response = await http.get(Uri.parse(storeUrl + customer_id.toString()));
    var customerData = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      this.name = customerData['name'];
      this.description = customerData['description'];
      this.imgUrl = serverIp + customerData['logo'];
      this.email = customerData['email'];
      this.phones = customerData['phones'];
      this.links = customerData['websites'];
      try {
        this.locationName = customerData['location']['name'];
      } catch (err) {}
      try {
        this.category_name = customerData['category']['name'];
      } catch (err) {}

      newNameController.text = name;
      emailController.text = email;
      descrController.text = this.description.toString();
    });
  }

  void initState() {
    this.getData();
    super.initState();
  }

  callbackLocation(new_value) {
    setState(() {
      locationId = new_value['id'].toString();
      locationName = new_value['name_tm'];
    });
  }

  callbackCategory(new_value) {
    setState(() {
      this.category_id = new_value['id'].toString();
      this.category_name = new_value['name'];
    });
  }

  callbackTC(new_value) {
    setState(() {
      this.tc_id = new_value['id'].toString();
      this.tc_name = new_value['name'];
    });
  }

  deleteImage() async {
    final prefs = await SharedPreferences.getInstance();

    var headers = {'token': await prefs.getString('access_token').toString()};
    var body = {'logo': 'delete'};
    showLoaderDialog(context);
    var response = await http.put(
        Uri.parse(serverIp + '/stores/' + customer_id.toString()),
        body: body,
        headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        imgUrl = ' ';
        prefs.setString('logo_url', '');
      });
    }
    Navigator.of(context).pop();
  }

  save() async {
    String url = storeUrl + customer_id.toString();
    final uri = Uri.parse(url);
    var request = new http.MultipartRequest("PUT", uri);

    var token = await get_access_token();

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    headers['token'] = token;
    request.headers.addAll(headers);
    request.fields['name'] = newNameController.text;
    request.fields['email'] = emailController.text;

    if (this.locationId != null) {
      request.fields['location'] = this.locationId.toString();
    }
    if (this.tc_id != null) {
      request.fields['center'] = this.tc_id.toString();
    }

    if (this.category_id != null) {
      request.fields['category'] = this.category_id.toString();
    }

    request.fields['description'] = descrController.text;

    try {
      var multipart = await http.MultipartFile.fromPath(
        'logo',
        image!.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipart);
    } catch (e) {}

    showLoaderDialog(context);
    final response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      this.callback();
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Ýatda saklandy',
          confirmBtnText: 'OK');
    }

    // ON ERROR
    if (response.statusCode != 200) {
      QuickAlert.show(
          text: 'Error', context: context, type: QuickAlertType.error);
    }
    if (response.statusCode == 401) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: const Text(
            "Profil",
            style: CustomText.appBarText,
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: 100,
                  child: GestureDetector(
                    onTap: () => {pickImage()},
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [
                            BoxShadow(blurRadius: 2, color: Colors.grey)
                          ]),
                      width: 200,
                      height: 200,
                      child: Image.network(
                        this.imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (e, o, c) {
                          return Image.asset(
                            defaulImageUrl,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      deleteImage();
                    },
                    child: Container(
                      width: 140,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text('Suraty aýyrmak')
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: newNameController,
                decoration: InputDecoration(
                    labelText: 'Adyňyz',
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Colors.grey,
                    border: const OutlineInputBorder(),
                    hintText: name,
                    contentPadding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Elektron poçtaňyz',
                    prefixIcon: Icon(Icons.mail),
                    prefixIconColor: Colors.grey,
                    border: const OutlineInputBorder(),
                    hintText: email,
                    contentPadding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: locationController,
                readOnly: true,
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return LocationWidget(callbackFunc: callbackLocation);
                      });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                    label: Text('Ýerleşýän ýeri'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: this.locationName,
                    contentPadding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: categoryController,
                readOnly: true,
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return StoreCategoryDialog(
                          callbackFunc: callbackCategory,
                        );
                      });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.layers),
                    border: OutlineInputBorder(),
                    label: Text('Kategoriýa'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: this.category_name,
                    contentPadding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: tcController,
                readOnly: true,
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return TCSelectorDialog(callbackFunc: callbackTC);
                      });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.business_outlined),
                    border: OutlineInputBorder(),
                    label: Text('Söwda merkezi'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: this.tc_name,
                    contentPadding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 15,
              ),
              Text('Habarlaşmak üçin telefon belgiler'),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: newPhoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    label: Text(''),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // hintText: this.category_name,
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.add),
                      onTap: () {
                        this.addPhone();
                      },
                    ),
                    contentPadding: EdgeInsets.all(10)),
              ),
              Column(
                children: this
                    .phones
                    .map((e) => Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                child: Text(e['phone']),
                              ),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    this.removePhone(e);
                                  },
                                  child: Icon(Icons.delete))
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Text('Sosial sahypalara linkler'),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: newLinkController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                    label: Text(''),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.add),
                      onTap: () {
                        this.addLink();
                      },
                    ),
                    contentPadding: EdgeInsets.all(10)),
              ),
              Column(
                children: this
                    .links
                    .map((e) => Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: e['link']));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.grey,
                                            content: Text(
                                                'Nusgasy göçürlip alyndy')));
                                  },
                                  child: Icon(Icons.link)),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    e['link'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    this.removeLink(e);
                                  },
                                  child: Icon(Icons.delete))
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descrController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      hintText: this.description,
                      labelText: 'Dükan barada'),
                  maxLines: 10,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColor,
                      foregroundColor: Colors.white),
                  child: const Text(
                    'Ýatda sakla',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    save();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
