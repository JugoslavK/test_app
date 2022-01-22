import 'package:get/get.dart';
import 'package:test_app/screens/main/view/main_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.mainScreen;

  static final routes = [
    GetPage(
      name: Routes.mainScreen,
      page: () => MainScreenView(),
    ),
  ];
}
