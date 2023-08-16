import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/progressIndicator.dart';
import 'package:my_app/pages/ribbon/ribbonList.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:my_app/pages/adPage.dart';
import 'package:my_app/pages/regionWidget.dart';
import 'package:my_app/dB/colors.dart';
import '../dB/providers.dart';
import '../main.dart';
import 'Search/search.dart';
import 'Store/store.dart';
import 'homePageLocation.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  bool a = false;
  bool status = true;
  List<dynamic> dataSlider1 = [];
  List<dynamic> dataSlider2 = [];
  List<dynamic> dataSlider3 = [];
  List<dynamic> items= [];
  String store_count ='';
  var region = {};
  bool determinate = false;
  var baseurl = "";

  void initState() {
    timers();
    setState(() {
      determinate = false; status = true;
      region = Provider.of<UserInfo>(context, listen: false).regionsCode;});
    getHomePage();
    super.initState();
  }

  callbackLocation(new_value){ setState(() {
    Provider.of<UserInfo>(context, listen: false).chang_Region_Code(new_value);
    region = Provider.of<UserInfo>(context, listen: false).regionsCode;
    determinate = false;
    getHomePage();
  });}

  timers() async {
    setState(() {status = true;});
    final completer = Completer();
    final t = Timer(Duration(seconds: 5), () => completer.complete());
    await completer.future;
    setState(() {
      status = false;
    });
  }
  
  @override
  Widget build(BuildContext context)  {
    return status==false ? Scaffold(
      appBar: AppBar(
        title: Column(        
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Baş sahypa",),
            ),
              Container(
                margin: EdgeInsets.only(top: 3),
                alignment: Alignment.centerLeft,
                child: region!={} && region['name_tm']!=null ? Text(region['name_tm'].toString(), style: TextStyle(fontSize: 12),): Container()
              ),
          ],
        ),
        actions: [
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                  child:  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RibbonList()));
                      },
                      child: Stack(
                        children: [
                          Icon(Icons.bookmark_border),
                          Positioned(right: 0,
                            child: Icon(Icons.circle, size: 10, color: Colors.green))
                        ],
                      ))),

              Container(
                  child:  GestureDetector(
                      onTap: (){
                        showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return LocationWidget(callbackFunc: callbackLocation);},);
                      },
                      child: const Icon(Icons.location_on, size: 25))),

              Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:0)));},
                  child: Icon(Icons.search, color: Colors.white, size: 25)
                )
              )              
            ])]),
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
        
        child: determinate  ? CustomScrollView(
        physics : ClampingScrollPhysics(),
        slivers: [      
          SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                    (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    color: Colors.black12,
                    child: ImageSlideshow(
                      indicatorColor: CustomColors.appColors,
                      indicatorBackgroundColor: Colors.grey,
                      onPageChanged: (value) {},
                      autoPlayInterval: 6666,
                      isLoop: true,
                      children: [
                        if (dataSlider1.length==0)
                              ClipRect(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child:  FittedBox(
                                          fit: BoxFit.cover,
                                          child:  Image.asset('assets/images/default.jpg'),
                                      ),
                                    ),
                              ),
                         
                        for (var item in dataSlider1)
                          if (item['img']!= null && item['img']!='')
                            GestureDetector(
                              onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdPage(id: item['id'].toString(),) ));
                              },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(baseurl+ item['img']),
                                            fit: BoxFit.cover,    // -> 02
                                          ),
                                        ),
                                      //   child:  FittedBox(
                                      //     fit: BoxFit.fill,
                                      //     child: Image.network( baseurl+ item['img']),
                                      // ),
                                    ),
                              
                            )
                      ],),);

                  },)),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                    (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                          children: <Widget>[
                            Expanded(child: Container(
                              height: 180,
                              color: Colors.black12,
                              child: ImageSlideshow(
                                width: double.infinity,
                                initialPage: 0,
                                indicatorColor: CustomColors.appColors,
                                indicatorBackgroundColor: Colors.grey,
                                onPageChanged: (value) {},
                                autoPlayInterval: 5555,
                                isLoop: true,
                                children: [
                                  if (dataSlider2.length==0)
                                  ClipRect(
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      child:  FittedBox(
                                        fit: BoxFit.cover,
                                        child:  Image.asset('assets/images/default.jpg'),
                                        ),),),
                                   
                                  for (var item in dataSlider2)
                                    if (item['img']!= null && item['img']!='')
                                      GestureDetector(
                                        onTap: (){
                                           Navigator.push(context, MaterialPageRoute(builder: (context) => AdPage(id: item['id'].toString(),) ));
                                        },
                                        child: ClipRect(
                                          child: Container(
                                            height: 200,
                                            width: double.infinity,
                                            child:  FittedBox(
                                              fit: BoxFit.cover,
                                              child: Image.network( baseurl+ item['img'],fit: BoxFit.cover,),
                                              ),),)
                                      )
                                  ],)
                                  
                                  ,)),
                                  SizedBox(width: 5,),
                            Expanded(child: Container(
                              height: 180,
                              color: Colors.black12,
                              child: ImageSlideshow(
                                width: double.infinity,
                                initialPage: 0,
                                indicatorColor: CustomColors.appColors,
                                indicatorBackgroundColor: Colors.grey,
                                onPageChanged: (value) {},
                                autoPlayInterval: 4444,
                                isLoop: true,
                                children: [
                                  if (dataSlider3.length==0)
                                      ClipRect(
                                          child: Container(
                                            height: 200,
                                            width: double.infinity,
                                            child:  FittedBox(
                                              fit: BoxFit.cover,
                                              child:  Image.asset('assets/images/default.jpg'),
                                          )
                                        )
                                  ),
                                   
                                  for (var item in dataSlider3)
                                    if (item['img']!= null && item['img']!='')
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdPage(id: item['id'].toString(),) ));
                                        },
                                    child: ClipRect(
                                      child: Container(
                                        height: 200,
                                        width: double.infinity,
                                        child:  FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.network( baseurl+ item['img'],fit: BoxFit.cover,),
                                      ))))
                                  ],),)),]));},)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: items.length,
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdPage(id: items[index]['id'].toString(),) ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                  elevation: 2,
                  shadowColor: CustomColors.appColors,
                  child: Container(
                    height: 110,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: ClipRect(
                              child: Container(
                              height: 110,
                              width: double.infinity,
                              child:  FittedBox(
                              fit: BoxFit.cover,
                              child: items[index]['img'] != null && items[index]['img'] != '' ? Image.network(
                                baseurl + items[index]['img'].toString(),
                                ): Image.asset('assets/images/default.jpg'))))
                          )),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(left: 2),
                            padding: const EdgeInsets.all(5),
                            color: CustomColors.appColors,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                 Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      items[index]['name'].toString(),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: CustomColors.appColorWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),),),),
                                SizedBox(height: 5,),
                                Expanded(child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text( items[index]['delta_time'].toString(), overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(color: CustomColors.appColorWhite,fontSize: 14)),
                                )),
                                SizedBox(height: 5),
                                Expanded(child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(items[index]['location'].toString(), overflow: TextOverflow.clip, maxLines: 1,style: TextStyle(color: CustomColors.appColorWhite, fontSize: 14))
                                )),
                              SizedBox(height: 10)
                              ]
                            )
                          )
                        )
                      ]
                    )
                  )
                )
                  )
                );
              }
            )
          )
        ]
      ):CustomProgressIndicator(funcInit: initState) 
      ),
      drawer: MyDraver(),
    ):HomePageProgressIndicator(funcInit: initState);
  }
  

  showConfirmationDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RegionWidget();},);}
        
  void getHomePage() async {

    var region_code = Provider.of<UserInfo>(context, listen: false).regionsCode;
    Map<String, String> _header = {};

    if (region_code!={} && region_code['id']!=null){
      _header = <String, String>{
      "Region-Id": region_code['id'].toString(), 
      "Source": "Android"};
    }
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/home_ads';
    final uri = Uri.parse(url);
    final response = await http.get(uri , headers: _header);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      baseurl =  server_url.get_server_url();
      dataSlider1  = json['data']['slider1'];
      if ( dataSlider1.length==0){dataSlider1 = [{"img": "", 'name':"", 'location':''}];}
      dataSlider2  = json['data']['slider2'];
      if ( dataSlider2.length==0){dataSlider2 = [{"img": "", 'name':"", 'location':''}];}
      dataSlider3  = json['data']['slider3'];
      if ( dataSlider3.length==0){dataSlider3 = [{"img": "", 'name':"", 'location':''}];}
      items  = json['data']['items'];
      if ( items.length==0){items = [{"img": "", 'name':"", 'location':''}];}
      if (dataSlider1.length!=0){setState(() {determinate = true; status = false;});}

      Map<String, dynamic> new_statistic = {"store_count": json['data']['store_count'].toString(),
                                            "pharmacy_count": json['data']['pharmacy_count'].toString(),
                                            "bazar_count": json['data']['bazar_count'].toString(),
                                            "shopping_center_count": json['data']['shopping_center_count'].toString(),
                                            "market_count": json['data']['market_count'].toString(),
                                            "car_count": json['data']['car_count'].toString(),
                                            "part_count": json['data']['part_count'].toString(),
                                            "service_count": json['data']['service_count'].toString(),
                                            "product_count": json['data']['product_count'].toString(),
                                            "factory_count": json['data']['factory_count'].toString(),
                                            "flat_count": json['data']['flat_count'].toString() };

      Provider.of<UserInfo>(context, listen: false).set_statistic(new_statistic);
    });}
}


