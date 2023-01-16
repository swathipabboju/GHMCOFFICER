class ConcessionairePickupCaptureBindPlantNameReq {
  String? uSERID;
  String? pASSWORD;

  ConcessionairePickupCaptureBindPlantNameReq({this.uSERID, this.pASSWORD});

  ConcessionairePickupCaptureBindPlantNameReq.fromJson(Map<String, dynamic> json) {
    uSERID = json['USER_ID'];
    pASSWORD = json['PASSWORD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['USER_ID'] = this.uSERID;
    data['PASSWORD'] = this.pASSWORD;
    return data;
  }
}
