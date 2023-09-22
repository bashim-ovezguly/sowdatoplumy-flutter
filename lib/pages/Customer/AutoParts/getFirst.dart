import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Car/carStore.dart';
import 'package:my_app/pages/Customer/AutoParts/edit.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../deleteAlert.dart';


class GetAutoParthFirst extends StatefulWidget {
  GetAutoParthFirst(
      {Key? key,
      required this.customer_id,
      required this.id,
      required this.refreshFunc,
      required this.user_customer_id})
      : super(key: key);
  final String id;
  final String customer_id;
  final String user_customer_id;
  final Function refreshFunc;

  @override
  State<GetAutoParthFirst> createState() =>
      _GetAutoParthFirstState(id: id, customer_id: customer_id);
}

class _GetAutoParthFirstState extends State<GetAutoParthFirst> {
  final String id;
  final String customer_id;
  final number = '+99364334578';
  int _current = 0;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  List<String> imgList = [];

  void initState() {
    widget.refreshFunc();
    if (imgList.length == 0) {
      imgList.add(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
    }
    getsingleparts(id: id);
    super.initState();
  }

  bool status = false;
  callbackStatus() {
    setState(() {
      status = true;
    });
  }

  callbackStatusDelete() {
    widget.refreshFunc();
    Navigator.pop(context);
  }

  _GetAutoParthFirstState({required this.customer_id, required this.id});
  @override
  Widget build(BuildContext context) {
    var user_customer_name = Provider.of<UserInfo>(context, listen: false).user_customer_name;
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: widget.user_customer_id=='' ? Text(
                "Meniň sahypam",
                style: CustomText.appBarText,
              ):
              Text(
                user_customer_name.toString() + " şahsy otag",
                style: CustomText.appBarText,
              ),

          actions: [
            if (widget.user_customer_id == '')
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AutoPartsEdit(
                                          old_data: data,
                                          callbackFunc: callbackStatus)));
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(Icons.edit_road, color: Colors.green, ),
                                  Text(' Üýtgetmek')
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteAlert(
                                        action: "parts",
                                        id: id,
                                        callbackFunc: callbackStatusDelete);
                                  });
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text('Pozmak')
                                ])))),
                  ];
                  return menuEntries2;
                },
              ),
          ],
        ),
        body: status == false
            ? determinate
                ? ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(left: 20, right: 10),
                          child: Row(
                            children: <Widget>[
                              Text( "Awtoşaýlar",
                                style: TextStyle(
                                  color: CustomColors.appColors,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        textDirection: TextDirection.rtl,
                        fit: StackFit.loose,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            height:220,
                            color: Colors.white,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  height:220,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: imgList.length>1 ? true: false,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.3,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              items: imgList
                                  .map((item) => Container(
                                        color: Colors.white,
                                        child: Center(
                                            child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), // Image border
                                          child: Image.network(
                                            item,
                                            fit: BoxFit.fill,
                                            height:220,
                                            width: double.infinity,
                                          ),
                                        )),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: DotsIndicator(
                              dotsCount: imgList.length,
                              position: _current.toDouble(),
                              decorator: DotsDecorator(
                                color: Colors.white,
                                activeColor: CustomColors.appColors,
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.access_time_outlined,
                                  size: 20,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data['created_at'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    color: CustomColors.appColors,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.visibility_sharp,
                                  size: 20,
                                  color: CustomColors.appColors,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data['viewed'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    color: CustomColors.appColors,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.auto_graph_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Id", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['id'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.privacy_tip,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Awtoulag marka", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['mark'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.production_quantity_limits,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Ady", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['name_tm'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.store,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Dükan", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['store'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.flag,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Öndürilen ýurdy", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['made_in'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.energy_savings_leaf,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Matory", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['engine'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.store,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Firmasy", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            if (data['part_factory'] != null &&
                                data['part_factory'] != '')
                              Expanded(
                                  child: SizedBox(
                                child: TextValueWidget(
                                    text:
                                        data['part_factory']['name'].toString(),
                                    size: 16.0),
                              ))
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Ýerleşýän ýeri", size: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                                    child: TextValueWidget(
                                        text: data['location'].toString(),
                                        size: 16.0)))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.category,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Katigoriýasy", size: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            if (data['category'] != null &&
                                data['category'] != '')
                              Expanded(
                                  child: SizedBox(
                                      child: TextValueWidget(
                                          text: data['category']['name']
                                              .toString(),
                                          size: 16.0)))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Bahasy", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['price'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.phone_callback,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Telefon", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['phone'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.monetization_on_sharp,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Kredit", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topLeft,
                              child: data['credit'] == null
                                  ? MyCheckBox(type: true)
                                  : MyCheckBox(type: data['credit']),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.library_add_check_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Çalyşyk", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topLeft,
                              child: data['swap'] == null
                                  ? MyCheckBox(type: true)
                                  : MyCheckBox(type: data['swap']),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.credit_card,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Nagt däl töleg", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.topLeft,
                              child: data['none_cash_pay'] == null
                                  ? MyCheckBox(type: true)
                                  : MyCheckBox(type: data['none_cash_pay']),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.invert_colors_on_sharp,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: " Ýangyjyň görnüşi", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['fuel'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.invert_colors_on_sharp,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Karopka", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['transmission'].toString(),
                                  size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.qr_code,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Vin kody", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['VIN'].toString(), size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.qr_code,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Original kody", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['orig_code'].toString(),
                                  size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.qr_code,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: const TextKeyWidget(
                                        text: "Dublikat kody", size: 16.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              child: TextValueWidget(
                                  text: data['duplicate_code'].toString(),
                                  size: 16.0),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 100,
                        width: double.infinity,
                        child: TextField(
                          enabled: false,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            hintText: data['detail'].toString(),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.appColors,
                    ),
                  )
            : Container(
                child: AlertDialog(
                  shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
                content: Container(
                  width: 200,
                  height: 100,
                  child: Text(
                      'Maglumat üýtgedildi operatoryň tassyklamagyna garaşyň'),
                ),
                actions: <Widget>[
                  Align(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        setState(() {
                          callbackStatus();
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetAutoParthFirst(
                              user_customer_id: widget.user_customer_id,
                              id: id,
                              customer_id: customer_id,
                              refreshFunc: widget.refreshFunc,
                            ),
                          ),
                        );
                      },
                      child: const Text('Dowam et'),
                    ),
                  )
                ],
              )));
  }

  void getsingleparts({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/parts/' + id;
    final uri = Uri.parse(url);
    // create request headers
    Map<String, String> headers = {};  
    for (var i in global_headers.entries){
      headers[i.key] = i.value.toString(); 
    }
    final response = await http.get(uri, headers: headers);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      baseurl = server_url.get_server_url();
      var i;
      imgList = [];
      for (i in data['images']) {
        imgList.add(baseurl + i['img_m']);
      }
      determinate = true;
      if (imgList.length == 0) {
        imgList.add(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWXAFCMCaO9NVAPUqo5i8rXVgWB5Qaj_Qthf-KQZNAy0YyJxlAxejBSvSWOK-5PMK3RQQ&usqp=CAU');
      }
    });
  }
}

class TextKeyWidget extends StatelessWidget {
  const TextKeyWidget({Key? key, required this.text, required this.size})
      : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 3, style: TextStyle(fontSize: 14, color: Colors.black26));
  }
}

class TextValueWidget extends StatelessWidget {
  const TextValueWidget({Key? key, required this.text, required this.size})
      : super(key: key);
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(fontSize: 14, color: CustomColors.appColors));
  }
}
