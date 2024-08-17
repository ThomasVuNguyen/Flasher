import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          Text('flash an OS'),
          IconButton(onPressed: (){
            //open usbimager
            runExeFromAssets();
          }, icon: Icon(Icons.flash_auto))
        ],
      )
    ));
  }
}

Future<void> runExeFromAssets() async {
  // 1. Copy exe from assets to documents directory
  final bytes = await rootBundle.load('assets/usb_imager/usbimager.exe');
  final list = bytes.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/usb_imager.exe';

  File(tempPath).writeAsBytesSync(list);

  // 2. Get path to the copied executable
  final exePath = tempPath;

  // 3. Run the executable
  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  String path_to_os = '${tempDir.path}/assets/os_images/2024-07-04-raspios-bullseye-armhf.img';
  print(path_to_os);
  final result = await Process.run(exePath, [], runInShell: true);

  print('Exit code: ${result.exitCode}');
  print('stdout: ${result.stdout}');
  print('stderr: ${result.stderr}');
}