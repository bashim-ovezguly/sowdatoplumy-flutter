import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/HomePage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoading = true;
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 300), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  _StartPageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset('assets/images/logo.png',
                  width: MediaQuery.sizeOf(context).width * 0.5),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Söwda toplumy',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: CustomColors.appColor),
              ),
            ),
            Text(
              'business-complex.com.tm',
              style: TextStyle(fontSize: 20, color: CustomColors.appColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SizedBox(
                child: LinearProgressIndicator(),
                width: 200,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
