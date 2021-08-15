import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/auth.dart';
import 'package:the_uss_project/widgets/poster_upload.dart';
import 'package:the_uss_project/widgets/show_alert_dialogue.dart';
import 'package:uuid/uuid.dart';

import '../key.dart';

enum SingingCharacter { online, offline }

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  SingingCharacter? _character = SingingCharacter.online;
  bool? _checkBoxValue = false;
  bool isOnline = true;
  bool isRegisterationRequired = false;
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
      isVerified = await loggedInUserDetail.get("isVerified");
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
            .child("$loggedInSocietyName-$eventTitle-${Uuid().v4()}");

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
        onlineEvent: isOnline,
        registerationRequired: isRegisterationRequired,
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
            onlineEvent: isOnline,
            registerationRequired: isRegisterationRequired,
          }
        ]),
      });
      setState(() {
        _imagePick = null;
        _isLoading = false;
      });

      var msgUrl = Uri.parse("https://fcm.googleapis.com/fcm/send");

      var response = http.post(
        msgUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$KEY",
        },
        body: jsonEncode(
          {
            "to": "/topics/Events",
            "notification": {
              "title":
                  "$loggedInSocietyName added a new event: ${eventTitle.toUpperCase()}",
              "body": "CHECK IT OUT!!",
              "click_action": "FLUTTER_CLICK_ACTION"
            },
            "data": {
              "title":
                  "$loggedInSocietyName added a new event: ${eventTitle.toUpperCase()}",
              "body": "CHECKOUT NEW EVENT",
              "click_action": "FLUTTER_CLICK_ACTION"
            }
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width * 0.08,
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
                          height: mediaQuery.width * 0.05,
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
                                color: Color(0xffd59b78),
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
                          height: mediaQuery.width * 0.025,
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
                                color: Color(0xffd59b78),
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
                          height: mediaQuery.width * 0.025,
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
                        Row(
                          children: [
                            SizedBox(
                              width: mediaQuery.width * 0.0125,
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
                                color: Color(0xffd59b78),
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
                          height: mediaQuery.width * 0.025,
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
                              // builder: (BuildContext context,child){
                              //   return Theme(
                              //     data: ThemeData(
                              //
                              //     ),
                              //   );
                              // }
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
                                color: Color(0xffd59b78),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffd59b78)),
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
                          height: mediaQuery.width * 0.025,
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
                                      color: Color(0xffd59b78),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffd59b78),
                                    ),
                                  ),
                                  hintText: "Event start time",
                                  contentPadding:
                                      EdgeInsets.all(mediaQuery.width * 0.035),
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
                              width: mediaQuery.width * 0.025,
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
                                  contentPadding:
                                      EdgeInsets.all(mediaQuery.width * 0.035),
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
                                      color: Color(0xffd59b78),
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
                          height: mediaQuery.width * 0.05,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: mediaQuery.width * 0.025,
                        ),
                        PosterUpload(_imagePicked),
                        Divider(
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: mediaQuery.width * 0.05,
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
                                color: Color(0xffd59b78),
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
                  SizedBox(
                    height: mediaQuery.width * 0.055,
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                themeProvider.isDarkTheme
                                    ? Color(0xffffa265)
                                    : Color(0xffcd885f),
                              ),
                            ),
                            onPressed: () {
                              isVerified
                                  ? verifyAndSchedule()
                                  : showMyDialog(
                                      context,
                                      "Please verify your society",
                                    );
                            },
                            child: Text("Schedule"),
                          ),
                        ),
                  SizedBox(
                    height: mediaQuery.width * 0.125,
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
