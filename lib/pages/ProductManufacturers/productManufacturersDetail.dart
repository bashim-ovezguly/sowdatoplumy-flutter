import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';  
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/progressIndicator.dart';
import '../../dB/textStyle.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';

class ProductManufacturersDetail extends StatefulWidget {
  ProductManufacturersDetail({Key? key, required this.id}) : super(key: key);
  final String id ;

  @override
  State<ProductManufacturersDetail> createState() => _ProductManufacturersDetailState(id: id);
}

class _ProductManufacturersDetailState extends State<ProductManufacturersDetail> {

  final String id ;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  var s=0;
  List<dynamic> products = [ ];
  List<String> imgList = [ ];
  bool determinate = false;
  bool slider_img = true;
  bool status = true;
  
  void initState() {
    timers();
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0YmKxREuu1UqGBi9U025dn-IEfCynmxvLng&usqp=CAU');
    }
    getsinglefactories(id: id);
    super.initState();
  }

    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      print(t);
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  _ProductManufacturersDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: const Text("Önüm öndürijiler", style: CustomText.appBarText,),
        actions: [],),
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
        child: determinate? CustomScrollView(
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
                  margin: const EdgeInsets.only(bottom: 10),
                  height:220,
                  child: GestureDetector(
                    child:  CarouselSlider(
                      options: CarouselOptions(
                        height:220,
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
                      items: imgList
                          .map((item) => Container(
                        color: Colors.white,
                        child: Center(
                          child: ClipRect(
                            child: Container(
                              height:220,
                              width: double.infinity,
                              child:  FittedBox(
                                fit: BoxFit.cover,
                                child: item != '' && slider_img == true? Image.network(item.toString(),):
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
            );

            },)),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                    (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(flex: 4,child: Row(
                            children: <Widget>[
                              SizedBox(width: 20,),
                              Icon(Icons.access_time_outlined,size: 20,color: CustomColors.appColors,),
                              SizedBox(width: 20,),
                              Text(data['created_at'].toString(), style: TextStyle(fontSize: 16, color: CustomColors.appColors,),),],),),
                          Expanded(child: Row(
                            children:  <Widget>[
                              Icon(Icons.visibility_sharp,size: 18,color: CustomColors.appColors,),
                              SizedBox(width: 10,),
                              Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, color: CustomColors.appColors,
                              ),),],),)],),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                        height: 35,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.auto_graph_outlined, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Id", style: CustomText.size_16_black54,
                              overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,)
                              ],),),
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
                              Text("Kategoriýa", style: CustomText.size_16_black54,
                              overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,)
                              ],),),
                          Expanded(child: Text(data['category'].toString(),  style: CustomText.size_16))],),),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 40,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Ady", style: CustomText.size_16_black54,
                              overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
                              )],),),
                          Expanded(child: Text(data['name_tm'].toString(),  style: CustomText.size_16))],),),

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
                          Expanded(child: Text(data['location']['name'].toString(),  style: CustomText.size_16))],),),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 30,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.phone_callback, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Nomeri", style: CustomText.size_16_black54,)],),),
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
                              Text("Address", style: CustomText.size_16_black54,)],),),
                          Expanded(child: Text(data['address'].toString(),  style: CustomText.size_16))],),),


                    ],);},)),
          if (products.length>0)
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.center,
                  child: Text("ÖNÜMLER", style: CustomText.size_16,),
                );
              },)),
          
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (BuildContext context, int index) {
              return  
              
              Container(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: products.map((item) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: item['id'].toString(), title: 'Önümler',)));
                      },
                      child: Card(
                      elevation: 2,
                      child: Container(
                        height: 180,
                        width: 120,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: item['img']!=null &&  item['img']!="" ? Image.network(
                                baseurl + item['img'].toString(),
                                fit: BoxFit.cover,
                                height: 140,
                              ): Image.asset('assets/images/default.jpg', fit: BoxFit.cover, height: 140,)
                            ),
                            Container(
                              height: 40,
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                     Text(item['name'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColors),),
                                     Text(item['price'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColors),),
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
              );

              },)),
        ],
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
      )
    ): CustomProgressIndicator(funcInit: initState);
  }


  void getsinglefactories({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/factories/' + id;
    final uri = Uri.parse(url);
       Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data = {};
        data  = json;
        products = json['products'];
        baseurl =  server_url.get_server_url();
        var i;
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img_m']);
        }
        determinate = true;
      if (imgList.length==0){
        slider_img = false;
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0YmKxREuu1UqGBi9U025dn-IEfCynmxvLng&usqp=CAU');
      }});}
}