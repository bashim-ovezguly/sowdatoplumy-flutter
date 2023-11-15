import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerList extends StatefulWidget {
  final String customer_id;
  CustomerList({super.key, required this.customer_id});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;

  @override
  void initState() {
    get_customers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text("Müşderiler",
                style: TextStyle(color: CustomColors.appColorWhite))),
        body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, top: 5),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Container(
                        color: Color.fromARGB(255, 217, 217, 217),
                        height: 70,
                        width: 70,
                        child: data[index]['photo'] != ''
                            ? Image.network(
                                baseurl + data[index]['photo'].toString(),
                                fit: BoxFit.cover)  
                            : Image.asset('assets/images/default.jpg'),
                      ),  
                    ),  
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("   " + data[index]['name'].toString(),
                              style: TextStyle(
                                  color: CustomColors.appColors, fontSize: 18)),
                          Text("   " + data[index]['phone'].toString(),
                              style: TextStyle(
                                  color: CustomColors.appColors, fontSize: 18))
                        ])
                  ]));
            }));
  }

  Future<void> get_customers() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/customer/clients/'+ widget.customer_id;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      print(data);
      baseurl = server_url.get_server_url();
      determinate = true;
    });
  }
}
