import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/services/event_services.dart';
import 'package:unevent/services/user_service.dart';

class ScanQRCode extends StatefulWidget {
  Event event;
  ScanQRCode({super.key, required this.event});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        title: Text(
          'Scan QR',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                MobileScanner(
                  controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates),
                  onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    print(barcodes.first.rawValue);
                    for (final barcode in barcodes) {
                      final String rawValue = barcode.rawValue ?? '';
                      // Assuming the format is "eventID|email"
                      final List<String> parts = rawValue.split('|');
                      if (parts.length == 2) {
                        final String eventId = parts[0];
                        final String email = parts[1];
                        print(widget.event.participants.contains(email));

                        if (widget.event.id == eventId) {
                          if (widget.event.participants.contains(email)) {
                            final tempUser =
                                await UserService().checkIfUserExists(email);
                            setState(() {
                              user = tempUser;
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "The ticket belongs to different event",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 12.0);
                        }
                        // Process the event ID and email as needed
                      }
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(color: Colors.green, width: 3.0),
                                left:
                                    BorderSide(color: Colors.green, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(color: Colors.green, width: 3.0),
                                right:
                                    BorderSide(color: Colors.green, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.green, width: 3.0),
                                left:
                                    BorderSide(color: Colors.green, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.green, width: 3.0),
                                right:
                                    BorderSide(color: Colors.green, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'Scan the QR to check-in user. Once checked-in the user cannot re-enter the event from the same ticket.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      user != null
                          ? Text(
                              'Name: ${user!.name}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )
                          : Text(
                              'Name:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                      Text(
                        'Event: ${widget.event.title}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Event Date: ${widget.event.dateTime.day}-${widget.event.dateTime.month}-${widget.event.dateTime.year}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: user != null
                              ? () async {
                                  widget.event.checkedins.add(user!.email!);
                                  await EventServices()
                                      .updateEventCheckedIns(widget.event);
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "User checked in",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 12.0);
                                }
                              : null,
                          child: Text('Check-in')),
                    ],
                  ),
                  Image.asset(
                    'Images/unevent black.png',
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
