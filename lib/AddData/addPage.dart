// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_app/AddData/addCar.dart';
import 'package:my_app/AddData/addProduct.dart';
import 'package:my_app/AddData/AddAksiya.dart';
import 'package:my_app/dB/constants.dart';
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
        TabController(length: 3, vsync: this, initialIndex: widget.index);
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: Text('Bildiriş goşmak', style: CustomText.appBarText)),
            body: Column(children: <Widget>[
              TabBar(
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  indicatorColor: CustomColors.appColor,
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: CustomColors.appColor,
                      ),
                      Text("Haryt",
                          style: TextStyle(
                              color: CustomColors.appColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(Icons.time_to_leave_outlined,
                          color: CustomColors.appColor),
                      Text("Awtoulag",
                          style: TextStyle(
                              color: CustomColors.appColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ])),
                    Tab(
                        child: Row(children: const <Widget>[
                      Icon(Icons.bookmark_border_outlined,
                          color: CustomColors.appColor),
                      Text("Aksiýa",
                          style: TextStyle(
                              color: CustomColors.appColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15))
                    ]))
                  ]),
              Expanded(
                  // height: MediaQuery.of(context).size.height - 130,
                  child:
                      TabBarView(controller: _tabController, children: <Widget>[
                AddProduct(),
                AddCars(),
                // AddParth(),
                // AddRealestate(),
                AddRobbinList()
              ]))
            ])));
  }
}
