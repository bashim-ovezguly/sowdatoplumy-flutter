import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/widgets/inputText.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../main.dart';

class LentaEdit extends StatefulWidget {
  final String id;
  final Function refreshListFunc;
  LentaEdit({Key? key, required this.id, required this.refreshListFunc})
      : super(key: key);

  @override
  State<LentaEdit> createState() => _LentaEditState();
}

class _LentaEditState extends State<LentaEdit> {
  var data = {};
  bool isLoading = false;

  @override
  void initState() {
    getData(id: widget.id);
    super.initState();
  }

  void setText(new_value) {
    setState(() {
      textController.text = new_value;
    });
  }

  remove_image() {
    getData(id: widget.id);
  }

  final textController = TextEditingController();
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
            int sizeInBytes = File(xfilePick[i].path).lengthSync();
            var j = (log(sizeInBytes) / log(1024)).floor();
            double sizeInMb = sizeInBytes / pow(1024, j);
            if (sizeInMb > 5000) {
            } else {
              selectedImages.add(File(xfilePick[i].path));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Surat saýlamadyňyz!')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    showErrorAlert(String text) {
      QuickAlert.show(
          text: text,
          title: "Ýalňyşlyk ýüze çykdy!",
          confirmBtnColor: Colors.green,
          confirmBtnText: 'Dowam et',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
          context: context,
          type: QuickAlertType.error);
    }

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(title: Text("Lenta ", style: CustomText.appBarText)),
        body: isLoading
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    InputText(
                        title: "Giňişleýin maglumat",
                        height: 250.0,
                        callFunc: setText,
                        oldData: data['text'].toString()),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColor),
                          onPressed: () {
                            getImages();
                          },
                          child: Text(
                            'Surat goşmak',
                            style: TextStyle(color: CustomColors.appColorWhite),
                          ),
                        ),
                      ],
                    ),
                    if (data['images'].length > 0)
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Suratlar " +
                                      data['images'].length.toString(),
                                  style: TextStyle(
                                      color: CustomColors.appColor,
                                      fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    for (var country in data['images'])
                                      Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  height: 100,
                                                  width: 100,
                                                  alignment: Alignment.topLeft,
                                                  child: Image.network(
                                                    serverIp + country['img'],
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: CustomColors
                                                              .appColor,
                                                        ),
                                                      );
                                                    },
                                                  )),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DeleteImage(
                                                        action: 'lenta',
                                                        image: country,
                                                        callbackFunc:
                                                            remove_image,
                                                      );
                                                    },
                                                  );
                                                  widget.refreshListFunc();
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.red),
                                                  alignment: Alignment.topRight,
                                                  child: Icon(Icons.close,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ],
                                )
                              ])),
                    if (selectedImages.length > 0)
                      Row(
                        children: [
                          Text('Täze surat ' + selectedImages.length.toString(),
                              style: TextStyle(color: CustomColors.appColor)),
                        ],
                      ),
                    if (selectedImages.length > 0)
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: const EdgeInsets.only(
                                              left: 10, bottom: 10),
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
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Icon(Icons.close,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }).toList(),
                          )),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(color: CustomColors.appColor)),
        floatingActionButton: Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String url = serverIp + '/mob/lenta/' + widget.id;
                  final uri = Uri.parse(url);
                  var request = new http.MultipartRequest("PUT", uri);
                  Map<String, String> headers = {};

                  headers['token'] = await get_access_token();
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
                    widget.refreshListFunc();
                    Navigator.pop(context);
                    // showSuccess(context);
                  } else {
                    showErrorAlert('Lenta üýtgetmek');
                  }
                },
                child: Text('Ýatda sakla',
                    style: TextStyle(color: Colors.white)))));
  }

  void getData({required id}) async {
    String url = serverIp + '/mob/lenta/' + id;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['msg'];
      isLoading = true;
      textController.text = data['text'].toString();
    });
  }
}
