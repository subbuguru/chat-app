import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog {
  static Future<File?> pickImage(BuildContext context) async {
    File? pickedFile;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.photo_album, color: Theme.of(context).iconTheme.color),
                      const Padding(padding: EdgeInsets.all(8.0)),
                      Text("Gallery", style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ],
                  ),
                  onTap: () async {

                    pickedFile = File((await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800))?.path ?? '');
                    Navigator.pop(context);
                    
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Theme.of(context).iconTheme.color),
                      const Padding(padding: EdgeInsets.all(8.0)),
                      Text("Camera", style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ],
                  ),
                  onTap: () async {

                    pickedFile = File((await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 800))?.path ?? '');
                    Navigator.pop(context);
                    
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return pickedFile;
  }
}
