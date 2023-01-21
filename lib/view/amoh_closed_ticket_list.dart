import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/model/amoh_closed_ticket_list_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showalert_singlebutton.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/view/amoh_close_ticket_details.dart';


class AmohClosedTicketList extends StatefulWidget {
  const AmohClosedTicketList({super.key});

  @override
  State<AmohClosedTicketList> createState() => _AmohClosedTicketListState();
}

class _AmohClosedTicketListState extends State<AmohClosedTicketList> {
  AmohClosedTicketsListResponse? amohClosedTicketsListResponse;
  
  List<TicketList> _amohCloseTicketListResponse = [];
  List<TicketList> _amohCloseTicketSearchListResponse = [];
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
                Navigator.pushNamed(
                    context, AppRoutes.consructiondemolitionwaste);
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
              "AMOH Closed Tickets",
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
                      itemCount:
                          _amohCloseTicketSearchListResponse.length,
                      itemBuilder: (context, index) {
                        final details =
                            _amohCloseTicketSearchListResponse[index];

                        return GestureDetector(
                          onTap: () async {
                            if(amohClosedTicketsListResponse?.ticketList?[index].listVehicles != null)
                            {
                             AppConstants.amoh_close_ticket_details = amohClosedTicketsListResponse?.ticketList?[index];
                            //EasyLoading.show();
                             Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AmohCloseTicketDetails(),
                                  )); 
                            }
                            else{
                              showToast("Vehicle list data is empty");
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.black87, width: 1),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    RowComponent(
                                      TextConstants.ticketid,
                                      details.tICKETID,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants.location,
                                      details.lOCATION,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants.ticketraiseddate,
                                      details.tICKETRAISEDDATE,
                                    ),
                                    Line(),
                                    RowComponent(
                                      TextConstants.ticketcloseddate,
                                      details.tICKETCLOSEDDATE,
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
                                          return Image.asset(ImageConstants.no_uploaded,
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
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _runFilter(String enteredKeyword) {
    List<TicketList> results = [];
    if (enteredKeyword.isEmpty) {
      results = _amohCloseTicketListResponse;
    } else {
      print(enteredKeyword);
      results = _amohCloseTicketListResponse
          .where((element) =>
              element.tICKETID!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        _amohCloseTicketSearchListResponse = results;
        print(_amohCloseTicketSearchListResponse.length);
      });
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
  }

  getdetails() async {
    var tokenid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    var empid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    const requestUrl = ApiConstants.cndw_baseurl +
        ApiConstants.amoh_closed_ticket_list_endpoint;

    final requestPayload = {
      "AMOH_EMP_ID": empid,
      "AMOH_EMP_WARD_ID": "",
      "DEVICEID": "5ed6cd80c2bf361b",
      "TOKEN_ID": tokenid
    };

    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requestUrl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = AmohClosedTicketsListResponse.fromJson(response.data);
      print(response.data);
      setState(() {
        if(data != null)
        {
        if (data.sTATUSCODE == "200") {
          EasyLoading.dismiss();
          if (data.ticketList != null) {
            amohClosedTicketsListResponse = data;
            _amohCloseTicketListResponse = amohClosedTicketsListResponse!.ticketList!;
            _amohCloseTicketSearchListResponse = _amohCloseTicketListResponse;
          }
        } 
       else if(data.sTATUSCODE == "600")
        {
          EasyLoading.dismiss();
          amohClosedTicketsListResponse = data;
          showDialog(
            context: context, 
          builder:(context) {
            return SingleButtonDialogBox(
              bgColor: Color.fromARGB(255, 225, 38, 38),
              title: "GHMC OFFICER APP", 
              descriptions: "${amohClosedTicketsListResponse?.sTATUSMESSAGE}", 
              Buttontext: "Ok", 
              img: Image.asset("assets/cross.png"), 
              onPressed: (){
                  Navigator.popUntil(context, ModalRoute.withName(AppRoutes.myloginpage));
              });
          },);
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
