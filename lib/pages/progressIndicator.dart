import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';

class CustomProgressIndicator extends StatefulWidget {
  final Function funcInit;
  CustomProgressIndicator({Key? key, required this.funcInit}) : super(key: key);

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      body: Center(
          child: Stack(children: [
        Center(
            child: GestureDetector(
                onTap: () {
                  widget.funcInit();
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Täzeden synanşyň!',
                          style: TextStyle(
                              color: CustomColors.appColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      Icon(Icons.refresh, color: CustomColors.appColor)
                    ])))
      ])),
    );
  }
}

class HomePageProgressIndicator extends StatefulWidget {
  final Function funcInit;
  final bool determinate1;
  HomePageProgressIndicator(
      {Key? key, required this.funcInit, required this.determinate1})
      : super(key: key);

  @override
  State<HomePageProgressIndicator> createState() =>
      _HomePageProgressIndicatorState();
}

class _HomePageProgressIndicatorState extends State<HomePageProgressIndicator> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      body: Container(
          color: CustomColors.appColorWhite,
          child: Column(children: [
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.width / 3,
                        )),
                    Container(
                        child: Text('Business Complex',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: CustomColors.appColor,
                                decoration: null))),
                    Container(
                        child: Text('Online dükanlar',
                            style: TextStyle(
                                fontSize: 20,
                                color: CustomColors.appColor,
                                decoration: null))),
                  ],
                )),
            SizedBox(height: 10),
            Container(
              height: 5,
              child: Container(
                width: 200,
                child: LinearProgressIndicator(
                  color: CustomColors.appColor,
                  backgroundColor: Color.fromARGB(255, 188, 187, 187),
                ),
              ),
            ),
            Expanded(flex: 1, child: Container())
          ])),
    );
  }
}
