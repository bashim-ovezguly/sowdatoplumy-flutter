import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/editStore.dart';
import 'package:my_app/pages/Customer/productDetail.dart';
import '../../dB/colors.dart';
import '../fullScreenSlider.dart';
import 'deleteAlert.dart';
import 'newProduct.dart';


class MyPage extends StatefulWidget {

  MyPage({Key? key, required this.id, required this.customer_id, required this.refreshFunc}): super(key: key);
  final String id;
  final String customer_id;
  final Function refreshFunc;
  @override
  State<MyPage> createState() => _MyPageState(id: id, customer_id: customer_id, refreshFunc: refreshFunc);
}

class _MyPageState extends State<MyPage> {
  final Function refreshFunc;
  final String id;
  final String customer_id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  List<dynamic> products = [];
  List<String> imgList = [];
  List<dynamic> data_tel =[];
  bool determinate = false;

  bool status = false;
  callbackStatus(){setState(() {status = true;});}

  void initState() {
    refreshFunc();
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBYAVt1PGvwtPxFwyln-2VL4hyc3ViLcdgYaVFxgnrcK2KP9ywLquGti9teKFEFz4vP1o&usqp=CAU');
    }
    getsinglemarkets(id: id);
    super.initState();
  }
  
  callbackStatusDelete(){
    refreshFunc();
    Navigator.pop(context);
    Navigator.pop(context);
  }
  callbackDeletePhone(){
    setState(() {
      if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBYAVt1PGvwtPxFwyln-2VL4hyc3ViLcdgYaVFxgnrcK2KP9ywLquGti9teKFEFz4vP1o&usqp=CAU');
    }
    getsinglemarkets(id: id);
      
    });
  }


  _MyPageState({required this.id , required this.customer_id, required this.refreshFunc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Meniň sahypam', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
          Text('Söwda nokady',  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
              
              itemBuilder: (context) {
                List<PopupMenuEntry<String>> menuEntries2 = [
                   PopupMenuItem<String>(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditStore(old_data: data, callbackFunc: callbackStatus)));  
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit_road, color: Colors.green,),
                          Text(' Üýtgetmek')
                        ],
                      ),
                    )
                  ),
                  PopupMenuItem<String>(
                    child: GestureDetector(
                      onTap: (){
                          showDialog(
                              context: context,
                              builder: (context){
                                return DeleteAlert(action: 'stores', id: id, callbackFunc: callbackStatusDelete,);});
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red,),
                          Text('Pozmak')
                        ],
                      ),
                    )  
                  ),
                ];
                return menuEntries2;
              },
            ), 
      ],
      
      ),
      body: status==false?
        RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColors,
          onRefresh: () async{
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
              return Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child:  Row(
                      children: <Widget>[
                        Text(data['name_tm'].toString(), 
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: CustomColors.appColors, fontSize: 18,),),
                        Spacer(),
                  
                  ],));
                },)),

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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Image border
                                child: Image.network(item, fit: BoxFit.fill, height: 200,width: double.infinity,),)

                          ),)).toList(),),
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) )); },),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child:    
                    DotsIndicator(
                      dotsCount: imgList.length,
                      position: _current.toDouble(),
                      decorator: DotsDecorator(
                        color: Colors.white,
                        activeColor: CustomColors.appColors,
                        activeShape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),)

                        )
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
                              SizedBox(width: 20,),
                              Icon(Icons.access_time_outlined,size: 20,color: CustomColors.appColors,),
                              SizedBox(width: 5,),
                              Text(data['created_at'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                              ),),],),),
                          Expanded(child: Row(
                            children: <Widget>[
                              Icon(Icons.visibility_sharp,size: 20,color: CustomColors.appColors,),
                              SizedBox(width: 5,),
                              Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                              ),),],),)],),
                      
                      Container(height: 15, child: Text(''),),

                      SizedBox(
                        child: Row(children: [
                          Expanded(child: 
                          Row(children: [ 
                              SizedBox(width: 20),
                              Icon(Icons.auto_graph_outlined, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Id ",  style: TextStyle(fontSize: 15, color: Colors.black54),)],)),
                            Expanded(child: Text(data['id'].toString(),  style: TextStyle(fontSize: 15, color: CustomColors.appColors))),
                            SizedBox(width: 10,),
                          ],),),

                      SizedBox(
                        child: Row(children: [
                          Expanded(child: 
                          Row(children: [ 
                              SizedBox(width: 20),
                              Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Ady ",  style: TextStyle(fontSize: 15, color: Colors.black54),)],)),
                            Expanded(child: Text(data['name_tm'].toString(),  style: TextStyle(fontSize: 15, color: CustomColors.appColors))),
                            SizedBox(width: 10,),
                          ],),),
                      
                      Container(height: 15, child: Text(''),),
                      SizedBox(
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 20,),
                              Icon(Icons.location_on, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Ýerleşýän ýeri", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                              Expanded(child: Text(
                                data['location'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColors),
                                maxLines: 2,),),
                              SizedBox(width: 10,),
                            ],),),
                      
                      Container(height: 15, child: Text(''),),
                      SizedBox(
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 20,),
                              Icon(Icons.brightness_1, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Göwrümi", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                              Expanded(child: Text(
                                data['size'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColors),
                                maxLines: 2,),),
                              SizedBox(width: 10,),
                            ],),),

                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 40,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.category, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Kategoriýasy", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                          Expanded(child: Text(data['category'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColors),
                            maxLines: 2,
                            ))],),),
                      
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 40,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.streetview, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Köçesi", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                          Expanded(child: Text(
                            
                            data['street'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColors),
                            maxLines: 2,
                            ))],),),
                
                    Container(
                        margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                        height: 30,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.lock_clock, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Iş wagty", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                          Expanded(child: Row(
                            children: [
                              Text(data['open_at'].toString(),  style: TextStyle(fontSize: 15, color: CustomColors.appColors)),
                              SizedBox(width: 10,),
                              Text(data['close_at'].toString(),  style: TextStyle(fontSize: 15, color: CustomColors.appColors))
                            ],))],),),

                  Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 40,
                        child: Row(children: [
                          Expanded(child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.location_city, color: Colors.black54,),
                              SizedBox(width: 10,),
                              Text("Address", style: TextStyle(fontSize: 15, color: Colors.black54),)],),),
                          Expanded(child: Text(data['address'].toString(),  style: TextStyle(fontSize: 15, color: CustomColors.appColors)))],),),

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

                        ],);},)),

                    if (data_tel.length > 0)
                  SliverList(delegate: SliverChildBuilderDelegate(
                      childCount: 1,
                      (BuildContext context, int index) {
                        return Container(
                          height: 20,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 15, left: 20),
                          child: Text('Telefon nomerleri', style: TextStyle(fontSize: 15, color: Colors.black54),),);},)),


                SliverList(delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, int index) {
                    return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(var i in data_tel)
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text("* ", style: TextStyle(color: Colors.black54),),
                                Icon(Icons.phone_android_outlined, color: Colors.black54,),
                                SizedBox(width: 10,),
                                Text(
                                  i['phone'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.appColors,),),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (context){
                                        return DeletePhoneAlert( id: i['id'].toString(), callbackFunc: callbackDeletePhone,);});

                                          },
                                  child: Icon(Icons.delete, color: Colors.red,),
                                ),
                                SizedBox(width: 20,)
                              ],
                            )
                        )
                    ],
                  ) ;},)),

            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,
                  (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                          child: Text("HARYTLAR", style: TextStyle(color: CustomColors.appColors, fontSize: 17, fontWeight: FontWeight.bold),),
                        ),),
                        Expanded(child: Container(
                            height: 30,
                            margin: EdgeInsets.only(right: 25),
                            alignment: Alignment.centerRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewProduct(title: "Haryt goşmak", customer_id: customer_id, id: id, action:'store') ));
                              },
                              child: Text("+"),
                              backgroundColor: Colors.green,
                            )
                        ),),
                      ],
                    )
                );
              },)),
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (BuildContext context, int index) {
              return  Container(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: products.map((item) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductDetail(title: "Haryt", id: item['id'].toString()) ));
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
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     Text(item['name'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis),),
                                     Text(item['price'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis),),
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
      ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),)):
      
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
              setState(() { callbackStatus();});
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyPage(id:id, customer_id: customer_id, refreshFunc: widget.refreshFunc,)));
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    )),
    );
  }

    void getsinglemarkets({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/stores/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        products = json['products'];
        baseurl =  server_url.get_server_url();
        data_tel = json['phones'];
        var i;
        print(data);
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img_l']);
        }
      if (imgList.length==0){
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBYAVt1PGvwtPxFwyln-2VL4hyc3ViLcdgYaVFxgnrcK2KP9ywLquGti9teKFEFz4vP1o&usqp=CAU');
      }
      determinate = true;

    });
  }

  
}


class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  int _value = 1;
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Eltip bermek hyzmaty' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
          )
        ],
      ),
      content: Container(
          height: 150,
          width: 300,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                      splashRadius: 20.0,
                      activeColor: CustomColors.appColors,
                      value: 1,
                      groupValue: _value,
                      onChanged: (value){ setState(() {
                        _value = value!;
                      });}),
                  GestureDetector(
                    onTap: (){setState(() {_value = 1;});},
                    child: Text("Eltip bermek hyzmaty bar"),)
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      splashRadius: 20.0,
                      activeColor: CustomColors.appColors,
                      value: 2,
                      groupValue: _value,
                      onChanged: (value){ setState(() {
                        _value = value!;
                      });}),
                  GestureDetector(
                    onTap: (){setState(() {_value = 2;});},
                    child: Text("Eltip bermek hyzmaty yok"),)
                ],
              ),

            ],
          )
      ),
      actions: <Widget>[

        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Gözle'),
          ),
        )
      ],
    );
  }
}

