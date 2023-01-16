
import 'package:flutter/material.dart';
import 'package:ghmcofficerslogin/model/grievance_details_response.dart';

import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';

import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
class CheckstatusComments extends StatefulWidget {
  const CheckstatusComments({super.key});

  @override
  State<CheckstatusComments> createState() => _CheckstatusCommentsState();
}

class _CheckstatusCommentsState extends State<CheckstatusComments> {
  GrievanceDetailsResponse? _detailsResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Comments")),
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        /*  ListView.builder(
            itemCount: _detailsResponse?.comments?.length ?? 0,
            itemBuilder: ((context, index) {
              if (_detailsResponse?.comments?[index].flag == "fail") {
                return showAlert();
              } else {
                return Card(
                  child: Text("${_detailsResponse?.comments?[index].cdid}"),
                );
              }
            })) */
      ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showAlert("No Records found");
    });
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
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.grivancedetails));
                },
                child: Text(
                  TextConstants.ok,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        }); //showDialog
  }
}
