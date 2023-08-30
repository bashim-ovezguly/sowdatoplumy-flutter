import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/fistStore.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:provider/provider.dart';

import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

const List<String> list = <String>['Ulgama gir', 'ulgamda cyk', 'bilemok', 'ozin karar'];

class CheckBoxModal {
  String title;
  bool value;
  CheckBoxModal({ required this.title, this.value=false});
}

// ignore: must_be_immutable
class Store extends StatefulWidget {
  Store({Key? key, required this.title}) : super(key: key);
   String title;
  @override
  State<Store> createState() => _StoreState(title:title);
}
class _StoreState extends State<Store> {

  String dropdownValue = list.first;
  late  List<String> imgList = [];
  String title;
  List<dynamic> dataSlider = [{"img": "", 'name':"", 'location':''}];
  List<dynamic> data = [];
  int _current = 0;
  var baseurl = "";
  bool determinate = false;
  bool determinate1 = false;
  bool status = true;
  bool filter = false;


  callbackFilter(){
  timers();
  setState(() { 
    determinate = false; determinate1 = false;
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    
    if (int.parse(sort)==2){sort_value = 'sort=price';}
    if (int.parse(sort)==3){sort_value = 'sort=-price';}
    if (int.parse(sort)==4){sort_value = 'sort=id';}
    if (int.parse(sort)==4){sort_value = 'sort=-id';}
    
    if(title=='Marketler'){getmarketslist(sort_value);getmarkets_slider();}
    if(title=='Söwda merkezler'){getshopping_centerslist(sort_value);getslider_shopping_centers();}
    if(title=='Söwda nokatlar'){
      print('1');
      getstoreslist(sort_value);getslider_stores();}
    if(title=='Bazarlar'){getbazarlarlist(sort_value);getslider_shopping();}
  });}

  @override
  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;

    timers();
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    if (int.parse(sort)==2){sort_value = 'sort=price';}
    if (int.parse(sort)==3){sort_value = 'sort=-price';}
    if (int.parse(sort)==4){sort_value = 'sort=id';}
    if (int.parse(sort)==4){sort_value = 'sort=-id';}
    
    if(title=='Marketler'){getmarketslist(sort_value);getmarkets_slider();}
    if(title=='Söwda merkezler'){getshopping_centerslist(sort_value); getslider_shopping_centers();}
    if(title=='Söwda nokatlar'){
      print('2');
      getstoreslist(sort_value);getslider_stores();}
    if(title=='Bazarlar'){getbazarlarlist(sort_value);getslider_shopping();}
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostPerRequest = 100;
  final int _nextPageTriger = 3;
  final ScrollController _controller = ScrollController();
  final double _height = 100.0;
  
