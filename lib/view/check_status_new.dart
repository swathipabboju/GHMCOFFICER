import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/check_status_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showtoast.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

class CheckStatusSample extends StatefulWidget {
  const CheckStatusSample({super.key});

  @override
  State<CheckStatusSample> createState() => _CheckStatusSampleState();
}

class _CheckStatusSampleState extends State<CheckStatusSample> {
  checkStatusResponse? _statusResponse;
  List<ViewGrievances>? _viewGrievances;
  Map<String, List>? listitems;
  Map headers = {};
  List val = [];
  List titles = [
    TextConstants.checkstatus_stepper_open,
    TextConstants.checkstatus_stepper_underprocess,
    TextConstants.checkstatus_stepper_resolvedbyofficer,
    TextConstants.checkstatus_stepper_closedbycitizen,
    TextConstants.checkstatus_stepper_conditionclosed
  ];
  List _titles = [];
  bool viewgrievanceflag = false;

  Map<String, String> d = {};
  List rightvalues = [];
  Map finalitems = {};
  List Repairstofootpath = [];
  List UnauthorizedHoardings = [];
  List CSCPaymentNotUpdatedinPortal = [];
  List PreviousYearsPropertyTaxPayment = [];
  List GarbageBurning = [];
  List RepairstoRoadPotholes = [];

