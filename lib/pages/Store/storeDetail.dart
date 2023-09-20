import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../fullScreenSlider.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key}) : super(key: key);

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGNhcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjJ8fGNhcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
  ];

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dükanlar", style: CustomText.appBarText,),),
      body: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.bottomCenter,
                textDirection: TextDirection.rtl,
                fit: StackFit.loose,
                clipBehavior: Clip.hardEdge,
                children: [
                Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: GestureDetector(
                  child:  CarouselSlider(
                    options: CarouselOptions(
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
                      color: Colors.white,
                      child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Image border
                            child: Image.network(item, fit: BoxFit.fill, height: 200,width: double.infinity,),)
                      ),)).toList(),),
                  onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) )); },),),

                  Container(
                    margin: EdgeInsets.only(bottom: 7),
                    child: DotsIndicator(
                      dotsCount: imgList.length,
                      position: _current.toDouble(),
                      decorator: DotsDecorator(
                        color: Colors.white,
                        activeColor: CustomColors.appColors,
                        activeShape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),),)
                ],
              );
            })),

          SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return    Container(
                  margin: EdgeInsets.only(left: 10,right: 10, top: 20),
                  height: 30,
                  child: Row(children: [
                    Expanded(child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.location_on, color: Colors.black54,),
                        SizedBox(width: 10,),
                        Text("Ýerleşýän ýeri", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                    Expanded(child: Text("Änew",  style: TextStyle(fontSize: 17, color: CustomColors.appColors)))],),);
              })),

          SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    height: 30,
                    child: Row(children: [
                      Expanded(child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                          SizedBox(width: 10,),
                          Text("Ady", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                      Expanded(child: Text("Arzuw market",  style: TextStyle(fontSize: 17, color: CustomColors.appColors)))],),);
              })),

          SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    height: 50,
                    child: Row(children: [
                      Expanded(child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.location_on, color: Colors.black54,),
                          SizedBox(width: 10,),
                          Text("Address", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                      Expanded(child: Text("Berkakarlyk etrap. Magtymguly koçesi",  style: TextStyle(fontSize: 17, color: CustomColors.appColors)))],),);
                  })),

          SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return           Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  height: 50,
                  child: Row(children: [
                    Expanded(child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.timer_sharp, color: Colors.black54,),
                        SizedBox(width: 10,),
                        Text("Iş wagty", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                    Expanded(child: Text("08:00 - 20:00",  style: TextStyle(fontSize: 17, color: CustomColors.appColors)))],),);
              })),

          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                alignment: Alignment.center,
                child: Text("HARYTLARY", style: TextStyle(color: Colors.black54, fontSize: 17, fontWeight: FontWeight.bold),),
              );},)),
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 5,
                (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(child: Card(
                      elevation: 2,
                      child: Container(
                        height: 250,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              height: 220,
                              child: Image.network(
                                'https://offautan-uc1.azureedge.net/-/media/images/off/ph/products-en/products-landing/landing/off_overtime_product_collections_large_2x.jpg?la=en-ph',
                                fit: BoxFit.cover,
                                height: 220,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Text("ProductName", style: TextStyle(fontSize: 18, color: CustomColors.appColors),)
                            ),
                          ],
                        ),
                      ),
                    )
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Card(
                      elevation: 2,
                      child: Container(
                        height: 250,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              height: 220,
                              child: Image.network(
                                'https://offautan-uc1.azureedge.net/-/media/images/off/ph/products-en/products-landing/landing/off_kids_product_collections_large_2x.jpg?la=en-ph',
                                fit: BoxFit.cover,
                                height: 220,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Text("ProductName", style: TextStyle(fontSize: 18, color: CustomColors.appColors),)
                            ),
                          ],
                        ),
                      ),
                    )
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              );
            },)),
        ],
      )
      );
  }
}
