// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_app/dB/constants.dart';
import 'package:quickalert/quickalert.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatefulWidget {
  final String img;
  FullScreenImage({Key? key, required this.img}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState(img: this.img);
}

class _FullScreenImageState extends State<FullScreenImage> {
  final String img;
  int index = 0;
  bool screen = true;
  int _turns = 0;

  void _onPressed() {
    setState(() {
      _turns += 1;
    });
  }

  _FullScreenImageState({required this.img});

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Suran ýüklenildi!',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.success,
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          color: Colors.white,
          child: Column(children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20, top: 30),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          child: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: CustomColors.appColor,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ))),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      _onPressed();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, top: 30),
                        child: Icon(Icons.screen_rotation,
                            color: CustomColors.appColor))),
                GestureDetector(
                    onTap: () async {
                      var response = await Dio().get(img,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data));
                      showSuccessAlert();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, top: 30),
                        child: Icon(Icons.arrow_downward,
                            color: CustomColors.appColor)))
              ],
            ),
            Stack(alignment: Alignment.center, children: [
              if (_turns % 2 == 0)
                RotatedBox(
                  quarterTurns: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 100,
                      child: PhotoView(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        minScale: PhotoViewComputedScale.contained,
                        imageProvider: NetworkImage(
                          img.toString(),
                        ),
                        customSize: MediaQuery.of(context).size,
                      )),
                ),
              if (_turns % 2 == 1)
                RotatedBox(
                  quarterTurns: 1,
                  child: Container(
                      width: MediaQuery.of(context).size.height - 100,
                      height: MediaQuery.of(context).size.width,
                      child: PhotoView(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        minScale: PhotoViewComputedScale.contained,
                        imageProvider: NetworkImage(
                          img.toString(),
                        ),
                        customSize: MediaQuery.of(context).size,
                      )),
                ),
            ])
          ])),
    );
  }
}
