import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/routes/app_pages.dart';
import 'package:test_app/screens/main/view/main_screen_view.dart';

import 'env.dart';
import 'logger/logger_utils.dart';

Future<void> main() async {
  setEnvironment(Environment.stage);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MainScreenView(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
      enableLog: true,
      logWriterCallback: Logger.write,
      // initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
