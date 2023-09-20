import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/OtherGoods/otherGoodsDetail.dart';
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
  bool status = true;
  var keyword = TextEditingController();

  bool filter = false;
  callbackFilter(){setState(() { 
    timers();
    determinate = false;
    determinate1 = false;
    getproductlist();
    getslider_products();
  });}

  void initState() {
    _pageNumber = 1;
    _isLastPage = false;
    _loading = true;
    _error = false;
    timers(); getproductlist(); getslider_products();
    super.initState();
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
  
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
        appBar: AppBar(
          title: const Text("Harytlar", style: CustomText.appBarText,),
          actions: [
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child:  GestureDetector(
                    onTap: (){showConfirmationDialog(context);},
                    child: const Icon(Icons.sort, size: 25,))),

                Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:4)));
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
          onRefresh: ()async{
            setState(() {
            determinate = false;
            determinate1 = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));},
          child: determinate && determinate1 ? Column(  
            children: [
              Container(margin: EdgeInsets.only(left: 10, right: 10),
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
                                getproductlist();
                              },
                              ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  keyword.text = '';
                                });
                                getproductlist();
                              },
                            ),
                            hintText: 'Gözleg...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
        Container(
          height: MediaQuery.of(context).size.height-125,
          child: ListView.builder(
            itemCount: data.length + (_isLastPage ? 0 : 1),
            
            itemBuilder: (context, index) {
            if (index == data.length - _nextPageTriger) {
              getproductlist();
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
                              autoPlay: dataSlider.length > 1 ? true: false,
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
                                    {Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: item['id'].toString(),title: 'Harytlar',) ));}
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
                                          child: item['img'] != null && item['img'] != '' ? Image.network(baseurl + item['img'].toString()):
                                          Image.asset('assets/images/default16x9.jpg'))
                                      )
                                    ),
                                      
                                    ]))))
                              ).toList())
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
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)))))
                      ])
                    ),
                    GestureDetector(
                    onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: data[index]['id'].toString(), title: 'Harytlar',)));},
                    child: Container(
                      height: 110,
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
                                                Text(data[index]['delta_time'].toString(),style: CustomText.itemText),
                                                Spacer(),
                                                Text(data[index]['price'].toString(),style: CustomText.itemText),
                                                ]
                                                ))),

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

                                          Expanded(child:Container(
                                            height: 25,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/store.png',
                                                      color: CustomColors.appColorWhite,
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      data[index]['store_name'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: CustomText.itemText,
                                                    )
                                                  ],
                                                ),
                                              ))

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
               ): 
               GestureDetector(
                    onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: data[index]['id'].toString(), title: 'Harytlar',)));},
                    child: Container(
                      height: 110,
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
                                                Text(data[index]['delta_time'].toString(),style: CustomText.itemText),
                                                Spacer(),
                                                Text(data[index]['price'].toString(),style: CustomText.itemText),
                                                ]
                                                ))),

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

                                          Expanded(child:Container(
                                            height: 25,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/store.png',
                                                      color: CustomColors.appColorWhite,
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      data[index]['store_name'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: CustomText.itemText,
                                                    )
                                                  ],
                                                ),
                                              ))

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
   
                );
          } 
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
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter);},);
  }

  void getproductlist() async {

    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";    
    if (int.parse(sort)==2){sort_value = 'sort=price';}
    if (int.parse(sort)==3){sort_value = 'sort=-price';}
    if (int.parse(sort)==4){sort_value = 'sort=id';}
    if (int.parse(sort)==4){sort_value = 'sort=-id';}
    
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products?';
    if (keyword.text!=''){var value = keyword.text; url = server_url.get_server_url() + '/mob/products?name=$value';}
       Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await get(Uri.parse( url + "&page=$_pageNumber&page_size=$_numberOfPostPerRequest"), headers: headers);
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
    }

    void getslider_products() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products?on_slider=1';
    final uri = Uri.parse(url);
       Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      dataSlider  = json['data'];
      if ( dataSlider.length==0){dataSlider = [{"img": "", 'name_tm':"", 'price':"", 'location':''}];}
      baseurl =  server_url.get_server_url();
      determinate1 = true;
    });
  }

    Widget errorDialog({required double size}){
    return SizedBox(
      height: 180,
      width: 200,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black
            ),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
              onTap:  ()  {
                setState(() {
                  _loading = true;
                  _error = false;
                  getproductlist();
                });
              },
              child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),)),
        ],
      ),
    );
  }
}
