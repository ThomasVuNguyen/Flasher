import 'dart:io';
import 'package:flasher_app/flasherPage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

String os_path = 'https://firebasestorage.googleapis.com/v0/b/comfyspace-73966.appspot.com/o/os%2Fos.xz?alt=media&token=d0029108-65b7-4ba1-b457-668b820747bb';

class DownloadImage extends StatefulWidget {
  const DownloadImage({super.key});

  @override
  _DownloadImageState createState() => _DownloadImageState();
}

class _DownloadImageState extends State<DownloadImage> {
  double _progress = 0.0;
  bool _isDownloading = false;
  bool _isDownloadComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Now, let\'s download the Operating System for your Raspberry Pi!'),
            ElevatedButton(
              onPressed: _isDownloading ? null : _handleButtonPress,
              child: Text(_getButtonText()),
            )
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    if (_isDownloadComplete) {
      return 'Next';
    } else if (_isDownloading) {
      return '${(_progress * 100).toStringAsFixed(2)}%';
    } else {
      return 'Download';
    }
  }

  void _handleButtonPress() {
    if (_isDownloadComplete) {
      _navigateToNextScreen();
    } else {
      _startDownload();
    }
  }

  Future<void> _navigateToNextScreen() async {
    final Directory? downnloadDir = await getDownloadsDirectory();
    String path_to_os = '${downnloadDir?.path}/os.img';
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FlasherPage(os_path: path_to_os)),
    );
  }

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      await downloadFile(os_path, 'os.img', (progress) {
        setState(() {
          _progress = progress;
        });
      });
      setState(() {
        _isDownloadComplete = true;
      });
    } catch (e) {
      print('Download failed: $e');
      // You might want to show an error message to the user here
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }
}


Future<void> downloadFile(String url, String fileName, Function(double) onProgress) async {
  final directory = await getDownloadsDirectory();
  if (directory == null) {
    throw Exception('Could not access the downloads directory');
  }

  final filePath = '${directory.path}${Platform.pathSeparator}$fileName';
  final file = File(filePath);

  final response = await http.Client().send(http.Request('GET', Uri.parse(url)));

  if (response.statusCode == 200) {
    final contentLength = response.contentLength ?? 0;
    var receivedBytes = 0;

    final sink = file.openWrite();

    await for (final chunk in response.stream) {
      sink.add(chunk);
      receivedBytes += chunk.length;
      final progress = contentLength > 0 ? (receivedBytes / contentLength).toDouble() : 0.0;
      onProgress(progress);
    }

    await sink.close();
    print('File downloaded to: $filePath');
  } else {
    throw Exception('Failed to download file: ${response.statusCode}');
  }
}