class MyDraver extends StatelessWidget {
  MyDraver({Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var statistic = Provider.of<UserInfo>(context, listen: false).statistic;


    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
              child: Image.asset(
                'assets/images/lllll.jpeg',
                height: 140,
                width: 200,
              ),
            ),
            ),
            
            GestureDetector(
            onTap: ()async{
              const url = 'http://business-complex.com.tm/';
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await FlutterWebBrowser.openWebPage(url: url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.explore, color: CustomColors.appColors,),
                  Image.asset('assets/images/browser_internet.png', height: 30, width: 30,),
                  Text('  business-complex.com.tm', 
                  style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.appColors,
              ),),
                ],
              )
            ),
          ),
          
          SizedBox(
            height: MediaQuery.of(context).size.height-200,
            child: ListView(
              children: <Widget>[
                
                GestureDetector(
                  onTap: (){Navigator.pushNamed(context, "/");},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: (){Navigator.pushNamed(context, "/");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.home, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Baş sahypa', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),),
                          ]
                        )
                      )
                    )  
                  )
                ),

                GestureDetector(
                  onTap: () async {
                    final allRows = await dbHelper.queryAllRows();
                    if (allRows.length==0){ Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}
                    else{Navigator.push(context, MaterialPageRoute(builder: (context) => MyPages() ));}},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () async {
                        final allRows = await dbHelper.queryAllRows();
                        if (allRows.length==0){ Navigator.push(context, MaterialPageRoute(builder: (context) => Login() ));  }
                        else{Navigator.push(context, MaterialPageRoute(builder: (context) => MyPages() ));  }},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.person, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Meniň sahypam', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                          ]
                        )
                      )
                    )
                  )
                ),

                 GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Söwda nokatlar") ));},
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Söwda nokatlar") ));},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.store_outlined, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Söwda nokatlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['store_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )
                  )
                 ),

                GestureDetector(
                  onTap: (){Navigator.pushNamed(context, "/othergoods/list");},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.pushNamed(context, "/othergoods/list");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.newspaper, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Harytlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['product_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )
                  )
                ),

                 GestureDetector(
                  onTap: (){Navigator.pushNamed(context, "/pharmacies/list");},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.pushNamed(context, "/pharmacies/list");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.local_pharmacy_sharp, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Dermanhanalar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['pharmacy_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )
                  )
                 ),

                 GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Bazarlar") )); },
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Bazarlar") )); },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.storefront_sharp, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Bazarlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['bazar_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )     
                  )
                 ),

                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Söwda merkezler") ));},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Söwda merkezler") ));},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.store, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Söwda merkezler', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['shopping_center_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )       
                  )
                ),

                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Marketler") ));},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Marketler") ));},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.storefront_outlined, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Marketler', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['market_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )
                  )
                ),

                GestureDetector(
                  onTap: () { Navigator.pushNamed(context, "/productManufacturers"); },
                  child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/productManufacturers");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.store_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 14,),
                          Text('Önüm öndürijiler', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                          Spacer(),
                          Text(statistic['factory_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                          SizedBox(width: 15),
                        ]
                      )
                    )
                  )
                )
              ),

                GestureDetector(
                  onTap: () {Navigator.pushNamed(context, "/car");},
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.pushNamed(context, "/car");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.car_repair, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Awtoulaglar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['car_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )
                  )
                ),

               GestureDetector(
                onTap: () { Navigator.pushNamed(context, "/autoParts"); },
                child:  Container(
                  color: Colors.white,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/autoParts");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 14,),
                          Text('Awtoşaýlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                          Spacer(),
                          Text(statistic['part_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                          SizedBox(width: 15),
                        ]
                      )
                    )
                  )
                )
               ),

                GestureDetector(
                  onTap: () { Navigator.pushNamed(context, "/properties/list"); },
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.pushNamed(context, "/properties/list");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.other_houses, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Emläkler', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['flat_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )
                  )
                ),

                GestureDetector(
                  onTap: () {Navigator.pushNamed(context, "/constructions/list");},
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.pushNamed(context, "/constructions/list");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.build_circle, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Gurluşyk harytlary', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['service_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )        
                  )
                ),
                
                GestureDetector(
                  onTap: () {Navigator.pushNamed(context, "/services/list");},
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: GestureDetector(
                      onTap: () {Navigator.pushNamed(context, "/services/list");},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.home_repair_service, size: 25, color: CustomColors.appColors,),
                            SizedBox(width: 14,),
                            Text('Hyzmatlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            Spacer(),
                            Text(statistic['service_count'], style: TextStyle(fontSize: 16, color: CustomColors.appColors)),
                            SizedBox(width: 15),
                          ]
                        )
                      )
                    )        
                  )
                ),
                Container(height: 20)        
              ]
            )
          )
        ]
      )
    );
  }
}

