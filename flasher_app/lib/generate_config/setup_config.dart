import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quick_usb/quick_usb.dart';

class setup_config extends StatefulWidget {
  const setup_config({super.key});

  @override
  State<setup_config> createState() => _setup_configState();
}

class _setup_configState extends State<setup_config> {
  TextEditingController wifi_name_controller = TextEditingController();
  TextEditingController wifi_pw_controller = TextEditingController();
  TextEditingController hotspot_name_controller = TextEditingController();
  TextEditingController hotspot_pw_controller = TextEditingController();
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

  Future<void> createConfigFile(String driveLetter, String wifi_name, String wifi_pw, String hotspot_name, String hotspot_pw) async {
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
    ssid="$hotspot_name"
    psk="$hotspot_pw"
    key_mgmt=WPA-PSK
}

network={
    ssid="$wifi_name"
    psk="$wifi_pw"
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('USB Picker'),
              Gap(30),
              TextField(
                controller: wifi_name_controller,
                decoration: InputDecoration(
                  hintText: 'wifi name'
                ),
              ),
              Gap(30),
              TextField(
                controller: wifi_pw_controller,
                decoration: InputDecoration(
                    hintText: 'wifi pw'
                ),
              ),
              Gap(30),
              TextField(
                controller: hotspot_name_controller,
                decoration: InputDecoration(
                    hintText: 'hotspot name'
                ),
              ),
              Gap(30),
              TextField(
                controller: hotspot_pw_controller,
                decoration: InputDecoration(
                    hintText: 'hotspot pw'
                ),
              ),
              Gap(30),
              IconButton(onPressed: () async {
                try {
                  List<String> drive_letter = await findDrivesWithConfigFile();
                  createConfigFile(
                      drive_letter[0],
                    wifi_name_controller.text,
                    wifi_pw_controller.text,
                    hotspot_name_controller.text,
                    hotspot_pw_controller.text
                  );
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
