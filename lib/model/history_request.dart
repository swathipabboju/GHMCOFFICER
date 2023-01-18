class GrievanceHistoryRequest {
  String? userid;
  String? password;
  String? compId;
  String? uid;

  GrievanceHistoryRequest({this.userid, this.password, this.compId, this.uid});

  GrievanceHistoryRequest.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    password = json['password'];
    compId = json['compId'];
    uid = json['Uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['password'] = this.password;
    data['compId'] = this.compId;
    data['Uid'] = this.uid;
    return data;
  }
}
