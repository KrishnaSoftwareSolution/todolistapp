import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:todolist/config/constants.dart';
import 'package:todolist/config/size_config.dart';
import 'package:todolist/models/category.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/services/tasksstorage.dart';

class CategoryTransactionPage extends StatefulWidget {
  const CategoryTransactionPage({
    Key? key,
    required this.FormType,
    required this.id,
    required this.name,
  }) : super(key: key);

  final int? id;
  final String FormType;
  final String name;

  @override
  _CategoryTransactionPageState createState() =>
      _CategoryTransactionPageState();
}

class _CategoryTransactionPageState extends State<CategoryTransactionPage> {
  final txtCategoryNameController = TextEditingController();

  void askPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  void clearData() {
    txtCategoryNameController.text = "";
  }

  @override
  void initState() {
    askPermissions();
    clearData();
    if (widget.FormType == "Modify") {
      txtCategoryNameController.text = widget.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;

    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade100,
                      Colors.grey.shade100,
                      Colors.grey.shade100,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.grey.shade200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.FormType == "Add"
                                              ? 'Add New Category'
                                              : 'Modify Category',
                                          style: kGeneralTextStyle(16,
                                              isBold: false),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 50),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              height: 50.0,
                                              child: TextField(
                                                controller:
                                                    txtCategoryNameController,
                                                style: kGeneralTextStyle(12,
                                                    isBold: false),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 14.0),
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    color: kButtonColor,
                                                  ),
                                                  hintText: "Enter Category",
                                                  hintStyle: kGeneralTextStyle(
                                                      12,
                                                      isBold: false),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0),
                                              width: double.infinity,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        kButtonColor,
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    elevation: 5.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    )),
                                                child: Text(
                                                  "SAVE CATEGORY",
                                                  style:
                                                      kGeneralTextStyleSecondary(
                                                          14,
                                                          isBold: false),
                                                ),
                                                onPressed: () async => {
                                                  () async {
                                                    if (verifyTextControllers([
                                                      txtCategoryNameController,
                                                    ])) {
                                                      if (widget.FormType ==
                                                          "Add") {
                                                        await _addCategory(
                                                          txtCategoryNameController
                                                              .text,
                                                        ).then((value) => () {
                                                              Navigator.pop(
                                                                  context);
                                                            }());
                                                      } else {
                                                        await _editCategory(
                                                                widget.id,
                                                                txtCategoryNameController
                                                                    .text)
                                                            .then(
                                                                (value) => () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }());
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Please fill all fields')),
                                                      );
                                                    }
                                                  }()
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool verifyTextControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> _editCategory(int? id, String categoryName) async {
    final editCategory = CategoryTask(id: id, name: categoryName);
    final TaskStorage _taskStorage = TaskStorage();
    await _taskStorage.updateCategory(editCategory);
  }

  Future<void> _addCategory(String categoryName) async {
    final newCategory = CategoryTask(name: categoryName);
    final TaskStorage _taskStorage = TaskStorage();
    await _taskStorage.insertCategory(newCategory);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Container(
          height: 55,
          width: 55,
          child: Image.asset('assets/icons/appicon.png')),
    );
  }
}
