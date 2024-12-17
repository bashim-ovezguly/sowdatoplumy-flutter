import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Profile/loadingWidget.dart';
import 'package:my_app/pages/FullScreenImage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileImages extends StatefulWidget {
  final String customer_id;
  final Function callbackFunc;
  const ProfileImages({
    Key? key,
    required this.customer_id,
    required this.callbackFunc,
  }) : super(key: key);

  @override
  State<ProfileImages> createState() => _ProfileImagesState();
}

class _ProfileImagesState extends State<ProfileImages> {
  bool isLoading = false;

  var images = [];

  @override
  void initState() {
    super.initState();
    getImages();
  }

  refreshListFunc() {
    getImages();
  }

  pickImage() async {
    List<File> selectedImages = [];

    final picker = ImagePicker();

    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        }
      },
    );

    var request = new http.MultipartRequest(
        "PUT", Uri.parse(serverIp + '/mob/stores/' + widget.customer_id));
    for (var i in selectedImages) {
      var multiport = await http.MultipartFile.fromPath(
        'images',
        i.path,
      );
      request.files.add(multiport);
    }

    var token = await get_access_token();
    Map<String, String> headers = {};
    headers['token'] = token;
    showLoaderDialog(context);
    final response = await request.send();
    if (response.statusCode == 200) {
      getImages();
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Surat goşuldy',
        confirmBtnText: 'OK',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.success,
      );
    } else {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Error',
        confirmBtnText: 'OK',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.error,
      );
    }
  }

  void getImages() async {
    Uri uri = Uri.parse(storesUrl + '/' + widget.customer_id.toString());
    var response = await http.get(uri);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;

      try {
        this.images = data['images'];
      } catch (err) {}
    });
  }

  void deleteImage(imgId, index) async {
    Uri uri =
        Uri.parse(serverIp + '/mob/stores/img/delete/' + imgId.toString());
    var response = await http.post(uri);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var tempArray = this.images;
      tempArray.remove(tempArray.elementAt(index));
      setState(() {
        images = tempArray;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
              "Suratlar " + this.images.length.toString(),
              style: CustomText.appBarText,
            ),
            actions: []),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDatasPage(
                          index: 2,
                        )));
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 1)
            ]),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Icon(Icons.add, size: 35, color: Colors.white)),
                  )),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Wrap(
              children: this.images.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FullScreenImage(img: serverIp + item['img_m']);
                    }));
                  },
                  child: Stack(
                    children: [
                      Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200)),
                          width: MediaQuery.sizeOf(context).width / 3 - 5,
                          height: MediaQuery.sizeOf(context).width / 3 - 5,
                          margin: EdgeInsets.all(1),
                          child: Image.network(
                            serverIp + item['img_m'],
                            fit: BoxFit.cover,
                            errorBuilder: (e, o, c) {
                              return Image.asset(defaulImageUrl);
                            },
                          )),
                      GestureDetector(
                        onTap: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              cancelBtnText: 'Ýok',
                              confirmBtnText: 'Hawa',
                              confirmBtnColor: Colors.green,
                              headerBackgroundColor: Colors.grey,
                              title: 'Tassyklaň',
                              onConfirmBtnTap: () {
                                this.deleteImage(
                                    item['id'], this.images.indexOf(item));
                              },
                              text: 'Bozmaga ynamyňyz barmy?');
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
