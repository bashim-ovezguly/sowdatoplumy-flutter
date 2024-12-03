import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Parts/awtoParts.dart';
import 'package:my_app/pages/Parts/awtoPartsDetail.dart';
import 'package:my_app/pages/Car/carList.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/restore.dart';
import 'package:my_app/pages/Products/ProductList.dart';
import 'package:my_app/pages/Flats/FlatDetail.dart';
import 'package:my_app/pages/Flats/FlatList.dart';
import 'package:my_app/pages/Settings/help.dart';
import 'package:my_app/pages/Settings/settings.dart';
import 'package:my_app/pages/Store/Stores.dart';
import 'package:my_app/pages/homePage.dart';
import 'package:my_app/pages/startPage.dart';
import 'dB/db.dart';
import 'package:flutter/services.dart';

final dbHelper = DatabaseSQL();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dbHelper.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme: TextTheme().apply(
        bodyColor: const Color.fromARGB(255, 255, 255, 255),
        displayColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.appColor,
          iconTheme: IconThemeData(color: Colors.white)),
    ),
    routes: {
      '/': (context) => StartPage(),
      '/home': (context) => Home(),
      '/store': (context) => Stores(),
      '/othergoods/list': (context) => ProductList(),
      '/settings': (context) => const Settings(),
      '/settings/help': (context) => const Help(),
      '/login': (context) => const Login(),
      '/car': (context) => const Car(),
      '/properties/list': (context) => Properties(),
      '/properties/detail': (context) => PropertiesDetail(
            id: '1',
          ),
      '/autoParts': (context) => const AutoParts(),
      '/autoParts/detail': (context) => AutoPartsDetail(id: '1'),
      '/customer/editProfil/newPassword': (context) => const RestoreAccount(),
    },
  ));
}
