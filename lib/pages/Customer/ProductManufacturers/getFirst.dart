import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/ProductManufacturers/edit.dart';
import '../../../dB/colors.dart';
import '../../../dB/textStyle.dart';
import '../../fullScreenSlider.dart';
import '../../progressIndicator.dart';
import '../deleteAlert.dart';
import '../newProduct.dart';
import '../productDetail.dart';



class FactoriesFirst extends StatefulWidget {
  FactoriesFirst({Key? key, required this.id, required this.customer_id, required this.refreshFunc}) : super(key: key);
  final String id;
  final String customer_id;
  final Function refreshFunc;
  @override
  State<FactoriesFirst> createState() => _FactoriesFirstState(id: id, customer_id: customer_id);
}

class _FactoriesFirstState extends State<FactoriesFirst> {
  final String id;
  final String customer_id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  var s=0;
  bool determinate = false;
  bool status1 = true;
  List<dynamic> products = [ ];
  List<String> imgList = [ ];
  
  void initState() {
    timers();
    widget.refreshFunc();
    if (imgList.length==0){
      imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0YmKxREuu1UqGBi9U025dn-IEfCynmxvLng&usqp=CAU');
    }
    getsinglefactories(id: id);
    super.initState();
  }

  bool status = false;
  callbackStatus(){setState(() {status = true;});}
    callbackStatusDelete(){
      widget.refreshFunc();
    Navigator.pop(context);
  }
    timers() async {
      setState(() {status1 = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  _FactoriesFirstState({required this.id ,required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return status1 ? Scaffold(backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Meniň sahypam', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
            Text('Önüm öndürijiler',  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),
          ],
        ),
              actions: [
        PopupMenuButton<String>(
              
              itemBuilder: (context) {
                List<PopupMenuEntry<String>> menuEntries2 = [
                   PopupMenuItem<String>(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FactoriesEdit(old_data: data, callbackFunc: callbackStatus)));  
                      },
                      child: Container(
                        color: Colors.white,
                        height: 40, width: double.infinity,
                        child: Row(children: [
                          Icon(Icons.edit_road, color: Colors.green,),
                          Text(' Üýtgetmek')
                        ]))
                    )
                  ),
                  PopupMenuItem<String>(
                    child: GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return DeleteAlert(action: 'factories',id: id, callbackFunc: callbackStatusDelete,);});
                      },
                      child: Container(
                        color: Colors.white,
                        height: 40, width: double.infinity,
                        child: Row(children: [
                          Icon(Icons.delete, color: Colors.red,),
                          Text('Pozmak')
                        ]))
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
                return Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child:  Row(
                      children: <Widget>[
                        Flexible(child: new Container(
                          child: Text(data['name_tm'].toString() ,overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: CustomColors.appColors, fontSize: 18,),),
                        )),
                      ],
                    )
                );
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Image border
                              child: Image.network(item, fit: BoxFit.fill, height: 200,width: double.infinity,),)
                        ),)).toList(),),
                    onTap: (){ 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) )); 
                      },),
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
            );},)),

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
                              Text(data['created_at'].toString(), style: TextStyle(fontSize: 18, color: CustomColors.appColors,),),],),),
                          Expanded(child: Row(
                            children:  <Widget>[
                              Icon(Icons.visibility_sharp,size: 20,color: CustomColors.appColors,),
                              SizedBox(width: 10,),
                              Text(data['viewed'].toString(), style: TextStyle(fontSize: 18, color: CustomColors.appColors,
                              ),),],),)],),

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
                          Expanded(child: Text(data['id'].toString(),  style: CustomText.size_16))],),),
                              
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        height: 30,
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
                        height: 40,
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
                          child: Text("ÖNÜMLER", style: TextStyle(color: CustomColors.appColors, fontSize: 17, fontWeight: FontWeight.bold),),
                        ),),
                        Expanded(child: Container(
                            height: 30,
                            margin: EdgeInsets.only(right: 25),
                            alignment: Alignment.centerRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewProduct(title: "Haryt goşmak", customer_id: customer_id, id : id, action:'factory') ));
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
              return  
              
              Container(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: products.map((item) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductDetail(title: "Önüm", id: item['id'].toString()) ));
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
                                color: CustomColors.appColors,
                                child: Column(
                                  children: [
                                     Text(item['name'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColorWhite),),
                                     Text(item['price'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColorWhite),),
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
        ):  Center(child: CircularProgressIndicator(color: CustomColors.appColors))
        
           ):
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FactoriesFirst(id:id, customer_id: customer_id, refreshFunc: widget.refreshFunc,)));
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    ))
    ): CustomProgressIndicator(funcInit: initState);
  }
  showConfirmationDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Delivery();},);}

    void getsinglefactories({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/factories/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data = {};
        data  = json;
        products = json['products'];
        baseurl =  server_url.get_server_url();
        // ignore: unused_local_variable
        var i;
        print(products);
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img_m']);
        }
        determinate = true;
      if (imgList.length==0){
        imgList.add('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0YmKxREuu1UqGBi9U025dn-IEfCynmxvLng&usqp=CAU');
      }});}

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

