import 'package:dio/dio.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/model/show_notification_response.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

class InboxNotifications extends StatefulWidget {
  const InboxNotifications({super.key});

  @override
  State<InboxNotifications> createState() => _InboxNotificationsState();
}

class _InboxNotificationsState extends State<InboxNotifications> {
  ShowNotificationResponse? showNotificationResponse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () async {
              EasyLoading.show();
              Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            TextConstants.notification_inbox,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Column(
                    children: [
                      Text("${showNotificationResponse?.title}"),
                      Text("${showNotificationResponse?.timestamp}"),
                      ExpandableText(
                        "${showNotificationResponse?.msg}",
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 1,
                        linkColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  fetchDetails() async {
    var mobile = await SharedPreferencesClass().readTheData(PreferenceConstants.mobileno);

    const requesturl =
        ApiConstants.baseurl + ApiConstants.inbox_notifications_endpoint;

    var payload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "mobileno": mobile,
    };
    

    final dioObject = Dio();

    try {

      final response = await dioObject.post(requesturl, data: payload);
      var len = response.data.length;

      for(var i=0;i<len; i++)
      {
      final data = ShowNotificationResponse.fromJson(response.data[i]);
       setState(() {
          if (data.status == "success") {
            EasyLoading.dismiss();
            showNotificationResponse = data;
          }
        });
      }

    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
  }
}
