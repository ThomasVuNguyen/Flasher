import 'dart:io';

import 'package:flasher_app/generate_config/setup_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('flash an OS'),
          IconButton(onPressed: (){
            //open usbimager
            runExeFromAssets();
          }, icon: Icon(Icons.flash_auto)),
          Gap(30),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => setup_config()));
          }, icon: Icon(Icons.arrow_right))
        ],
      )
    ));
  }
}

Future<void> runExeFromAssets() async {

  // 1. Download OS
  //String os_path='https://gitlab.com/bztsrc/usbimager/-/raw/master/README.md?ref_type=heads&inline=false';
  String os_path = 'https://firebasestorage.googleapis.com/v0/b/comfyspace-73966.appspot.com/o/os%2Fos.xz?alt=media&token=d0029108-65b7-4ba1-b457-668b820747bb';
  await downloadFile(os_path, 'os.img',
          (progress) {
        print('Download progress: ${(progress * 100).toStringAsFixed(2)}%');
      }
  );

  if(Platform.isWindows){
    // 2. Copy exe from assets to documents directory
    final bytes = await rootBundle.load('assets/usb_imager/usbimager.exe');
    final list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/usb_imager.exe';

    File(tempPath).writeAsBytesSync(list);

    // 3. Get path to the copied executable
    final exePath = tempPath;

    // 4. Run the executable
    final Directory? downnloadDir = await getDownloadsDirectory();
    String path_to_os = '${downnloadDir?.path}/os.img';
    print(path_to_os);
    final result = await Process.run(exePath, [], runInShell: true);

    print('Exit code: ${result.exitCode}');
    print('stdout: ${result.stdout}');
    print('stderr: ${result.stderr}');
  }

  else if(Platform.isLinux){
    // 2. Copy exe from assets to documents directory
    final bytes = await rootBundle.load('assets/usb_imager/usbimager_1.0.10-amd64.deb');
    final list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/usbimager_1.0.10-amd64.deb';

    File(tempPath).writeAsBytesSync(list);

    // 3. Get path to the copied executable
    final exePath = tempPath;

    // 4. Run the executable
    final Directory? downnloadDir = await getDownloadsDirectory();
    String path_to_os = '${downnloadDir?.path}/os.img';
    print(path_to_os);
    final result = await Process.run(exePath, [], runInShell: true);

    print('Exit code: ${result.exitCode}');
    print('stdout: ${result.stdout}');
    print('stderr: ${result.stderr}');
  }




}



Future<void> downloadFile(String url, String fileName, Function(double) onProgress) async {
  // Get the downloads directory
  final directory = await getDownloadsDirectory();
  if (directory == null) {
    throw Exception('Could not access the downloads directory');
  }

  final filePath = '${directory.path}${Platform.pathSeparator}$fileName';
  final file = File(filePath);

  // Send GET request to download the file
  final response = await http.Client().send(http.Request('GET', Uri.parse(url)));

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Get the total size of the file
    final contentLength = response.contentLength ?? 0;
    var receivedBytes = 0;

    // Open the file in write mode
    final sink = file.openWrite();

    // Listen to the response stream
    await response.stream.forEach((List<int> chunk) {
      // Write each chunk to the file
      sink.add(chunk);

      // Update received bytes and calculate progress
      receivedBytes += chunk.length;
      final progress = contentLength > 0 ? (receivedBytes / contentLength).toDouble() : 0.0;

      // Call the progress callback
      onProgress(progress);
    });

    // Close the file
    await sink.close();

    print('File downloaded to: $filePath');
  } else {
    throw Exception('Failed to download file: ${response.statusCode}');
  }
}