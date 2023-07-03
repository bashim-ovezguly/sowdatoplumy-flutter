import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Awtoparts/awtoPartsDetail.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import '../dB/textStyle.dart';


class AdPage extends StatefulWidget {
  AdPage({Key? key,  required this.id}) : super(key: key);
  final String id ;
  @override
  State<AdPage> createState() => _AdPageState(id: id);
}
class _AdPageState extends State<AdPage> {
  final String id ;
  List<String> imgList = [];
  var data = {};
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  
  @override
  initState() {
    getsinglecar(id: id);
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    super.initState();
  }
  _AdPageState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reklama hyzmaty", style: CustomText.appBarText,),),
    
      body: determinate? ListView(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            textDirection: TextDirection.rtl,
            fit: StackFit.loose,
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
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
                    items: imgList.map((item) => Container(
                      color: Colors.white,
                      child: ClipRect(child: Container(
                        height: 200,
                        width: double.infinity,
                        child:  FittedBox(
                          fit: BoxFit.cover,
                          child: item != '' ? Image.network(item.toString(),):
                          Image.asset('assets/images/default.jpg'),),
                          ),),)).toList(),),
                  onTap: (){ 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) ));
                     },),),

              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: DotsIndicator(
                  dotsCount: imgList.length,
                  position: _current.toDouble(),
                  decorator: DotsDecorator(
                    color: Colors.white,
                    activeColor: CustomColors.appColors,
                    activeShape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),),),
            ],),
          
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10,top: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.near_me, color: Colors.grey,size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Ady", size: 16.0),)],),),
                    Expanded(child: SizedBox(child: TextValueWidget(text: data['title_tm'].toString(), size: 16.0),))
              ],),),

            Container(
            height: 40,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.location_on, color: Colors.grey,size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Ýerleşýän ýeri", size:16.0),),],),),
                    Expanded(child: SizedBox(child: TextValueWidget(text: data['location'].toString(), size: 16.0)))
              ],),),
                 
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.phone, color: Colors.grey,size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Telefon", size:16.0),),],),),
                    Expanded(child: SizedBox(child: data['phone']!=null && data['phone']!='' ? TextValueWidget(text: data['phone'].toString(), size: 16.0):
                    TextValueWidget(text: '', size: 16.0)
                    ))
              ],),),
          Container(
            height: 100,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black26)),
            child: Text(
              data['body_tm'].toString(),
              style: TextStyle(fontSize: 17, color: CustomColors.appColors),
              maxLines: 3,
              ),),
        ],
      ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
    );
  }
  void getsinglecar({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/ads/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        baseurl =  server_url.get_server_url();
        // ignore: unused_local_variable
        var i;
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img']);
        }
      if (imgList.length==0){
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
      }
      determinate = true;
    });
  }
}
