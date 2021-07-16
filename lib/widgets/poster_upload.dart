import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PosterUpload extends StatefulWidget {
  final void Function(File pickedImage)? imagePicker;

  PosterUpload(this.imagePicker);

  @override
  _PosterUploadState createState() => _PosterUploadState();
}

class _PosterUploadState extends State<PosterUpload> {
  File? _pickedImage;

  void _getFromGallery() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 200,
      maxHeight: 200,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePicker!(_pickedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: Image going when changing pages
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _pickedImage != null
              ? Container(
                  height: 225,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(_pickedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          ElevatedButton.icon(
            icon: Icon(Icons.cloud_upload),
            onPressed: _getFromGallery,
            label: Text("Upload Poster"),
          ),
        ],
      ),
    );
  }
}
