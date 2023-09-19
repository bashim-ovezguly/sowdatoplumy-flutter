import 'package:flutter/material.dart';
import '../dB/colors.dart';


class CustomProgressIndicator extends StatefulWidget {
  final Function funcInit;
  CustomProgressIndicator({Key? key, required this.funcInit}) : super(key: key);

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  void initState(){super.initState();}
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,      
      body: Center(
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: (){widget.funcInit();},
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Täzeden synanşyň!', style: TextStyle(color: CustomColors.appColors, fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(Icons.refresh, color: CustomColors.appColors)
                ]
              )
              )
            )
          ]
        )
    ),
    );
  }
}

class HomePageProgressIndicator extends StatefulWidget {
  final Function funcInit;
  HomePageProgressIndicator({Key? key, required this.funcInit}) : super(key: key);

  @override
  State<HomePageProgressIndicator> createState() => _HomePageProgressIndicatorState();
}

class _HomePageProgressIndicatorState extends State<HomePageProgressIndicator> {
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      body: Container(
      color: CustomColors.appColorWhite,
        child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset('assets/images/logo.png',
                          width: MediaQuery.of(context).size.width / 3,
                          )),
                        Container(
                          child: Text('Söwda toplumy', style: TextStyle(fontSize: 25, color: CustomColors.appColors, decoration: null))
                        )
                      ],
                    )
                    ),
                  SizedBox(height: 10),
                  Container(height: 5, 
                    child: Container(
                      width: 200,
                      child: LinearProgressIndicator(color: CustomColors.appColors, backgroundColor: Color.fromARGB(255, 188, 187, 187),),                      
                    ),
                  ),
                  Expanded(flex:1, child: Container())
                ]
              )
          
    ),
    );
    
  }
}