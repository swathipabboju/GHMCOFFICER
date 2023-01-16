import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/request_by_amoh_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';


class RequestByAmohList extends StatefulWidget {
  const RequestByAmohList({super.key});

  @override
  State<RequestByAmohList> createState() =>
      _RequestByAmohListState();
}

class _RequestByAmohListState
    extends State<RequestByAmohList> {
  RequestByAmohResponse? requestByAmohResponse;

  List<CitizenList> _requestByAmohListResponse = [];
  List<CitizenList> _requestByAmohSearchListResponse = [];
 
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
                Navigator.pushNamed(context, AppRoutes.consructiondemolitionwaste);
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
              "No of Requests by AMOH",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
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
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                          itemCount: _requestByAmohSearchListResponse.length,
                          itemBuilder: (context, index) {
                            final details = _requestByAmohSearchListResponse[index];
                                
                            return GestureDetector(
                              onTap: () async {
                                /*  await SharedPreferencesClass().writeTheData(
                                  PreferenceConstants.historydetails, details.id); */
                                //print(details?.id);
                                //EasyLoading.show();
                                /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GrievanceHistory(),
                                  )); */
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black87, width: 1),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Column(
                                      children: [
                                        RowComponent(
                                          TextConstants
                                              .ticketid,
                                          details.tICKETID,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .dateandtime,
                                          details.cREATEDDATE,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .location,
                                          details.lOCATION,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .estimatedweight,
                                          details.eSTWT,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .status,
                                          details.sTATUS,
                                        ),
                                        Line(),
                                        RowComponent(
                                          TextConstants
                                              .paymentstatus,
                                          details.pAYMENTSTATUS,
                                        ),
                                        Line(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8.0),
                                          child: Image.network(
                                            "${details.iMAGE1PATH}",
                                            height: 100.0,
                                            width: 100.0,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                ImageConstants.no_uploaded,
                                                height: 100.0,
                                                width: 100.0,
                                                ); 
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
              ],
            ),
          ],
        ));
  }

  Line() {
    return Divider(
      thickness: 1.0,
      color: Colors.grey,
    );
  }

  

  showAlertImage(String? photo) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            actions: [
              Center(
                  child: Container(
                      child: Image.network(
                photo!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(ImageConstants.no_uploaded);
                },
              ))),
            ],
          );
        });
  }

  RowComponent(var data, var value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Color.fromARGB(255, 125, 120, 120),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  _runFilter(String enteredKeyword) {
    List<CitizenList> results = [];
    if (enteredKeyword.isEmpty) {
      results = _requestByAmohListResponse;
    } else {
      print(enteredKeyword);
      results = _requestByAmohListResponse
          .where((element) =>
              element.tICKETID!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        _requestByAmohSearchListResponse = results;
        //print(_fullGrievancesSearchListResponse.length);
      });
    }
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
  }
  
  getdetails() async {
    var tokenid = await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    var empid = await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    const requestUrl =
        ApiConstants.cndw_baseurl + ApiConstants.amoh_request_by_endpoint;

    final requestPayload = {
      "EMPLOYEE_ID":empid,
      "DEVICEID":"5ed6cd80c2bf361b",
      "TOKEN_ID":tokenid,
      };

    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requestUrl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = RequestByAmohResponse.fromJson(response.data);
      print(response.data);
      setState(() {
        if (data.sTATUSCODE == "200") {
          EasyLoading.dismiss();
          if (data.citizenList != null) {
            requestByAmohResponse = data;
             _requestByAmohListResponse = requestByAmohResponse!.citizenList!;
            _requestByAmohSearchListResponse = _requestByAmohListResponse;
          }
        }
        else if (data.sTATUSCODE == "600"){
          
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
            // title: Text(message + text),
            actions: [
              TextButton(
                onPressed: () {
                  print("clicked");
                  // print("button Action");
                  Navigator.pop(context);
                },
                child: Text(TextConstants.ok),
                //style: ButtonStyle(backgroundColor,
              )
            ],
          );
        }); //showDialog
  }
  
  //

}