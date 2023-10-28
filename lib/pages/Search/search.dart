// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_app/pages/Search/autoPartsSearch.dart';
import 'package:my_app/pages/Search/carSearch.dart';
import 'package:my_app/pages/Search/otherGoodsSearch.dart';
import 'package:my_app/pages/Search/outletsSearch.dart';
import 'package:my_app/pages/Search/pharmaciesSearch.dart';
import 'package:my_app/pages/Search/propertieSearch.dart';

import '../../dB/colors.dart';
import '../../dB/textStyle.dart';

class Search extends StatelessWidget {
  final int index;
   const Search({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MyStatefulWidget(index: index);
  }
}

class MyStatefulWidget extends StatefulWidget {
  int index;
  MyStatefulWidget({super.key,  required this.index});


  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


class _MyStatefulWidgetState extends State<MyStatefulWidget>
  with TickerProviderStateMixin {

  late TabController _tabController;
  @override
  void initState() {
    super.initState();  
    _tabController = TabController(length: 6, vsync: this, initialIndex: widget.index);
  }
  
  callbackIndex(value){}
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 5, child: Scaffold(
          backgroundColor: CustomColors.appColorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Gözleg', style: CustomText.appBarText,),
          actions: [
           Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 15, top: 12, bottom: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Search(index: widget.index)));
              }, child: Text('Arassala',style: TextStyle(color: CustomColors.appColors),              
            ),)
           )
          ],
        ),
        body: Column(
          children: <Widget>[
            TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              indicatorColor: CustomColors.appColors,
              unselectedLabelColor: Colors.black,
              isScrollable: true,
              tabs:   <Widget>[
                Tab(
                  child: Row(children: const <Widget>[
                    Icon(Icons.car_rental_rounded,color: CustomColors.appColors,),
                    Text("Awtoulaglar",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                Tab(
                  child: Row(children: const <Widget>[
                    Icon(Icons.settings_applications_sharp,color: CustomColors.appColors,),
                    Text("Awtoşaýlar",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                Tab(
                  child: Row(children: const <Widget>[
                    Icon(Icons.storefront_outlined,color: CustomColors.appColors,),
                    Text("Dükanlar",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                Tab(
                  child: Row(children: const <Widget>[
                    Icon(Icons.holiday_village,color: CustomColors.appColors,),
                    Text("Emläkler",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                Tab(
                  child: Row(children: const <Widget>[
                    Icon(Icons.shopify,color: CustomColors.appColors,),
                    Text("Beýleki bildirişler",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                // Tab(
                //   child: Row(children: const <Widget>[
                //     Icon(Icons.shopify,color: CustomColors.appColors,),
                //     Text("Hyzmatlar",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                // Tab(
                //   child: Row(children: const <Widget>[
                //     Icon(Icons.shopify,color: CustomColors.appColors,),
                //     Text("Önüm öndürijiler",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold,fontSize: 15),)],),),
                Tab(
                  child: Row(children: const <Widget>[
                    Icon(Icons.shopify,color: CustomColors.appColors,),
                    Text("Dermanhanalar",style: TextStyle(color: CustomColors.appColors, fontWeight: FontWeight.bold, fontSize: 15),)],),),

              ],),

            SizedBox(
              height: MediaQuery.of(context).size.height-130,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  CarSerach(callbackFunc: callbackIndex,),
                  AutoPartsSearch(callbackFunc: callbackIndex,),
                  OutletsSearch(callbackFunc: callbackIndex,),
                  PropertieSearch(callbackFunc: callbackIndex,),
                  OtherGoodsSearch(callbackFunc: callbackIndex,),
                  // ServiceSearch(callbackFunc: callbackIndex,),
                  // ProductManufacturersSerarch(callbackFunc: callbackIndex,),
                  PharmaciesSerach(callbackFunc: callbackIndex,)
                  
                ],
              ),
            )
          ],
        )
    ));
  }
}