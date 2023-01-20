
import 'package:flutter/material.dart';

class AlertsNetwork {
  static showAlertDialog(BuildContext context, var message,
      {
      required Function() onpressed,
      Color? buttoncolor,
      Color? buttontextcolor,
      align,
      required String buttontext}) {
    Widget okButton = TextButton(
      onPressed: onpressed,
      child: Text(
        buttontext,
        textAlign: align,
        style: TextStyle(
            color: buttontextcolor ?? Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "${message.toString()}",
        //textAlign: TextAlign.center,
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
