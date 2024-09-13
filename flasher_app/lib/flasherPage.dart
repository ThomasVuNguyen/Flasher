import 'dart:io';

import 'package:flasher_app/congratsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FlasherPage extends StatelessWidget {
  const FlasherPage({super.key, required this.os_path});
  final String os_path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Now that the OS is downloaded, let\'s flash it onto the USB!'),
            Text('1. Press below to start the process'),
            TextButton(onPressed: () async {
              // 2. Copy exe from assets to documents directory
              final bytes = await rootBundle.load('assets/usb_imager/usbimager.exe');
              final list = bytes.buffer.asUint8List();

              final tempDir = await getTemporaryDirectory();
              final tempPath = '${tempDir.path}/usb_imager.exe';

              File(tempPath).writeAsBytesSync(list);

              // 3. Get path to the copied executable
              final exePath = tempPath;

              // 4. Run the executable
              final result = await Process.run(exePath, [], runInShell: true);

              print('Exit code: ${result.exitCode}');
              print('stdout: ${result.stdout}');
              print('stderr: ${result.stderr}');
            }, child: Text('Press me daddy')),
            Text('2. Copy the following $os_path onto the application'),
            Text('3. Pick you USB'),
            Text('4. Press goooo!'),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CongratsPage()));
            }, child: Text('Done-zo! Next please'))
          ],
        ),
      ),
    );
  }
}
