import 'dart:ui';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:todolist/common/gnfunctions.dart';
import 'package:todolist/config/constants.dart';
import 'package:todolist/config/size_config.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/models/category.dart';
import 'package:todolist/screens/category/categoryscreen.dart';
import 'package:todolist/screens/tasks/tasktransaction.dart';
import 'package:todolist/services/tasksstorage.dart';
import 'package:todolist/themes/themeprovider.dart';

class Dashbaord extends StatefulWidget {
  const Dashbaord({super.key});

  @override
  State<Dashbaord> createState() => _DashbaordState();
}

class _DashbaordState extends State<Dashbaord> {
  final TaskStorage _taskStorage = TaskStorage();
  List<Task> _tasks = [];
  List<CategoryTask> _categories = [];
  int? _selectedCategoryId;

  Future<void> requestPermission() async {
    Permission permission = Permission.storage;
    final status = await permission.request();

    _loadData();
    _loadCategories();
  }

  Future<void> _loadData() async {
    final tasks = await _taskStorage.fetchTasks();

    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _loadCategories() async {
    final categories = await _taskStorage.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Task> _getFilteredTasks() {
    List<Task> tasksToDisplay = _selectedCategoryId == null
        ? _tasks
        : _tasks
            .where((task) => task.categoryId == _selectedCategoryId)
            .toList();

    tasksToDisplay.sort((a, b) {
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return tasksToDisplay;
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final filteredTasks = _getFilteredTasks();
    double screenwidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Container(
            height: 55,
            width: 55,
            child: Image.asset('assets/icons/appicon.png')),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskTransactionPage(
                      FormType: "Add",
                      name: "",
                    )),
          ).then(
            (value) => setState(() {
              _loadData();
            }),
          );
        },
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight + getProportionateScreenHeight(150),
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
                  padding: EdgeInsets.all(0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                      "To Do List",
                                      style:
                                          kGeneralTextStyle(16, isBold: false),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            height: screenHeight,
                            child: Column(children: [
                              DropdownButtonFormField<int>(
                                value: _selectedCategoryId,
                                onChanged: (int? newValue) {
                                  if (newValue == -1) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CategoriesPage(),
                                        ))
                                        .then((value) => setState(() {
                                              _loadCategories();
                                              _selectedCategoryId = null;
                                            }));
                                  } else if (newValue == -2) {
                                    _loadData();
                                    _selectedCategoryId = null;
                                  } else {
                                    setState(() {
                                      _selectedCategoryId = newValue;
                                    });
                                  }
                                },
                                items: [
                                  ..._categories.map<DropdownMenuItem<int>>(
                                      (CategoryTask category) {
                                    return DropdownMenuItem<int>(
                                      value: category.id,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  DropdownMenuItem<int>(
                                    value: -2,
                                    child: Text(
                                      'All Categories',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: -1,
                                    child: Text(
                                      'Add New Category',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              filteredTasks.length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                        itemCount: filteredTasks.length,
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
                                                            "Are You Sure To Delete This Task !",
                                                        SubDesc:
                                                            filteredTasks[index]
                                                                .name,
                                                        callback: (val) =>
                                                            () async {
                                                          if (val == "1") {
                                                            await _taskStorage
                                                                .deleteTask(
                                                                    filteredTasks[
                                                                            index]
                                                                        .id!);
                                                            _loadData();
                                                          }
                                                        }(),
                                                      );
                                                    });
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskTransactionPage(
                                                      FormType: "Modify",
                                                      id: filteredTasks[index]
                                                          .id,
                                                      categoryId:
                                                          filteredTasks[index]
                                                              .categoryId,
                                                      name: filteredTasks[index]
                                                          .name,
                                                      dueDate:
                                                          filteredTasks[index]
                                                              .dueDate,
                                                    ),
                                                  ),
                                                ).then((value) => () {
                                                      setState(() {
                                                        _loadData();
                                                      });
                                                    }());
                                              }
                                            },
                                            child: TaskCard(
                                              task: filteredTasks[index],
                                              deleteTask: () => () async {}(),
                                              press: () => () {}(),
                                              callback: (val) => () {
                                                setState(() {
                                                  _loadData();
                                                });
                                              }(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : EmptyDashboard(),
                            ]),
                          ),
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
}

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.task,
    required this.deleteTask,
    required this.press,
    required this.callback,
  }) : super(key: key);

  final Task task;
  final Function press;
  final Function deleteTask;
  final Function(String val) callback;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String categoryName = "";
  final TaskStorage _taskStorage = TaskStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getCategoryName();
    });
  }

  Future<void> getCategoryName() async {
    final name =
        await _taskStorage.fetchCategoryNameByID(widget.task.categoryId);
    if (mounted) {
      setState(() {
        categoryName = name;
      });
    }
  }

  Future<void> changeTaskStatus(bool status) async {
    final updateTask = Task(
      id: widget.task.id,
      name: widget.task.name,
      categoryId: widget.task.categoryId,
      completed: status,
      dueDate: widget.task.dueDate,
    );
    final TaskStorage _taskStorage = TaskStorage();
    await _taskStorage.updateTask(updateTask);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue =
        widget.task.dueDate != null && widget.task.dueDate!.isBefore(now);
    final isUpcoming =
        widget.task.dueDate != null && widget.task.dueDate!.isAfter(now);

    return GestureDetector(
      onTap: () => widget.press(),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isOverdue
                ? Colors.redAccent
                : isUpcoming
                    ? Colors.yellowAccent
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: widget.task.completed,
                onChanged: (bool? value) {
                  setState(() {
                    changeTaskStatus(value!);
                    widget.task.completed = value!;
                  });
                  widget.callback("");
                },
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Due Date: " +
                          DateFormat('dd-MMM-yyyy')
                              .format(widget.task.dueDate!),
                      style: TextStyle(
                        fontSize: 14,
                        color: isOverdue ? Colors.red : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyDashboard extends StatefulWidget {
  const EmptyDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<EmptyDashboard> createState() => _EmptyDashboardState();
}

class _EmptyDashboardState extends State<EmptyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: getProportionateScreenHeight(100),
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: EdgeInsets.only(
                top: getProportionateScreenWidth(10),
                left: getProportionateScreenWidth(1),
                bottom: getProportionateScreenWidth(0),
                right: getProportionateScreenWidth(1)),
            child: Container(
              width: SizeConfig.screenWidth,
              height: getProportionateScreenHeight(100),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: SizeConfig.screenWidth - 30,
                        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Tasks Found",
                              style:
                                  kGeneralTextStyleDisable(14, isBold: false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
