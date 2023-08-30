import 'package:flutter/material.dart';
import 'package:my_app/pages/Construction/constructionDetail.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

import '../../dB/providers.dart';

class StoreMaterials extends StatefulWidget {
  StoreMaterials({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<StoreMaterials> createState() => _StoreMaterialsState(id: id);
}

class _StoreMaterialsState extends State<StoreMaterials> {
  @override
  final String id;

  var shoping_cart_items = [];
  var products = [];
  var keyword = TextEditingController();

  var baseurl = '';

  @override
  void initState() {
    get_products_modul(id);
    super.initState();
  }

  _StoreMaterialsState({required this.id});

  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextFormField(
              controller: keyword,
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      get_products_modul(id);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        keyword.text = '';
                      });
                      get_products_modul(id);
                    },
                  ),
                  hintText: 'Gözleg...',
                  border: InputBorder.none),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          children: products.map((item) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ConstructionDetail(id: item['id'].toString())));
                },
                child: Card(
                    elevation: 2,
                    child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Column(children: [
                          Container(
                              alignment: Alignment.topCenter,
                              child: item['img'] != null && item['img'] != ""
                                  ? Image.network(
                                      baseurl + item['img'].toString(),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          10,
                                      height: 130,
                                    )
                                  : Image.asset(
                                      'assets/images/default.jpg',
                                      height: 200,
                                    )),
                          Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'].toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.appColors,
                                        overflow: TextOverflow.clip),
                                  ),
                                  Text(
                                    item['price'].toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.appColors,
                                        overflow: TextOverflow.clip),
                                  ),
                                ],
                              ))
                        ]))));
          }).toList(),
        )
      ],
    );
  }

  void get_products_modul(id) async {
    Urls server_url = new Urls();
    var param = 'materials';
    String url = server_url.get_server_url() + '/mob/' + param + '?store=' + id;

    if (keyword.text != '') {
      url = server_url.get_server_url() +
          '/mob/' +
          param +
          '?store=' +
          id +
          "&name=" +
          keyword.text;
    }
    final uri = Uri.parse(url);
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      products = json['data'];
      baseurl = server_url.get_server_url();
    });
  }
}
