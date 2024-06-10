import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:todolist/common/gnfunctions.dart';
import 'package:todolist/config/constants.dart';
import 'package:todolist/config/size_config.dart';
import 'package:todolist/models/category.dart';
import 'package:todolist/screens/category/categorytransaction.dart';
import 'package:todolist/services/tasksstorage.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TaskStorage _taskStorage = TaskStorage();
  List<CategoryTask> _categories = [];

  Future<void> _loadData() async {
    final categories = await _taskStorage.fetchCategories();
    setState(() {
      _categories = categories.cast<CategoryTask>();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CategoryTransactionPage(FormType: "Add", id: 0, name: "")),
          ).then(
            (value) => setState(() {
              _loadData();
            }),
          );
        },
      ),
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Container(
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
                                          'Tasks Categories',
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
                                    Container(
                                      height: screenHeight,
                                      width: screenwidth,
                                      child: ListView.builder(
                                        itemCount: _categories.length,
                                        itemBuilder: (context, index) =>
                                            ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: Dismissible(
                                            key: UniqueKey(),
                                            direction:
                                                DismissDirection.horizontal,
                                            background: slideRightBackground(),
                                            secondaryBackground:
                                                slideLeftBackground(),
                                            confirmDismiss: (direction) async {
                                              if (direction ==
                                                  DismissDirection.endToStart) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DeleteGeneralDialog(
                                                        MainDesc:
                                                            "Are You Sure To Delete This Category !",
                                                        SubDesc:
                                                            _categories[index]
                                                                .name,
                                                        callback: (val) => () {
                                                          if (val == "1") {
                                                            final TaskStorage
                                                                _taskStorage =
                                                                TaskStorage();
                                                            _taskStorage
                                                                .deleteCategory(
                                                                    _categories[
                                                                            index]
                                                                        .id)
                                                                .then((value) =>
                                                                    () {
                                                                      setState(
                                                                          () {
                                                                        _loadData();
                                                                      });
                                                                    }());
                                                          }
                                                        }(),
                                                      );
                                                    });
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CategoryTransactionPage(
                                                      FormType: "Modify",
                                                      id: _categories[index].id,
                                                      name: _categories[index]
                                                          .name,
                                                    ),
                                                  ),
                                                ).then((value) => () {
                                                      setState(() {
                                                        _loadData();
                                                      });
                                                    }());
                                              }
                                            },
                                            child: CategoryCard(
                                              category: _categories[index],
                                              deleteCategory: () => () {
                                                setState(() {
                                                  _taskStorage
                                                      .fetchCategories();
                                                });
                                              }(),
                                              press: () => () {}(),
                                              callback: (val) => () {
                                                setState(() {
                                                  _taskStorage
                                                      .fetchCategories();
                                                });
                                              }(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(60),
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

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    Key? key,
    required this.category,
    required this.deleteCategory,
    required this.press,
    required this.callback,
  }) : super(key: key);

  final CategoryTask category;
  final Function press;
  final Function deleteCategory;
  final Function(String val) callback;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: getProportionateScreenHeight(80),
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () => widget.press(),
            child: Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(10),
                  left: getProportionateScreenWidth(8),
                  bottom: getProportionateScreenWidth(0),
                  right: getProportionateScreenWidth(8)),
              child: Container(
                width: SizeConfig.screenWidth,
                height: getProportionateScreenHeight(130),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth - 40,
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: kGeneralTextStyle(14, isBold: false),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
