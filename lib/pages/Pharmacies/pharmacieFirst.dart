import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
  
import 'package:my_app/dB/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dB/textStyle.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';


class PharmacieFirst extends StatefulWidget {
  PharmacieFirst({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<PharmacieFirst> createState() => _PharmacieFirstState(id: id);
}

class _PharmacieFirstState extends State<PharmacieFirst> {
  final String id;
  int _current = 0;
  var baseurl = "";
  var telefon = {};
  var data = {};
  var data_tel = []; 
  List<dynamic> products = [];
  List<String> imgList = [ ];
  bool slider_img = true;
  bool determinate = false;
  
  void initState() {
    if (imgList.length==0){
      imgList.add('https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-building-under-construction-image_1141142.jpg');
    }
    getsinglepharmacies(id: id);
    super.initState();
  }

  _PharmacieFirstState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dermanhanalar", style: CustomText.appBarText,),
        actions: [
        ],),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: () async {
            setState(() {
            determinate = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: determinate ? CustomScrollView(
          slivers: [
            SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(left: 15, top: 5,),
                alignment: Alignment.topLeft,
                child: Text(data['name_tm'].toString(),
                  style:  TextStyle(fontSize: 18, color: CustomColors.appColors, fontWeight: FontWeight.bold)),
           );},)),

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
                margin: const EdgeInsets.all(10),
                child: GestureDetector(
                  child:  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
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
                          child: ClipRect(
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child:  FittedBox(
                              fit: BoxFit.cover,
                              child: item != '' && slider_img==true ? Image.network(item.toString(),):
                              Image.asset('assets/images/default16x9.jpg'),),
                              ),),
                      ),)).toList(),),
                  onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) )); },),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: DotsIndicator(
                  dotsCount: imgList.length,
                  position: _current.toDouble(),
                  decorator: DotsDecorator(
                    color: Colors.white,
                    activeColor: CustomColors.appColors,
                    activeShape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),),)
            ],);},)),
            
            
            
            SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (BuildContext context, int index) {
              return Row(
            children: <Widget>[
              Expanded(flex: 4,child: Row(
                children:  <Widget>[

                  SizedBox(width: 10,),
                  Icon(Icons.access_time_outlined,size: 20,color: CustomColors.appColors,),
                  SizedBox(width: 10,),
                  Text(data['created_at'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      color: CustomColors.appColors,
                    ),
                  ),
                ],
              ),),
              Spacer(),
              Expanded(child: Row(
                children:  <Widget>[
                  Icon(Icons.visibility_sharp,size: 20,color: CustomColors.appColors,),
                  SizedBox(width: 10,),
                  Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                  ),),],),
              )
            ],
          );},)),

            SliverList(delegate: SliverChildBuilderDelegate(childCount: 1,(BuildContext context, int index) {return Container(height: 15,);},)),

            SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (BuildContext context, int index) {
              return  SizedBox(
                child: Row(children: [
                  Expanded(child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Icon(Icons.location_on, color: Colors.black54,),
                      SizedBox(width: 10,),
                      Text("Address", style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                  Expanded(child: Text(data['address'].toString(),  style: TextStyle(fontSize: 14, color: CustomColors.appColors))),
                  SizedBox(width: 10,),],),);},)),

          SliverList(delegate: SliverChildBuilderDelegate(childCount: 1,(BuildContext context, int index) {return Container(height: 10,);},)),

           if (data_tel.length > 0)
              SliverList(delegate: SliverChildBuilderDelegate(
                      childCount: 1,
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                            Expanded(child: Row(
                              children: [
                                SizedBox(width: 20,),
                                Icon(Icons.phone, color: Colors.black54,),
                                SizedBox(width: 10,),
                                Text("Telefon", style: TextStyle(fontSize: 14, color: Colors.black54),),],),),
                            if (telefon != {})
                            Expanded(child: Row(
                              children: [
                                 Icon(Icons.phone_android_outlined, color: CustomColors.appColors,),
                                 SizedBox(width: 10,),
                                 GestureDetector(
                                  onTap: () async {
                                    final call = Uri.parse('tel:'+ telefon['phone'].toString());
                                      if (await canLaunchUrl(call)) {
                                        launchUrl(call);}
                                      else {
                                        throw 'Could not launch $call';
                                        }
                                  },
                                  child: Text(
                                  telefon['phone'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold),),
                                )
                              ],
                            )),
                              
                              ],)
                        );},)),

                  SliverList(delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, int index) {
                    return Column(
                    children: [
                      for(var i in data_tel)
                      if (i!=telefon)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(child: Text('')),
                                Expanded(child: Row(
                                  children: [
                                Icon(Icons.phone_android_outlined, color: CustomColors.appColors,),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () async {
                                    final call = Uri.parse('tel:'+ i['phone'].toString());
                                      if (await canLaunchUrl(call)) {
                                        launchUrl(call);}
                                      else {
                                        throw 'Could not launch $call';
                                        }
                                  },
                                  child: Text(
                                  i['phone'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.appColors,
                                    fontWeight: FontWeight.bold),),
                                )
                                  ],
                                ))
                              ],
                            )
                        )
                    ],
                  ) ;},)),

          
        
        if (data['ad'] != null && data['ad'] !='')
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (BuildContext context, int index) {
              return  Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(" Reklama hyzmaty",
                    style:  TextStyle(
                        fontSize: 17,
                        color: CustomColors.appColors,
                        fontWeight: FontWeight.bold),),
                  Container(
                    color: Color.fromARGB(96, 214, 214, 214),
                    child: Image.network(baseurl + data['img'].toString(),
                        fit: BoxFit.fitHeight, height: 160, width: double.infinity),),
                ],),);},)),

          
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                alignment: Alignment.center,
                child: Text("Harytlar", style: TextStyle(color: Colors.black54, fontSize: 17, fontWeight: FontWeight.bold),),
              );
            },)),
            
            SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (BuildContext context, int index) {
              return  GestureDetector(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: item['id'].toString(), title: 'Harytlar',)));

                },
                child: Container(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: products.map((item) {
                    return GestureDetector(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: item['id'].toString(), title: 'Dermanhanalar',)));

                      },
                      child: Card(
                      elevation: 2,
                      child: Container(
                        height: 240,
                        width: 170,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: item['img']!=null &&  item['img']!="" ? Image.network(
                                baseurl + item['img'].toString(),
                                fit: BoxFit.cover,
                                height: 200,
                              ): Image.asset('assets/images/default.jpg', fit: BoxFit.cover, height: 200,)
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     Text(item['name'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis),),
                                     Text(item['price'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis),),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),  
                    ),
                    );
                  }).toList(),
                ),
              ),
              );

              },)),
          ],
      ):Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
      )
    );
  }

  void getsinglepharmacies({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/pharmacies/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        baseurl =  server_url.get_server_url();
        data_tel = json['phones'];
        products = json['products'];
        if (json['phones'].length!=0){
          telefon = json['phones'][0]; 
        }
        var i;
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img_l']);
        }
      if (imgList.length==0){
        slider_img = false;
        imgList.add('https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-building-under-construction-image_1141142.jpg');
      }
      determinate = true;

    });
  }
}
