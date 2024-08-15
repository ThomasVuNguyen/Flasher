import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  void initState() {
    syncCommand(
      [
        //'powershell Start-Process diskpart -Verb RunAs',
        'diskpart list disk',

      ]
    );
    super.initState();
  }

  Future<void> syncCommand(List<String> commandList) async {
    var shell = Shell();

    commandList.forEach((command){
      var results = shell.runSync(command);
      var result = results.first;
      print('output: "${result.outText.trim()}" exitCode: ${result.exitCode}');
    });

// This is a synchronous call and will block until the child process terminates.

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}

