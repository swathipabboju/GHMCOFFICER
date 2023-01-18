import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/history_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';


class NewViewComments extends StatefulWidget {
  const NewViewComments({super.key});

  @override
  State<NewViewComments> createState() => _NewViewCommentsState();
}

class _NewViewCommentsState extends State<NewViewComments> {
  GrievanceHistoryResponse? grievanceHistoryResponse;
  List<Comments>? list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          TextConstants.view,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),

       ListView.builder(itemCount: grievanceHistoryResponse?.comments?.length,itemBuilder: ((context, index) {
      //  var item = grievanceHistoryResponse?.comments?[index];
         return  Text("data");/* Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black87, width: 1),
                    ),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        RowComponent(
                          "PostedBy",
                          item?.cuserName,
                        ),
                        /* RowComponent(
                          "ID",
                          item?.cid,
                        ),
                        RowComponent(
                          "Status",
                          item?.cstatus,
                        ),
                        RowComponent(
                          "Time Stamp",
                          item?.ctimeStamp,
                        ),
                        RowComponent(
                          "Remarks",
                          item?.cremarks,
                        ),
                        RowComponents("Mobile", item?.cmobileno,
                            ico: IconButton(
                                onPressed: () {
                                  launch("tel:${item?.cmobileno}");
                                },
                                icon: Icon(
                                  Icons.call,
                                  color: Color.fromARGB(255, 40, 133, 43),
                                ))),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network(
                            "${item?.cphoto}",
                            height: 100.0,
                            width: 100.0,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                ImageConstants.ghmc_logo_new,
                                width: 200.0,
                                height: 100.0,
                                );
                            },
                          ),
                        ), */
                      ],
                    ),
                  ); */
       }))

      ],),);
  }
  RowComponent(var data, var value) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetails();
  }
  void fetchDetails() async {
    var compid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.historydetails);
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.uid);
    const url = ApiConstants.baseurl + ApiConstants.history_endpoint;
    final pload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "compId": compid,
      "Uid": uid
    };
    final _dioObject = Dio();
    try {
      final _response = await _dioObject.post(url, data: pload);

      final data = GrievanceHistoryResponse.fromJson(_response.data);

      setState(() {
        if (data.status == "success") {
          EasyLoading.dismiss();
          if (data.comments != null) {
             grievanceHistoryResponse = data;
          }
        }
      });
      print(_response.data);
    } on DioError catch (e) {
      print(e);
    }
  }
}