import 'package:flutter/material.dart';

class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Congrats, you are finished!'),
            Image.network('https://media2.giphy.com/media/rBszdmXbzglQUX7N4j/giphy.webp?cid=790b7611p78bmt6xptqmjjuvig328csg9gu18n1ytz8cvacr&ep=v1_gifs_search&rid=giphy.webp&ct=g'),
            Text('Plug in your Raspberry Pi & continue with the app!'),
            Text('You can keep this running for a cool beat if you like!')
          ],
        ),
      ),
    );
  }
}
