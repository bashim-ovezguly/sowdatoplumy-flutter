// ignore_for_file: unused_field, unused_local_variable
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'db.dart';


class Regions extends ChangeNotifier{
  int selectedIndex = 6;
  void set_selectedIndex(value){
    selectedIndex = value;
    notifyListeners();
  }
}

class UserInfo extends ChangeNotifier {

  var regionsCode = {};
  var user_info = {};
  var storeProducts = [];
  var storeModul = '';
  var storeProductStatus ;
  String device_id ='';
  String access_token = '';
  String refresh_token = '';
  String sort = "1";
  String user_customer_name = '';
  bool updateApp = false;

  Map<String, dynamic> statistic = {"store_count": "",
                                    "pharmacy_count": "",
                                    "bazar_count": "",
                                    "shopping_center_count": "",
                                    "market_count": "",
                                    "car_count": "",
                                    "part_count": "",
                                    "service_count": "",
                                    "material_count":"",
                                    "product_count": "",
                                    "factory_count": "",
                                    "flat_count": "",
                                    "announcements": "",
                                    "restaurants": ""};

  void set_statistic(value){
    statistic = value;
    notifyListeners(); 
  }

  void set_update_app(value){
    print('update_App $value');
    updateApp = value;
    notifyListeners();
  }

  void set_device_id(value){
    device_id = value;
    setHeadersDevice_id(value);
    notifyListeners(); 
  }

  void set_user_info(value){
    user_info = value;
    notifyListeners(); 
  }

  void set_storeProducts(value){
    storeProducts = value;
    notifyListeners(); 
  }

  void set_storeProductStatus(value){
    storeProductStatus = value;
    notifyListeners(); 
  }

  void set_storeModul(value){
    storeModul = value;
    notifyListeners(); 
  }


  void set_user_customer_name(value){
    user_customer_name = value;
    notifyListeners();
  }

  void setsort(value){
    sort = value;
    notifyListeners(); 
  }

  void chang_Region_Code(value){
    regionsCode = value;
    setHeadersLocation_id(value['id']);
    notifyListeners(); 
  }

  void setAccessToken(value1, value2){
    access_token = value1;
    refresh_token = value2;
    print('access_token ___ $access_token');
    print('refresh_token __ $refresh_token');
    notifyListeners();
  }

  Future<bool> update_tokenc() async {
    print('isledi update');
     Urls server_url  =  new Urls();
     String url = server_url.get_server_url() + '/mob/token/refresh';
     final uri = Uri.parse(url);
     final response = await http.post(uri,
                                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                      body: { 'refresh_token': refresh_token,},);

    print('Url----- $uri');
    print('Url----- $refresh_token');
    print(response.statusCode);
    if (response.statusCode==200){
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> row = { DatabaseSQL.columnName: json['access_token'],
                                   DatabaseSQL.columnPassword: json['refresh_token'],
                                   DatabaseSQL.columnUserId: json['id']};
      
      final delete = await dbHelper.deleteAllRows();
      setAccessToken(json['access_token'], json['refresh_token']);
      final id = await dbHelper.insert(row);
      return Future<bool>.value(true);
    }
    if (response.statusCode != 200){
     Urls server_url  =  new Urls();
     String url = server_url.get_server_url() + '/mob/token/obtain';
     final uri = Uri.parse(url);
      var allRows = await dbHelper.queryAllRows1();
      var data = [];
      for (final row in allRows) {
        data.add(row);
      }
      if (data.length==0){
        return Future<bool>.value(false);
      }
     final response = await http.post(uri,
                                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                      body: { 'phone': data[0]['name'],
                                              'password': data[0]['age'],},);
      print('Url----- $uri');
      print(data[0]['name']);
      print( data[0]['age']);
      print(response.statusCode);
     final json = jsonDecode(utf8.decode(response.bodyBytes));
     
     if (json['status']=='success'){
      Map<String, dynamic> row = {DatabaseSQL.columnName: json['data']['access_token'],
                                  DatabaseSQL.columnPassword: json['data']['refresh_token'],
                                  DatabaseSQL.columnUserId: json['data']['id']};
      final delete = await dbHelper.deleteAllRows();
    
      final id = await dbHelper.insert(row);
      access_token = json['data']['access_token'];
      refresh_token = json['data']['refresh_token'];
      setAccessToken(json['data']['access_token'], json['data']['refresh_token']);
      return Future<bool>.value(true);
     }
    }
    return Future<bool>.value(false);
  }
}