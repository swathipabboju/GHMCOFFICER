import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghmcofficerslogin/model/where_am_i_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

class CustomInfoWindowExample extends StatefulWidget {
  @override
  _CustomInfoWindowExampleState createState() =>
      _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final LatLng _latLng = LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;

  WhereAmIResponse? whereAmIResponse;

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId("marker_id"),
        position: _latLng,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Image.asset(ImageConstants.ghmc_logo_new,
                          height: 25.0,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row( 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ward:",
                               style: TextStyle(
                                fontSize: 8.0,
                                color: Colors.red
                              ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "${whereAmIResponse?.wardName}",
                                 style: TextStyle(
                                fontSize: 8.0,
                                color: Colors.red
                              ),
                              )
                            ],
                          ),
                          Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Circle:",
                              style: TextStyle(
                                fontSize: 8.0
                              ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "${whereAmIResponse?.circlename}",
                                 style: TextStyle(
                                fontSize: 8.0
                              ),
                              )
                            ],
                          ),
                          Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Zone:",
                               style: TextStyle(
                                fontSize: 8.0
                              ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "${whereAmIResponse?.zone}",
                                 style: TextStyle(
                                fontSize: 8.0
                              ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                
              ],
            ),
            _latLng,
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
      actions: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.black),
              onPressed: () async{
                //EasyLoading.show();
                Navigator.pushNamed(context, AppRoutes.ghmcdashboard);
              },
            ),
          ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          TextConstants.locate_on_map,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 150,
            offset: 50,
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
  
   fetchDetails() async{

    const requesturl = ApiConstants.baseurl + ApiConstants.where_am_i;
    
    var requestPayload = 
    { 
      "userid": "cgg@ghmc", 
      "password": "ghmc@cgg@2018", 
      "latitude" : "17.436617", 
      "longitude" : "78.3608504" };
    
   final dioObject = Dio();
    try{
      final response = await dioObject.post(requesturl, data: requestPayload);

       final data = WhereAmIResponse.fromJson(response.data);
       print(response.data);

       setState(() {
        if (data.status == true) {
          EasyLoading.dismiss();
          whereAmIResponse = data;
        }
      });

    }on DioError catch(e)
    {

    }
   }
}