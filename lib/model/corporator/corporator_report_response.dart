class CorporatorReportResponse {
  String? filePath;
  String? status;
  String? fileName;

  CorporatorReportResponse({this.filePath, this.status, this.fileName});

  CorporatorReportResponse.fromJson(Map<String, dynamic> json) {
    filePath = json['FilePath'];
    status = json['status'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FilePath'] = this.filePath;
    data['status'] = this.status;
    data['fileName'] = this.fileName;
    return data;
  }
}