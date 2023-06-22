import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
  
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Car/carStore.dart';
import '../../dB/textStyle.dart';
import '../call.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';

class PropertiesDetail extends StatefulWidget {
   PropertiesDetail({Key? key, required this.id}) : super(key: key);
   final String id ;

  @override
  State<PropertiesDetail> createState() => _PropertiesDetailState(id: id);
}

class _PropertiesDetailState extends State<PropertiesDetail> {
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
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_kT38o_6efgNspm1kIxkRiw6clWQ5s0D7m9qKCZKu53v8x9pIKjdxbJuhlOqlyhpBtYA&usqp=CAU');
    }
    getsingleparts(id: id);
    super.initState();
  }



  _PropertiesDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Emläkler", style: CustomText.appBarText,),
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
            height: 35,
            child: Row(children: [
                Expanded(child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.category_outlined, color: Colors.black26,),
                    SizedBox(width: 10,),
                    Text("Kategoriýa", style: CustomText.size_16_black54,)],),),
                Expanded(child: Text(data['category'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 35,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Ýerleşýän köçesi", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['street'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.price_change_rounded, color: Colors.black26,),
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
                  Icon(Icons.location_on, color: Colors.black26,),
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
                  Icon(Icons.phone_callback, color: Colors.black26,),
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
                  Icon(Icons.drive_file_rename_outline, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Eyesiniň ady", style: CustomText.size_16_black54,)],),),
                if (data['customer']!=null && data['customer']!='')
                Expanded(child: Text(data['customer']['name'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.home_work_outlined, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Binadaky gat sany", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['floor'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.numbers_sharp, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Ýerleşýan gaty", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['at_floor'].toString(),  style: CustomText.size_16))],),),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.home_work, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Otag any", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['room_count'].toString(),  style: CustomText.size_16))],),),
            
            Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                     SizedBox(width: 10,),
                    const Icon(Icons.change_circle_outlined, color: Colors.black26, size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Eýesinden", size:16.0),)],),),
                Expanded(child: Container(alignment: Alignment.topLeft,
                    child: data['own'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['own'] ),))
              ],),),
            
            Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                     SizedBox(width: 10,),
                    const Icon(Icons.change_circle_outlined, color: Colors.black26, size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Çalşyk", size:16.0),)],),),
                Expanded(child: Container(alignment: Alignment.topLeft,
                    child: data['swap'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['swap'] ),))
              ],),),

            Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    const Icon(Icons.assignment, color: Colors.black26, size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Ipoteka", size:16.0),)],),),
                Expanded(child: Container(alignment: Alignment.topLeft,
                    child: data['ipoteka'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['ipoteka'] ),))
              ],),),

            Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    const Icon(Icons.monetization_on_sharp, color: Colors.black26, size: 20,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Kridit", size:16.0),)],),),
                Expanded(child: Container(alignment: Alignment.topLeft,
                    child: data['credit'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['credit'] ),))
              ],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.auto_awesome_mosaic, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Meýdany", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['square'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.collections, color: Colors.black26,),
                  SizedBox(width: 10,),
                  Text("Remondy", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['remont_state'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.broadcast_on_personal_sharp, color: Colors.black26,),
                  SizedBox(width: 5,),
                  Text("Ýazgydaky adam sany", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['people'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.document_scanner_outlined, color: Colors.black26,),
                  SizedBox(width: 5,),
                  Text("Resminama ýagdaýy", style: CustomText.size_16_black54)],),),
              Expanded(child: Text(data['documents_ready'].toString(),  style: CustomText.size_16))],),),
        if (data['ad'] != null && data['ad'] !='')
          Container(
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
                  child: Image.network(baseurl + data['ad']!['img'].toString(),
                      fit: BoxFit.fitHeight, height: 160, width: double.infinity),),
              ],),),

          Container(
              margin: const EdgeInsets.all(10),
              height: 100,
              width: double.infinity,
              child: TextField(
                enabled: false, 
                maxLines:  3 ,
                decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintText: data['detail'].toString(),
                fillColor: Colors.white,),),),
          Call(phone: number)

        ],
      ):Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),

      )
    );    
  }



    void getsingleparts({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/flats/' + id;
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
          imgList.add(baseurl + i['img']);
        }
      if (imgList.length==0){
        slider_img = false;
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_kT38o_6efgNspm1kIxkRiw6clWQ5s0D7m9qKCZKu53v8x9pIKjdxbJuhlOqlyhpBtYA&usqp=CAU');
      }
      determinate = true;

    });
  }
}
