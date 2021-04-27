import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ISTISHARA/Database/Databasers.dart';

class UserImagePicker extends StatefulWidget {
  Function(File pickedImage) pickImagefn;
  var list;
  UserImagePicker({@required this.pickImagefn, @required this.list});
  @override
  State<UserImagePicker> createState() => UserImagePickerState();
}

var x;

class UserImagePickerState extends State<UserImagePicker> {
  viewImage() async {
    x = widget.list[0]['image name'];
  }

  void initState() {
    super.initState();
    viewImage();
   
  }

  File pickedImage;
  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);
    setState(() {
      pickedImage = File(pickedImageFile.path);
    });
 
    widget.pickImagefn(pickedImage);
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
                : NetworkImage(x),
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
