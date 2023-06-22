import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';



class FullScreenSlider extends StatelessWidget {
  const FullScreenSlider({Key? key, required this.imgList}) : super(key: key);

  final List<String>  imgList ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Expanded(flex: 1, child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 30,left: 20),
                  child: GestureDetector(
                    child: const Icon(Icons.arrow_back, size: 30, color: Colors.white,),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  )
              )),
              Expanded(flex: 10, child: Align(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.5,
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      autoPlay: true
                  ),
                  items: imgList
                      .map((item) =>
                      PhotoView(
                        imageProvider: NetworkImage(item.toString()),
                        
                          backgroundDecoration: BoxDecoration(color: Colors.black),
                          customSize: MediaQuery.of(context).size,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 1.8,
                          initialScale: PhotoViewComputedScale.contained,
                          )
                      // InteractiveViewer(
                      //   clipBehavior: Clip.none,
                      //   child: AspectRatio(
                      //     aspectRatio: 1.1,
                      //     child: ClipRect(
                      //     child: Container(
                      //       width: double.infinity,
                      //       child:  FittedBox(
                      //         fit: BoxFit.fill,
                      //         child: item != '' ? Image.network(item.toString(),):
                      //         Image.asset('assets/images/default_cars.jpg'),),
                      //         ),),
                      //   )
                      // )
                      ).toList(),),
              )
              )
            ],
          ),
        )
    );
  }
}