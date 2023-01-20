import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/corporator/corporator_report_req.dart';
import 'package:ghmcofficerslogin/model/corporator/corporator_report_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/button.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

import 'package:ghmcofficerslogin/view/image_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../res/components/datepicker.dart';

class CorporatorViewDoc extends StatefulWidget {
  const CorporatorViewDoc({super.key});

  @override
  State<CorporatorViewDoc> createState() => _CorporatorViewDocState();
}

class _CorporatorViewDocState extends State<CorporatorViewDoc> {
  CorporatorReportResponse? _corporatorReportResponse;

  TextEditingController _dateController = TextEditingController();
  bool date = false;
  //var _selectedDate;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  FocusNode myFocusNode = new FocusNode();
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
          child: Text(
            "Reports",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: TextWidget(
                          text: "Date",
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          textcolor: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null) {
                              initializeDateFormatting('es');
                              String formattedDate =
                                  DateFormat.yMd('es').format(selectedDate);
                              print("formatted date ${formattedDate}");
                              //DateFormat('dd/MM/yyyy').format(selectedDate);
                              setState(() {
                                _dateController.text = formattedDate;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.blueAccent,
                          ),
                        )),
                        controller: _dateController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Card(
                  color: Colors.transparent,
                  child: textButton(
                      text: TextConstants.exportpdf,
                      textcolor: Colors.white,
                      onPressed: () {
                        getCorporatorReportDetails();
                        print(
                            "filepath: ${_corporatorReportResponse?.filePath}");
                        //(_corporatorReportResponse!.filePath!.contains('.pdf'))
                        //_pdfViewerKey.currentState?.openBookmarkView();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewPage(
                                      filePath:
                                          "${_corporatorReportResponse?.filePath}",
                                    )));
                      }),
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
    getCorporatorReportDetails();
  }

  void getCorporatorReportDetails() async {
    var menuId =
        await SharedPreferencesClass().readTheData(PreferenceConstants.menuId);
    var ward =
        await SharedPreferencesClass().readTheData(PreferenceConstants.ward);
    var type =
        await SharedPreferencesClass().readTheData(PreferenceConstants.type);

    //creating request url with base url and endpoint
    // https: //19cghmc.cgg.gov.in/myghmcwebapi/Grievance/CorporatorList
    const requesturl = ApiConstants.baseurl + ApiConstants.corporatorReport;

    //creating payload because request type is POST
    CorporatorReportRequest corporatorReportRequest =
        new CorporatorReportRequest();

    corporatorReportRequest.fROMDATE = _dateController.text;
    corporatorReportRequest.tODATE = _dateController.text;
    corporatorReportRequest.mENUID = menuId;
    corporatorReportRequest.wARD = ward;
    corporatorReportRequest.tYPE = type;
    var requestPayload = corporatorReportRequest.toJson();

    print(requestPayload);

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
      final data = CorporatorReportResponse.fromJson(response.data);
      print(response.data);

      setState(() {
        if (data.status == "sucess") {
          _corporatorReportResponse = data;
          print("file ====== ${_corporatorReportResponse?.filePath}");
        } else {
          showAlert("${data.status}");
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
                  Navigator.popUntil(context,
                      ModalRoute.withName(AppRoutes.corporatordashboard));
                },
                child: Text(TextConstants.ok),
                //style: ButtonStyle(backgroundColor,
              )
            ],
          );
        }); //showDialog
  } //
}
