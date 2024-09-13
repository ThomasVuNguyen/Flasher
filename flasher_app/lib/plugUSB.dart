import 'package:flasher_app/downloadImage.dart';
import 'package:flutter/material.dart';

class Plugusb extends StatelessWidget {
  const Plugusb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Plug in a USB into your laptop'),
            Image.network('https://images.unsplash.com/photo-1477949331575-2763034b5fb5?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bGFwdG9wJTIwdXNifGVufDB8fDB8fHww'),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadImage()));
            }, child: Text('It\'s plugged')),

          ],
        ),
      ),
    );
  }
}
