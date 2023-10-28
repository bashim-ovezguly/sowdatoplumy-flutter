import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Call extends StatelessWidget {
  const Call({Key? key, required this.phone}) : super(key: key);

  final String phone;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topLeft: Radius.circular(100))),
        backgroundColor: Colors.green,
        onPressed: () async {
          final call = Uri.parse('tel:' + phone);
          if (await canLaunchUrl(call)) {
            launchUrl(call);
          } else {
            throw 'Could not launch $call';
          }
        },
        child: Icon(Icons.phone_enabled, color: Colors.white));
  }
}
