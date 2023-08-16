// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Awtoparts/awtoPartsDetail.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/Construction/constructionDetail.dart';
import 'package:my_app/pages/Propertie/propertiesDetail.dart';
import 'package:my_app/pages/Store/order.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../../main.dart';
import '../Customer/login.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import '../Services/serviceDetail.dart';
import '../fullScreenSlider.dart';

List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class MarketDetail extends StatefulWidget {
  MarketDetail({Key? key, required this.id, required this.title}) : super(key: key);
  final String id ;
  final String title;

  @override
  State<MarketDetail> createState() => _MarketDetailState(id: id, title: title);
}

class _MarketDetailState extends State<MarketDetail> {
  String modul_name = "Harytlar";
  String modul = "0";
  final String id ;
  final String title;
  final number = '+99364334578';
  var telefon = {};
  String delivery_price_str = "";
  var de = {};
  var modules = {};
  int _current = 0;
  var baseurl = "";
  var data = {};
  String store_name = '';
  var shoping_carts = [];
  var shoping_cart_items = [];
  List<dynamic> products = [ ];
  List<dynamic> data_tel = [];
  List<String> imgList = [ ];
  bool determinate = false;
  var keyword = TextEditingController();
  
  change_modul(value){setState(() {modul = value.toString();
    if (value.toString()=='0'){ modul_name = 'Harytlar';}
    if (value.toString()=='1'){ modul_name = 'Awtoulaglar';}
    if (value.toString()=='2'){ modul_name = 'Awtoşaýlar';}
    if (value.toString()=='3'){ modul_name = 'Emläkler';}
    if (value.toString()=='4'){ modul_name = 'Gurluşyk harytlar';}
    if (value.toString()=='5'){ modul_name = 'Hyzmatlar';}
      
  get_products_modul(modul, id); });}
  int item_count = 0;
  bool status = true;
  refresh(){getsinglemarkets(id: id, title: title); get_products_modul(modul, id); timers();}

