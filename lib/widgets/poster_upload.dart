import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PosterUpload extends StatefulWidget {
  final void Function(File pickedImage)? imagePicker;

  PosterUpload({this.imagePicker});

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
    return Column(
      children: [
        _pickedImage != null
            ? Container(
                height: 200,
                width: 100,
                decoration: BoxDecoration(
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
    );
    // return Column(
    //   children: [
    //     InkWell(
    //       onTap: _getFromCamera,
    //       child: CircleAvatar(
    //         radius: 37,
    //         backgroundColor: Colors.black12,
    //         backgroundImage:
    //             _pickedImage != null ? FileImage(_pickedImage) : null,
    //         child: Icon(
    //           Icons.camera_alt_outlined,
    //           color: _pickedImage != null ? Colors.white : Colors.black,
    //         ),
    //       ),
    //     ),
    //     TextButton.icon(
    //       onPressed: _getFromGallery,
    //       icon: Icon(Icons.image),
    //       label: Text("Upload Image"),
    //     ),
    //   ],
    // );
  }
}
