import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist/config/constants.dart';
import 'package:todolist/config/size_config.dart';

class DeleteGeneralDialog extends StatefulWidget {
  const DeleteGeneralDialog(
      {Key? key,
      required this.MainDesc,
      required this.SubDesc,
      required this.callback})
      : super(key: key);

  final String MainDesc, SubDesc;
  final Function(String val) callback;

  @override
  _DeleteGeneralDialogState createState() => _DeleteGeneralDialogState();
}

class _DeleteGeneralDialogState extends State<DeleteGeneralDialog> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: getProportionateScreenHeight(270),
            width: getProportionateScreenWidth(350),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  widget.MainDesc,
                  style: kGeneralTextStyle(12, isBold: true),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  widget.SubDesc,
                  style: kGeneralTextStyle(12, isBold: true),
                ),
                SizedBox(height: getProportionateScreenHeight(80)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: (SizeConfig.screenWidth / 2) - 80,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: kDeleteColor,
                            padding: EdgeInsets.all(5.0),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        child: Text(
                          "DELETE",
                          style: kGeneralTextStyleSecondary(14, isBold: false),
                        ),
                        onPressed: () => {
                          () async {
                            Navigator.pop(context);
                            widget.callback("1");
                          }()
                          //MyProfile.checkProfile(txtUserController.text, txtPasswordController.text)
                        },
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: (SizeConfig.screenWidth / 2) - 80,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: kButtonColor,
                            padding: EdgeInsets.all(5.0),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        child: Text(
                          "CANCEL",
                          style: kGeneralTextStyleSecondary(14, isBold: false),
                        ),
                        onPressed: () => {
                          () async {
                            Navigator.pop(context);
                            widget.callback("0");
                          }()
                          //MyProfile.checkProfile(txtUserController.text, txtPasswordController.text)
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: getProportionateScreenWidth(20),
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
