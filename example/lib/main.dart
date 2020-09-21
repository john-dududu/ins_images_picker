import 'package:flutter/material.dart';
import 'dart:io';

import 'package:ins_images_picker/ins_images_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<File> _images = new List<File>();

  @override
  void initState() {
    super.initState();
  }

  void showImagePicker() async {
    List<File> images = await InsImagesPicker.showImagePicker(maxImages: 3);
    if (images != null && images.isNotEmpty) {
      images.forEach((element) {
        _images.add(element);
      });
      setState(() {});
    } else {
      print(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Plugin example app',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        body: Center(
            // child: Text('Running on: $_platformVersion\n'),
            child: Column(
          children: [
            MaterialButton(
              onPressed: showImagePicker,
              child: Text("hello",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              color: Colors.blue,
            ),
            Column(
              children: _images
                  .map((e) => Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Image.file(
                          e,
                          height: 100,
                          width: 100,
                        ),
                      ))
                  .toList(),
            )
          ],
        )),
      ),
    );
  }
}
