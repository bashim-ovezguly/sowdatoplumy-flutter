import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import '../Car/carStore.dart';
import '../fullScreenSlider.dart';
import 'OtherGoods/edit.dart';
import 'deleteAlert.dart';


class ProductDetail extends StatefulWidget {
  final String title;
  final String id;
  ProductDetail({super.key, required this.title, required this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState(title: title, id: id);
}

class _ProductDetailState extends State<ProductDetail> {
  final String title;
  final String id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  List<String> imgList = [];

  void initState() {
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsingleproduct(id: id);
    super.initState();
  }

    callbackStatusDelete(){
    Navigator.pop(context);
  }


    bool status = false;
  callbackStatus(){setState(() {status = true;});}

  _ProductDetailState({required this.title, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(title, style: CustomText.appBarText,),
        actions: [
        ],),
      body: status==false?
      determinate? ListView(
        children: <Widget>[ 
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 10,right: 10),
              child:  Row(
                children: <Widget>[
                  Text(data['name_tm'].toString(), style: TextStyle(color: CustomColors.appColors, fontSize: 20,),),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 30,
                        child: OutlinedButton(
                          child: Text("Üýgetmek"),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsEdit(old_data: data, callbackFunc: callbackStatus, title: title)));  },),),
                      SizedBox(width: 10,),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 30,
                      child: OutlinedButton(
                        child: Text("Pozmak"),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red,
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return DeleteAlert(action: 'products', id: id, callbackFunc: callbackStatusDelete,);});},),)
                    ],
                  )
                ],
              )
          ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Image border
                            child: Image.network(item, fit: BoxFit.fill, height: 200,width: double.infinity,),)
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

          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
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

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 35,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.store, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Dükan", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['store'].toString(),  style: CustomText.size_16))],),),

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
                  Text("Brend", style: CustomText.size_16_black54,)],),),
              if (data['brand']!=null && data['brand']!='')
                Expanded(child: Text(data['brand']['name'].toString(),  style: CustomText.size_16))],),),

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
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Eýesiniň ady", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['customer'].toString(),  style: CustomText.size_16))],),),

          // Container(
          //   height: 30,
          //   margin: const EdgeInsets.only(left: 10),
          //   child: Row(

          //     children: <Widget>[
          //       Expanded(child: Row(
          //         children: <Widget>[
          //           SizedBox(width: 10,),
          //           const Icon(Icons.monetization_on_sharp, color: Colors.black54,),
          //           Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Kredit", size:16.0),)],),),
          //       Expanded(child: Container(
          //         alignment: Alignment.topLeft,
           
          //           child: data['credit'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['credit'] ),))
          //     ],),),

          // Container(
          //   height: 30,
          //   margin: const EdgeInsets.only(left: 10),
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(child: Row(
          //         children: <Widget>[
          //           SizedBox(width: 10,),
          //           const Icon(Icons.library_add_check_outlined, color: Colors.black54),
          //           Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Çalyşyk", size:16.0),)],),),
          //       Expanded(child: Container(
          //           alignment: Alignment.topLeft,
          //           child: data['swap'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['swap'] ),))
          //     ],),),

          // Container(
          //   height: 30,
          //   margin: const EdgeInsets.only(left: 10),
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(child: Row(
          //         children: <Widget>[
          //           SizedBox(width: 10,),
          //           const Icon(Icons.credit_card, color: Colors.black54),
          //           Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Nagt däl töleg", size:16.0),)],),),
          //           Expanded(child: Container(
          //           alignment: Alignment.topLeft,
          //           child: data['none_cash_pay'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['none_cash_pay'] ),))

          //     ],),),
      
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
                  Text("Öndürilen ýurdy", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['made_in'].toString(),  style: CustomText.size_16))],),),
          
          Container(
                      margin: const EdgeInsets.all(10),
                      height: 100,
                      width: double.infinity,
                      child: TextField(
                        enabled: false, 
                        cursorColor: Colors.red,
                        maxLines:  3 ,
                        decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                          filled: true,
                          hintText: data['body_tm'].toString(),
                          fillColor: Colors.white,),),),
        ],
      ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),):

           Container(
          child: AlertDialog(
            content: Container(
              width: 200,
              height: 100,
              child: Text(
                'Maglumat üýtgedildi operatoryň tassyklamagyna garaşyň'),),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            onPressed: () async {
                Navigator.pop(context);
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    ))
    );
  }

    void getsingleproduct({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        baseurl =  server_url.get_server_url();
        var i;
        print(data);
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img_l']);
        }
        determinate = true;
      if (imgList.length==0){
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
      }
    });
  }

}