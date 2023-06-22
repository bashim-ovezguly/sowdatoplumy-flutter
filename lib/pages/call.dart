import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dB/colors.dart';


class Call extends StatelessWidget {
  const Call({Key? key, required this.phone}) : super(key: key);

  final String  phone ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.appColors,
              foregroundColor: Colors.white),
          onPressed: () async {
            final call = Uri.parse('tel:'+ phone);
            if (await canLaunchUrl(call)) {
              launchUrl(call);}
            else {
              throw 'Could not launch $call';
              }
          },
          child: const Text('Jaň etmek'),),),);
  }
}

