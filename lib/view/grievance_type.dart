import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/raise_grievance_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';

class RaiseGrievance extends StatefulWidget {
  const RaiseGrievance({super.key});

  @override
  State<RaiseGrievance> createState() => _RaiseGrievanceState();
}

class _RaiseGrievanceState extends State<RaiseGrievance> {
  raiseGrievanceResponse? _grievanceResponse;
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
              "Grievance Types",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Stack(
          children: [
            BgImage(imgPath: ImageConstants.bg),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    itemCount: _grievanceResponse?.rOW?.length ?? 0,
                    itemBuilder: (context, index) {
                      final data = _grievanceResponse?.rOW?[index];
                      return GestureDetector(
                        onTap: () async {
                          EasyLoading.show();
                          await SharedPreferencesClass().writeTheData(
                              PreferenceConstants.grievance_type,
                              data?.gRIEVANCEID);
                          Navigator.pushNamed(context, AppRoutes.newcomplaint);
                        },
                        child: Column(
                          children: [
                            Image.network(
                              "${data?.iURL}",
                              height: 50,
                            ),
                            // SizedBox(
                            //   height: 5.0,
                            // ),
                            Text(
                              "${data?.cNAME}",
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
          ],
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
        ));
  }

  @override
  void initState() {
    super.initState();
    raiseGrievanceDetails();
  }

  raiseGrievanceDetails() async {
    var no = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.mobileno);
    print("number ${no}");
    final raise_grievance_url =
        ApiConstants.baseurl + ApiConstants.raise_grievance_endpoint;
    final raise_grievance_payload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018"
    };
    final dio_obj = Dio();
    try {
      final raise_grievance_response = await dio_obj.post(raise_grievance_url,
          data: raise_grievance_payload);
      print(raise_grievance_response.data);
      final data =
          raiseGrievanceResponse.fromJson(raise_grievance_response.data);
      setState(() {
        if (data.rOW != null) {
          EasyLoading.dismiss();
          _grievanceResponse = data;
        }
      });
      print(_grievanceResponse?.tag);
    } on DioError catch (e) {
      print(e);
    }
  }
}

      /* body: Stack(
        children: [
          BgImage(imgPath: ImageConstants.bg),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: GridView.builder(
                  itemCount: _grievanceResponse?.rOW?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data = _grievanceResponse?.rOW?[index];
                    return GestureDetector(
                      onTap: () {

                      },
                      child: Column(
                        children: [
                          Image.network("${data?.iURL}",
                          height: 50,
                          ),
                          // SizedBox(
                          //   height: 5.0,
                          // ),
                          Text(
                            "${data?.cNAME}",
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
          
        ],
      ),
       bottomSheet: Container(
        decoration: BoxDecoration(
         color: Colors.transparent
        ),
        padding: EdgeInsets.all(6.0),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rights Reserved@GHMC",
            style: TextStyle(
              color: Colors.white
            ),
            ),
            Text("Powered By CGG",
            style: TextStyle(
              color: Colors.white
            ),
            ),
          ],
      ),
       )  */
      
  
 

  


