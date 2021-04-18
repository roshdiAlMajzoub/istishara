import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendImagePicker extends StatefulWidget {
  final String source;
  SendImagePicker({@required this.source});
  @override
  State<SendImagePicker> createState() => SendImagePickerState(source: source);
}

var x;

class SendImagePickerState extends State<SendImagePicker> {
  final String source;
  File pickedImage;
  SendImagePickerState({@required  this.source});
  
  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(
        source: source=="Gallery"?ImageSource.gallery : ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      pickedImage = File(pickedImageFile.path);
    });
    print(pickedImage.path);
    final TextEditingController maxWidthController = TextEditingController();
    final TextEditingController maxHeightController = TextEditingController();
    final TextEditingController qualityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Center(
        child: Stack(children: [
      Container(
          width: screenWidth / 3,
          height: screenHeight / 3.5,
          child: CircleAvatar(
            backgroundImage: pickedImage != null
                ? FileImage(pickedImage)
                : x != null
                    ? NetworkImage(x)
                    : null,
            radius: 30,
          )),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: screenHeight / 6.5,
          width: screenWidth / 6.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 4,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            color: Colors.deepPurple,
          ),
          child: IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: pickImage),
        ),
      ),
    ]));
  }
}
