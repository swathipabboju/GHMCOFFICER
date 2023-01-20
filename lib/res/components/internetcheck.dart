import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NetCheck extends StatefulWidget {
  const NetCheck({super.key});

  @override
  State<NetCheck> createState() => _NetCheckState();
}

class _NetCheckState extends State<NetCheck> {
  StreamSubscription? connection;
  bool isoffline = false;
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
     InternetCheck();
    // TODO: implement initState
    super.initState();
   
  }
  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }


  InternetCheck() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
        });
      }
    });
  }
}
