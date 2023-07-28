import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/merketDetail.dart';

import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../Car/carStore.dart';
import '../progressIndicator.dart';


class StoreFirst extends StatefulWidget {
  StoreFirst({Key? key,  required this.id, required this.title}): super(key: key);
   final String id ;
  final String title;

  @override
  State<StoreFirst> createState() =>_StoreFirstState(title: title, id: id);
}

class _StoreFirstState extends State<StoreFirst> {
  final String id ;
  final String title;
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool status = true;
  bool determinate = false;
  List<dynamic> stores = [ ];
  List<String> imgList = [ ];
  List<dynamic> dataSlider = [{'img':''}];
  List<dynamic> dataStores = [];
  
  void initState() {
    timers();
    getsinglemarkets(id: id, title: title);
    super.initState();
  }
     timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  
_StoreFirstState({required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(
        title: Text("$title", style: CustomText.appBarText,),
      ),
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
        child: determinate? ListView(
        children: <Widget>[
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
                    items: dataSlider
                        .map((item) =>GestureDetector(
                          onTap: (){
                            if (item['id']!=null && item['id']!=''){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: item['id'].toString(), title: 'Söwda nokatlar',) ));
                            }
                          },      
                      child: Container(
                        color: Colors.white,
                          child: Container(
                            height: 200, 
                            width: double.infinity,
                            child: item['img'] != null && item['img']!='' ? Image.network(baseurl + item['img'].toString(), fit: BoxFit.cover,):
                              Image.asset('assets/images/default16x9.jpg', fit: BoxFit.cover),),),

                        )).toList(),),
                  onTap: (){},),),

              Container(
                margin: EdgeInsets.only(bottom: 7),
                child: DotsIndicator(
                  dotsCount: dataSlider.length,
                  position: _current.toDouble(),
                  decorator: DotsDecorator(
                    color: Colors.white,
                    activeColor: CustomColors.appColors,
                    activeShape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),),)
            ],),
            Row(
            children: <Widget>[
              Expanded(flex: 4,child: Row(
                children:  <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.access_time_outlined,size: 20,color: CustomColors.appColors,),
                  SizedBox(width: 20,),
                  Text(data['created_at'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      color: CustomColors.appColors,
                    ),
                  ),
                ],
              ),),
            ],
          ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Expanded(child: Row(
                    children: <Widget>[
                      const Icon(Icons.store, color: Colors.grey,size: 20,),
                      Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Ady", size: 18.0),)],),),

                    Expanded(child: SizedBox(child: TextValueWidget(text:data['name_tm'].toString(), size: 15.0),))
                ],),),

          Container(
            height: 50,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.location_on, color: Colors.grey,size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Address", size: 18.0),)],),),

                Expanded(child: Container(padding: const EdgeInsets.all(5),child:  TextValueWidget(text: data['location'].toString() , size: 15.0,),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10,),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.category, color: Colors.grey,size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Kategory", size: 18.0),)],),),

                const  Expanded(child: SizedBox(child: TextValueWidget(text:"Bazarlar", size: 17.0),))
              ],),),


          

          Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                alignment: Alignment.center,
                child: Text("Dükanlar", style: TextStyle(color: CustomColors.appColors, fontSize: 17, fontWeight: FontWeight.bold),),
              ),

            Wrap(alignment: WrapAlignment.spaceAround,
            children: dataStores.map((item) {
              return GestureDetector(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: item['id'].toString(), title: 'Söwda nokatlar',) ));
                      },
                      child: Card(
                      elevation: 2,
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width/2-10,
                        child: Column(
                          children: [
                           Container(
                              alignment: Alignment.topCenter,
                              child: item['img']!=null &&  item['img']!="" ? Image.network(
                                baseurl + item['img'].toString(),
                                fit: BoxFit.fill,
                                height: 140, width: MediaQuery.of(context).size.width/2-10,
                              ): Image.asset('assets/images/default.jpg', height: 140,)
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     Text(item['name'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis),),
                                     Text(item['location'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis),),
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

        ],
      ):Center(child: CircularProgressIndicator(color: CustomColors.appColors))
      )
    ): CustomProgressIndicator(funcInit: initState);
  }

    void getsinglemarkets({required id, required title}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/bazarlar/' + id;

    if (title=="Söwda merkezler"){
      url = server_url.get_server_url() + '/mob/shopping_centers/' + id;
    }

    final uri = Uri.parse(url);
    final response = await http.get(uri);    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        stores = json['stores'];
        baseurl =  server_url.get_server_url();
        dataSlider = json['stores_on_slider'];
        if (dataSlider.length==0){
          dataSlider = [{'img':''}];
        }
        dataStores = data['stores'];
        determinate = true;
    });
  }

}


