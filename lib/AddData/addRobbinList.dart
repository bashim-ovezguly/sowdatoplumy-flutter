import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/providers.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddRobbinList extends StatefulWidget {
  const AddRobbinList({super.key});

  @override
  State<AddRobbinList> createState() => _AddRobbinListState();
}

class _AddRobbinListState extends State<AddRobbinList> {
  List<dynamic> categories = [];
  List<File> selectedImages = [];
  List<dynamic> stores = [];

  var storesController = {};
  var locationController = {};
  var categoryController = {};

  final picker = ImagePicker();
  final textController = TextEditingController();

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
    super.initState();
  }

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Lenta goşuldy. Operatoryň tassyklamagyna garaşyň',
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
            height: 250,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: textController,
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
              return Column(
                children: [
                  Stack(
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
                  )
                ],
              );
            }).toList(),
          )),
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
                    var allRows = await dbHelper.queryAllRows();

                    var data = [];
                    for (final row in allRows) {
                      data.add(row);
                    }
                    Urls server_url = new Urls();
                    String url = server_url.get_server_url() + '/mob/lenta';
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

                    request.fields['text'] = textController.text;
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
                      showConfirmationDialogError(context);
                    }
                  },
                  child: const Text('Ýatda sakla',
                      style: TextStyle(fontWeight: FontWeight.bold))))),
      SizedBox(height: 200)
    ]);
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
