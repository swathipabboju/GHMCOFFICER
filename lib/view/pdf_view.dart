import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class DownloadingDialog extends StatefulWidget {
  final String filePath;
   const DownloadingDialog({super.key, required this.filePath});

  @override
  State<DownloadingDialog> createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async
  {
     String url = "${widget.filePath}";
    const String fileName = "xyz.pdf";
    String path = await _getFilePath(fileName);

    await dio.download(url, path,
    onReceiveProgress:(recievedBytes, totalBytes) {
      setState(() {
        progress = recievedBytes / totalBytes;
      });
      print(progress);
    },
    deleteOnError: true,
    ).then((_) => {
      Navigator.pop(context),
    });
  }

  Future<String> _getFilePath(String filename)
  async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDownloading();
  }
  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text("Downloading: $downloadingprogress%",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
          ),
      
        ],
      ),
    );
  }
}