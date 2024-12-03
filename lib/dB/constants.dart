import 'package:my_app/dB/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const serverIp = 'http://216.250.9.45:8000';
const storesUrl = serverIp + '/mob/stores';
const ordersUrl = serverIp + '/mob/orders';
const carsUrl = serverIp + '/mob/cars';
const carImageDeleteUrl = serverIp + '/mob/cars/img/delete/';
const partsUrl = serverIp + '/mob/parts';
const flatsUrl = serverIp + '/mob/flats';
const productsUrl = serverIp + '/mob/products';
const storeUrl = serverIp + '/mob/stores/';
const lentaUrl = serverIp + '/mob/lenta';
const orderAddUrl = serverIp + '/mob/orders/add';

const indexCarsUrl = serverIp + '/mob/index/car';
const indexFlatUrl = serverIp + '/mob/index/flat';
const indexProductUrl = serverIp + '/mob/index/product';
const indexStoreUrl = serverIp + '/mob/index/store';
const homePageUrl = serverIp + '/mob/homepage';
const profileUrl = serverIp + '/mob/profile';
const device_id_url = serverIp + '/mob/device_id';
const newsUrl = serverIp + '/mob/news';
const tokenObtainUrl = serverIp + '/mob/token/obtain';
const token_refresh_url = serverIp + '/mob/token/refresh';
const order_products_url = serverIp + '/mob/orders/products/';

String defaulImageUrl = 'assets/images/default16x9.jpg';

final pref = SharedPreferences.getInstance();

class CustomColors {
  static const Color appColor = Color(0xff0c2463);
  static const Color appColorWhite = Colors.white;
  static const Color appColorBlack54 = Colors.black54;
}

class Urls {
  String server_url = "http://216.250.9.45:8000";

  String get_server_url() {
    return server_url;
  }
}

Map<String, String> global_headers = {
  'Api-key': 'bc_android_client_key',
  'App-Version': '27-11-2024',
  'Device-Id': getLocalStorage('device-id').toString(),
  'Location-Id': getLocalStorage('location-id').toString(),
  'Content-Type': 'application/x-www-form-urlencoded',
};

void setHeadersDevice_id(value) {
  global_headers['Device-Id'] = value;
}

void setHeadersLocation_id(value) {
  global_headers['Location-Id'] = value.toString();
}
