import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/material.dart';
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
import 'Customer/locationWidget.dart';
import 'Orders/ordersList.dart';
import 'Search/search.dart';
import 'Store/store.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  bool a = false;
  List<dynamic> dataSlider1 = [];
  List<dynamic> dataSlider2 = [];
  List<dynamic> dataSlider3 = [];
  List<dynamic> items= [];  
  var region = {};

  bool determinate = false;
  var baseurl = "";
  void initState() {
    setState(() {region = Provider.of<UserInfo>(context, listen: false).regionsCode;});
    getHomePage();
    super.initState();
  }
  callbackLocation(new_value){ setState(() {
    Provider.of<UserInfo>(context, listen: false).chang_Region_Code(new_value);
    region = Provider.of<UserInfo>(context, listen: false).regionsCode;
    });}
  
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
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
                        showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return LocationWidget(callbackFunc: callbackLocation);},);
                      },
                      child: const Icon(Icons.location_on, size: 25,))),
            ],)],),
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
        
        child: determinate ? CustomScrollView(
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
                                  ],),)),
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
                                          ),
                                        ),
                                  ),
                                   
                                  for (var item in dataSlider1)
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
                                      ),
                                    ),
                              )
                                      )                                  
                                  ],),)),]));},)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: items.length,
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdPage(id: items[index]['id'].toString(),) ));
                  },
                  child: Card(
                  elevation: 2,
                  shadowColor: CustomColors.appColors,
                  child: Container(
                    height: 110,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            color: Colors.white,
                            child: 
                            ClipRect(
                              child: Container(
                              height: 200,
                              width: double.infinity,
                              child:  FittedBox(
                              fit: BoxFit.cover,
                              child: items[index]['img'] != null && items[index]['img'] != '' ? Image.network(baseurl + items[index]['img'].toString(),):
                                Image.asset('assets/images/default.jpg'),),
                                      ),
                                    ),
                          )
                          
                          ,),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(2),
                            color: CustomColors.appColors,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                 Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      items[index]['name'].toString(),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),),),),
                                SizedBox(height: 5,),
                                Expanded(
                                    child:Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children:  <Widget>[
                                          Icon(Icons.access_time_outlined,color: Colors.white, size: 15 ,),
                                          SizedBox(width: 5,),
                                          Text( items[index]['delta_time'].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,))],),)),
                                SizedBox(height: 5,),
                                Expanded(child:Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children:  <Widget>[
                                      Icon(Icons.place ,color: Colors.white, size: 15 ),
                                      SizedBox(width: 5,),
                                      Text(items[index]['location'].toString(),
                                      overflow: TextOverflow.clip,
                                          style: TextStyle(color: Colors.white, fontSize: 15,))],),)),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:0)));
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
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RegionWidget();},);}
        
  void getHomePage() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/home_ads';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      baseurl =  server_url.get_server_url();

      dataSlider1  = json['data']['slider1'];
      if ( dataSlider1.length==0){
        dataSlider1 = [{"img": "", 'name':"", 'location':''}];
      }

      dataSlider2  = json['data']['slider2'];
      if ( dataSlider2.length==0){
        dataSlider2 = [{"img": "", 'name':"", 'location':''}];
      }

      dataSlider3  = json['data']['slider3'];
      if ( dataSlider3.length==0){
        dataSlider3 = [{"img": "", 'name':"", 'location':''}];
      }

      items  = json['data']['items'];
      if ( items.length==0){
        items = [{"img": "", 'name':"", 'location':''}];
      }
      if (dataSlider1.length!=0){
      setState(() {
        determinate = true;
      });
      }
    });}
}



class MyDraver extends StatelessWidget {
  const MyDraver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
              child: Image.asset(
                'assets/images/lllll.jpeg',
                height: 150,
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
                  fontSize: 15,
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
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, "/");
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.home, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Baş sahypa', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),),
                        ],
                      ),
                    ),
                  ),  
                ),
                Container(
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
                          SizedBox(width: 15,),
                          Text('Meniň sahypam', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                 Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Search(index:0)));
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Gözleg', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                 Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/pharmacies/list");
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.local_pharmacy_sharp, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Dermanhanalar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                 Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Bazarlar") )); 
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.storefront_sharp, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Bazarlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Söwda merkezler") ));
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.store, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Söwda merkezler', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),


                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Söwda nokatlar") ));
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.store_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Söwda nokatlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),


                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Store(title: "Marketler") ));
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.storefront_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Marketler', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/productManufacturers");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.store_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Önüm öndürijiler', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/car");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.car_repair, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Awtoulaglar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/autoParts");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Awtoşaýlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/properties/list");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.other_houses, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Emläkler', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/constructions/list");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.build_circle, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Gurluşyk harytlary', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),
                
                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/services/list");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.home_repair_service, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Hyzmatlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                 Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/othergoods/list");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.newspaper, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                          Text('Beýleki harytlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersList() ));},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 25, color: CustomColors.appColors,),
                          SizedBox(width: 15,),
                           Text('Sargytlar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {Navigator.pushNamed(context, "/settings");},
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 25, color: CustomColors.appColors,),
                          SizedBox(width:15),
                          Text('Sazlamalar', style: TextStyle(fontSize: 16, color: CustomColors.appColors,),)
                        ],
                      ),
                    ),
                  ),        
                ),
              ],
            ),            
          ),
        ],
      ),
    );
  }
}

