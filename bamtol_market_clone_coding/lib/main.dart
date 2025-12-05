import 'package:bamtol_market_app/firebase_options.dart';
import 'package:bamtol_market_app/src/app.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/controller/bottom_nav_controller.dart';
import 'package:bamtol_market_app/src/common/controller/data_load_controller.dart';
import 'package:bamtol_market_app/src/common/controller/product_controller.dart';
import 'package:bamtol_market_app/src/product/page/product_write_page.dart';
import 'package:bamtol_market_app/src/product/page/trade_location_page.dart';
import 'package:bamtol_market_app/src/root.dart';
import 'package:bamtol_market_app/src/splash/controller/splash_controller.dart';
import 'package:bamtol_market_app/src/user/login/page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization error: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '당근마켓 클론코딩',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(BottomNavController());
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(AuthenticationController());
        Get.put(ProductController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(name: '/home', page: () => const Root()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/product/write', page: () => const ProductWritePage()),
        GetPage(
            name: '/product/trade-location',
            page: () => const TradeLocationPage()),
      ],
    );
  }
}
