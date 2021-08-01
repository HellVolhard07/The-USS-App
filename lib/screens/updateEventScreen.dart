import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/auth.dart';
import 'package:the_uss_project/widgets/poster_upload.dart';
import 'package:the_uss_project/widgets/show_alert_dialogue.dart';
import 'package:uuid/uuid.dart';

enum SingingCharacter { online, offline }

class UpdateEventScreen extends StatefulWidget {
  final String eventTitle;
  final String eventID;
  final String eventDesc;
  final String eventVenue;
  final DateTime eventDate;
  final String eventStartTime;
  final String? eventEndTime;
  final String eventPoster;
  final String? miscellaneous;

  UpdateEventScreen({
    required this.eventTitle,
    required this.eventVenue,
    required this.eventDate,
    this.eventEndTime,
    required this.eventStartTime,
    required this.eventDesc,
    this.miscellaneous,
    required this.eventID,
    required this.eventPoster,
  });

  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  SingingCharacter? _character = SingingCharacter.online;
  bool? _checkBoxValue = false;
  bool isOnline = true;
  bool isRegisterationRequired = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _addEventFormKey = GlobalKey<FormState>();

  File? _imagePick;

  @override
  void initState() {
    getCurrentUserData();
    _titleController = TextEditingController(
      text: widget.eventTitle,
    );

    _descController = TextEditingController(
      text: widget.eventDesc,
    );
    _venueController = TextEditingController(
      text: widget.eventVenue,
    );

    _miscController = TextEditingController(
      text: "",
    );

    _dateEditingController = TextEditingController(
      text: "",
    );
    _startTimeEditingController = TextEditingController(
      text: widget.eventStartTime,
    );
    _endTimeEditingController = TextEditingController(
      text: widget.eventEndTime,
    );
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

  void verifyAndUpdate(String id, String posterUrl) async {
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

      await firestore.collection(eventsCollection).doc(id).update({
        title: eventTitle,
        aboutEvent: eventDesc,
        venue: eventVenue,
        date: eventDate,
        startTime: eventStartTime,
        endTime: eventEndTime,
        posterURL: _imagePick == null ? posterUrl : url,
        societyName: loggedInSocietyName,
        societyLogo: loggedInSocietyLogo,
        onlineEvent: isOnline,
        registerationRequired: isRegisterationRequired,
      });

      var index = loggedInSocietyEvents
          .indexWhere((element) => element['eventId'] == id);
      loggedInSocietyEvents[index] = {
        eventId: id,
        title: eventTitle,
        aboutEvent: eventDesc,
        venue: eventVenue,
        date: eventDate,
        startTime: eventStartTime,
        endTime: eventEndTime,
        posterURL: _imagePick == null ? posterUrl : url,
        societyName: loggedInSocietyName,
        societyLogo: loggedInSocietyLogo,
        onlineEvent: isOnline,
        registerationRequired: isRegisterationRequired,
      };
      await firestore
          .collection(societiesCollection)
          .doc(_auth.currentUser!.uid)
          .update({"myEvents": loggedInSocietyEvents});

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7),
          content: Text("Event updated successfully"),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: themeProvider.isDarkTheme
                ? Color(0xffcd885f)
                : Color(0xffD59B78),
          ),
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
                      vertical: 0.0,
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
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
                            ),
                            labelText: "Event Title",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffffa265)
                                  : Color(0xffcd885f),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
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
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : Colors.black,
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
                                color: Color(0xffd59b78),
                              ),
                            ),
                            labelText: "Event description",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffffa265)
                                  : Color(0xffcd885f),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
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
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: const Text('Online'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.online,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      isOnline = true;
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: const Text('Offline'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.offline,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      isOnline = false;
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   width: 70,
                        // ),
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                  title: Text('Requires Registeration'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: _checkBoxValue,
                                  onChanged: (newCheckBoxValue) {
                                    setState(() {
                                      isRegisterationRequired =
                                          !isRegisterationRequired;
                                      _checkBoxValue = newCheckBoxValue;
                                    });
                                  }),
                            ),
                          ],
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
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required";
                            }
                            if (isOnline && !value.contains("https://") ||
                                isRegisterationRequired &&
                                    !value.contains("https://")) {
                              return "Invalid";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
                            ),
                            labelText: "Venue",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffffa265)
                                  : Color(0xffcd885f),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
                            ),
                            hintText: isRegisterationRequired
                                ? "Registeration Link"
                                : isOnline
                                    ? "Event link"
                                    : "Venue",
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
                              eventDate = DateTime(
                                eventDate.year,
                                eventDate.month,
                                eventDate.day,
                                23,
                                59,
                                59,
                              );
                            });
                          },
                          focusNode: _eventDate,
                          style: TextStyle(
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : Colors.black,
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
                                color: Color(0xffd59b78),
                              ),
                            ),
                            labelText: "Date",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffffa265)
                                  : Color(0xffcd885f),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
                            ),
                            hintText: "Event Date",
                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xffd59b78),
                            ),
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
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
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
                                      color: Color(0xffd59b78),
                                    ),
                                  ),
                                  labelText: "Start Time",
                                  labelStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: themeProvider.isDarkTheme
                                        ? Color(0xffffa265)
                                        : Color(0xffcd885f),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffd59b78),
                                    ),
                                  ),
                                  hintText: "Event start time",
                                  contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon: Icon(
                                    Icons.more_time,
                                    color: Color(0xffd59b78),
                                  ),
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
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
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
                                      color: Color(0xffd59b78),
                                    ),
                                  ),
                                  labelText: "End time",
                                  labelStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: themeProvider.isDarkTheme
                                        ? Color(0xffffa265)
                                        : Color(0xffcd885f),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffd59b78),
                                    ),
                                  ),
                                  hintText: "Event end time",
                                  suffixIcon: Icon(
                                    Icons.more_time,
                                    color: Color(0xffd59b78),
                                  ),
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
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : Colors.black,
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
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
                            ),
                            labelText: "Miscellaneous",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffffa265)
                                  : Color(0xffcd885f),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffd59b78),
                              ),
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
                  SizedBox(height: 25),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // print(eventDate);
                              verifyAndUpdate(
                                widget.eventID,
                                widget.eventPoster,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                themeProvider.isDarkTheme
                                    ? Color(0xffffa265)
                                    : Color(0xffcd885f),
                              ),
                            ),
                            child: Text("Update"),
                          ),
                        ),
                  SizedBox(
                    height: 50.0,
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
