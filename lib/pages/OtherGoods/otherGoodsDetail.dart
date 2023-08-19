import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import '../../dB/textStyle.dart';
import '../call.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';
import '../progressIndicator.dart';

class OtherGoodsDetail extends StatefulWidget {

  OtherGoodsDetail({Key? key, required this.id, required this.title}) : super(key: key);
  final String id , title ;
  @override
  State<OtherGoodsDetail> createState() => _OtherGoodsDetailState(id: id, title: title);
}

class _OtherGoodsDetailState extends State<OtherGoodsDetail> {
  final String id, title;
  String number = '';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  bool slider_img = true;
  bool status = true;
  List<String> imgList = [ ];

    void initState() {
      timers();
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsingleproduct(id: id);
    super.initState();
  }

    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }


  _OtherGoodsDetailState({required this.id, required this.title});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(

      appBar: AppBar(
        title: Text(title, style: CustomText.appBarText,),
        actions: [
        ],),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: ()async{
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
                margin: const EdgeInsets.all(10),
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
                        onPageChanged: (index, reason) {setState(() {
                          _current = index;});}
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
                              child: item != '' && slider_img==true? Image.network(item.toString(),):
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
                  Icon(Icons.access_time_outlined, size: 20,color: CustomColors.appColors,),
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

          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
            height: 35,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.auto_graph_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Id", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['id'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 35,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.category_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Kategoriýa", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['category'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Ady", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['name_tm'].toString(),  style: CustomText.size_16))],),),

            if (data['store_name']!= null && data['store_name']!='')
            SizedBox(
              child: Row(
                children: [
                  Expanded(child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Icon(Icons.store, color: Colors.black54),
                    SizedBox(width: 10,),
                    Text("Söwda nokat", style: CustomText.size_16_black54,)],),),

                   Expanded(child:Container(
                    height: 25,
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        if (data['store']!=null && data['store_id']!=''){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: data['store_id'].toString(), title: 'Söwda nokatlar')));
                        }
                      },
                      child: Text(data['store_name'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomText.itemText,
                      )))),
                      SizedBox(width: 10)
                ],
              ),
            ),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.price_change_rounded, color: Colors.black54,),
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
                  Icon(Icons.discount_rounded, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Brand", style: CustomText.size_16_black54,)],),),
                  if (data['brand']!=null && data['brand']!='')
                    Expanded(child: Text(data['brand'].toString(),  style: CustomText.size_16))],),),

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
              if (data['location']!=null && data['location']!='')
              Expanded(child: Text(data['location'].toString(), overflow: TextOverflow.clip,maxLines: 2,softWrap: false, style: CustomText.size_16))],),),

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
              Expanded(child: Text(data['phone'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 35,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Eyesiniň ady", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['customer'].toString(),  style: CustomText.size_16))],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(

              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    const Icon(Icons.monetization_on_sharp, color: Colors.black54,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Kredit", size:16.0),)],),),
                Expanded(child: Container(
                  alignment: Alignment.topLeft,
                    child: data['credit'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['credit'] ),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    const Icon(Icons.library_add_check_outlined, color: Colors.black54),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Çalyşyk", size:16.0),)],),),
                Expanded(child: Container(
                    alignment: Alignment.topLeft,
                    child: data['swap'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['swap'] ),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    const Icon(Icons.credit_card, color: Colors.black54),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Nagt däl töleg", size:16.0),)],),),
                    Expanded(child: Container(
                    alignment: Alignment.topLeft,
                    child: data['none_cash_pay'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['none_cash_pay'] ),))

              ],),),
      
          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.countertops_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Möçberi", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['amount'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.discount_rounded, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Ýasalan ýurdy", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['made_in'].toString(),  style: CustomText.size_16))],),),
          
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
        SizedBox(height: 70,),

        ],
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors)) 
      
      ),
      floatingActionButton: status ? Container(
        margin: EdgeInsets.only(top: 30, left: 25),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(top: 50),
        child: Call(phone: number),
      ): Container()

    ): CustomProgressIndicator(funcInit: initState);
  }
  
  void getsingleproduct({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        imgList = [];
        baseurl =  server_url.get_server_url();
        if (data['phone']!=null && data['phone']!=''){
          number = data['phone'].toString();
        }
        
        for (var i in data['images']) {
          imgList.add(baseurl + i['img_m']);
        }
      if (imgList.length==0){
        slider_img = false;
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
      }
      determinate = true;
    });
  }
}
