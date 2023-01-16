import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/check_status_response.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:group_list_view/group_list_view.dart';


Map<String, List> _elements = {
  'Team A': ['Klay Lewis', 'Ehsan Woodard', 'River Bains'],
  'Team B': ['Toyah Downs', 'Tyla Kane'],
  'Team C': ['Marcus Romero', 'Farrah Parkes', 'Fay Lawson', 'Asif Mckay'],
  'Team D': [
    'Casey Zuniga',
    'Ayisha Burn',
    'Josie Hayden',
    'Kenan Walls',
    'Mario Powers'
  ],
  'Team Q': ['Toyah Downs', 'Tyla Kane', 'Toyah Downs'],
};

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  checkStatusResponse? _statusResponse;
   List<Map<String, String>> d = [];
  var check;
   dynamic jsonResult;
  dynamic list;
     
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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
            onPressed: (() {
              Navigator.of(context).pop();
              // complaint.value="select";
            })
            //() => Navigator.of(context).pop(),
            ),
        title: Center(
          child: Text(
            "Check Status",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
        body: Stack(
          children: [
            BgImage(imgPath: ImageConstants.bg),
            Column(
              children: [
                ReusableSearchbar(
                bgColor: Colors.white,
                screenHeight: 0.05,
                searchIcon: Icon(Icons.search),
                topPadding: 8.0,
                onChanged: (value){
                  
                },
                screenWidth: 1,
                onPressed: () {},
              ),
                Expanded(
                  child: GroupListView(
                    sectionsCount: _elements.keys.toList().length,
                    countOfItemInSection: (int section) {
                      return _elements.values.toList()[section].length;
                    },
                    itemBuilder: _itemBuilder,
                    groupHeaderBuilder: (BuildContext context, int section) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _elements.keys.toList()[section],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${_elements.values.toList()[section].length}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    String user = _elements.values.toList()[index.section][index.index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 8,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
          leading: CircleAvatar(
            child: Text(
              _getInitials(user),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: _getAvatarColor(user),
          ),
          title: Text(
            _elements.values.toList()[index.section][index.index],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }

  Color _getAvatarColor(String user) {
    return Colors.black;
  }

  checkStatusDetails() async {
    final check_status_url =
        ApiConstants.baseurl + ApiConstants.check_status_endpoint;
    final check_status_payload = {
      "mobileno": "8008554962",
      "password": "ghmc@cgg@2018",
      "userid": "cgg@ghmc"
    };
    final dio_obj = Dio();
    try {
      final check_status_response =
          await dio_obj.post(check_status_url, data: check_status_payload);
      // print(check_status_response.data);

      final data = checkStatusResponse.fromJson(check_status_response.data);
      final j = data.toJson;
      // print(j);
      setState(() {
        if (data != null && data.status == "success") {
          EasyLoading.dismiss();
          _statusResponse = data;
        }
      });

      // print(_statusResponse?.viewGrievances);

      //print(customers);

      var len = _statusResponse?.viewGrievances?.length ?? 0;
      for (var i = 0; i < len; i++) {
        var item = _statusResponse?.viewGrievances?[i];

        d.add({
          TextConstants.check_status_id: item?.id ?? "",
          TextConstants.check_status_assigned_to: item?.assignedto ?? "",
          TextConstants.check_status_category_name: item?.category ?? "",
          TextConstants.check_status_subcategory_name: item?.type ?? "",
          TextConstants.check_status_time_stamp: item?.timestamp ?? "",
          TextConstants.check_status_status: item?.status ?? "",
        });
      }

      // print(d);
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkStatusDetails();
    fetchjsondata();
    print(check);

    // groupEmployeesByCountryAndCity(_items);
  }

  RowComponent(var data, var val) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              //Text("${data}",style: TextStyle(decoration: TextDecoration.underline),)
              child: TextWidget(
                text: "${data}",
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                textcolor: Colors.black54,
              )),
          Expanded(
              flex: 2,
              child: TextWidget(
                text: "${val}",
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                textcolor: Colors.blueGrey,
              ))
        ],
      ),
    );
  }

  Line() {
    return Divider(
      thickness: 1.0,
      color: Colors.grey,
    );
  }

  jsondetails(String k, String v) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            k,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            v,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  fetchjsondata() async {
    String jsondata =
        await rootBundle.loadString('assets/check_status_json_data.json');

    setState(() {
      jsonResult = json.decode(jsondata);
    });
    //  print(jsonResult["viewGrievances"]);
    list = jsonResult["viewGrievances"];
    // print(list);
  }

  /* _runFilter(String enteredKeyword) {
    List<ViewGrievances> results = [];
    if (enteredKeyword.isEmpty) {
      results = viewGrievanceResponse;
    } else {
      // print(enteredKeyword);
      results = viewGrievanceResponse
          .where((element) =>
              element.id!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        viewGrievanceSearchListResponse = results;
        // print(viewGrievanceSearchListResponse.length);
      });
    }
  } */
}