
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghmcofficerslogin/model/where_am_i.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowExample extends StatefulWidget {
  @override
  _CustomInfoWindowExampleState createState() =>
      _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  WhereAmIModel? data;
  // final LatLng _latLng = LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;
  LatLng? _currentPosition;
  bool _isLoading = true;
  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    AppConstants.custominfowindowlat=lat;
    AppConstants.custominfowindowlong=long;

    LatLng location = LatLng(AppConstants.custominfowindowlat ?? 0.0, AppConstants.custominfowindowlong ?? 0.0);
 
    setState(() {
      _currentPosition = location;
      _isLoading = false;
      whereAmIApiCall(_currentPosition!);
    });
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
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
      body:  _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            :Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              print(position);
              _handleTap(position);
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
              target: _currentPosition!,
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 250,
            offset: 50,
          ),
        ],
      ),
      bottomSheet: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: TextButton(
                        onPressed: () {
                         Navigator.pop(context, [AppConstants.custominfowindowlat, AppConstants.custominfowindowlong]);
                        },
                        child: Text(
                          "Set Location",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
    );
    
  }

  _handleTap(LatLng point) {
   // print("fhfhfg1${point}");
    whereAmIApiCall(point);
  }

  whereAmIApiCall(LatLng Latlong) async {
    // print(double.parse(Latlong.latitude.toString()));
    //  print(Latlong.longitude.toString());
    final whereAmiUrl = ApiConstants.baseurl + ApiConstants.where_am_i;
        //"https://19cghmc.cgg.gov.in/myghmcwebapi/Grievance/WhereAmI";
    final whereami_payload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "latitude": Latlong.latitude.toString(),//17.4366511
      "longitude": Latlong.longitude.toString(),//78.3608587
    };
    print(whereAmiUrl);
    print(whereami_payload);
    final dio_obj = Dio();
    try {
      final whereami_response =
          await dio_obj.post(whereAmiUrl, data: whereami_payload);
      print("fhfhfg${whereami_response.data}");
      data = WhereAmIModel.fromJson(whereami_response.data);

       setState(() {
          _markers = {};
        print("multiple markers$_markers");
        _markers.add(Marker(
          markerId: MarkerId(Latlong.toString()),
          position: Latlong,
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
                                width: 2.0,
                              ),
                              Text(
                                "${data?.wardName}",
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
                                width: 2.0,
                              ),
                              Text(
                                "${data?.circlename}",
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
                                width: 2.0,
                              ),
                              Text(
                                "${data?.zone}",
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
            Latlong,
          );
        },
      ),
        );
      });
    } on DioError catch (e) {
      print(e);
    }
  }
}
