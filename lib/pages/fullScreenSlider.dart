import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_app/dB/colors.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:quickalert/quickalert.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class FullScreenSlider extends StatefulWidget {
  final List<String> imgList;
  FullScreenSlider({Key? key, required this.imgList}) : super(key: key);

  @override
  State<FullScreenSlider> createState() =>
      _FullScreenSliderState(imgList: this.imgList);
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  final List<String> imgList;
  String name = 'ababajn.jpg';
  int _current = 0;
  int index = 0;
  bool screen = true;
  change_index(value) {
    setState(() {
      index = value;
      bool screen = true;
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
          confirmBtnColor: CustomColors.appColors,
          type: QuickAlertType.success,
          onConfirmBtnTap: () {
            Navigator.pop(context);
          });
    }

    return Scaffold(
      body: screen == false
          ? RotatedBox(
              quarterTurns: 1,
              child: Container(
                  color: Colors.black,
                  child: Column(children: <Widget>[
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(left: 20, top: 30),
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ))),
                        Spacer(),
                        GestureDetector(
                            onTap: () async {
                              setState(() {
                                screen = !screen;
                              });
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 30),
                                child: Icon(Icons.screen_rotation,
                                    color: Colors.white))),
                        GestureDetector(
                            onTap: () async {
                              var response = await Dio().get(imgList[_current],
                                  options: Options(
                                      responseType: ResponseType.bytes));
                              final result = await ImageGallerySaver.saveImage(
                                  Uint8List.fromList(response.data));
                              showSuccessAlert();
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 30),
                                child: Icon(Icons.arrow_downward,
                                    color: Colors.white)))
                      ],
                    )),
                    Stack(alignment: Alignment.center, children: [
                      Container(
                          child: GestureDetector(
                        child: CarouselSlider(
                            options: CarouselOptions(
                                height: MediaQuery.of(context).size.width - 60,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.3,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                            items: imgList
                                .map((item) => Container(
                                    color: Colors.black,
                                    child: Stack(children: [
                                      
                                      PhotoView(
                                        imageProvider:
                                            NetworkImage(item.toString()),
                                        // backgroundDecoration: BoxDecoration(color: Colors.black),
                                        customSize: MediaQuery.of(context).size,
                                        // minScale:
                                        //     PhotoViewComputedScale.contained *
                                        //         0.8,
                                        // maxScale:
                                        //     PhotoViewComputedScale.covered *
                                        //         1.8,
                                        // initialScale:
                                        //     PhotoViewComputedScale.contained,
                                      )
                                    ])))
                                .toList()),
                      )),
                      Positioned(
                          bottom: 10,
                          child: Container(
                              child: DotsIndicator(
                                  dotsCount: imgList.length,
                                  position: _current.toDouble(),
                                  decorator: DotsDecorator(
                                      color: Colors.white,
                                      activeColor: CustomColors.appColors,
                                      activeShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0))))))
                    ])
                  ])),
            )
          : Container(
              color: Colors.black,
              child: Column(children: <Widget>[
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, top: 30),
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              child: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ))),
                    Spacer(),
                    GestureDetector(
                        onTap: () async {
                          setState(() {
                            screen = !screen;
                          });
                        },
                        child: Container(
                            margin: const EdgeInsets.only(right: 20, top: 30),
                            child: Icon(Icons.screen_rotation,
                                color: Colors.white))),
                    GestureDetector(
                        onTap: () async {
                          var response = await Dio().get(imgList[_current],
                              options:
                                  Options(responseType: ResponseType.bytes));
                          final result = await ImageGallerySaver.saveImage(
                              Uint8List.fromList(response.data));
                          showSuccessAlert();
                        },
                        child: Container(
                            margin: const EdgeInsets.only(right: 20, top: 30),
                            child: Icon(Icons.arrow_downward,
                                color: Colors.white)))
                  ],
                )),
                Stack(alignment: Alignment.center, children: [
                  Container(
                      child: GestureDetector(
                    child: CarouselSlider(
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height - 60,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        items: imgList
                            .map((item) => Container(
                                color: Colors.black,
                                child: Stack(children: [
                                  PhotoView(
                                    imageProvider:
                                        NetworkImage(item.toString()),
                                    backgroundDecoration:
                                        BoxDecoration(color: Colors.black),
                                    customSize: MediaQuery.of(context).size,
                                    minScale:
                                        PhotoViewComputedScale.contained * 0.8,
                                    maxScale:
                                        PhotoViewComputedScale.covered * 1.8,
                                    initialScale:
                                        PhotoViewComputedScale.contained,
                                  )
                                ])))
                            .toList()),
                  )),
                  Positioned(
                      bottom: 10,
                      child: Container(
                          child: DotsIndicator(
                              dotsCount: imgList.length,
                              position: _current.toDouble(),
                              decorator: DotsDecorator(
                                  color: Colors.white,
                                  activeColor: CustomColors.appColors,
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0))))))
                ])
              ])),
    );
  }
}
