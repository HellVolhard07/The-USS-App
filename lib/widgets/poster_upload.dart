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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upload poster",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            //TODO: implement delete poster
            _pickedImage != null
                ? IconButton(
                    icon: Icon(Icons.delete_outline_rounded),
                    onPressed: () {
                      setState(() {
                        _pickedImage = null;
                      });
                    },
                  )
                : Container(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pickedImage != null
                ? GestureDetector(
                    onTap: _getFromGallery,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      height: 225,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(_pickedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(),
            _pickedImage == null
                ? GestureDetector(
                    onTap: _getFromGallery,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, bottom: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined),
                          Text("Upload Poster"),
                        ],
                      ),
                    ),
                  )
                : Container(),
            // ElevatedButton.icon(
            //   style: ButtonStyle(
            //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            //       EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            //     ),
            //   ),
            //   icon: Icon(Icons.cloud_upload),
            //   onPressed: _getFromGallery,
            //   label: Text("Upload Poster"),
            // ),
          ],
        ),
      ],
    );
  }
}
