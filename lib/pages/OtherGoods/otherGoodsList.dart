import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/OtherGoods/otherGoodsDetail.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';
import '../sortWidget.dart';


const List<String> list = <String>['Ulgama gir', 'ulgamda cyk', 'bilemok', 'ozin karar'];

class OtherGoodsList extends StatefulWidget {

  OtherGoodsList({Key? key}) : super(key: key);
  @override
  State<OtherGoodsList> createState() => _OtherGoodsListState();
}

class _OtherGoodsListState extends State<OtherGoodsList> {
  String dropdownValue = list.first;

  List<dynamic> dataSlider = [{"img": "", 'name':"", 'price':"", 'location':''}];
  List<dynamic> data = [];
  int _current = 0;
  var baseurl = "";  
  bool determinate = false;
  bool determinate1 = false;

  bool filter = false;
  callbackFilter(){setState(() { 
    determinate = false;
    determinate1 = false;
    getproductlist();
    getslider_products();
  });}

  void initState() {
    getproductlist();
    getslider_products();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Beýleki bildirişler", style: CustomText.appBarText,),

          actions: [
            Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10),
                    child:  GestureDetector(
                        onTap: (){
                          showConfirmationDialog(context);
                        },
                        child: const Icon(Icons.sort, size: 25,))),
              ],
            )
          ],
        ),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColors,
          onRefresh: ()async{
            setState(() {
            determinate = false;
            determinate1 = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));

          },
          child: determinate && determinate1? CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                      (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                       
                      },
                      child: Stack(
                      alignment: Alignment.bottomCenter,
                      textDirection: TextDirection.rtl,
                      fit: StackFit.loose,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 200,
                          color: Colors.white,
                          child: CarouselSlider(
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
                                .map((item) => GestureDetector(
                                  onTap: (){
                                    if (item['id']!=null && item['id']!='')
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: item['id'].toString(),title: 'Beýleki bildirişler',) ));
                                    }
                                    
                                  },
                                  child: Container(
                              color: Colors.white,
                              child: Center(
                                  child: Stack(
                                    children: [
                                      ClipRect(
                                      child: Container(
                                        height: 200,
                                        width: double.infinity,
                                        child:  FittedBox(
                                          fit: BoxFit.cover,
                                          child: item['img'] != null && item['img'] != '' ? Image.network(baseurl + item['img'].toString(),):
                                          Image.asset('assets/images/default16x9.jpg'),),
                                      ),
                                    ),
                                      Positioned(top: 130, left: 10,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (item['name']!=null)
                                              Text(item['name'].toString(),
                                                style: TextStyle(shadows: [
                                                  Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                                  Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                                    fontSize: 20, color: Colors.white,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold),),
                                              Text(item['price'].toString() , style: TextStyle(shadows: [
                                                Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                                Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                                  fontSize: 18, color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold),),
                                              Text(item['location'].toString(), style: TextStyle(shadows: [
                                                Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                                Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                                  fontSize: 18, color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold),)],))
                                    ],)),))
                              ).toList(),),
                        ),
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

                      ],
                    ),
                    );},)),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: data.length,
                    (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){ 
                       Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: data[index]['id'].toString(), title: 'Beýleki bildirişler',)));
                      },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Card(
                        elevation: 2,
                        child: Container(
                          height: 110,
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                                 Expanded(flex: 1,
                                   child: ClipRect(
                                      child: Container(
                                      height: 110,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: data[index]['img'] != '' && data[index]['img'] != null ? Image.network(baseurl + data[index]['img'].toString(),):
                                        Image.asset('assets/images/default.jpg', ),),),
                                     )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: CustomColors.appColors,
                                  margin: EdgeInsets.only(left: 2),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      if (data[index]['name']!=null && data[index]['name']!='')
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data[index]['name'],
                                            maxLines: 1,
                                            style: CustomText.itemTextBold,),),),
                                      if (data[index]['location']!=null && data[index]['location']!='')
                                      Expanded(child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.place,color: Colors.white, size: 15,),SizedBox(width: 5,),
                                            Text(data[index]['location'].toString(), style: CustomText.itemText)],),)),

                                      Expanded(
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.access_time_outlined,color: Colors.white, size: 15,),SizedBox(width: 5,),
                                                Text(data[index]['delta_time'].toString(),style: CustomText.itemText)],),)),

                                      if (data[index]['store_id']==null || data[index]['store_id']=='')
                                          Expanded(child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: <Widget>[
                                                Text('Kredit',style: TextStyle(color: Colors.white, fontSize: 12)),
                                                data[index]['credit'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                                SizedBox(width: 5,),
                                                Text('Obmen',style: TextStyle(color: Colors.white, fontSize: 12)),
                                                data[index]['swap'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                                SizedBox(width: 5,),
                                                Text('Nagt däl',style: TextStyle(color: Colors.white, fontSize: 12)),
                                                data[index]['none_cash_pay'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                              ],),))
                                        else
                                          Expanded(child:Align(
                                              alignment: Alignment.centerLeft,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                child: Text(
                                                  data[index]['store_name'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: CustomText.itemText,
                                                ),
                                              )))

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
        ),

        drawer: const MyDraver(),
        floatingActionButton: Container(
          height: 45,
          width: 45,
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 182, 210, 196), width: 2.0),
                color : Colors.blue[900],
                shape: BoxShape.circle,
              ),
              child: InkWell(
              
                borderRadius: BorderRadius.circular(
                    500.0), 
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:4)));
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  //size: 50,
                ),
              ),
            ),
          ),
        ),
    );
  }

  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter);},);}


    void getproductlist() async {

    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    
    if (int.parse(sort)==2){
      sort_value = 'sort=price';
    }
    
    if (int.parse(sort)==3){
      sort_value = 'sort=-price';
    }
    
    if (int.parse(sort)==4){
      sort_value = 'sort=id';
    }

    if (int.parse(sort)==4){
      sort_value = 'sort=-id';
    }
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products?';
    print(url);
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      print(data);
      determinate = true;
    });}


    void getslider_products() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products?on_slider=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      if ( dataSlider.length==0){
        dataSlider = [{"img": "", 'name_tm':"", 'price':"", 'location':''}];
      }
      baseurl =  server_url.get_server_url();
      determinate1 = true;
    });}

}
