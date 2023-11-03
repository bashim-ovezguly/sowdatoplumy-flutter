// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_app/AddData/addCars.dart';
import 'package:my_app/AddData/addNotification.dart';
import 'package:my_app/AddData/addParth.dart';
import 'package:my_app/AddData/addRealestate.dart';
import 'package:my_app/AddData/addRobbinList.dart';
import 'package:my_app/AddData/addStore.dart';

import '../../dB/colors.dart';
import '../../dB/textStyle.dart';

class AddDatasPage extends StatelessWidget {
  final int index;
  const AddDatasPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget(index: index);
  }
}

class MyStatefulWidget extends StatefulWidget {
  int index;
  MyStatefulWidget({super.key, required this.index});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: widget.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: Text('Bildiriş goşmak', style: CustomText.appBarText)),
            body: Column(children: <Widget>[
              TabBar(
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  indicatorColor: CustomColors.appColors,
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(
                        Icons.store_outlined,
                        color: CustomColors.appColors,
                      ),
                      Text("Dükan",
                          style: TextStyle(
                              color: CustomColors.appColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(Icons.car_repair, color: CustomColors.appColors),
                      Text("Awtoulag",
                          style: TextStyle(
                              color: CustomColors.appColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(
                        Icons.settings_outlined,
                        color: CustomColors.appColors,
                      ),
                      Text("Awtoşaý",
                          style: TextStyle(
                              color: CustomColors.appColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(
                        Icons.campaign,
                        color: CustomColors.appColors,
                      ),
                      Text("Bildiriş",
                          style: TextStyle(
                              color: CustomColors.appColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(Icons.other_houses, color: CustomColors.appColors),
                      Text("Emläk ",
                          style: TextStyle(
                              color: CustomColors.appColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(Icons.bookmark, color: CustomColors.appColors),
                      Text("Lenta",
                          style: TextStyle(
                              color: CustomColors.appColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ]))
                  ]),
              SizedBox(
                  height: MediaQuery.of(context).size.height - 130,
                  child:
                      TabBarView(controller: _tabController, children: <Widget>[
                    AddStore(),
                    AddCars(),
                    AddParth(),
                    AddNotifications(),
                    AddRealestate(),
                    AddRobbinList()
                  ]))
            ])));
  }
}
