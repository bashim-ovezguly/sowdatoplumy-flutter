// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_app/dB/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:quickalert/quickalert.dart';

class FullScreenSlider extends StatefulWidget {
  final List<String> imgList;
  final int current;
  FullScreenSlider({Key? key, required this.imgList, this.current = 0})
      : super(key: key);

  @override
  State<FullScreenSlider> createState() =>
      _FullScreenSliderState(imgList: this.imgList, current: this.current);
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  _FullScreenSliderState({required this.imgList, required this.current});

  final List<String> imgList;
  int current;
  bool screen = true;
  int _turns = 0;
  PageController _pageController = PageController();

  void _onPressed() {
    setState(() {
      _turns += 1;
    });
  }

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
  void initState() {
    super.initState();
    this._pageController = PageController(initialPage: this.current);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.white,
            child: Column(children: <Widget>[
              Row(children: [
                Expanded(
                    child: Container(
                        color: Colors.transparent,
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
                            }))),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      _onPressed();
                    },
                    child: Container(
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(right: 20, top: 30),
                        child: Icon(Icons.screen_rotation,
                            color: CustomColors.appColor))),
                GestureDetector(
                    onTap: () async {
                      var response = await Dio().get(imgList[current],
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data));
                      showSuccessAlert();
                    },
                    child: Container(
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(right: 20, top: 30),
                        child: Icon(Icons.arrow_downward,
                            color: CustomColors.appColor)))
              ]),
              Container(
                child: Stack(alignment: Alignment.center, children: [
                  if (_turns % 2 == 0)
                    RotatedBox(
                        quarterTurns: 0,
                        child: Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 100,
                            child: PhotoViewGallery.builder(
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.transparent),
                                itemCount: imgList.length,
                                pageController: _pageController,
                                builder: (BuildContext context, int index) {
                                  String myImg = imgList[this.current];
                                  return PhotoViewGalleryPageOptions(
                                    minScale: PhotoViewComputedScale.contained,
                                    imageProvider: NetworkImage(myImg),
                                  );
                                },
                                onPageChanged: (int index) {
                                  setState(() {
                                    current = index;
                                  });
                                }))),
                  if (_turns % 2 == 1)
                    RotatedBox(
                        quarterTurns: 1,
                        child: Container(
                            // color: Colors.white,
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.height - 100,
                            height: MediaQuery.of(context).size.width,
                            child: PhotoViewGallery.builder(
                                itemCount: imgList.length,
                                enableRotation: true,
                                pageController: _pageController,
                                builder: (BuildContext context, int index) {
                                  String myImg = imgList[this.current];

                                  return PhotoViewGalleryPageOptions(
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      imageProvider: NetworkImage(myImg));
                                },
                                onPageChanged: (int index) {
                                  setState(() {
                                    current = index;
                                  });
                                }))),
                  Positioned(
                      bottom: 10,
                      child: Container(
                          child: DotsIndicator(
                              dotsCount: imgList.length,
                              position: current.toDouble(),
                              decorator: DotsDecorator(
                                  color: CustomColors.appColor,
                                  activeColor: Colors.grey,
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0))))))
                ]),
              )
            ])));
  }
}
