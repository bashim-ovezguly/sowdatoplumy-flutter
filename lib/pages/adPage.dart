import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Awtoparts/awtoPartsDetail.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/fullScreenSlider.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool status = true;
  
  @override
  initState() {
    timers();
    getsinglecar(id: id);
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    super.initState();
  }

  timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }
  _AdPageState({required this.id});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(title: data['title_tm']!=null && data['title_tm']!='' ? Text(data['title_tm'].toString(), style: CustomText.appBarText): Text('')),
    
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
                      autoPlay: imgList.length>1 ? true: false,
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
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)))))
            ]),
          
          SizedBox(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.near_me, color: Colors.grey,size: 20),
                    SizedBox(child: const TextKeyWidget(text: "Ady", size: 16.0))])),
                    Expanded(child: SizedBox(child: Text(data['title_tm'].toString(), style: TextStyle(color: CustomColors.appColors)))),
                    SizedBox(width: 10)
              ])),
            
            SizedBox(height: 10),
            SizedBox(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.location_on, color: Colors.grey,size: 20,),
                    SizedBox(child: const TextKeyWidget(text: "Ýerleşýän ýeri", size:16.0))])),
                    Expanded(child: SizedBox(child: Text( data['location'].toString(), style: TextStyle(color: CustomColors.appColors)))),
                SizedBox(width: 10)
              ])),
            
            if (data['store']!=null && data['store']!='')
            SizedBox(height: 10),
            SizedBox(
              child: Row(
                children: [
                  Expanded(child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.store, color: Colors.grey,size: 20),
                    SizedBox(width: 10),
                    SizedBox(child: const TextKeyWidget(text: "Söwda nokat", size:16.0))
                    ],),),

                   Expanded(child:Container(
                    height: 25,
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        if (data['store']!=null && data['store_id']!=''){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: data['store_id'].toString(), title: 'Söwda nokatlar')));
                        }
                      },
                      child: Text(data['store'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomText.itemText,
                      )))),
                      SizedBox(width: 10)
                ],
              ),
            ),

          SizedBox(height: 10),
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.phone, color: Colors.grey,size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, child: const TextKeyWidget(text: "Telefon", size:16.0),),],),),
                    Expanded(child: SizedBox(child: data['phone']!=null && data['phone']!='' ? GestureDetector(
                      onTap: () async {
                        final call = Uri.parse('tel:'+ data['phone'].toString());
                        if (await canLaunchUrl(call)) {
                          launchUrl(call);}
                        else {
                          throw 'Could not launch $call';
                          }
                      },
                      child: Text(data['phone'].toString(), style: TextStyle(color: CustomColors.appColors))
                    ):
                    TextValueWidget(text: '', size: 16.0)
                    ))
              ])),
          if (data['body_tm']!=null && data['body_tm']!='')
            SizedBox(
              width: double.infinity,
              child: TextField(
                enabled: false, 
                decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintMaxLines: 10,
                hintStyle: TextStyle(fontSize: 14, color: CustomColors.appColors),
                hintText: data['body_tm'].toString(),
                fillColor: Colors.white,),),),
        ]
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
    ): CustomProgressIndicator(funcInit: initState);
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