  void _animateToIndex(int index) {
    _controller.animateTo(
      index * 1,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
  
  _StoreState({required this.title});

  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(title: Text(title, style: CustomText.appBarText),
      actions: [
         Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:2)));
                  },
                  child: Icon(Icons.search, color: Colors.white, size: 25)
                )
              ) 
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
        child: determinate && determinate1? Container(
          height: MediaQuery.of(context).size.height-85,
          child: ListView.builder(
            controller: _controller,
            itemCount: data.length + (_isLastPage ? 0 : 1),
            
            itemBuilder: (context, index) {
            if (index == data.length - _nextPageTriger && _error==false) {
              
              var sort_value = "";
              var sort = Provider.of<UserInfo>(context, listen: false).sort;
              if (int.parse(sort)==2){sort_value = 'sort=price';}
              if (int.parse(sort)==3){sort_value = 'sort=-price';}
              if (int.parse(sort)==4){sort_value = 'sort=id';}
              if (int.parse(sort)==4){sort_value = 'sort=-id';}
              if(title=='Marketler'){getmarketslist(sort_value);getmarkets_slider();}
              if(title=='Söwda merkezler'){getshopping_centerslist(sort_value);getslider_shopping_centers();}
              if(title=='Söwda nokatlar'){
                getstoreslist(sort_value);getslider_stores();}
              if(title=='Bazarlar'){getbazarlarlist(sort_value);getslider_shopping();}
            }

            if (index == data.length) {
              if (_error) {
                return Center(
                    child: errorDialog(size: 15)
                );
              } else {
                return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ));
              }
            }

            return Container(
              child: index==0 ?
               Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){},
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
                            autoPlay: dataSlider.length>1 ? true: false,
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
                                  if (title=='Marketler' || title=='Söwda nokatlar'){
                                    if (item['id']!=null){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: item['id'].toString(), title: title,) ));
                                    }
                                    
                                  }
                                  else{
                                    if (item['id']!=null)
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StoreFirst(id: item['id'].toString(), title: title,) ));
                                    }
                                    
                                  }
                                },
                                child: Stack(
                                  children: [
                                          Container(
                                            height: 200,
                                            width: double.infinity,
                                            child:  FittedBox(
                                              fit: BoxFit.cover,
                                              child: item['img'] != '' ? Image.network(baseurl + item['img'].toString(),):
                                              Image.asset('assets/images/default16x9.jpg'),),
                                              ),
                                  ],),)).toList(),),),
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
                  ),
                   GestureDetector(
                  onTap: (){

                    if (title=='Marketler' || title=='Söwda nokatlar'){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: data[index]['id'].toString(), title: title), ));
                    }
                    else {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => StoreFirst(id: data[index]['id'].toString(), title: title,) ));
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
                                  color: CustomColors.appColors,
                                  margin: EdgeInsets.only(left: 2),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data[index]['name'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomText.itemTextBold))
                                            ),
                                      Expanded(
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                if (title=='Söwda merkezler') 
                                                  Text(
                                                    ' Söwda merkezi',                                                  
                                                    style: CustomText.itemText ),
                                                if (title=='Bazarlar') 
                                                  Text(
                                                    ' Bazary',                                                  
                                                    style: CustomText.itemText ),
                                                if (title=='Marketler' || title=='Söwda nokatlar') 
                                                 Text(
                                                    data[index]['category'].toString(),
                                                    overflow: TextOverflow.clip,
                                                    style: CustomText.itemText )
                                                    ],),)),
                                      Expanded(child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(child: new Container(
                                              child: Text(data[index]['location'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                                style: CustomText.itemText),
                                            ))
                                                ],),)),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          )
                        )
                      )
                    )
                )
                ],
               ): 
               GestureDetector(
                  onTap: (){

                    if (title=='Marketler' || title=='Söwda nokatlar'){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: data[index]['id'].toString(), title: title), ));
                    }
                    else {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => StoreFirst(id: data[index]['id'].toString(), title: title,) ));
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
                                  color: CustomColors.appColors,
                                  margin: EdgeInsets.only(left: 2),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data[index]['name'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomText.itemTextBold))
                                            ),
                                      Expanded(
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                if (title=='Söwda merkezler') 
                                                  Text(
                                                    ' Söwda merkezi',                                                  
                                                    style: CustomText.itemText ),
                                                if (title=='Bazarlar') 
                                                  Text(
                                                    ' Bazary',                                                  
                                                    style: CustomText.itemText ),
                                                if (title=='Marketler' || title=='Söwda nokatlar') 
                                                 Text(
                                                    data[index]['category'].toString(),
                                                    overflow: TextOverflow.clip,
                                                    style: CustomText.itemText )
                                                    ],),)),
                                      Expanded(child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(child: new Container(
                                              child: Text(data[index]['location'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                                style: CustomText.itemText),
                                            ))
                                                ],),)),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          )
                        )
                      )
                    )
                )

                );
          }
          ),
              )
        
        : Center(child: CircularProgressIndicator(color: CustomColors.appColors))
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
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter,);},);}


  void getmarketslist(sort_value) async {
    try{
      Urls server_url  =  new Urls();
      String url = server_url.get_server_url() + '/mob/markets?'+ sort_value.toString();
      var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
      final response = await http.get(Uri.parse( url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"), 
       headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id}
      );
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      
      var postList = [];
        for (var i in json['data']){
          postList.add(i);
        }
      setState(() {
      baseurl =  server_url.get_server_url();
      determinate = true;
      _isLastPage = data.length < _numberOfPostPerRequest;
      _loading = false;
      _pageNumber = _pageNumber + 1;
      data.addAll(postList);
    });
    
    } catch(e){
      setState(() {
        _loading = false;
        _error = true;
      });
    } 
    }

  void getmarkets_slider() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/markets?on_slider=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      baseurl =  server_url.get_server_url();
      if ( dataSlider.length==0){
        dataSlider = [{"img": "", 'name':"", 'location':''}];
      }
      determinate1 = true; 
      print(dataSlider);
    });}


  void getstoreslist(sort_value) async {
    print('isledi');
    try{
      Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/stores?'+ sort_value;
    final response = await http.get(Uri.parse( url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    var postList = [];
    for (var i in json['data']){
        postList.add(i);
      }
    setState(() {
      baseurl =  server_url.get_server_url();
      determinate = true;
      _isLastPage = data.length < _numberOfPostPerRequest;
      _loading = false;
      _pageNumber = _pageNumber + 1;
      data.addAll(postList);
    });
    } catch(e){
        setState(() {
        _loading = false;
        _error = true;
      });
    }
    
    }

  void getslider_stores() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/stores?on_slider=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      baseurl =  server_url.get_server_url();
      if ( dataSlider.length==0){dataSlider = [{"img": "", 'name':"", 'location':''}];}
      determinate1 = true;
    });}


  void getshopping_centerslist(sort_value) async {
    try{
      Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/shopping_centers?'+sort_value;
    final response = await http.get(Uri.parse( url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    var postList = [];
    for (var i in json['data']){
        postList.add(i);
      }
    setState(() {
      baseurl =  server_url.get_server_url();
      determinate= true;
      _isLastPage = data.length < _numberOfPostPerRequest;
      _loading = false;
      _pageNumber = _pageNumber + 1;
      data.addAll(postList);
    });
    } catch(e){
        setState(() {
        _loading = false;
        _error = true;
      });
    }
    }

  void getslider_shopping_centers() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/shopping_centers?on_slider=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      baseurl =  server_url.get_server_url();
      print(dataSlider);
      determinate1 =true;
    });}


  void getbazarlarlist(sort_value) async {
    try{
      Urls server_url  =  new Urls();
      String url = server_url.get_server_url() + '/mob/bazarlar?'+sort_value;
      final response = await http.get(Uri.parse( url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      var postList = [];
      for (var i in json['data']){
          postList.add(i);
        }
    setState(() {
      baseurl =  server_url.get_server_url();
      determinate = true;
      _isLastPage = data.length < _numberOfPostPerRequest;
      _loading = false;
      _pageNumber = _pageNumber + 1;
      data.addAll(postList);
    });
    } catch(e){
        setState(() {
        _loading = false;
        _error = true;
      }); 
    }
    }

  void getslider_shopping() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/bazarlar?on_slider=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate1 = true;
    });}


  Widget errorDialog({required double size}){
    return 
      GestureDetector(
        onTap: (){
          _animateToIndex(1);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title , style: TextStyle(color: CustomColors.appColors)),
            SizedBox(width: 5),
            Icon(Icons.arrow_upward, color: CustomColors.appColors,)
          ]
        )
    );
  }
}