  List finalitemsResponse = [];
  List finalitemsSearchListResponse = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () async {
              // EasyLoading.show();
              Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
            },
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (() {
              Navigator.of(context).pop();
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
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        Column(
          children: [
            ReusableSearchbar(
              bgColor: Colors.white,
              screenHeight: 0.05,
              searchIcon: Icon(Icons.search),
              topPadding: 8.0,
              onChanged: (value) => _runFilter(value),
              screenWidth: 1,
              onPressed: () {},
            ),viewgrievanceflag?
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: finalitemsSearchListResponse
                                .asMap()
                                .keys
                                .toList()
                                .length,
                            itemBuilder: (BuildContext context, int index1) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    color: Color.fromARGB(255, 20, 55, 83),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            finalitems.keys.toList()[index1],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "${finalitemsSearchListResponse.asMap().values.toList()[index1].length}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      itemCount: finalitemsSearchListResponse
                                          .asMap()
                                          .values
                                          .toList()[index1]
                                          .length,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index2) {
                                        return GestureDetector(
                                          onTap: (() {
                                            SharedPreferencesClass()
                                                .writeTheData(
                                                    PreferenceConstants
                                                        .check_status_id,
                                                    finalitemsSearchListResponse
                                                            .asMap()
                                                            .values
                                                            .toList()[index1]
                                                        [index2]["ID"]);

                                            Navigator.pushNamed(context,
                                                AppRoutes.grivancedetails);
                                          }),
                                          child: Container(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RowComponent(
                                                  TextConstants.check_status_id,
                                                  finalitemsSearchListResponse
                                                              .asMap()
                                                              .values
                                                              .toList()[index1]
                                                          [index2][
                                                      TextConstants
                                                          .check_status_id]),
                                              Line(),
                                              RowComponent(
                                                  TextConstants
                                                      .check_status_category_name,
                                                  finalitemsSearchListResponse
                                                              .asMap()
                                                              .values
                                                              .toList()[index1]
                                                          [index2][
                                                      TextConstants
                                                          .check_status_category_name]),
                                              Line(),
                                              RowComponent(
                                                  TextConstants
                                                      .check_status_subcategory_name,
                                                  finalitemsSearchListResponse
                                                              .asMap()
                                                              .values
                                                              .toList()[index1]
                                                          [index2][
                                                      TextConstants
                                                          .check_status_subcategory_name]),
                                              Line(),
                                              RowComponent(
                                                  TextConstants
                                                      .check_status_time_stamp,
                                                  finalitemsSearchListResponse
                                                              .asMap()
                                                              .values
                                                              .toList()[index1]
                                                          [index2][
                                                      TextConstants
                                                          .check_status_time_stamp]),
                                              Line(),
                                              RowComponent(
                                                  TextConstants
                                                      .check_status_assigned_to,
                                                  finalitemsSearchListResponse
                                                              .asMap()
                                                              .values
                                                              .toList()[index1]
                                                          [index2][
                                                      TextConstants
                                                          .check_status_assigned_to]),
                                              Line(),
                                              RowComponent(
                                                  TextConstants
                                                      .check_status_status,
                                                  finalitemsSearchListResponse
                                                              .asMap()
                                                              .values
                                                              .toList()[index1]
                                                          [index2][
                                                      TextConstants
                                                          .check_status_status]),
                                              Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                                  child: Container(
                                                      // width: this._width,
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Row(
                                                        children: _iconViews(
                                                            status: finalitemsSearchListResponse
                                                                        .asMap()
                                                                        .values
                                                                        .toList()[
                                                                    index1][index2]
                                                                [TextConstants
                                                                    .check_status_status]),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: _titleViews(),
                                                      ),
                                                    ],
                                                  )))
                                            ],
                                          )),
                                        );
                                      }),
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ):Text("")
          ],
        ),
      ]), /* */
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatusDetails();
  }

  showAlert(String message, {String text = ""}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextWidget(
              text: message + text,
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              fontsize: 15,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(AppRoutes.ghmcdashboard));
                },
                child: Text(
                  TextConstants.ok,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        }); //showDialog
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
              child: TextWidget(
                text: "${data}",
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                textcolor: Colors.black,
                fontWeight: FontWeight.bold,
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

  _runFilter(String enteredKeyword) {
    List results = [];
    var r;
    if (enteredKeyword.isEmpty) {
      results = finalitemsResponse;
    } else {
      print(enteredKeyword);
      finalitemsResponse.forEach((element) {
        print(element["ID"]);
      });

      setState(() {
        finalitemsSearchListResponse = results;
      });
    }
  }

  checkStatusDetails() async {
    print("called");
    EasyLoading.dismiss();
    var mobileno = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.mobileno);

    final check_status_url =
        ApiConstants.baseurl + ApiConstants.check_status_endpoint;
    final check_status_payload = {
      "mobileno": mobileno,
      "password": AppConstants.password,
      "userid": AppConstants.userid
    };
    final dio_obj = Dio();
    print("payload ${check_status_payload}");

    try {
      final check_status_response =
          await dio_obj.post(check_status_url, data: check_status_payload);
      print("check status response ${check_status_response.data}");

      final data = checkStatusResponse.fromJson(check_status_response.data);

      setState(() {
        if (data != null && data.status == "success") {
          _statusResponse = data;
          if (_statusResponse?.viewGrievances != null) {
            viewgrievanceflag = true;
            // _viewGrievances = data.viewGrievances;
            viewgrievanceflag = true;

            var len = _statusResponse?.viewGrievances?.length ?? 0;
            for (var i = 0; i < len; i++) {
              val.add(_statusResponse?.viewGrievances?[i]);
              headers[_statusResponse?.viewGrievances?[i].type] = val;

              var item = _statusResponse?.viewGrievances?[i];
              _titles.add(item?.status);
              d = {
                TextConstants.check_status_id: item?.id ?? "",
                TextConstants.check_status_assigned_to: item?.assignedto ?? "",
                TextConstants.check_status_category_name: item?.category ?? "",
                TextConstants.check_status_subcategory_name: item?.type ?? "",
                TextConstants.check_status_time_stamp: item?.timestamp ?? "",
                TextConstants.check_status_status: item?.status ?? "",
              };

              switch (d[TextConstants.check_status_subcategory_name]) {
                case TextConstants.checkstatus_repairs_to_footpath:
                  Repairstofootpath.add(d);
                  break;
                case TextConstants.checkstatus_unauthorized_hoardings:
                  UnauthorizedHoardings.add(d);
                  break;
                case TextConstants.checkstatus_cscpayment_not_updatedinportal:
                  CSCPaymentNotUpdatedinPortal.add(d);
                  break;
                case TextConstants.checkstatus_previousyearstaxpayment:
                  PreviousYearsPropertyTaxPayment.add(d);
                  break;
                case TextConstants.checkstatus_garbageburning:
                  GarbageBurning.add(d);
                  break;
                case TextConstants.checkstatus_repairstoroad_potholes:
                  RepairstoRoadPotholes.add(d);
                  break;
              }
              finalitems = {
                TextConstants.checkstatus_repairs_to_footpath:
                    Repairstofootpath,
                TextConstants.checkstatus_unauthorized_hoardings:
                    UnauthorizedHoardings,
                TextConstants.checkstatus_cscpayment_not_updatedinportal:
                    CSCPaymentNotUpdatedinPortal,
                TextConstants.checkstatus_previousyearstaxpayment:
                    PreviousYearsPropertyTaxPayment,
                TextConstants.checkstatus_garbageburning: GarbageBurning,
                TextConstants.checkstatus_repairstoroad_potholes:
                    RepairstoRoadPotholes
              };
            }

            finalitemsResponse = finalitems.values.toList();
            finalitemsSearchListResponse = finalitemsResponse;
          }
        } else {
          viewgrievanceflag = false;
          showAlert("${data.message}");
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  List<Widget> _iconViews({required status}) {
    bool openflag = false;
    bool underprocess = false;
    bool resolvedbyofficer = false;
    bool closedbycitizen = false;
    bool conditionclosed = false;
    switch (status) {
      case TextConstants.checkstatus_stepper_open:
        openflag = true;
        break;
      case TextConstants.checkstatus_stepper_underprocess:
        underprocess = true;
        break;
      case TextConstants.checkstatus_stepper_resolvedbyofficer:
        resolvedbyofficer = true;
        break;
      case TextConstants.checkstatus_stepper_closedbycitizen:
        closedbycitizen = true;
        break;
      case TextConstants.checkstatus_stepper_conditionclosed:
        conditionclosed = true;
        break;
      default:
    }

    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      switch (i) {
        case 0:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: openflag ? Colors.blue : Colors.black,
                  width: openflag ? 10.0 : 2.0,
                ),
              ),
            ),
          );

          break;
        case 1:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: underprocess ? Colors.orange : Colors.black,
                  width: underprocess ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;
        case 2:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: resolvedbyofficer
                      ? Color.fromARGB(255, 26, 67, 27)
                      : Colors.black,
                  width: resolvedbyofficer ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;
        case 3:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: closedbycitizen
                      ? Color.fromARGB(255, 26, 67, 27)
                      : Colors.black,
                  width: closedbycitizen ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;
        case 4:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: conditionclosed
                      ? Color.fromARGB(255, 104, 22, 16)
                      : Colors.black,
                  width: conditionclosed ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;

        default:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),

              /* child: Icon(
            Icons.radio_button_off_outlined,
            color: Colors.black,
            size: 20.0,
          ), */
            ),
          );
          break;
      }
      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: 1.5,
          color: Colors.black,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(Expanded(
        child: Text(text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
            )),
      ));
    });
    return list;
  }
}



