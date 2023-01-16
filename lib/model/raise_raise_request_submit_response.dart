class RaiseRequestRaiseRequestSubmitResponse {
  String? sTATUSCODE;
  String? sTATUSMESSAGE;
  String? cNDWGRIEVANCEID;

  RaiseRequestRaiseRequestSubmitResponse(
      {this.sTATUSCODE, this.sTATUSMESSAGE, this.cNDWGRIEVANCEID});

  RaiseRequestRaiseRequestSubmitResponse.fromJson(Map<String, dynamic> json) {
    sTATUSCODE = json['STATUS_CODE'];
    sTATUSMESSAGE = json['STATUS_MESSAGE'];
    cNDWGRIEVANCEID = json['CNDW_GRIEVANCE_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS_CODE'] = this.sTATUSCODE;
    data['STATUS_MESSAGE'] = this.sTATUSMESSAGE;
    data['CNDW_GRIEVANCE_ID'] = this.cNDWGRIEVANCEID;
    return data;
  }
}
