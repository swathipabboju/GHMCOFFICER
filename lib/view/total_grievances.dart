import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/model/user_details_response.dart';
import 'package:ghmcofficerslogin/model/user_list_response.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/logo_details.dart';
import 'package:ghmcofficerslogin/res/components/navigation.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/View/display_user_details.dart';

class MyTotalGrievances extends StatefulWidget {
  const MyTotalGrievances({super.key});

  @override
  State<MyTotalGrievances> createState() => _MyTotalGrievances();
}

class _MyTotalGrievances extends State<MyTotalGrievances> {
  GrievanceUserList? grievanceUserList;
  UserDetailsResponse? userDetailsResponse;
  TextEditingController Complaint_id = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ReusableNavigation(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                /* title: const Text("GHMC Officer App",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )), */
                collapseMode: CollapseMode.pin,
                background: SizedBox(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Image.asset(
                          ImageConstants.bg,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            child: LogoAndDetails(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            BgImage(imgPath: ImageConstants.bg),
            Container(
                child: Stack(
              children: [
                /* Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Search by Complaint Id',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.black), //<-- SEE HERE
                        ),
                        icon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ))),
                  ),

                ), 270822556445 */
                ReusableSearchbar(
                  controller: Complaint_id,
                  bgColor: Colors.white,
                  screenHeight: 0.04,
                  searchIcon: Icon(Icons.search),
                  topPadding: 10.0,
                  onPressed: () async {
                    if (Complaint_id.text.isNotEmpty) {
                      await SharedPreferencesClass().writeTheData(
                          PreferenceConstants.historydetails,
                          Complaint_id.text);
                      Navigator.pushNamed(context, AppRoutes.grievancehistory);
                    } else {
                      showAlert();
                    }
                  },
                  screenWidth: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: ListView.builder(
                    itemCount: grievanceUserList?.rOW?.length ?? 0,
                    itemBuilder: (context, index) {
                      final datalist = grievanceUserList?.rOW?[index];

                      return GestureDetector(
                        onTap: () async {
                          await SharedPreferencesClass().writeTheData(
                              PreferenceConstants.userdetails,
                              datalist?.mODEID);
                          //print(datalist?.mODEID);
                          await SharedPreferencesClass().writeTheData(
                              PreferenceConstants.cname, datalist?.cNAME);
                          EasyLoading.show();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetails()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black87, width: 1),
                          ),
                          color: Colors.transparent,
                          child: ListTile(
                            leading: Image.network(
                              "${datalist?.iURL}",
                              height: 30.0,
                            ),
                            title: Center(
                                child: Text(
                              "${datalist?.cNAME}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            )),
                            trailing: Text(
                              "${datalist?.mCOUNT}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget createDrawerItem({required String maintext}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Text(
            maintext,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    GrievanceUserDetails();
  }

  void GrievanceUserDetails() async {
    var slftype =
        await SharedPreferencesClass().readTheData(PreferenceConstants.totalid);
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    var typeid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.typeid);
    //print(uid);
    //creating request url with base url and endpoint
    const requesturl = ApiConstants.baseurl + ApiConstants.userlist_endpoint;

    //creating payload because request type is POST
    var requestPayload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "uid": uid,
      "type_id": typeid,
      "slftype": slftype
    };

    //no headers and authorization

    //creating dio object in order to connect package to server
    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requesturl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = GrievanceUserList.fromJson(response.data);
      //print(response.data);
      setState(() {
        if (data.status == "true") {
          EasyLoading.dismiss();
          if (data.rOW != null && data.rOW!.length > 0) {
            grievanceUserList = data;
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
// step 5: print the response
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              TextConstants.no_complait_id,
              style: TextStyle(fontSize: 16.0),
            ),
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
  }
}
