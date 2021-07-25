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

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  Future getCurrentUserData() async {
    try {
      final loggedInUserDetail = await firestore
          .collection(societiesCollection)
          .doc(_auth.currentUser!.uid)
          .get();

      loggedInSocietyName = await loggedInUserDetail.get('societyName');
      loggedInSoceityAbout = await loggedInUserDetail.get('societyAbout');
      loggedInSocietyEvents = await loggedInUserDetail.get('myEvents');
      loggedInSocietyLogo = await loggedInUserDetail.get('societyLogo');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  File? _imagePick;

  void _imagePicked(File image) {
    _imagePick = image;
  }

  bool _isLoading = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _venueController = TextEditingController();
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
  String eventID = ""; //eventID contains the document id for events
  String eventDesc = "";
  String eventVenue = "";
  late DateTime eventDate;
  late DateTime selectedDate;
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
        societyLogo: loggedInSocietyLogo,
      }).then((value) {
        eventID = value.id;
      });

      await firestore
          .collection(societiesCollection)
          .doc(_auth.currentUser!.uid)
          .update({
        "myEvents": FieldValue.arrayUnion([
          {
            eventId: eventID,
            title: eventTitle,
            aboutEvent: eventDesc,
            venue: eventVenue,
            date: eventDate,
            startTime: eventStartTime,
            endTime: eventEndTime,
            posterURL: _imagePick == null ? loggedInSocietyLogo : url,
            societyName: loggedInSocietyName,
            societyLogo: loggedInSocietyLogo,
          }
        ]),
      });
      setState(() {
        _imagePick = null;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Event added successfully"),
        ),
      );
      Navigator.of(context).pop();
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateEditingController.dispose();
    _descController.dispose();
    _venueController.dispose();
    _miscController.dispose();
    _startTimeEditingController.dispose();
    _endTimeEditingController.dispose();
    _eventTitleNode.dispose();
    _eventDescriptionNode.dispose();
    _eventVenue.dispose();
    _eventDate.dispose();
    _eventStartTime.dispose();
    _eventEndTime.dispose();
    _misc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _addEventFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 23.0,
                      vertical: 25.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Details",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "This section contains the basic details of your event",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
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
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            labelText: "Event Title",
                            labelStyle: TextStyle(fontSize: 18.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            hintText: "Event Title",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            _eventTitleNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_eventDescriptionNode);
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _descController,
                          onSaved: (desc) {
                            setState(() {
                              eventDesc = desc.toString();
                            });
                          },
                          focusNode: _eventDescriptionNode,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            labelText: "Event description",
                            labelStyle:
                                TextStyle(fontSize: 18.0, color: Colors.green),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            hintText: "Event description",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onFieldSubmitted: (_) {
                            _eventDescriptionNode.unfocus();
                            FocusScope.of(context).requestFocus(_eventVenue);
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _venueController,
                          onSaved: (venue) {
                            setState(() {
                              eventVenue = venue.toString();
                            });
                          },
                          focusNode: _eventVenue,
                          style: TextStyle(
                            color: Colors.white,
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
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            labelText: "Venue",
                            labelStyle:
                                TextStyle(fontSize: 18.0, color: Colors.green),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            hintText: "Venue(Link if online)",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            _eventVenue.unfocus();
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _dateEditingController,
                          readOnly: true,
                          onTap: () async {
                            selectedDate = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            ))!;
                            eventDate = selectedDate;
                            _dateEditingController.text =
                                DateFormat.yMMMd().format(selectedDate);
                          },
                          onSaved: (date) {
                            setState(() {
                              eventDate = selectedDate;
                            });
                          },
                          focusNode: _eventDate,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            labelText: "Date",
                            labelStyle:
                                TextStyle(fontSize: 18.0, color: Colors.green),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            hintText: "Event Date",
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onFieldSubmitted: (date) {
                            _eventDate.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_eventStartTime);
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _startTimeEditingController,
                                readOnly: true,
                                onSaved: (startTime) {
                                  setState(() {
                                    eventStartTime =
                                        _startTimeEditingController.text;
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
                                      DateFormat("jm").format(dt);
                                  eventStartTime =
                                      _startTimeEditingController.text;
                                },
                                focusNode: _eventStartTime,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  labelText: "Start Time",
                                  labelStyle: TextStyle(
                                      fontSize: 18.0, color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  hintText: "Event start time",
                                  contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon: Icon(Icons.more_time),
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
                            SizedBox(
                              width: 7.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _endTimeEditingController,
                                readOnly: true,
                                onSaved: (endTime) {
                                  setState(() {
                                    eventEndTime =
                                        _endTimeEditingController.text;
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
                                      DateFormat("jm").format(dt);
                                  eventEndTime =
                                      _startTimeEditingController.text;
                                },
                                focusNode: _eventEndTime,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  labelText: "End time",
                                  labelStyle: TextStyle(
                                      fontSize: 18.0, color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  hintText: "Event end time",
                                  suffixIcon: Icon(Icons.more_time),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                onFieldSubmitted: (_) {
                                  _eventEndTime.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        PosterUpload(_imagePicked),
                        Divider(
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _miscController,
                          focusNode: _misc,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onSaved: (misc) {
                            setState(() {
                              miscellaneous = misc!;
                            });
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            labelText: "Miscellaneous",
                            labelStyle: TextStyle(fontSize: 18.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                            ),
                            hintText:
                                "Any additional information/guidelines/links",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onFieldSubmitted: (misc) {
                            _misc.unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              verifyAndSchedule();
                            },
                            child: Text("Schedule"),
                          ),
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