  void initState() {  
    timers();
    if (imgList.length==0){
      imgList.add('x');
    }
    getsinglemarkets(id: id, title: title);
    get_products_modul(modul, id);
    super.initState();
  }

    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }
  
  _MarketDetailState({required this.id, required this.title});
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {

    showSuccessAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Haryt sebede goşuldy.',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: (){
          Navigator.pop(context);
        });
    }

    showWarningAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Haryt sebetde bar.',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.warning,
        onConfirmBtnTap: (){
          Navigator.pop(context);
        });
    }

    return status? Scaffold(
      appBar: AppBar(
        title: Text(store_name.toString(), style: CustomText.appBarText,),
           actions: [
              Badge(
                badgeColor: Colors.green,
                badgeContent: Text(item_count.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                position: BadgePosition(start: 30, bottom: 30),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Order(store_name: data['name_tm'].toString(), store_id: data['id'].toString(), refresh: refresh, delivery_price: delivery_price_str)));  
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
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
                    height: 200,
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
                                  child: item != 'x' ? Image.network(item.toString(),):
                                  Image.asset('assets/images/default16x9.jpg'),),
                                  ),),
                          ),)).toList(),),
                      onTap: (){
                        if (imgList.length==1 && imgList[0]=='x'){}
                        else{Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) ));}
                    })
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
                              SizedBox(width: 10,),
                              Icon(Icons.access_time_outlined,size: 20,color: CustomColors.appColors,),
                              SizedBox(width: 10,),
                              Text(data['created_at'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                              ),),],),),
                            Spacer(),
                          Expanded(child: Row(
                            children: <Widget>[
                              Icon(Icons.visibility_sharp,size: 20,color: CustomColors.appColors,),
                              SizedBox(width: 10,),
                              Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                              ),),],),)],),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10, top: 15),
                        height: 30,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [ 
                              SizedBox(width: 10,),
                              Icon(Icons.auto_graph_outlined, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Id ",  style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                          Expanded(child: Text(data['id'].toString(),  style: TextStyle(fontSize: 14, color: CustomColors.appColors)))],),),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 30,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [ 
                              SizedBox(width: 10,),
                              Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Ady ",  style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                          Expanded(child: Text(data['name_tm'].toString(),  style: TextStyle(fontSize: 14, color: CustomColors.appColors)))],),),
                            
                      Container(height: 10, child: Text('')),
                      
                      SizedBox(  
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 15,),
                              Icon(Icons.location_on, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Ýerleşýän ýeri", style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                              if (data['location']!=null && data['location']!='')
                              Expanded(child: Text(
                                data['location']['name'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors),maxLines: 2,)),
                              SizedBox(width: 10,),
                            ],),),
                      Container(height: 10, child: Text(''),),
                      SizedBox(  
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 15,),
                              Icon(Icons.brightness_1, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Göwrümi", style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                              Expanded(child: Text(
                                data['size'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors),maxLines: 2,)),
                              SizedBox(width: 10,),
                            ],),),
                            Container(height: 10, child: Text(''),),

                      SizedBox(  
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 15,),
                              Icon(Icons.person, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Satyjy", style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                              if (data['customer']!=null && data['customer']!={} && data['customer']!='')
                              Expanded(child: Text(data['customer']['name'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors),maxLines: 2,)),
                              SizedBox(width: 10,),
                            ],),),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                        height: 30,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.lock_clock, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Iş wagty", style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                          Expanded(child: Row(
                            children: [
                              Text(data['open_at'].toString(),  style: TextStyle(fontSize: 14, color: CustomColors.appColors)),
                              SizedBox(width: 10,),
                              Text(data['close_at'].toString(),  style: TextStyle(fontSize: 14, color: CustomColors.appColors))
                            ],))],),),
                      
                      SizedBox(
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 20,),
                              Icon(Icons.drive_file_rename_outline, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Address", style: TextStyle(fontSize: 14, color: Colors.black54),)],),),
                          Expanded(child: Text(data['address'].toString(),  style: TextStyle(fontSize: 14, color: CustomColors.appColors))),
                          SizedBox(width: 10,),
                          ]))
                    ]);})),
            
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
                                 Icon(Icons.phone_android_outlined, color: CustomColors.appColors, size: 15),
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
                      if (i != telefon)
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(child: Text('')),
                                Expanded(child: Row(
                                  children: [
                                Icon(Icons.phone_android_outlined, color: CustomColors.appColors, size: 15,),
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
                      return Container(
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
                            SizedBox(height: 10,)
                            ],),);},)),
          
          if (data['body_tm']!=null && data['body_tm']!='')
                SliverList(delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (BuildContext context, int index) {
                      return SizedBox(width: double.infinity,
                      child: TextField(
                        enabled: false,
                        maxLines:  100 ,
                        decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                          filled: true,
                          hintStyle: TextStyle(fontSize: 14, color: CustomColors.appColors),
                          hintText: data['body_tm'].toString(),
                          fillColor: Colors.white,),),);},)),
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return  Column(
                  children: [
                    Container(
                  alignment: Alignment.center,
                  height: 40,
                  margin: EdgeInsets.only(left: 80, right: 80, top: 20),
                  child: Text(modul_name, style: TextStyle(color: CustomColors.appColors, fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        controller: keyword,
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.search), 
                              onPressed: () {
                                get_products_modul(modul, id);
                              },
                              ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  keyword.text = '';
                                });
                                get_products_modul(modul, id);
                              },
                            ),
                            hintText: 'Gözleg...',
                            border: InputBorder.none),
                      ),
                    ),
                  )
                  ],
                );
              },)),
            SliverList(delegate: SliverChildBuilderDelegate(childCount: 1,(BuildContext context, int index) {return Container(height: 20,);},)),
            
            if (products.length==0)
              SliverList(delegate: SliverChildBuilderDelegate(childCount: 1,(BuildContext context, int index) {return 
              Container(height: 20,
              child: Align(child: Text(modul_name + " ýok! ", style: CustomText.size_16,),
              ),
              );},)),



            SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (BuildContext context, int index) {
              return  Container(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: products.map((item) {
                    return GestureDetector(
                      onTap: (){
                        if (modul=='0'){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: item['id'].toString(), title: 'Harytlar',)));}
                        if (modul=='1'){ Navigator.push(context, MaterialPageRoute(builder: (context) => CarStore(id: item['id'].toString())));}
                        if (modul=='2'){ Navigator.push(context, MaterialPageRoute(builder: (context) => AutoPartsDetail(id: item['id'].toString())));}
                        if (modul=='3'){ Navigator.push(context, MaterialPageRoute(builder: (context) => PropertiesDetail(id: item['id'].toString())));}
                        if (modul=='4'){ Navigator.push(context, MaterialPageRoute(builder: (context) => ConstructionDetail(id: item['id'].toString())));}
                        if (modul=='5'){ Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetail(id: item['id'].toString())));}
                      },
                      child: Card(
                      elevation: 2,
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width/3-10,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: item['img']!=null &&  item['img']!="" ? Image.network(
                                baseurl + item['img'].toString(),
                                fit: BoxFit.cover,
                                width:  MediaQuery.of(context).size.width/3-10,
                                height: 130,
                              ): Image.asset('assets/images/default.jpg', height: 200,)
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (modul=='1') 
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(item['mark'].toString(), maxLines: 1, style: TextStyle(fontSize: 12, color: CustomColors.appColors, overflow: TextOverflow.clip, ),),
                                          SizedBox(width: 2,),
                                          Text(item['year'].toString(), maxLines: 1, style: TextStyle(fontSize: 12, color: CustomColors.appColors, overflow: TextOverflow.clip),),
                                        ],   
                                      ),
                                    if (modul=='0')
                                      Text(item['name'].toString(), maxLines: 1, style: TextStyle(fontSize: 12, color: CustomColors.appColors, overflow: TextOverflow.clip),),
                                     Text(item['price'].toString(), maxLines: 1, style: TextStyle(fontSize: 12, color: CustomColors.appColors, overflow: TextOverflow.clip),),
                                  
                                  if (modul!='1')
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(height: 20),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700]
                                    ),
                                      
                                      child: Text('Sebede goş',
                                      style: TextStyle(fontSize: 12, color: CustomColors.appColorWhite, overflow: TextOverflow.clip)),
                                      onPressed: () async {
                                        var allRows = await dbHelper.queryAllRows();
                                        var data = [];
                                        for (final row in allRows) {data.add(row);}
                                        if (data.length==0){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}

                                        setState(() {
                                          shoping_cart_items = [];
                                        });
                                        var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: id);
                                        var array = [];
                                          for (final row in shoping_cart) {
                                            array.add(row);
                                          }

                                        var shoping_cart_item = await dbHelper.get_shoping_cart_item(soping_cart_id: array[0]['id'].toString(), product_id: item['id'].toString());
                                        for (final row in shoping_cart_item) {
                                          shoping_cart_items.add(row);
                                        }
                                        if (shoping_cart_items.length==0){
                                          Map<String, dynamic> row = {'soping_cart_id': array[0]['id'],
                                                                      'product_id': item['id'],
                                                                      'product_img': item['img'],
                                                                      'product_name': item['name'],
                                                                      'product_price': item['price'].toString(),
                                                                      'count': 1};
                                          var shoping_cart = await dbHelper.add_product_shoping_cart(row);
                                          showSuccessAlert();
                                            var count = await dbHelper.get_shoping_cart_items(soping_cart_id: array[0]['id'].toString());
                                            var array1 = [];
                                            for (final row in count) {
                                              array1.add(row);
                                            }
                                          setState(() {
                                            item_count = array1.length;
                                          });
                                          } else {
                                            showWarningAlert();
                                          }
                                      },
                                    ),
                                  ),
                                  
                                  ],
                                )
                            )
                          ]
                        )
                      )  
                    )
                    );
                  }).toList(),
                ));
              })),

              SliverList(delegate: SliverChildBuilderDelegate(childCount: 1,(BuildContext context, int index) {return Container(height: 50);})),
          ],
        ): Center(child: CircularProgressIndicator(color: CustomColors.appColors)),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: myPopMenu(context),
        backgroundColor: Colors.white,),   
      ):  CustomProgressIndicator(funcInit: initState);
    }


   Widget myPopMenu(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.blue),),
          child: PopupMenuButton(
              offset: const Offset(-90, 100),
              icon: Icon(Icons.menu, color: CustomColors.appColors,),
              onSelected: (value) {
                setState(() {
                  change_modul(value);
                });              
              },
              itemBuilder: (context) {    
                return [
                  if (modules['products']>0)
                  PopupMenuItem(
                    child: Center(
                      child: Text('Harytlar',style: TextStyle(color: Colors.black),),),
                    value: 0,
                  ),
                  if (modules['products']>0)
                  PopupMenuItem( height: 4,child: Container(height: 2,color: Colors.black,),),
                  

                  if (modules['cars']>0)
                  PopupMenuItem(
                    child: Center(
                      child: Text( 'Awtoulaglar', style: TextStyle(color: Colors.black),),),
                    value: 1,
                  ),
                  if (modules['cars']>0)
                  PopupMenuItem(height: 4,child: Container(height: 2,color: Colors.black,),),

                  if (modules['parts']>0)
                  PopupMenuItem(
                    child: Center(
                      child: Text('Awtoşaýlar',style: TextStyle(color: Colors.black),),),
                    value: 2,
                  ),
                  if (modules['parts']>0)
                  PopupMenuItem(height: 4,child: Container(height: 2,color: Colors.black,),),
                  
                  if (modules['flats']>0)
                  PopupMenuItem(
                    child: Center(
                      child: Text('Emläkler',style: TextStyle(color: Colors.black),),),
                    value: 3,
                  ),
                  if (modules['flats']>0)
                  PopupMenuItem(height: 4,child: Container(height: 2,color: Colors.black,),),

  
                  if (modules['materials']>0)
                  PopupMenuItem(
                    child: Center(
                      child: Text('Gurluşyk harytlar',style: TextStyle(color: Colors.black),),),
                    value: 4,
                  ),
                  if (modules['materials']>0)
                  PopupMenuItem(height: 4,child: Container(height: 2,color: Colors.black,),),


                  if (modules['services']>0)
                  PopupMenuItem(
                    child: Center(
                      child: Text('Hyzmatlar',style: TextStyle(color: Colors.black),),),
                    value: 5,
                  ),

                ];
              }),
        );
      }

  void getsinglemarkets({required id, required title}) async {
    var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: id);
    for (final row in shoping_cart) {
      shoping_carts.add(row);
    }

    if (shoping_carts.length==0){
      Map<String, dynamic> row = { 'store_id': int.parse(id)};
      var shoping_cart = await dbHelper.shoping_cart_inser(row);
    }
    var test = await dbHelper.get_shoping_cart_by_store(id: id);
    var array = [];
    for (final row in test) {
      array.add(row);
    }

    var count = await dbHelper.get_shoping_cart_items(soping_cart_id: array[0]['id'].toString());
    var array1 = [];
    for (final row in count) {
      array1.add(row);
    }
    setState(() {
      item_count = array1.length;
    });

    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/markets/' + id;

    if (title=="Söwda nokatlar"){url = server_url.get_server_url() + '/mob/stores/' + id;}
    final uri = Uri.parse(url);
    final response = await http.get(uri);    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        var i; imgList = [];
        data = json;
        
        delivery_price_str = json['delivery_price'];
        if (delivery_price_str=='0' || delivery_price_str=='0 TMT'){delivery_price_str = 'tölegsiz';}
        baseurl =  server_url.get_server_url();
        data_tel = json['phones'];
        store_name = data['name_tm'];
        modules = json['modules'];
        if (json['phones'].length!=0){ telefon = json['phones'][0]; }
        for ( i in data['images']) { imgList.add(baseurl + i['img_m']);}

      determinate = true;
      if (imgList.length==0){imgList.add('x');}});}
    
    Future<void> get_products_modul(modul, id) async {
      Urls server_url  =  new Urls(); var param = '';
      if (modul=='0'){ param = 'products'; }
      if (modul=='1'){ param = 'cars'; }
      if (modul=='2'){ param = 'parts'; }
      if (modul=='3'){ param = 'flats'; }
      if (modul=='4'){ param = 'materials'; }
      if (modul=='5'){ param = 'services'; }

      String url = server_url.get_server_url() + '/mob/' + param +'?store='+ id;
      if (keyword.text!=''){url = server_url.get_server_url() + '/mob/' + param +'?store='+ id +"&name="+ keyword.text;}
      final uri = Uri.parse(url);
      final response = await http.get(uri);    
      final json = jsonDecode(utf8.decode(response.bodyBytes));
       setState(() {products = json['data'];});
    }
}