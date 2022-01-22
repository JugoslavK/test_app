import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';
import 'package:test_app/components/databse/moor_database.dart';
import 'package:test_app/components/httpRequest/api_calls.dart';
import 'package:test_app/components/models/item_model.dart';
import 'package:test_app/constant.dart';

import '../../../env.dart';

/// Main screen controller
class MainScreenController extends SuperController {
  ///List of items models
  List<ItemModel> listItems = <ItemModel>[].obs;

  /// List of items models to show
  List<ItemModel> listItemsShow = <ItemModel>[].obs;

  /// List of column names
  List<String> listColumnsNames = <String>[].obs;

  /// Scroll controller
  final ScrollController scrollController = ScrollController();

  /// App database
  final database = AppDatabase();

  /// From element to element to show as pagination.
  int from = 0;
  int to = 20;

  /// Loading and loading more boolean
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();

    /// Set scroll listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoadingMore.value &&
          listItems.length > listItemsShow.length) {
        // getDataApi();
        isLoadingMore.value = true;
        setListValue();
      }
    });

    getDataApi();
  }

  /// On pull to refresh data
  onRefresh() {
    isLoadingMore.value = true;
    from = 0;
    to = 20;
    getDataApi();
  }

  /// On click cell open dialog with data
  openDialog(String data, BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text(data),
        content: Text(data),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Get data from api if there is internet or get data from database
  getDataApi() async {
    isLoading.value = true;
    checkInternet().then((connectivityResult) async {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var response;
        response = await apiCalls.get(apiBaseUrl, {});
        if (response.statusCode == 200) {
          listItems.clear();
          listColumnsNames.clear();
          listItems = (response.data as List)
              .map((e) => ItemModel.fromJson(e))
              .toList();
          getDataReady();
          setUpDataToDatabase();
        } else {
          Get.snackbar('Error', 'Error');
          isLoading.value = false;
        }
      } else {
        Get.snackbar('No internet', 'Getting data from database');
        getDataFromDatabase();
      }
    });
  }

  /// Check internet connection
  Future<ConnectivityResult> checkInternet() async {
    return (Connectivity().checkConnectivity());
  }

  /// Setup the database and insert all the data
  setUpDataToDatabase() {
    for (int i = 0; i < listColumnsNames.length; i++) {
      database.insertTitleData(NameColumns(name: listColumnsNames[i]));
    }
    for (int i = 0; i < listItems.length; i++) {
      database.insertRowsValue(RowsValuesData(
          name: listItems[i].name ?? EnvironmentData.noValue,
          body: listItems[i].body ?? EnvironmentData.noValue,
          email: listItems[i].email ?? EnvironmentData.noValue,
          id: listItems[i].id ?? -1,
          postId: listItems[i].postId ?? -1));
    }
  }

  /// Get data from database
  getDataFromDatabase() {
    listItems.clear();
    listColumnsNames.clear();
    database.getAllRowsValue().then((value) {
      for (int i = 0; i < value.length; i++) {
        listItems.add(ItemModel(
            email: value[i].email,
            body: value[i].body,
            id: value[i].id,
            name: value[i].name,
            postId: value[i].postId));
      }
      getDataReady();
    });
  }

  /// Set data ready - columns values
  getDataReady() {
    if (listItems.isNotEmpty) {
      listItems[0].toJson().forEach((key, value) {
        listColumnsNames.add(key);
      });
    }

    setListValue();
  }

  /// Set data - row data
  setListValue() {
    if (listItems.isNotEmpty) {
      for (from; from < to; from++) {
        listItemsShow.add(listItems[from]);
      }
    }

    isLoadingMore.value = false;
    isLoading.value = false;
  }

  @override
  void onReady() {
    print('The build method is done. '
        'Your controller is ready to call dialogs and snackbars');
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose called');
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    print('the window size did change');
    super.didChangeMetrics();
  }

  @override
  void didChangePlatformBrightness() {
    print('platform change ThemeMode');
    super.didChangePlatformBrightness();
  }

  @override
  Future<bool> didPushRoute(String route) {
    print('the route $route will be open');
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPopRoute() {
    print('the current route will be closed');
    return super.didPopRoute();
  }

  @override
  void onDetached() {
    print('onDetached called');
  }

  @override
  void onInactive() {
    print('onInative called');
  }

  @override
  void onPaused() {
    print('onPaused called');
  }

  @override
  void onResumed() {
    print('onResumed called');
  }
}
