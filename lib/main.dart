import 'package:flutter/material.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Awtoparts/awtoParts.dart';
import 'package:my_app/pages/Awtoparts/awtoPartsDetail.dart';
import 'package:my_app/pages/Car/car.dart';
import 'package:my_app/pages/Construction/constructionDetail.dart';
import 'package:my_app/pages/Construction/constructionList.dart';
import 'package:my_app/pages/Customer/Finance/getFirst.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/newPassword.dart';
import 'package:my_app/pages/OtherGoods/otherGoodsList.dart';
import 'package:my_app/pages/Pharmacies/pharmaciesList.dart';
import 'package:my_app/pages/ProductManufacturers/productManufacturers.dart';
import 'package:my_app/pages/ProductManufacturers/productManufacturersDetail.dart';
import 'package:my_app/pages/Propertie/propertiesDetail.dart';
import 'package:my_app/pages/Propertie/propertiesList.dart';
import 'package:my_app/pages/Services/serviceDetail.dart';
import 'package:my_app/pages/Services/servicesList.dart';
import 'package:my_app/pages/Settings/help.dart';
import 'package:my_app/pages/Settings/settings.dart';
import 'package:my_app/pages/Store/fistStore.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:my_app/pages/Store/store.dart';
import 'package:my_app/pages/Store/storeDetail.dart';
import 'package:my_app/pages/Store/storesList.dart';
import 'package:my_app/pages/homePages.dart';
import 'dB/colors.dart';
import 'dB/db.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

final dbHelper = DatabaseSQL();

Future<void> main() async {
  

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ]
  );
  await dbHelper.init();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => UserInfo())),
          ChangeNotifierProvider(create: ((context) => Regions()))
        ],
        child: MaterialApp(  
          debugShowCheckedModeBanner: false,
          theme: ThemeData(appBarTheme: const AppBarTheme(color: CustomColors.appColors)),
            routes: {
            '/': (context) => const Home(),

            '/services/list' : (context) => ServicesList(),
            '/service/detail': (context) => ServiceDetail(id: '2',),
            '/store': (context) =>  Store(title: "",),
            '/store/first': (context) =>  StoreFirst(title: "", id: "1",),
            '/stores/list': (context) => StoresList(),
            '/store/detail': (context) => StoreDetail(),
            '/market/detail': (context) => MarketDetail(id: '19',title: '',),
            '/othergoods/list': (context) => OtherGoodsList(),
            '/constructions/list': (context) => ConstructionsList(),
            '/construction/detail': (context) => ConstructionDetail(id: '1'),
            '/settings': (context) => const Settings(),
            '/settings/help': (context) => const Help(),
            '/login': (context) => const Login(),
            '/car': (context) => const Car(),
            '/pharmacies/list': (context) => const PharmaciesList(),
            '/properties/list': (context) => Properties(),
            '/properties/detail': (context) => PropertiesDetail(id: '1',),
            '/productManufacturers': (context) => const  ProductManufacturers(),
            '/productManufacturers/detail': (context) =>  ProductManufacturersDetail(id: '1',),
            '/autoParts': (context) => const AutoParts(),
            '/autoParts/detail': (context) =>  AutoPartsDetail(id: '1'),
            '/customer/myPages/finance/getFirst': (context) => const GetFinanceFirst(),
            '/customer/editProfil/newPassword': (context) => const NewPassword(),
          },
        ),
      )
  );
}

