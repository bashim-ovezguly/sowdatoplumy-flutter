import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_app/dB/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';


import 'dart:math' as math;



class FullScreenSlider extends StatefulWidget {
  final List<String>  imgList ;
  FullScreenSlider({Key? key, required this.imgList}) : super(key: key);

  @override
  State<FullScreenSlider> createState() => _FullScreenSliderState(imgList: this.imgList);
}


class _FullScreenSliderState extends State<FullScreenSlider> {

  final List<String>  imgList ;
  double? _progres ; 
  String name = 'ababajn.jpg';
  int _current = 0;
  int index = 0;
  change_index(value){
    setState(() {
      index = value;
    });
  }

  _FullScreenSliderState({required this.imgList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Expanded(child: Row(
                children: [
                  Expanded(flex: 1, child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 30,left: 20),
                  child: GestureDetector(
                    child: const Icon(Icons.arrow_back, size: 30, color: Color.fromARGB(255, 255, 255, 255),),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  )
                  )),
                  Spacer(),
                ],
              )),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: GestureDetector(
                      child:  CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height-60,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {setState(() {_current = index;});}
                        ),
                        items: imgList
                            .map((item) => Container(
                          color: Colors.black,
                          child: Stack(
                            children: [
                              PhotoView(
                            imageProvider: NetworkImage(item.toString()),
                              backgroundDecoration: BoxDecoration(color: Colors.black),
                              customSize: MediaQuery.of(context).size,
                              minScale: PhotoViewComputedScale.contained * 0.8,
                              maxScale: PhotoViewComputedScale.covered * 1.8,
                              initialScale: PhotoViewComputedScale.contained,
                              )       
                            ]
                      )
                      )).toList()),
                     )
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                    child: DotsIndicator(
                      dotsCount: imgList.length,
                      position: _current.toDouble(),
                      decorator: DotsDecorator(
                        color: Colors.white,
                        activeColor: CustomColors.appColors,
                        activeShape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)))))
                    )
                ])
            ]
          )
          )
    )
    
    ;
  }

  // void image_dowland(int index){
  //   print(index);
  //   print(imgList[index]);

  //   FileDownloader.downloadFile(url:imgList[index], onProgress: (fileName, progress) => {
  //     set
  //   },)
  // }

}

