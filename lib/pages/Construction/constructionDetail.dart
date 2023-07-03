import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
  
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import '../call.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';

class ConstructionDetail extends StatefulWidget {
  ConstructionDetail({Key? key, required this.id}) : super(key: key);
  final String id ;
  
  @override
  State<ConstructionDetail> createState() => _ConstructionDetailState(id: id);
}

class _ConstructionDetailState extends State<ConstructionDetail> {
  final String id ;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  bool slider_img = true;
  List<String> imgList = [ ];

  void initState() {
    if (imgList.length==0){
      imgList.add('https://png.pngtree.com/element_our/20190528/ourmid/pngtree-blue-building-under-construction-image_1141142.jpg');
    }
    getsingleparts(id: id);
    super.initState();
  }


  _ConstructionDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Gurluşyk harytlar", style: CustomText.appBarText,),
        actions: [
        ],),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: () async{
          setState(() {
            determinate = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: determinate ? ListView(
        children: <Widget>[

          Stack(
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
            ],
          ),
            Row(
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
                  Icon(Icons.visibility_sharp, size: 20,color: CustomColors.appColors,),
                  SizedBox(width: 10,),
                  Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                  ),),],),
              )
            ],
          ),
          SizedBox(height: 10,),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.auto_graph_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Id", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['id'].toString(), style: CustomText.size_16,
                      overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
              ))],),),


          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 40,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Ady", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['name_tm'].toString(), style: CustomText.size_16,
                      overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
              ))],),),
              
            if (data['store_name']!= null && data['store_name']!='')
             SizedBox(
              child: Row(
                children: [
                  Expanded(child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Icon(Icons.store, color: Colors.black54,),
                    SizedBox(width: 10,),
                    Text("Söwda nokat", style: CustomText.size_16_black54,)],),),

                   Expanded(child:Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 13, color: CustomColors.appColorWhite)),
                      onPressed: () {
                        if (data['store_id']!=null && data['store_id']!=''){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: data['store_id'].toString(), title: 'Söwda nokatlar')));
                        }
                      },
                      child: Text(data['store_name'].toString(),),)))
                ],
              ),
            ),

          Container(
            height: 35,
            margin: EdgeInsets.only(left: 10,right: 10),
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.category_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Kategoriýa", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['category'].toString(), maxLines: 2,  style: CustomText.size_16,
               overflow: TextOverflow.clip,
                                            
                                            softWrap: false,
              ))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.money, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Bahasy", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['price'].toString(),  style: CustomText.size_16))],),),

  
          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.phone_callback, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Telefon", style: CustomText.size_16_black54,)],),),
              Expanded(child:data['phone']!=null && data['phone']!='' ? Text(data['phone'].toString() ,  style: CustomText.size_16): Text(''))],),),
        
          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.location_on, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Ýerleşýän ýeri", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['location'].toString(),  style: CustomText.size_16))],),),
          
          if (data['ad'] != null && data['ad'] !='')
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(" Reklama hyzmaty",
                    style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.appColors,
                        fontWeight: FontWeight.bold),),
                  Container(
                    color: Color.fromARGB(96, 214, 214, 214),
                    child: Image.network(baseurl + data['ad']!['img'].toString(), 
                        fit: BoxFit.fitHeight, height: 160, width: double.infinity),),
                ],),),
          if (data['ad'] == null && data['ad'] =='')
            SizedBox(height: 60,),


        if (data['detail']!=null && data['detail']!='')
        SizedBox(
              width: double.infinity,
              child: TextField(
                enabled: false, 
                decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintMaxLines: 10,
                hintStyle: TextStyle(fontSize: 14, color: CustomColors.appColors),
                hintText: data['detail'].toString(),
                fillColor: Colors.white,),),),
        SizedBox(height: 70,),
        ],
      ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 30, left: 25),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(top: 50),
        child: Call(phone: data['phone'].toString()),
      )
    );
  }



    void getsingleparts({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/materials/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        baseurl =  server_url.get_server_url();
        // ignore: unused_local_variable
        var i;
        print(data);
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
