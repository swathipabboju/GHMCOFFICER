/* import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmc_officer/Model/history_response.dart';
import 'package:ghmc_officer/Model/shared_model.dart';
import 'package:ghmc_officer/Res/components/appbar.dart';
import 'package:ghmc_officer/Res/components/background_image.dart';
import 'package:ghmc_officer/Res/components/sharedpreference.dart';
import 'package:ghmc_officer/Res/constants/Images/image_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCommentsScreen extends StatefulWidget {
  ViewCommentsScreen({
    super.key,
  });

  //bool errorFoundInImageLoad = false;

  @override
  State<ViewCommentsScreen> createState() => _ViewCommentsScreenState();
}

class _ViewCommentsScreenState extends State<ViewCommentsScreen> {
  //ViewCommentsModel? _viewCommentsModel;
  GrievanceHistoryResponse? grievanceHistoryResponse;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        ReusableAppbar(
          topPadding: 25,
          screenWidth: 1,
          screenHeight: 0.06,
          bgColor: Colors.white,
          appIcon: Icon(Icons.arrow_back),
          title: "View Comments",
          fontSize: 80.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ListView.builder(
              itemCount: grievanceHistoryResponse?.comments?.length,
              itemBuilder: ((context, index) {
                var item = grievanceHistoryResponse?.comments?[index];
                return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black87, width: 1),
                        ),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            RowComponent(
                              "PostedBy",
                              item?.cuserName,
                            ),
                            RowComponent(
                             "ID",
                              item?.cid,
                            ),
                            RowComponent(
                              "Status",
                              item?.cstatus,
                            ),
                            
                            RowComponent(
                              "Time Stamp",
                              item?.ctimeStamp,
                            ),
                            RowComponent(
                              "Remarks",
                              item?.cremarks,
                            ),
                            RowComponents(
                              "Mobile",
                              item?.cmobileno,
                              ico: IconButton(
                                onPressed: (){
                                  launch("tel:${item?.cmobileno}");
                              }, icon: Icon(
                                Icons.call,
                                color: Color.fromARGB(255, 40, 133, 43),
                                ))
                              
                            ),
                          ],
                        ),
                        );
              })),
        ),
      ],
    );
  }

  RowComponent(var data, var value) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  RowComponents(var data, var value, {IconButton? ico}) {
     //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
         Expanded(
            flex: 1,
           child: Container(child: ico),
          ),
          
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    var compid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.historydetails);
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.uid);
    const url =
        "https://19cghmc.cgg.gov.in/myghmcwebapi/Grievance/viewGrievanceHistory1";
    final pload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "compId": compid,
      "Uid": uid
    };
    final _dioObject = Dio();
    try {
      final _response = await _dioObject.post(url, data: pload);

      print(_response.data);
      final data = GrievanceHistoryResponse.fromJson(_response.data);
      if (data.comments == null) {
        print("no comments");
      } else {
        setState(() {
          grievanceHistoryResponse = data;
        });
        await EasyLoading.dismiss();

        //var len = _viewCommentsModel?.comments?.length;
        /*   print(_viewCommentsModel?.comments?.length);
        print(_viewCommentsModel?.comments?[0].cid); */

        /*  for (var i = 0; i < len!.toInt(); i++) {
          print(_viewCommentsModel?.comments?[i].toJson());
          commentsList.add(_viewCommentsModel?.comments![0]);
        } */
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  /*  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    } */
}
/*  Future<void> dialNumber(
      {required String phoneNumber, required BuildContext context}) async {
    final url = "tel:7995490649";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //ShowSnackBar.showSnackBar(context, "Unable to call $phoneNumber");
    }

    return;
  } */
 */
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/history_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCommentsScreen extends StatefulWidget {
  const ViewCommentsScreen({super.key});

  @override
  State<ViewCommentsScreen> createState() => _ViewCommentsScreenState();
}

class _ViewCommentsScreenState extends State<ViewCommentsScreen> {
  GrievanceHistoryResponse? grievanceHistoryResponse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          TextConstants.view,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          BgImage(imgPath: ImageConstants.bg),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
                itemCount: grievanceHistoryResponse?.comments?.length ?? 0,
                itemBuilder: ((context, index) {
                  var item = grievanceHistoryResponse?.comments?[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black87, width: 1),
                    ),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        RowComponent(
                          "PostedBy",
                          item?.cuserName,
                        ),
                        RowComponent(
                          "ID",
                          item?.cid,
                        ),
                        RowComponent(
                          "Status",
                          item?.cstatus,
                        ),
                        RowComponent(
                          "Time Stamp",
                          item?.ctimeStamp,
                        ),
                        RowComponent(
                          "Remarks",
                          item?.cremarks,
                        ),
                        RowComponents("Mobile", item?.cmobileno,
                            ico: IconButton(
                                onPressed: () {
                                  launch("tel:${item?.cmobileno}");
                                },
                                icon: Icon(
                                  Icons.call,
                                  color: Color.fromARGB(255, 40, 133, 43),
                                ))),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network(
                            "${item?.cphoto}",
                            height: 100.0,
                            width: 100.0,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                ImageConstants.ghmc_logo_new,
                                width: 200.0,
                                height: 100.0,
                                );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }

  setImage(_backgroundImage, {void Function()? onTap}) {
    if (_backgroundImage.contains('.pdf')) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Image.asset(
            ImageConstants.viewpdf,
            width: 80,
            height: 50,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Image.asset(
            ImageConstants.viewimage,
            width: 80,
            height: 60,
          ),
        ),
      );
    }
  }

  RowComponent(var data, var value) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  RowComponents(var data, var value, {IconButton? ico}) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(child: ico),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    var compid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.historydetails);
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.uid);
    const url = ApiConstants.baseurl + ApiConstants.history_endpoint;
    final pload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "compId": compid,
      "Uid": uid
    };
    final _dioObject = Dio();
    try {
      final _response = await _dioObject.post(url, data: pload);

      final data = GrievanceHistoryResponse.fromJson(_response.data);

      setState(() {
        if (data.status == "success") {
          EasyLoading.dismiss();
          if (data.comments != null) {
            grievanceHistoryResponse = data;
          }
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }
}
