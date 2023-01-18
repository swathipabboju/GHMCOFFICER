class InsertGrievanceRequest {
  String? userid;
  String? password;
  String? remarks;
  String? photo;
  String? photo1;
  String? photo2;
  String? latlon;
  String? mobileno;
  String? deviceid;
  String? compType;
  String? landmark;
  String? username;
  String? ward;
  String? source;
  String? empid;
  String? agentid;

  InsertGrievanceRequest(
      {this.userid,
      this.password,
      this.remarks,
      this.photo,
      this.photo1,
      this.photo2,
      this.latlon,
      this.mobileno,
      this.deviceid,
      this.compType,
      this.landmark,
      this.username,
      this.ward,
      this.source,
      this.empid,
      this.agentid});

  InsertGrievanceRequest.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    password = json['password'];
    remarks = json['remarks'];
    photo = json['photo'];
    photo1 = json['photo1'];
    photo2 = json['photo2'];
    latlon = json['latlon'];
    mobileno = json['mobileno'];
    deviceid = json['deviceid'];
    compType = json['compType'];
    landmark = json['landmark'];
    username = json['username'];
    ward = json['ward'];
    source = json['source'];
    empid = json['empid'];
    agentid = json['agentid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['password'] = this.password;
    data['remarks'] = this.remarks;
    data['photo'] = this.photo;
    data['photo1'] = this.photo1;
    data['photo2'] = this.photo2;
    data['latlon'] = this.latlon;
    data['mobileno'] = this.mobileno;
    data['deviceid'] = this.deviceid;
    data['compType'] = this.compType;
    data['landmark'] = this.landmark;
    data['username'] = this.username;
    data['ward'] = this.ward;
    data['source'] = this.source;
    data['empid'] = this.empid;
    data['agentid'] = this.agentid;
    return data;
  }
}
