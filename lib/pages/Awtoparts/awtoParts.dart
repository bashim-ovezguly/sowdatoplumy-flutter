import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/Search/search.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'awtoPartsDetail.dart';

const List<String> list = <String>['Ulgama gir', 'ulgamda cyk', 'bilemok', 'ozin karar'];

class AutoParts extends StatefulWidget {
  const AutoParts({Key? key}) : super(key: key);

  @override
  State<AutoParts> createState() => _AutoPartsState();
}

class _AutoPartsState extends State<AutoParts> {
  String dropdownValue = list.first;
  List<dynamic> data = [];
  List<dynamic> dataSlider = [{"img": "", 'name':"", 'price':"", 'location':''}];
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool determinate1 = false;
  bool status = true;
  
  bool filter = false;
  callbackFilter(){setState(() { 
    determinate = false;
    determinate1 = false;
    getpartslist();
    getparts_slider();  
    });}

  void initState() {
    timers();
    getpartslist();
    getparts_slider();  
    super.initState();
  }
  timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  @override
  Widget build(BuildContext context) {
    return status? Scaffold(
        appBar: AppBar(
          title: const Text("Awtoşaýlar", style: CustomText.appBarText,),
          actions: [
            Row(
              children: <Widget>[
                Container(
                    child:  GestureDetector(
                        onTap: (){showConfirmationDialog(context);},
                        child: const Icon(Icons.sort, size: 25,))),

                  Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:1)));
                  },
                  child: Icon(Icons.search, color: Colors.white, size: 25)
                )
              )  
              ],
            )
          ],
        ),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColors,
          onRefresh: () async{
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
                  childCount:1,
                      (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      textDirection: TextDirection.rtl,
                      fit: StackFit.loose,
                      clipBehavior: Clip.hardEdge,
                      children: [
                    Container(
                    margin: const EdgeInsets.all(10),
                        height: 200,
                        color: Colors.black12,
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
                        onPageChanged: (index, reason) {
                        setState(() {
                        _current = index;
                        });}),
                        items: dataSlider
                            .map((item) => 
                            GestureDetector(
                              onTap: (){
                                if (item['id']!=null && item['id']!=''){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AutoPartsDetail(id: item['id'].toString(),) ));
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
                                  if (item['name_tm']!=null)
                                  Text(item['name_tm'].toString(),
                                    style: TextStyle(shadows: [
                                      Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                      Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                        fontSize: 18, color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),),
                                  if (item['price']!=null)
                                  Text(item['price'].toString() , style: TextStyle(shadows: [
                                    Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                    Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                      fontSize: 18, color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),),
                                  if (item['location']!=null)
                                  Text(item['location'].toString(), style: TextStyle(shadows: [
                                    Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                    Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                      fontSize: 18, color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),)],))],)),),
                            )                  
                        ).toList(),),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: DotsIndicator(
                            dotsCount: dataSlider.length,
                            position: _current.toDouble(),
                            decorator: DotsDecorator(
                              color: Colors.white,
                              activeColor: CustomColors.appColors,
                              activeShape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            ),
                          ),
                        )


                        ],
                    );

                    },)),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: data.length,
                    (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: (){
                        if (data[index]['id']!=null && data[index]['id']!=''){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AutoPartsDetail(id: data[index]['id'].toString())));
                        }
                       
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: Card(
                            elevation: 2,
                            child: Container(
                              height: 110,
                              child: Row(
                                children: <Widget>[
                                  Expanded(flex: 1,
                                   child: ClipRect(
                                      child: Container(
                                      height: 110,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: data[index]['img'] != '' ? Image.network(baseurl + data[index]['img'].toString(),):
                                        Image.asset('assets/images/default.jpg', ),),),
                                     )),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 2),
                                      padding: const EdgeInsets.all(10),
                                      color: CustomColors.appColors,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                data[index]['name_tm'].toString(),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 2,
                                                  softWrap: false,
                                                style: CustomText.itemTextBold,),),),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                 data[index]['location'].toString(),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 2,
                                                  softWrap: false,
                                                style: CustomText.itemText,),),),
                                          Expanded(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    data[index]['price'].toString(),
                                                    style: CustomText.itemText
                                                ),)),


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
                                                ),)))


                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )

                  );
                },
              ),
            )
          ],
        ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
        ),
        drawer: const MyDraver(),
    ):CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter,);},);}

    void getpartslist() async {

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
    String url = server_url.get_server_url() + '/mob/parts?' + sort_value.toString();
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate = true;
      print(data);

    });}

    void getparts_slider() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/parts?on_slider=1';
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
      print(data);
    });}


}

