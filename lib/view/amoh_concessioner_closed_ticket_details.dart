import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/button.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';



class AmohCCloseTicketDetails extends StatefulWidget {
  const AmohCCloseTicketDetails({super.key});

  @override
  State<AmohCCloseTicketDetails> createState() => _AmohCCloseTicketDetails();
}

class _AmohCCloseTicketDetails extends State<AmohCCloseTicketDetails> {
  FocusNode myFocusNode = new FocusNode();
  TextEditingController remarks = new TextEditingController();
  String? reason;
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
            " Concessionaire Close Ticket Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),  
      ),
      body: Stack(children: [
        BgImage(imgPath: ImageConstants.bg),
        Container(
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      RowComponent(
                        TextConstants.amoh_c_closed_ticket_details_ticketid,
                        AppConstants.amoh_closedticketlist?.tICKETID,
                      ),
                      RowComponent(
                        TextConstants
                            .amoh_c_closed_ticket_details_ticketraiseddate,
                        AppConstants.amoh_closedticketlist?.tICKETRAISEDDATE,
                      ),
                      RowComponent(
                        TextConstants
                            .amoh_c_closed_ticket_details_ticketcloseddate,
                        AppConstants.amoh_closedticketlist?.tICKETCLOSEDDATE,
                      ),
                      RowComponent(
                        TextConstants.amoh_c_closed_ticket_details_zone,
                        AppConstants.amoh_closedticketlist?.zONENAME,
                      ),
                      RowComponent(
                        TextConstants.amoh_c_closed_ticket_details_circle,
                        AppConstants.amoh_closedticketlist?.cIRCLENAME,
                      ),
                      RowComponent(
                        TextConstants.amoh_c_closed_ticket_details_ward,
                        AppConstants.amoh_closedticketlist?.wARDNAME,
                      ),
                      RowComponent(
                        TextConstants.amoh_c_closed_ticket_details_loaction,
                        AppConstants.amoh_closedticketlist?.lOCATION,
                      ),
                      RowComponent(
                        TextConstants.amoh_c_closed_ticket_details_inchargename,
                        AppConstants.amoh_closedticketlist?.cONCESSIONERNAME,
                      ),
                      RowComponent(
                        TextConstants
                            .amoh_c_closed_ticket_details_Type_of_waste,
                        AppConstants.amoh_closedticketlist?.tYPEOFWASTE,
                      ),
                      RowComponent(
                          TextConstants
                              .amoh_c_closed_ticket_details_No_of_trips,
                          ""),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: AppConstants
                              .amoh_closedticketlist?.listVehicles?.length,
                          itemBuilder: ((context, index) {
                            final details = AppConstants
                                .amoh_closedticketlist?.listVehicles?[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  /*  side: BorderSide(
                                              color: Colors.black87, width: 1), */
                                  ),
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    VehicleRowComponent(
                                      TextConstants
                                          .amoh_c_closed_ticket_vehicleno,
                                      details?.vEHICLENO,
                                    ),
                                    VehicleRowComponent(
                                      TextConstants
                                          .amoh_c_closed_ticket_vehicleid,
                                      details?.vEHICLEID,
                                    ),
                                    VehicleRowComponent(
                                      TextConstants
                                          .amoh_c_closed_ticket_drivername,
                                      details?.dRIVERNAME,
                                    ),
                                    VehicleRowComponent(
                                      TextConstants.amoh_c_closed_ticket_driverno,
                                      details?.dRIVERMOBILENUMBER,
                                    ),
                                    //
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 15.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              TextConstants
                                                  .amoh_c_closed_ticket_beforetrip
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              TextConstants
                                                  .amoh_closed_ticket_aftertrip
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Image.network(
                                              "${details?.bEFORETRIPIMAGE}",
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
                                          Expanded(
                                            flex: 2,
                                            child: Image.network(
                                              "${details?.aFTERTRIPIMAGE}",
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
                                  ],
                                ),
                              ),
                            );
                          })),
                    ),
                  )),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Do you want to",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: RadioListTile(
                          title: Text("Re Assign",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                          value: "Re Assign",
                          groupValue: reason,
                          onChanged: (value) {
                            setState(() {
                              reason = value.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: RadioListTile(
                          title: Text("Close",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                          value: "Close",
                          groupValue: reason,
                          onChanged: (value) {
                            setState(() {
                              reason = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        focusNode: myFocusNode,
                        controller: remarks,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        cursorColor: Color.fromARGB(255, 33, 184, 166),
                        decoration: InputDecoration(
                          //to hide maxlength
                          counterText: '',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 33, 184, 166),
                          )),
                  
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
                                  ? Color.fromARGB(255, 33, 184, 166)
                                  : Colors.white,
                              fontSize: 15.0),
                          labelText: TextConstants
                              .concenssionaire_incharge_manual_closing_tickets_remarks,
                        ),
                      ),
                    ),
                  ),
                 
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Card(
                      color: Colors.transparent,
                      child: textButton(
                        text:
                            TextConstants.concessionaire_pickup_capture_submit,
                        textcolor: Colors.white,
                        onPressed: () {
                          if (remarks.text.isEmpty) {
                            showToast("Please enter remarks");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rights Reserved @ GHMC",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Powered By CGG",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  VehicleRowComponent(var data, var value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.black,
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

  RowComponent(var data, var value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
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
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
