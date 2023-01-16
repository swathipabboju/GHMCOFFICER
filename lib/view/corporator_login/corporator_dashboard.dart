import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/corporator/corporator_list_req.dart';
import 'package:ghmcofficerslogin/model/corporator/corporator_list_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/grievance_row.dart';
import 'package:ghmcofficerslogin/res/components/logo_details.dart';
import 'package:ghmcofficerslogin/res/components/navigation.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';

import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

class CorporatorDashboard extends StatefulWidget {
  const CorporatorDashboard({super.key});

  @override
  State<CorporatorDashboard> createState() => _CorporatorDashboardState();
}

class _CorporatorDashboardState extends State<CorporatorDashboard> {
  CorporatorListResponse? corporatorListResponse;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body:NestedScrollView(headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  delegate: MySliverAppBar(expandedHeight: 200.0),
                  pinned: true,
                ),
              ];
            },
          body: Stack(
            children: [
              BgImage(imgPath: ImageConstants.bg),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: GridView.builder(
                        itemCount: corporatorListResponse?.rOW?.length ?? 0,
                        itemBuilder: (context, index) {
                          final data = corporatorListResponse?.rOW?[index];
                          return GestureDetector(
                            onTap: () async {
                             // EasyLoading.show();
                              await SharedPreferencesClass().writeTheData(
                                  PreferenceConstants.menuId,
                                  data?.iMENUID);
                                  
                              Navigator.pushNamed(context, AppRoutes.corporatorviewdoc);
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  "${data?.uRL}",
                                  height: 50,
                                ),
                                // SizedBox(
                                //   height: 5.0,
                                // ),
                                Text(
                                  "${data?.mENUNAME}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rights Reserved@GHMC",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Powered By CGG",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    corporatorListDetails();
  }

  void corporatorListDetails() async {
    var empID =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    var name =
        await SharedPreferencesClass().readTheData(PreferenceConstants.name);
    print(empID);
    print(name);
    //creating request url with base url and endpoint
    // https: //19cghmc.cgg.gov.in/myghmcwebapi/Grievance/CorporatorList
    const requesturl = ApiConstants.baseurl + ApiConstants.corporatorList;

    //creating payload because request type is POST
    CorporatorListReq corporatorListReq = new CorporatorListReq();
    print(empID);
    corporatorListReq.empid = empID;
    corporatorListReq.userid = "cgg@ghmc";
    corporatorListReq.password = "ghmc@cgg@2018";
    var requestPayload = corporatorListReq.toJson();

    //no headers and authorization

    //creating dio object in order to connect package to server
    final dioObject = Dio();

    try {
      final response = await dioObject.post(requesturl,
          data: requestPayload,
          options: Options(headers: {
            'Content-Type': "application/json",
          }));
      //converting response from String to json
      final data = CorporatorListResponse.fromJson(response.data);
      print(response.data);
    
        EasyLoading.dismiss();
        setState(() {
        if (data.rOW != null) {
        
          corporatorListResponse = data;
        }
      });
      

      
      EasyLoading.dismiss();
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
// step 5: print the response
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(TextConstants.no_grievance_available),
            // title: Text(message + text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(TextConstants.ok),
              )
            ],
          );
        }); //showDialog
  } //

}
class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              BgImage(imgPath: ImageConstants.bg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
              
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.myloginpage);
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: const Text(
              'Corporator Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 5 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: LogoAndDetails(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