/* GroupListView(
                  sectionsCount: finalitems.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return finalitems.values.toList()[section].length;
                  },
                  itemBuilder: _itemBuilder,
                  groupHeaderBuilder: (BuildContext context, int section) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              finalitems.keys.toList()[section],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Text(
                              "${finalitems.values.toList()[section].length}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  sectionSeparatorBuilder: (context, section) =>
                      SizedBox(height: 10),
                ), */
               /*  Widget _itemBuilder(BuildContext context, IndexPath index) {
    finalitems.forEach(
      (key, value) {
        print(value[index.section]["ID"]);
      },
    );
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RowComponent(TextConstants.check_status_id,
            finalitems.values.toList()[index.section][index.index]["ID"]),
        Line(),
        RowComponent(
            TextConstants.check_status_category_name,
            finalitems.values.toList()[index.section][index.index]
                ["Category Name"]),
        Line(),
        RowComponent(
            TextConstants.check_status_subcategory_name,
            finalitems.values.toList()[index.section][index.index]
                ["Subcategory Name"]),
        Line(),
        RowComponent(
            TextConstants.check_status_time_stamp,
            finalitems.values.toList()[index.section][index.index]
                ["Time stamp"]),
        Line(),
        RowComponent(
            TextConstants.check_status_assigned_to,
            finalitems.values.toList()[index.section][index.index]
                ["Assigned to"]),
        Line(),
        RowComponent(TextConstants.check_status_status,
            finalitems.values.toList()[index.section][index.index]["Status"]),
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
    ));
  } */
/*  Column(
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
                                                  color: Colors.black, _viewGrievances,
                                                  
                                                  
                                                  ),
                                                  
                                            ],
                                          ), */