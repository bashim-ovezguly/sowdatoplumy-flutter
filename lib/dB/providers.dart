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
  
  String access_token = '';
  String refresh_token = '';
  String sort = "1";

  void setsort(value){
    sort = value;
    notifyListeners(); 
  }

  void chang_Region_Code(value){
    regionsCode = value;
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
     Urls server_url  =  new Urls();
     String url = server_url.get_server_url() + '/mob/token/refresh';
     final uri = Uri.parse(url);
     final response = await http.post(uri,
                                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                      body: { 'refresh_token': refresh_token,},);
    
    if (response.statusCode==200){
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> row = { DatabaseSQL.columnName: json['data']['access_token'],
                                   DatabaseSQL.columnPassword: json['data']['refresh_token'],
                                   DatabaseSQL.columnUserId: json['data']['id']};
      
      final delete = await dbHelper.deleteAllRows();
      final id = await dbHelper.insert(row);
      return true;
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
        return false;
      }
     final response = await http.post(uri,
                                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                      body: { 'phone': data[0]['name'],
                                              'password': data[0]['age'],},);
     final json = jsonDecode(utf8.decode(response.bodyBytes));
     if (json['status']=='success'){
      Map<String, dynamic> row = {DatabaseSQL.columnName: json['data']['access_token'],
                                  DatabaseSQL.columnPassword: json['data']['refresh_token'],
                                  DatabaseSQL.columnUserId: json['data']['id']};
      final delete = await dbHelper.deleteAllRows();
    
      final id = await dbHelper.insert(row);
      access_token = json['data']['access_token'];
      refresh_token = json['data']['refresh_token'];
      print(json['data']['access_token']);
      print(json['data']['refresh_token']);
      return true;
     }
    }
    return false;
  }
}