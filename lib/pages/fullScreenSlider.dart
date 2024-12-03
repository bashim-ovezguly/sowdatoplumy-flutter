// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_app/dB/constants.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:quickalert/quickalert.dart';

class FullScreenSlider extends StatefulWidget {
  final List<String> imgList;
  FullScreenSlider({Key? key, required this.imgList}) : super(key: key);

  @override
  State<FullScreenSlider> createState() =>
      _FullScreenSliderState(imgList: this.imgList);
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  final List<String> imgList;
  int _current = 0;
  int index = 0;
  bool screen = true;
  int _turns = 0;
  PageController _pageController = PageController(initialPage: 0);

  void _onPressed() {
    setState(() {
      _turns += 1;
    });
  }

  _FullScreenSliderState({required this.imgList});
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        body: Container(
            color: Colors.black,
            child: Column(children: <Widget>[
              Row(children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20, top: 30),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            }))),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      _onPressed();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, top: 30),
                        child:
                            Icon(Icons.screen_rotation, color: Colors.white))),
                GestureDetector(
                    onTap: () async {
                      var response = await Dio().get(imgList[_current],
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data));
                      showSuccessAlert();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, top: 30),
                        child: Icon(Icons.arrow_downward, color: Colors.white)))
              ]),
              Stack(alignment: Alignment.center, children: [
                if (_turns % 2 == 0)
                  RotatedBox(
                      quarterTurns: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 100,
                          child: PhotoViewGallery.builder(
                              itemCount: imgList.length,
                              pageController: _pageController,
                              builder: (BuildContext context, int index) {
                                String myImg = imgList[index];

                                return PhotoViewGalleryPageOptions(
                                  imageProvider: NetworkImage(myImg),
                                );
                              },
                              onPageChanged: (int index) {
                                setState(() {
                                  _current = index;
                                });
                              }))),
                if (_turns % 2 == 1)
                  RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.height - 100,
                          height: MediaQuery.of(context).size.width,
                          child: PhotoViewGallery.builder(
                              itemCount: imgList.length,
                              pageController: _pageController,
                              builder: (BuildContext context, int index) {
                                String myImg = imgList[index];

                                return PhotoViewGalleryPageOptions(
                                    imageProvider: NetworkImage(myImg));
                              },
                              onPageChanged: (int index) {
                                setState(() {
                                  _current = index;
                                });
                              }))),
                Container(color: Colors.amberAccent),
                Positioned(
                    bottom: 10,
                    child: Container(
                        child: DotsIndicator(
                            dotsCount: imgList.length,
                            position: _current.toDouble(),
                            decorator: DotsDecorator(
                                color: Colors.white,
                                activeColor: CustomColors.appColor,
                                activeShape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15.0))))))
              ])
            ])));
  }
}
