import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Services/serviceDetail.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';


const List<String> list = <String>['Ulgama gir', 'ulgamda cyk', 'bilemok', 'ozin karar'];

class ServicesList extends StatefulWidget {

  ServicesList({Key? key}) : super(key: key);
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  String dropdownValue = list.first;
  List<dynamic> data = [];
  List<dynamic> dataSlider = [{"img": "", 'name_tm':"", 'price':"", 'location':''}];
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool determinate1 = false;
  bool status = true;

  bool filter = false;
  callbackFilter(){
    timers();
    setState(() { filter=true;});
    }

  @override
  void initState() {
    timers();
    getserviceslist();
    getservices_slider();
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
    return status ? Scaffold(
        appBar: AppBar(
          title: const Text("Hyzmatlar", style: CustomText.appBarText,),
          actions: [
            Row(
              children: <Widget>[
                Container(
                    child:  GestureDetector(
                        onTap: (){
                          showConfirmationDialog(context);
                        },
                        child: const Icon(Icons.sort, size: 25,))),
                Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:5)));
                  },
                  child: Icon(Icons.search, color: Colors.white, size: 25)
                )
              ) 
              ],
            )
          ],),
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
                        Navigator.pushNamed(context, '/service/detail');
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
                                  print(item['id']);
                                  if (item['id']!= null){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetail(id: item['id'].toString(),) ));
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
                                             Text(item['name_tm'].toString(),
                                               style: TextStyle(shadows: [
                                                 Shadow(blurRadius: 10.0, color: Colors.black45, offset: Offset(5.0, 5.0),),
                                                 Shadow(color: Colors.white10, blurRadius: 10.0, offset: Offset(-10.0, 5.0),),],
                                                   fontSize: 20, color: Colors.white,
                                                   fontStyle: FontStyle.italic,
                                                   fontWeight: FontWeight.bold),),
                                             Text(item['price'].toString(), style: TextStyle(shadows: [
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
                                   ],)),),
                               )
                                   
                                   ).toList(),),),
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
                     ],),);},)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: data.length,
                    (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){ 
                      
                       Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetail(id: data[index]['id'].toString())));
                      
                      },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
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
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              child: Text(data[index]['name'].toString(), style: CustomText.itemTextBold,),)
                                        ),),

                                      Expanded(child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Text(data[index]['location'].toString(), overflow: TextOverflow.clip, style: CustomText.itemText)],),)),
                                      
                                      if (data[index]['store_id']==null || data[index]['store_id']=='')
                                          Expanded(
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: <Widget>[
                                                Text(data[index]['price'].toString(), style: CustomText.itemText)],),))
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
                    ),
                  );
                },
              ),
            )
          ],
        ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
        ),
        drawer: MyDraver(),
    ): CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc:callbackFilter,);},);}


  void getserviceslist() async {
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
    String url = server_url.get_server_url() + '/mob/services?' + sort_value;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      print(data);
      determinate = true;
    });}

  void getservices_slider() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/services?on_slider=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      baseurl =  server_url.get_server_url();
      if ( dataSlider.length==0){
        dataSlider = [{"img": "", 'name_tm':"", 'price':"", 'location':''}];
      }
      print(dataSlider);
      determinate1 = true;
    });}


}
