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
                  // Row(
                  //   children: [
                  //     Container(
                  // margin: const EdgeInsets.only(top: 30),
                  // child: GestureDetector(
                  //   child: const Icon(Icons.download, color: Color.fromARGB(255, 255, 255, 255),),
                  //   onTap: (){
                  //      print(imgList[index]);

                  //       FileDownloader.downloadFile(url:imgList[index].trim(), onProgress: (name, progress) => {
                  //         setState(() {
                  //           _progres = progress;
                  //         },) 
                  //       },
                  //       onDownloadCompleted: (value){
                  //         print('path $value');
                  //         setState(() {
                  //           _progres = null;
                  //         });
                  //       }
                  //       );
                  //   },
                  // )
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  //   child: const Icon(Icons.wifi_protected_setup_outlined, color: Color.fromARGB(255, 255, 255, 255),),
                  // )
                  //   ],
                  // )
                ],
              )),
              Expanded(flex: 10, child: Align(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    onPageChanged: (index, reason) => {
                      change_index(index),
                      setState((){
                        _current = index;
                      })
                    },

                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      autoPlay: true
                  ),
                  items: imgList
                      .map((item) =>
                      Stack(
                        children: [
                          PhotoView(
                        imageProvider: NetworkImage(item.toString()),
                          backgroundDecoration: BoxDecoration(color: Colors.black),
                          customSize: MediaQuery.of(context).size,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 1.8,
                          initialScale: PhotoViewComputedScale.contained,
                          ),
                          
                            Container(
                              alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 10),
                            child: DotsIndicator(
                              dotsCount: imgList.length,
                              position: _current.toDouble(),
                              decorator: DotsDecorator(
                                color: Colors.white,
                                activeColor: CustomColors.appColors,
                                activeShape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),),),
                          
                        ],
                      ),
                      
              
                      ).toList(),),
              )
              )
            ],
          ),
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

