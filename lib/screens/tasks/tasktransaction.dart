import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todolist/config/constants.dart';
import 'package:todolist/config/size_config.dart';
import 'package:todolist/models/category.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/screens/category/categoryscreen.dart';
import 'package:todolist/services/tasksstorage.dart';

class TaskTransactionPage extends StatefulWidget {
  const TaskTransactionPage({
    Key? key,
    required this.FormType,
    required this.name,
    this.id,
    this.categoryId,
    this.dueDate,
  }) : super(key: key);

  final String FormType;
  final int? id;
  final int? categoryId;
  final String name;
  final DateTime? dueDate;

  @override
  _TaskTransactionPageState createState() => _TaskTransactionPageState();
}

class _TaskTransactionPageState extends State<TaskTransactionPage> {
  final txtTaskNameController = TextEditingController();
  final txtTaskCategoryController = TextEditingController();
  final txtDueDateController = TextEditingController();

  int? _selectedCategoryId;
  final TaskStorage _taskStorage = TaskStorage();
  List<CategoryTask> _categories = [];

  void askPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  Future<void> _loadCategories() async {
    final categories = await _taskStorage.fetchCategories();
    setState(() {
      _categories = categories;
      _selectedCategoryId = widget.categoryId;
    });
  }

  void clearData() {
    txtTaskNameController.text = "";
    txtTaskCategoryController.text = "";
    final formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    txtDueDateController.text = formattedDate;
  }

  @override
  void initState() {
    askPermissions();
    clearData();
    _loadCategories();
    if (widget.FormType == "Modify") {
      txtTaskNameController.text = widget.name;
      final formattedDate = DateFormat('dd-MMM-yyyy').format(widget.dueDate!);
      txtDueDateController.text = formattedDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDueDate;
    double screenwidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;

    void _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDueDate)
        setState(() {
          selectedDueDate = picked;
          final formattedDate = DateFormat('dd-MMM-yyyy').format(picked);
          txtDueDateController.text = formattedDate;
        });
    }

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
                                              ? 'Add New Task'
                                              : 'Modify Task',
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
                                                    txtTaskNameController,
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
                                                  hintText: "Enter Task Name",
                                                  hintStyle: kGeneralTextStyle(
                                                      12,
                                                      isBold: false),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            DropdownButtonFormField<int>(
                                              value: _selectedCategoryId,
                                              onChanged: (int? newValue) {
                                                if (newValue == -1) {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            CategoriesPage(),
                                                      ))
                                                      .then((value) =>
                                                          setState(() {
                                                            _loadCategories();
                                                            _selectedCategoryId =
                                                                -1;
                                                          }));
                                                } else {
                                                  setState(() {
                                                    _selectedCategoryId =
                                                        newValue;
                                                  });
                                                }
                                              },
                                              items: [
                                                ..._categories.map<
                                                        DropdownMenuItem<int>>(
                                                    (CategoryTask category) {
                                                  return DropdownMenuItem<int>(
                                                    value: category.id,
                                                    child: Text(category.name),
                                                  );
                                                }).toList(),
                                                DropdownMenuItem<int>(
                                                  value: -1,
                                                  child: Text(
                                                    'Add New Category',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                              decoration: InputDecoration(
                                                labelText: 'Category',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      25),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Due Date:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        txtDueDateController,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Select due date',
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons
                                                            .calendar_today),
                                                        onPressed: () =>
                                                            _selectDate(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      30),
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
                                                  "SAVE TASK",
                                                  style:
                                                      kGeneralTextStyleSecondary(
                                                          14,
                                                          isBold: false),
                                                ),
                                                onPressed: () async => {
                                                  () async {
                                                    if (verifyTextControllers([
                                                      txtTaskNameController,
                                                    ])) {
                                                      if (widget.FormType ==
                                                          "Add") {
                                                        await _addTask(
                                                                txtTaskNameController
                                                                    .text,
                                                                _selectedCategoryId,
                                                                txtDueDateController
                                                                    .text)
                                                            .then(
                                                                (value) => () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }());
                                                      } else {
                                                        await _editTask(
                                                                widget.id,
                                                                txtTaskNameController
                                                                    .text,
                                                                _selectedCategoryId,
                                                                txtDueDateController
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

  Future<void> _editTask(int? id, String taskName, int? categoryID,
      String? selectedDueDate) async {
    DateTime parsedDate = DateFormat('dd-MMM-yyyy').parse(selectedDueDate!);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    DateTime dueDate = DateTime.parse(formattedDate);
    final editTask =
        Task(id: id, name: taskName, categoryId: categoryID, dueDate: dueDate);
    final TaskStorage _taskStorage = TaskStorage();
    await _taskStorage.updateTask(editTask);
  }

  Future<void> _addTask(
      String taskName, int? categoryID, String? selectedDueDate) async {
    DateTime parsedDate = DateFormat('dd-MMM-yyyy').parse(selectedDueDate!);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    DateTime dueDate = DateTime.parse(formattedDate);

    final newTask =
        Task(name: taskName, categoryId: categoryID, dueDate: dueDate);
    final TaskStorage _taskStorage = TaskStorage();
    await _taskStorage.insertTask(newTask);
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
