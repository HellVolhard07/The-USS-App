import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/auth.dart';
import 'package:the_uss_project/widgets/poster_upload.dart';
import 'package:the_uss_project/widgets/show_alert_dialogue.dart';
import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _addEventFormKey = GlobalKey<FormState>();

  File? _imagePick;

  void _imagePicked(File image) {
    _imagePick = image;
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _venueController = TextEditingController();

  bool _isLoading = false;

  TextEditingController _miscController = TextEditingController();

  TextEditingController _dateEditingController = TextEditingController();
  TextEditingController _startTimeEditingController = TextEditingController();
  TextEditingController _endTimeEditingController = TextEditingController();

  int currentStep = 0;
  int numberOfSteps = 3; //4-1

  FocusNode _eventTitleNode = FocusNode();
  FocusNode _eventDescriptionNode = FocusNode();
  FocusNode _eventVenue = FocusNode();
  FocusNode _eventDate = FocusNode();
  FocusNode _eventStartTime = FocusNode();
  FocusNode _eventEndTime = FocusNode();
  FocusNode _misc = FocusNode();

  String eventTitle = "";
  String eventDesc = "";
  String eventVenue = "";
  String eventDate = "";
  String eventStartTime = "";
  String eventEndTime = "";
  String eventPoster = "";
  String miscellaneous = "";

  Future verifyAndSchedule() async {
    if (!_addEventFormKey.currentState!.validate()) {
      showMyDialog(context, "Some fields are missing", showAction: true);
      return;
    }
    _addEventFormKey.currentState!.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Event added successfully"),
      ),
    );

    setState(() {
      _isLoading = true;
    });

    try {
      var url;
      if (_imagePick != null) {
        final ref = storage
            .ref()
            .child("event_posters")
            .child("${_auth.currentUser!.uid}-${Uuid().v4()}");

        await ref.putFile(_imagePick!);
        url = await ref.getDownloadURL();
      }

      await firestore.collection(eventsCollection).add({
        title: eventTitle,
        aboutEvent: eventDesc,
        venue: eventVenue,
        date: eventDate,
        startTime: eventStartTime,
        endTime: eventEndTime,
        posterURL: _imagePick == null ? loggedInSocietyLogo : url,
        societyName: loggedInSocietyName,
      });

      await firestore
          .collection(societiesCollection)
          .doc(_auth.currentUser!.uid)
          .update({
        "myEvents": FieldValue.arrayUnion([
          {
            title: eventTitle,
            aboutEvent: eventDesc,
            venue: eventVenue,
            date: eventDate,
            startTime: eventStartTime,
            endTime: eventEndTime,
            posterURL: url,
          }
        ]),
      });
      setState(() {
        _isLoading = false;
      });
      _titleController.clear();
      _descController.clear();
      _venueController.clear();
      _dateEditingController.clear();
      _startTimeEditingController.clear();
      _endTimeEditingController.clear();
      _imagePick = null;
      _miscController.clear();
    } catch (err) {
      print(err);
    }

    // print(eventTitle);
    // print(eventDesc);
    // print(eventVenue);
    // print(eventDate);
    // print(eventStartTime);
    // print(eventEndTime);
    // print(miscellaneous);
  }

  @override
  Widget build(BuildContext context) {

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: _addEventFormKey,
                    child: Column(
                      children: [
                        Column(
                    children: [
                      // Container(
                      //   width: double.infinity,
                      //   height: 200,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(
                      //       bottomLeft: Radius.circular(10),
                      //       bottomRight: Radius.circular(10),
                      //     ),
                      //     image: DecorationImage(
                      //       image: AssetImage(
                      //         "assets/images/aboutevent.png",
                      //       ),
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "About*",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(thickness: 3),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurpleAccent,
                                    blurRadius: 3,
                                    offset: Offset(5, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _titleController,
                                      onSaved: (title) {
                                        setState(() {
                                          eventTitle = title.toString();
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      focusNode: _eventTitleNode,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Event Title",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onFieldSubmitted: (_) {
                                        _eventTitleNode.unfocus();
                                        FocusScope.of(context).requestFocus(
                                            _eventDescriptionNode);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: _descController,
                                      onSaved: (desc) {
                                        setState(() {
                                          eventDesc = desc.toString();
                                        });
                                      },
                                      focusNode: _eventDescriptionNode,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Description",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      onFieldSubmitted: (_) {
                                        _eventDescriptionNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_eventVenue);
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: _venueController,
                                      onSaved: (venue) {
                                        setState(() {
                                          eventVenue = venue.toString();
                                        });
                                      },
                                      focusNode: _eventVenue,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        }
                                        if (!value.contains("https://")) {
                                          return "Invalid";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Venue/Link (if online)",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onFieldSubmitted: (_) {
                                        _eventVenue.unfocus();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date and Time*",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(thickness: 3),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurpleAccent,
                                    blurRadius: 3,
                                    offset: Offset(5, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),

                                          child: TextFormField(
                                            controller: _dateEditingController,
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime selectedDate =
                                                  (await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              ))!;
                                              eventDate = DateFormat.yMMMd()
                                                  .format(selectedDate);
                                              _dateEditingController.text =
                                                  DateFormat.yMMMd()
                                                      .format(selectedDate);
                                            },
                                            onSaved: (date) {
                                              setState(() {
                                                eventDate =
                                                    _dateEditingController.text;
                                              });
                                            },
                                            focusNode: _eventDate,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Required";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Date",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onFieldSubmitted: (date) {
                                              _eventDate.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _eventStartTime);
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller:
                                                _startTimeEditingController,
                                            readOnly: true,
                                            onSaved: (startTime) {
                                              setState(() {
                                                eventStartTime =
                                                    _startTimeEditingController
                                                        .text;
                                              });
                                            },
                                            onTap: () async {
                                              TimeOfDay selectedStartTime =
                                                  (await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ))!;
                                              // eventStartTime = selectedStartTime.toString();
                                              var dt = DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                selectedStartTime.hour,
                                                selectedStartTime.minute,
                                              );
                                              _startTimeEditingController.text =
                                                  DateFormat.Hm().format(dt);
                                              eventStartTime =
                                                  _startTimeEditingController
                                                      .text;
                                            },
                                            focusNode: _eventStartTime,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Required";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Start Time",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onFieldSubmitted: (_) {
                                              _eventStartTime.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(_eventEndTime);
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller:
                                                _endTimeEditingController,
                                            readOnly: true,
                                            onSaved: (endTime) {
                                              setState(() {
                                                eventEndTime =
                                                    _endTimeEditingController
                                                        .text;
                                              });
                                            },
                                            onTap: () async {
                                              TimeOfDay selectedEndTime =
                                                  (await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ))!;
                                              // eventStartTime = selectedStartTime.toString();
                                              var dt = DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                selectedEndTime.hour,
                                                selectedEndTime.minute,
                                              );
                                              _endTimeEditingController.text =
                                                  DateFormat.Hm().format(dt);
                                              eventEndTime =
                                                  _startTimeEditingController
                                                      .text;
                                            },
                                            focusNode: _eventEndTime,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Required";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "End Time",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onFieldSubmitted: (_) {
                                              _eventEndTime.unfocus();
                                            },
                                          ),
                                        ),
                                      ),
                                      onFieldSubmitted: (_) {
                                        _eventEndTime.unfocus();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upload Poster",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(thickness: 3),
                            SizedBox(height: 20),
                            PosterUpload(_imagePicked),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Miscellaneous",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(thickness: 3),
                            SizedBox(height: 20),
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurpleAccent,
                                    blurRadius: 3,
                                    offset: Offset(5, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _miscController,
                                      focusNode: _misc,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      onSaved: (misc) {
                                        setState(() {
                                          miscellaneous = misc!;
                                        });
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Any Additional Information / Guidelines / Links etc.",
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      onFieldSubmitted: (misc) {
                                        _misc.unfocus();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            verifyAndSchedule();
                          },
                          child: Text("Schedule"),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
