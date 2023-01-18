import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/model/concessioner/c_manual_closing_ticktes_submit_res.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/button.dart';
import 'package:ghmcofficerslogin/res/components/showalert.dart';
import 'package:ghmcofficerslogin/res/components/showtoast.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

import 'package:intl/intl.dart';

import '../../res/components/sharedpreference.dart';

class ConcessionaireInchargeManualClosingTickets extends StatefulWidget {
  const ConcessionaireInchargeManualClosingTickets({super.key});

  @override
  State<ConcessionaireInchargeManualClosingTickets> createState() =>
      _ConcessionaireInchargeManualClosingTicketsState();
}

class _ConcessionaireInchargeManualClosingTicketsState
    extends State<ConcessionaireInchargeManualClosingTickets> {
  TextEditingController remarks = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();
  List<String>? ticketslist;
  CManualClosingTicketsSubmitRes? _cManualClosingTicketsSubmitRes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (() {
              Navigator.of(context).pop();
            })
            //() => Navigator.of(context).pop(),
            ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Concenssionaire Incharge Manual Closing \nTickets",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        SingleChildScrollView(
          child: Column(
            children: [
              RowComponent(
                  TextConstants.concessionaire_pickup_capturelist_ticketID,
                  AppConstants
                      .concessionaireInchargeManualClosingTicketlist?.tICKETID),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_currentdate,
                  DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now())),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_zone,
                  AppConstants
                      .concessionaireInchargeManualClosingTicketlist?.zONENAME),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_circle,
                  AppConstants.concessionaireInchargeManualClosingTicketlist
                      ?.cIRCLENAME),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_ward,
                  AppConstants
                      .concessionaireInchargeManualClosingTicketlist?.wARDNAME),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_locatio,
                  AppConstants
                      .concessionaireInchargeManualClosingTicketlist?.lOCATION),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_createddate,
                  AppConstants.concessionaireInchargeManualClosingTicketlist
                      ?.cREATEDDATE),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_typeofwaste,
                  AppConstants.concessionaireInchargeManualClosingTicketlist
                      ?.tYPEOFWASTE),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_status,
                  AppConstants
                      .concessionaireInchargeManualClosingTicketlist?.sTATUS),
              RowComponent(
                  TextConstants
                      .concenssionaire_incharge_manual_closing_tcikets_image,
                  ""),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(
                      "${AppConstants.concessionaireInchargeManualClosingTicketlist?.iMAGE1PATH}",
                      height: 100.0,
                      width: 100.0, errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImageConstants.no_uploaded,
                      width: 200.0,
                      height: 100.0,
                    );
                  })),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          fontSize: 18.0),
                      labelText: TextConstants
                          .concenssionaire_incharge_manual_closing_tcikets_remarks,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Card(
                  color: Colors.transparent,
                  child: textButton(
                    text: TextConstants.concessionaire_pickup_capture_submit,
                    textcolor: Colors.white,
                    onPressed: () {
                      if (remarks.text.isEmpty) {
                        ShowToats.showToast("Please enter remarks");
                      } else {
                        submitservice();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(AppConstants.concessionaireInchargeManualClosingTicketlist?.cIRCLEID);
  }

  submitservice() async {
    var empid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    var tokenid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.tokenId);
    final url = ApiConstants.cndw_baseurl +
        ApiConstants.c_incharge_manual_closing_tickets_submit;
    final payload = {
      "CNDW_GRIEVANCE_ID":
          AppConstants.concessionaireInchargeManualClosingTicketlist?.tICKETID,
      "EMPLOYEE_ID": empid,
      "DEVICEID": "5ed6cd80c2bf361b",
      "TOKEN_ID": tokenid,
      "IS_PENDING": "",
      "REMARKS": remarks.text
    };
    print(payload);
    final _dioobject = Dio();
    final response = await _dioobject.post(url, data: payload);
    print(response.data);
    final data = CManualClosingTicketsSubmitRes.fromJson(response.data);
    if (data.sTATUSCODE == "200") {
      _cManualClosingTicketsSubmitRes = data;
      Alerts.showAlertDialog(
          context, _cManualClosingTicketsSubmitRes?.sTATUSMESSAGE,
          Title: "GHMC Officer App", buttoncolor: Colors.green, onpressed: () {
        Navigator.popUntil(
            context,
            ModalRoute.withName(
                AppRoutes.concessionaireinchargemanualclosingticketslist));
      }, buttontext: 'ok');
    } else if (data.sTATUSCODE == "400") {
      _cManualClosingTicketsSubmitRes = data;
      Alerts.showAlertDialog(
          context, _cManualClosingTicketsSubmitRes?.sTATUSMESSAGE,
          Title: "GHMC Officer App",
          buttoncolor: Color.fromARGB(255, 167, 42, 34), onpressed: () {
        Navigator.popUntil(
            context,
            ModalRoute.withName(
                AppRoutes.concessionaireinchargemanualclosingticketslist));
      }, buttontext: 'ok');
    } else if (data.sTATUSCODE == "600") {}
  }

  RowComponent(var data, var val) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                textcolor: Colors.white,
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
                textcolor: Colors.white,
              ))
        ],
      ),
    );
  }

  validate(String remarks) {
    if (remarks.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
