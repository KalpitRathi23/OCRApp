import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Screen/recognization_page.dart';
import 'Utils/image_cropper_page.dart';
import 'Utils/image_picker_class.dart';
import 'Widgets/modal_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Optical Character Recognition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(context, onCameraTap: () {
            log("Camera");
            pickImage(source: ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          }, onGalleryTap: () {
            log("Gallery");
            pickImage(source: ImageSource.gallery).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          });
        },
        tooltip: 'Increment',
        label: const Text("Scan photo"),
      ),
    );
  }
}
