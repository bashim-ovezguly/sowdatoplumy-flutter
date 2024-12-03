import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';

import 'package:my_app/dB/constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: ListView(scrollDirection: Axis.vertical, children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedImages.map((country) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(10),
                            height: 100,
                            width: 100,
                            alignment: Alignment.topLeft,
                            child: Image.file(
                              country,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            )),
                        Positioned(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.remove(country);
                              });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }).toList(),
            )),
        Container(
          margin: EdgeInsets.all(8),
          child: TextFormField(
            controller: textController,
            maxLines: 10,
            decoration: const InputDecoration(
                labelText: 'Tekst',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                focusColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
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
                        backgroundColor: CustomColors.appColor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      this.save();
                    },
                    child: const Text('Ýatda sakla',
                        style: TextStyle(fontWeight: FontWeight.bold))))),
        SizedBox(height: 200)
      ]),
    );
  }

  save() async {
    final uri = Uri.parse(lentaUrl);
    var request = new http.MultipartRequest("POST", uri);

    Map<String, String> headers = {};

    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }

    headers['token'] = await get_access_token();
    request.headers.addAll(headers);

    request.fields['store'] = await get_store_id();
    request.fields['text'] = textController.text;

    for (var i in selectedImages) {
      var multipart = await http.MultipartFile.fromPath(
        'images',
        i.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipart);
    }
    showLoaderDialog(context);
    final response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showSuccessAlert();
    } else {
      showConfirmationDialogError(context);
    }
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
