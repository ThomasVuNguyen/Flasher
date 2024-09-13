import 'package:flasher_app/plugUSB.dart';
import 'package:flutter/material.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hi there!', textAlign: TextAlign.center,),
            Text('You must be here to setup your Raspberry Pi!', textAlign: TextAlign.center,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Plugusb()));
            }, child: Text('Let\'s go'))
          ],
        ),
      ),
    );
  }
}
