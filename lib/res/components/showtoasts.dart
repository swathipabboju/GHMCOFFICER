import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToats{
  static  showToast(String msg,{gravity,Color? bgcolor,Color? textcolor}) {
    Fluttertoast.showToast(
        msg: msg,
        timeInSecForIosWeb:1,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
       
        backgroundColor:bgcolor?? Colors.transparent,
        textColor:textcolor?? Colors.white,
       
        fontSize: 16.0);
        
  }
}