import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_usb/quick_usb.dart';

class UsbPicker extends StatefulWidget {
  const UsbPicker({super.key});

  @override
  State<UsbPicker> createState() => _UsbPickerState();
}

class _UsbPickerState extends State<UsbPicker> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<String> listWindowsDrives() {
    if (!Platform.isWindows) {
      throw UnsupportedError('This function is only supported on Windows.');
    }

    List<String> drives = [];

    for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
      var path = '$letter:\\';
      try {
        var dir = Directory(path);
        if (dir.existsSync()) {
          drives.add(letter);
        }
      } catch (e) {
        // Ignore errors and continue to the next drive
        // print('Error checking drive $letter: $e');
      }
    }

    return drives;
  }
  Future<List<String>> findDrivesWithConfigFile() async {
    List<String> drives = listWindowsDrives();
    List<String> drivesWithConfig = [];

    for (String drive in drives) {
      String configPath = '$drive:\\config.txt';
      try {
        bool exists = await File(configPath).exists();
        if (exists) {
          drivesWithConfig.add(drive);
        }
      } catch (e) {
        // Ignore errors and continue to the next drive
      }
    }
    print(drivesWithConfig);
    return drivesWithConfig;
  }

  Future<void> createConfigFile(String driveLetter) async {
    if (!Platform.isWindows) {
      throw UnsupportedError('This function is only supported on Windows.');
    }
    String wpa_supplicant_path = '$driveLetter:\\wpa_supplicant.conf';
    String ssh_path = '$driveLetter:\\ssh';
    String user_config_path = '$driveLetter:\\userconf.txt';
    String test_path = '$driveLetter:\\test.txt';

    Map<String, String> testFile = {
      'path': test_path,
      'content': 'this is a test file for comfy purposes. Thank you for using comfy!',
      'message': 'adding test file'
    };

    Map<String, String> user_config = {
      'path': user_config_path,
      'content': 'comfy:\$6\$F7q1XPpU4v20dzcu\$TJR/vCu3c7KMkxCtpQOLq3h5Zv9uJHggnjiASfbM2aPnt.T.Bn1afvfWxO21H2Dzgi7NuoP2wZdGWL4ZZ43Bc0',
      'message': 'adding user config'
    };

    Map<String, String> ssh_config = {
      'path': ssh_path,
      'content': '',
      'message': 'adding ssh file'
    };

    Map<String, String> network_config = {
      'path': wpa_supplicant_path,
      'content': '''ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=GB

network={
    ssid="tung"
    psk="tungtung"
    key_mgmt=WPA-PSK
}

network={
    ssid="MiraGalaxy"
    psk="24LIVINGMIRA3330!"
    key_mgmt=WPA-PSK
}''',
      'message': 'adding wpa supplicant file'
    };

    List<Map<String, String>> config_list = [
      testFile,
      user_config,
      ssh_config,
      network_config
    ];

    for (Map<String, String> config in config_list){
      String filePath = config['path']!;
      String content = config['content']!;
      String message = config['message']!;
      print(message);
      try {
        print(message);
        File file = File(filePath);
        await file.writeAsString(content);
        print('file created');

      } catch (e) {
        print('Error creating file: $e');

      }
    }

  }
@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('USB Picker'),
              IconButton(onPressed: () async {
                try {
                  List<String> drive_letter = await findDrivesWithConfigFile();
                  createConfigFile(drive_letter[0]);
                } catch (e) {
                  print('Error: $e');
                }
              }, icon: Icon(Icons.scanner))
            ],
          )
          ,
        )
      ),
    );

  }
}
