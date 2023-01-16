class RequestByAmohRequest {
  String? eMPLOYEEID;
  String? dEVICEID;
  String? tOKENID;

  RequestByAmohRequest({this.eMPLOYEEID, this.dEVICEID, this.tOKENID});

  RequestByAmohRequest.fromJson(Map<String, dynamic> json) {
    eMPLOYEEID = json['EMPLOYEE_ID'];
    dEVICEID = json['DEVICEID'];
    tOKENID = json['TOKEN_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['DEVICEID'] = this.dEVICEID;
    data['TOKEN_ID'] = this.tOKENID;
    return data;
  }
}
