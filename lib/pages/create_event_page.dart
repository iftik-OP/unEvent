import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/components/event_card.dart';
import 'package:unevent/components/unEventLoading.dart';
import 'package:unevent/providers/event_provider.dart';
import 'package:unevent/providers/user_provider.dart';
import 'package:unevent/services/event_services.dart';
import 'package:unevent/services/user_service.dart';

class CreateEventPage extends StatefulWidget {
  final String fest;
  const CreateEventPage({super.key, required this.fest});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  String _dateTime =
      '${DateTime.now().hour}:${DateTime.now().minute} | ${DateTime.now().day}-${DateTime.now().month}';
  File? image;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Title');
    _locationController = TextEditingController(text: 'Location');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<String> createEvent(User currentUser, Event event) async {
    unEventLoading.showLoadingDialog(context);
    if (image != null) {
      String fileName = '${currentUser.email}${DateTime.now()}';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("event_images/$fileName");
      UploadTask uploadTask;

      uploadTask = ref.putFile(image as File);

      await uploadTask.whenComplete(() => null);
      // Get the download URL and return it
      String photoURL = await ref.getDownloadURL();
      event.image = photoURL;
    }
    EventServices eventServices = EventServices();
    UserService userService = UserService();
    final id = await eventServices.createEvent(event);
    currentUser.createdEvents.add(id!);
    await userService.updateCreatedEvents(
        currentUser.createdEvents, currentUser.id);
    unEventLoading.hideLoadingDialog(context);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    Event event = Event(
      description: _descriptionController.text,
      title: _titleController.text,
      id: '',
      dateTime: _date,
      eventOwner: currentUser!.email,
      image: image,
      location: _locationController.text,
      fest: widget.fest,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Create New Event'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (_titleController.text == 'Title' ||
                          _titleController.text.isEmpty) {
                        return 'Please enter title for your event';
                      }
                    },
                    onChanged: (change) {
                      setState(() {});
                    },
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    style: const TextStyle(
                        fontFamily: 'Akira',
                        color: Color(0xffE83094),
                        fontSize: 35),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: (change) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (_locationController.text.isEmpty ||
                          _locationController.text == 'Location') {
                        return 'please enter location for your event';
                      }
                    },
                    controller: _locationController,
                    style: const TextStyle(fontFamily: 'Akira', fontSize: 15),
                    decoration: const InputDecoration(
                        labelText: 'Location',
                        suffixIcon: FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: Color(0xFF41E4A9),
                          size: 20,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      picker.DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2025), onConfirm: (date) {
                        setState(() {
                          _date = date;
                          String formattedDate =
                              DateFormat('kk:mm | dd-MM').format(date);
                          _dateTime = formattedDate;
                        });
                      },
                          currentTime: DateTime.now(),
                          locale: picker.LocaleType.en);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dateTime,
                          style: const TextStyle(
                              fontFamily: 'Akira', fontSize: 20),
                        ),
                        const FaIcon(
                          FontAwesomeIcons.calendarCheck,
                          color: Color(0xFF41E4A9),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    minLines: 5,
                    validator: (value) {
                      if (_descriptionController.text.isEmpty) {
                        return 'Please enter a description for your event';
                      }
                    },
                    controller: _descriptionController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                        hintText: 'Description for the event',
                        suffixIcon: FaIcon(
                          FontAwesomeIcons.alignLeft,
                          color: Color(0xFF41E4A9),
                          size: 20,
                        )),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Center(
                    child: Text(
                      'Event Preview',
                      style: TextStyle(
                          fontFamily: 'Akira',
                          fontSize: 15,
                          color: Color(0xffE83094)),
                    ),
                  ),
                  EventCard(event: event),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        pickImage();
                      },
                      child: const Text('Change Picture'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final id = await createEvent(currentUser, event);
                          currentUser.createdEvents.add(id);
                          final eventsFuture =
                              await Provider.of<EventProvider>(context)
                                  .allEvents;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF41E4A9),
                        elevation: 2, // Set elevation to 0
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Border radius
                          // Border color
                        ),
                      ),
                      child: const Text(
                        'Create Event',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
