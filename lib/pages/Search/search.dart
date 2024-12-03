// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Search/carSearch.dart';
import 'package:my_app/pages/Search/ProductsSearch.dart';
import 'package:my_app/pages/Search/storeSearch.dart';

import '../../dB/textStyle.dart';

class Search extends StatelessWidget {
  final int index;
  const Search({Key? key, required this.index}) : super(key: key);

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

  callbackIndex(value) {}
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: CustomColors.appColorWhite,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                'Gözleg',
                style: CustomText.appBarText,
              ),
              actions: [
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Search(index: widget.index)));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.cleaning_services_outlined,
                            color: CustomColors.appColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Arassala',
                            style: TextStyle(color: CustomColors.appColor),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            body: Column(
              children: <Widget>[
                TabBar(
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  indicatorColor: CustomColors.appColor,
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.storefront,
                            color: CustomColors.appColor,
                          ),
                          Text(
                            "Dükanlar",
                            style: TextStyle(
                                color: CustomColors.appColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.card_giftcard_rounded,
                            color: CustomColors.appColor,
                          ),
                          Text(
                            "Harytlar",
                            style: TextStyle(
                                color: CustomColors.appColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.time_to_leave_outlined,
                            size: 28,
                            color: CustomColors.appColor,
                          ),
                          Text(
                            "Awtoulaglar",
                            style: TextStyle(
                                color: CustomColors.appColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      StoreSearch(
                        callbackFunc: callbackIndex,
                      ),
                      ProductsSearch(
                        callbackFunc: callbackIndex,
                      ),
                      CarSerach(
                        callbackFunc: callbackIndex,
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
