import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
  
import 'package:my_app/pages/call.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/constants.dart';
import '../../dB/textStyle.dart';
import '../fullScreenSlider.dart';
import '../../dB/colors.dart';
import '../progressIndicator.dart';

class CarStore extends StatefulWidget {
  CarStore({Key? key, required this.id}) : super(key: key);
  final String id ;
  @override
  State<CarStore> createState() => _CarStoreState(id: id);
}

class _CarStoreState extends State<CarStore> {

  List<String> imgList = [];

  final String number = '+99364334578';
  final String id ;
  var baseurl = "";
  var data = {};
  int _current = 0;
  bool determinate = false;
  bool slider_img = true;
  bool status = true;

  void initState() {
    timers();
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsinglecar(id: id);
    super.initState();
  }
    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  _CarStoreState({required this.id});
  @override
  Widget build(BuildContext context) {
    return status? Scaffold(
      appBar: AppBar(
        title: data['model']!=null && data['model']!=''? Text(data['model'].toString(), style: CustomText.appBarText,):
          Text(''),
        actions:  [
          // Container(margin: const EdgeInsets.only(right: 10),child: const Icon(Icons.help, size: 30,),),
        ],),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: ()async{
            setState(() {
            determinate = false;
            initState();
          });

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
                  onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) )); },),),

              Container(
                margin: EdgeInsets.only(bottom: 5),
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
              Spacer(),
              Expanded(child: Row(
                children:  <Widget>[
                  Icon(Icons.visibility_sharp,size: 20,color: CustomColors.appColors,),
                  SizedBox(width: 10,),
                  Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                  ),),],),
              )
            ],
          ), 
           Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10,top: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.auto_graph_outlined, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Id", size: 16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['id'].toString(), size: 16.0),))
              ],),),
          

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.car_crash_sharp, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Marka", size: 16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['mark'].toString(), size: 16.0),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.model_training_sharp, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Modeli", size: 16.0),)],),),
                Expanded(child: SizedBox(child: TextValueWidget(text: data['model'].toString(), size: 16.0),))
              ],),),

            if (data['store_name']!= null && data['store_name']!='')
            SizedBox(
              child: Row(
                children: [
                  Expanded(child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.store, color: Colors.grey,size: 18,),
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
                      child: Text(data['store'].toString(),),)))
                ],
              ),
            ),
            
            Container(height: 10,),

            SizedBox(
              child: Row(children: [
                Expanded(child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.location_on, color: Colors.grey,size: 18,),
                    SizedBox(width: 10,),
                    Text("Address", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                    SizedBox(width: 10,),
                    if (data['location']!=null && data['location']!='')
                      Expanded(child: Text(data['location'].toString(),  style: TextStyle(fontSize: 15, color: CustomColors.appColors))),
                    SizedBox(width: 10,),
                    ],),),
          
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range_sharp, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Ýyly", size:16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['year'].toString() + ' ý', size: 16.0),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range_sharp, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Geçen ýoly", size:16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['millage'].toString() + ' mil', size: 16.0),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.monetization_on, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Bahasy", size:16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['price'].toString() , size: 16.0),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.color_lens_rounded, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Reňki", size:16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['color'].toString(), size: 16.0),))
              ],),),
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.format_color_fill_rounded, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Reňki üýtgedilen", size:16.0),)],),),

                Expanded(child: SizedBox(child:
                  data['recolored'] == null ? TextValueWidget(text: "howwa", size: 17.0): TextValueWidget(text: "ýok", size: 16.0),))
              ],),),
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.energy_savings_leaf, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Matory", size:16.0),)],),),

                 Expanded(child: SizedBox(child: TextValueWidget(text: data['engine'].toString() , size: 16.0),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(

              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.monetization_on_sharp, color: Colors.grey,size: 18,),
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
                    const Icon(Icons.library_add_check_outlined, color: Colors.grey,size: 18,),
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
                    const Icon(Icons.credit_card, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Nagt däl töleg", size:16.0),)],),),
                Expanded(child: Container(
                    alignment: Alignment.topLeft,
                    child: data['none_cash_pay'] == null ? MyCheckBox(type: true ): MyCheckBox(type: data['none_cash_pay'] ),))

              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.phone_callback, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Telefon", size:16.0),)],),),

                  Expanded(child: SizedBox(child: TextValueWidget(text: data['phone'].toString(), size: 16.0),))
              ],),),
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.person_outline_outlined, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Satyjy", size:16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['customer_name'].toString(), size: 16.0),))
              ],),),


          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.qr_code, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Vin kody", size: 16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['vin'].toString(), size: 16.0),))
              ],),),
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.invert_colors_on_sharp, color: Colors.grey, size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Ýangyjyň görnüşi", size:16.0),)],),),

                Expanded(child: SizedBox(child: TextValueWidget(text: data['fuel'].toString(), size: 16.0),))
              ],),),

          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Expanded(child: Row(
                  children: <Widget>[
                    const Icon(Icons.car_crash_rounded, color: Colors.grey,size: 18,),
                    Container(margin: const EdgeInsets.only(left: 10), alignment: Alignment.center, height: 100,child: const TextKeyWidget(text: "Görnüşi", size: 16.0),)],),),


                  Expanded(child: SizedBox(child: TextValueWidget( text: data['body_type'].toString(), size: 16.0),))
              ],),),

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
                    child: Image.network(baseurl + data['img'].toString(),
                        fit: BoxFit.fitHeight, height: 160, width: double.infinity),),
                ],),),

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
      ):Center(child: CircularProgressIndicator(color: CustomColors.appColors))
       
      ),
      
      floatingActionButton: status ? Container(
        margin: EdgeInsets.only(top: 30, left: 25),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(top: 50),
        child: Call(phone: data['phone'].toString()),
      ): Container()
    ): CustomProgressIndicator(funcInit: initState);
  }

  void getsinglecar({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/cars/' + id;
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

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({Key? key, required this.type}) : super(key: key);
  final bool type;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: type
      ? const Icon(Icons.check, color: Colors.green, size: 25):  Icon(Icons.close, color: Colors.red, size: 25,),

    );
  }
}


class TextKeyWidget extends StatelessWidget {
  const TextKeyWidget({Key? key, required this.text, required this.size}) : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text, maxLines: 3,style: TextStyle(fontSize: 14, color: Colors.black54,));
  }
}


class TextValueWidget extends StatelessWidget {
  const TextValueWidget({Key? key, required this.text, required this.size}) : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14, color: CustomColors.appColors));
  }
}


