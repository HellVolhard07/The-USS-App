import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:the_uss_project/widgets/poster_upload.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _addEventFormKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _venueController = TextEditingController();

  TextEditingController _dateEditingController = TextEditingController();
  TextEditingController _startTimeEditingController = TextEditingController();
  TextEditingController _endTimeEditingController = TextEditingController();

  int currentStep = 0;
  int numberOfSteps = 2; //3-1

  FocusNode _eventTitleNode = FocusNode();
  FocusNode _eventDescriptionNode = FocusNode();
  FocusNode _eventVenue = FocusNode();
  FocusNode _eventDate = FocusNode();
  FocusNode _eventStartTime = FocusNode();
  FocusNode _eventEndTime = FocusNode();
  FocusNode _eventPoster = FocusNode();

  String eventTitle = "";
  String eventDesc = "";
  String eventVenue = "";
  late DateTime eventDate;
  String eventStartTime = "";
  String eventEndTime = "";
  String eventPoster = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconStepper(
                  icons: [
                    Icon(Icons.info),
                    Icon(Icons.lock_clock),
                    Icon(Icons.photo_library),
                    Icon(Icons.miscellaneous_services_rounded)
                  ],
                  stepReachedAnimationEffect: Curves.easeOut,
                  stepReachedAnimationDuration: const Duration(
                    milliseconds: 500,
                  ),
                  activeStep: currentStep,
                  onStepReached: (index) {
                    setState(() {
                      currentStep = index;
                    });
                  },
                ),
                stepWidget(currentStep),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stepWidget(stepIndex) {
    Widget content;
    switch (stepIndex) {
      case 0:
        content = Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/aboutevent.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
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
                    child: Form(
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
                                FocusScope.of(context)
                                    .requestFocus(_eventDescriptionNode);
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Description",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
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
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 1:
        content = Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/date_picker.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date and Time",
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
                    child: Form(
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
                              onTap: () async {
                                DateTime selectedDate = (await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ))!;
                                eventDate = selectedDate;
                                _dateEditingController.text =
                                    DateFormat.yMMMd().format(eventDate);
                              },
                              // onSaved: (venue) {
                              //   setState(() {
                              //     eventVenue = venue.toString();
                              //   });
                              // },
                              focusNode: _eventDate,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Date",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              onFieldSubmitted: (date) {
                                // print(eventDate);
                                _eventDate.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_eventStartTime);
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _startTimeEditingController,
                              // onSaved: (desc) {
                              //   setState(() {
                              //     eventDesc = desc.toString();
                              //   });
                              // },
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
                                    _startTimeEditingController.text;
                              },
                              focusNode: _eventStartTime,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Start Time",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                print(eventStartTime);
                                _eventStartTime.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_eventEndTime);
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _endTimeEditingController,
                              // onSaved: (desc) {
                              //   setState(() {
                              //     eventDesc = desc.toString();
                              //   });
                              // },
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
                                eventEndTime = _startTimeEditingController.text;
                              },
                              focusNode: _eventEndTime,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "End Time",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                print(eventEndTime);
                                _eventStartTime.unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 2:
        content = Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/file_upload.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
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
                  PosterUpload(),
                ],
              ),
            ),
          ],
        );
        break;
      default:
        content = Text("Invalid");
        break;
    }
    return content;
  }
}
