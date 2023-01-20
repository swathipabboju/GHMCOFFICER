
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghmcofficerslogin/view/pdf_view.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ImageViewPage extends StatefulWidget {
  final String filePath;
  const ImageViewPage( {super.key, required this.filePath,});
  

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.black),
            onPressed: ()  {
              //EasyLoading.show();
              showDialog(builder: (BuildContext context) => DownloadingDialog(filePath: '${widget.filePath}',), context: context);
            },
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (() {
              Navigator.of(context).pop();
            })
            //() => Navigator.of(context).pop(),
            ),
        title: Center(
          child: Text(
            "Pdf",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child:SfPdfViewer.network(
         widget.filePath
         // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
           ),
      ),
      floatingActionButton:FloatingActionButton(
      onPressed: shareFile,
      child: Icon(Icons.share),
     ),
    );
    
  }
  void shareFile() async
  {
    var file = await FilePicker.platform.pickFiles();
    Share.shareFiles([file!.paths[0]!]);
  }

}