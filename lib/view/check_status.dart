import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/check_status_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/appbar.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/View/stepper.dart';

import 'package:grouped_list/grouped_list.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({super.key});

  @override
  State<CheckStatus> createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  checkStatusResponse? _statusResponse;
  // ViewGrievancePreview? _grievancePreview;
  List<ViewGrievances> viewGrievanceResponse = [];
  List<ViewGrievances> viewGrievanceSearchListResponse = [];

  List<Map<String, String>> d = [];
  List customers = [""];
  dynamic jsonResult;
  dynamic? list;
  var check;

  var count = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          BgImage(imgPath: ImageConstants.bg),
          Column(
            children: [
              ReusableAppbar(
                topPadding: 20,
                screenWidth: 1,
                screenHeight: 0.08,
                bgColor: Colors.white,
                appIcon: Icon(Icons.arrow_back),
                title: "Check Status",
                onPressed: (() {
                  Navigator.pop(context);
                }),
                homeIcon: Icon(Icons.home),
                homeTapped: (() {
                  Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
                }),
              ),
              ReusableSearchbar(
                bgColor: Colors.white,
                screenHeight: 0.05,
                searchIcon: Icon(Icons.search),
                topPadding: 8.0,
                onChanged: (value) => _runFilter(value),
                screenWidth: 1,
                onPressed: () {},
              ),
              Expanded(
                child: GroupedListView<dynamic, String>(
                  stickyHeaderBackgroundColor: Colors.amber,
                  elements: d,
                  groupBy: (element) => element["Subcategory Name"],
                  groupComparator: (value1, value2) => value2.compareTo(value1),
                  /*  itemComparator: (item1, item2) =>
                      item1['ID'].compareTo(item2['ID']), */
                  // order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: false,
                  groupSeparatorBuilder: (String value) => SizedBox(
                    height: 50,
                    child: Card(
                      color: Colors.black,
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  indexedItemBuilder: ((context, ele, index) {
                    //  print("element ${ele["Subcategory Name"]}");
                    //  print(index);

                    // print( d.where((ViewGrievances) =>
                    //     ViewGrievances["type"] == ele["type"]));

                    // (d.map((e) => e[" Subcategory Name"] == ele["type"]));
                    d.map((e) {
                      if (e[" Subcategory Name"] == ele["type"]) {
                        print("true");
                      } else {
                        print("no");
                      }
                    });
                    // print("checking ${check}");
                    /* d.map(
                      (e) {
                        print("elements of e ${e}");
                      },
                    ); */

                    return GestureDetector(
                      onTap: () {
                        SharedPreferencesClass().writeTheData(
                            PreferenceConstants.check_status_id, ele["ID"]);
                        Navigator.pushNamed(context, AppRoutes.grivancedetails);
                      },
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RowComponent(
                              TextConstants.check_status_id, ele["ID"]),
                          Line(),
                          RowComponent(TextConstants.check_status_category_name,
                              ele["Category Name"]),
                          Line(),
                          RowComponent(
                              TextConstants.check_status_subcategory_name,
                              ele["Subcategory Name"]),
                          Line(),
                          RowComponent(TextConstants.check_status_time_stamp,
                              ele["Time stamp"]),
                          Line(),
                          RowComponent(TextConstants.check_status_assigned_to,
                              ele["Assigned to"]),
                          Line(),
                          RowComponent(
                              TextConstants.check_status_status, ele["Status"]),
                          Column(
                            children: [
                              StepperPage(
                                  curStep: 1,
                                  titles: [
                                    "Open",
                                    "Under Process",
                                    "Resolved By Officer",
                                    "Closed By Citizen",
                                    "Condition Closed"
                                  ],
                                  width: 10.0,
                                  color: Colors.black),
                            ],
                          ),
                        ],
                      )),
                    );
                  }),
                ),
              ),
            ],
          )
        ],
      ),
    );
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

  _runFilter(String enteredKeyword) {
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
  }
}
