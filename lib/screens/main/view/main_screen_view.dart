import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/screens/main/controller/main_screen_controller.dart';

class MainScreenView extends StatelessWidget {
  final MainScreenController _mainScreenController =
      Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            _mainScreenController.onRefresh();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _mainScreenController.scrollController,
            child: Obx(() {
              return Column(
                children: [
                  if (_mainScreenController.isLoading.value) ...{
                    const Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  } else ...{
                    if (_mainScreenController.listItems.isEmpty) ...{
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () =>
                                    _mainScreenController.getDataApi(),
                                child: const Text('NO INTERNET - REFRESH'),
                              ),
                            ],
                          ),
                        ),
                      )
                    } else ...{
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: DataTable(
                            columnSpacing: 0,
                            dataRowHeight: 150,
                            columns: _mainScreenController.listColumnsNames
                                .map((data) => DataColumn(
                                        label: Expanded(
                                            child: Text(
                                      data,
                                      textAlign: TextAlign.center,
                                    ))))
                                .toList(),
                            rows: _mainScreenController.listItems
                                .map((data) => DataRow(cells: [
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              _mainScreenController.openDialog(
                                                  data.postId.toString(),
                                                  context),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              child: Text(
                                                data.postId.toString(),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              _mainScreenController.openDialog(
                                                  data.id.toString(), context),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              child: Text(data.id.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              _mainScreenController.openDialog(
                                                  data.name.toString(),
                                                  context),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Text(data.name.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              _mainScreenController.openDialog(
                                                  data.email.toString(),
                                                  context),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Text(data.email.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              _mainScreenController.openDialog(
                                                  data.body.toString(),
                                                  context),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Text(data.body.toString(),
                                                  textAlign: TextAlign.center)),
                                        ),
                                      )
                                    ]))
                                .toList()),
                      )
                    }
                  }
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
