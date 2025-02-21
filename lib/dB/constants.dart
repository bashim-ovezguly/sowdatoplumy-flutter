import 'package:flutter/material.dart';

const serverIp = 'http://216.250.9.45:8000';
const storesUrl = serverIp + '/stores';
const tradeCenters = serverIp + '/trade_centers';
const ordersUrl = serverIp + '/orders';
const carsUrl = serverIp + '/cars';
const carImageDeleteUrl = serverIp + '/cars/img/delete/';
const partsUrl = serverIp + '/parts';
const flatsUrl = serverIp + '/flats';
const productsUrl = serverIp + '/products';
const storeUrl = serverIp + '/stores/';
const lentaUrl = serverIp + '/lenta';
const orderAddUrl = serverIp + '/orders/add';

const indexCarsUrl = serverIp + '/index/car';
const indexFlatUrl = serverIp + '/index/flat';
const indexProductUrl = serverIp + '/index/product';
const indexStoreUrl = serverIp + '/index/store';
const homePageUrl = serverIp + '/homepage';
const profileUrl = serverIp + '/profile';
const device_id_url = serverIp + '/device_id';
const newsUrl = serverIp + '/news';
const tokenObtainUrl = serverIp + '/token/obtain';
const token_refresh_url = serverIp + '/token/refresh';
const order_products_url = serverIp + '/orders/products/';

String defaulImageUrl = 'assets/images/default.jpg';

class CustomColors {
  static const Color appColor = Color.fromRGBO(4, 129, 203, 1);
  static const Color appColorWhite = Colors.white;
  static const Color appColorBlack54 = Colors.black54;
}

// class Urls {
//   String server_url = "http://216.250.9.45:8000";

//   String get_server_url() {
//     return server_url;
//   }
// }

Map<String, String> global_headers = {
  'Api-key': 'bc_android_client_key',
  'App-Version': '07-01-2025',
};

BoxShadow appShadow = BoxShadow(
    blurRadius: 3,
    spreadRadius: 1,
    color: Colors.grey.shade400,
    offset: Offset(2, 2));
