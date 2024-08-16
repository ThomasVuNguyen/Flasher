import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  void initState() {
    syncCommand_v2([
      'echo list disk | diskpart'
    ]);
    super.initState();
  }

  Future<void> syncCommand_v1(List<String> commandList) async {
    var shell = Shell();

    commandList.forEach((command){
      var results = shell.runSync(command);
      var result = results.first;
      print('output: "${result.outText.trim()}" exitCode: ${result.exitCode}');
    });

// This is a synchronous call and will block until the child process terminates.

  }
  Future<void> syncCommand_v2(List<String> commandList) async {
    var shell = Shell();
    bool runInShell = Platform.isWindows;

    commandList.forEach((command) async {
      ProcessCmd cmd = ProcessCmd(command, [], runInShell: runInShell);
      var result = await runCmd(cmd, verbose: true);
      print('result: ${result.outText}');
    });

// This is a synchronous call and will block until the child process terminates.

  }
  Future<void> testCommand() async{
    // Simple echo command
    // Somehow windows requires runInShell for the system commands
    bool runInShell = Platform.isWindows;

    // Run the command
    ProcessCmd cmd = ProcessCmd('diskpart /s list disk', [], runInShell: runInShell);
    await runCmd(cmd);

    // Running the command in verbose mode (i.e. display the command and stdout/stderr)
    // > $ echo "hello world"
    // > hello world
    await runCmd(cmd, verbose: true);

    // Stream the out to stdout
    await runCmd(cmd, stdout: stdout);

    // Calling dart
    cmd = DartCmd(['--version']);
    await runCmd(cmd);

    // clone the command to allow other modifications
    cmd = ProcessCmd('dism /Get-WimInfo /WimFile:E:\sources\install.wim', [], runInShell: runInShell);
    // > $ echo "hello world"
    // > hello world
    await runCmd(cmd, verbose: true);
    // > $ echo "new hello world"
    // > new hello world
    await runCmd(cmd.clone()
      ..arguments = ["new hello world"], verbose: true);

    // Calling dart
    // > $ dart --version
    // > Dart VM version: 1.19.1 (Wed Sep  7 15:59:44 2016) on "linux_x64"
    cmd = DartCmd(['--version']);
    await runCmd(cmd, verbose: true);

    // Calling dart script
    // $ dart example/my_script.dart my_first_arg my_second_arg
    await runCmd(DartCmd(['example/my_script.dart', 'my_first_arg', 'my_second_arg']), commandVerbose: true);

    // Calling pub
    // > $ pub --version
    // > Pub 1.19.1
    await runCmd(PubCmd(['--version']), verbose: true);

    // Listing global activated packages
    // > $ pub global list
    // > ...
    await runCmd(PubCmd(['global', 'list']), verbose: true);
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

