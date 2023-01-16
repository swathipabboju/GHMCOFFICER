import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/plant_operator/get_plant_operator_response.dart';
import 'package:ghmcofficerslogin/model/plant_operator/get_plant_operator_trip_req.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/logo_details.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/cnd_api_constant.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import '../../res/components/sharedpreference.dart';
import '../../res/constants/Images/image_constants.dart';

class PlantOperatorDashboardScreen extends StatefulWidget {
  const PlantOperatorDashboardScreen({super.key});

  @override
  State<PlantOperatorDashboardScreen> createState() =>
      _PlantOperatorDashboardScreen();
}

class _PlantOperatorDashboardScreen
    extends State<PlantOperatorDashboardScreen> {
  GetPlantOperatorVehicleTripResponse? getPlantOperatorVehicleTripResponse;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
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
                Column(
                  children: [
                    listCardWidget(
                        text1: 'Vehicle Trips At Plant',
                        text2: (getPlantOperatorVehicleTripResponse
                                ?.operatorVehicleList?.length)
                            .toString(),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.plantoperatorlist);
                        }),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget listCardWidget(
      {required String text1, required text2, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black87, width: 1),
        ),
        color: Colors.transparent,
        margin: const EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text1,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                text2,
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchplantOperatorDetails();
  }

  fetchplantOperatorDetails() async {
    var tokenid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    var empid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    const requestUrl =
        CndApiConstants.cndbaseurl + CndApiConstants.getOperatorVehicleTrip;
    GetPlantOperatorVehicleTripReq getPlantOperatorVehicleTripReq =
        new GetPlantOperatorVehicleTripReq();
    getPlantOperatorVehicleTripReq.tOKENID = tokenid;
    getPlantOperatorVehicleTripReq.dEVICEID = "5ed6cd80c2bf361b";
    getPlantOperatorVehicleTripReq.eMPLOYEEID = empid;

    final requestPayload = getPlantOperatorVehicleTripReq.toJson();
    print(requestPayload);
    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requestUrl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = GetPlantOperatorVehicleTripResponse.fromJson(response.data);
      print(response.data);
      setState(() {
        if (data.sTATUSCODE == "200") {
          EasyLoading.dismiss();
          if (data.operatorVehicleList != null) {
            print(data.operatorVehicleList);
            getPlantOperatorVehicleTripResponse = data;
            AppConstants.vehicleList = data.operatorVehicleList;
          }
        }
      });
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
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
              'AMOH Dashboard',
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
