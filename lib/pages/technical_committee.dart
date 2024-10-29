import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unevent/classes/member.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/components/app_bar.dart';
import 'package:unevent/providers/committee_provider.dart';
import 'package:unevent/providers/user_provider.dart';
import 'package:unevent/services/committee_services.dart';
import 'package:unevent/services/user_service.dart';

class TechnicalCommittee extends StatefulWidget {
  const TechnicalCommittee({super.key});

  @override
  State<TechnicalCommittee> createState() => _TechnicalCommitteeState();
}

class _TechnicalCommitteeState extends State<TechnicalCommittee> {
  User? searchedUser;

  void _showAddMemberDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    String? selectedDesignation;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('New Member'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Enter email',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            // Handle the search action
                            String email = emailController.text;
                            if (email.endsWith('@bitmesra.ac.in')) {
                              UserService userService = UserService();
                              final User? user =
                                  await userService.checkIfUserExists(email);
                              if (user != null) {
                                setState(() {
                                  searchedUser = user;
                                  selectedDesignation =
                                      null; // Reset the designation
                                });
                              } else {
                                setState(() {
                                  searchedUser = null;
                                  selectedDesignation = null;
                                });
                              }
                            }
                            // Perform the search or any other action with the email
                            print('Email entered: $email');
                          },
                        ),
                      ],
                    ),
                    if (searchedUser != null)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(searchedUser!.photoURL!),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        searchedUser!.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(searchedUser!.email!),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedDesignation,
                              hint: Text('Select designation'),
                              onChanged: (value) {
                                setState(() {
                                  selectedDesignation = value;
                                });
                              },
                              items: [
                                'Head Coordinator',
                                'Coordinator',
                                'Jr. Coordinator',
                                'Volunteer'
                              ].map((String designation) {
                                return DropdownMenuItem<String>(
                                  value: designation,
                                  child: Text(designation),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: searchedUser != null && selectedDesignation != null
                      ? () async {
                          // Add the user action
                          CommitteeServices committeeServices =
                              CommitteeServices();
                          await committeeServices.addOrUpdateMember(
                              searchedUser!, selectedDesignation!);
                          // Fetch the updated members list

                          Fluttertoast.showToast(
                              msg:
                                  "Member is added. It will reflect the changes after few minutes",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 12.0);
                          Navigator.of(context).pop('refresh');
                        }
                      : null,
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _refresh() async {
    setState(() async {
      await Provider.of<CommitteeProvider>(context).loadMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = Provider.of<CommitteeProvider>(context).allMembers;
    final currentUser = Provider.of<UserProvider>(context).user;
    print(currentUser!.designation);
    return Scaffold(
        // appBar: unEventAppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'The\nTechnical\nCommittee',
                  style: TextStyle(fontFamily: 'Akira', fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: members,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Some Error Occurred'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No Member Found'),
                        );
                      }
                      final allMembers = snapshot.data;
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemCount: allMembers!.length,
                          itemBuilder: (context, index) {
                            Member member = allMembers[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFF41E4A9).withOpacity(0.6),
                                    width: 2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(member.photoURL),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          member.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(member.designation),
                                      ],
                                    ),
                                  ),
                                  currentUser.designation ==
                                              'Head Coordinator' ||
                                          currentUser.designation ==
                                              'Coordinator'
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () async {
                                            // Implement the remove action here
                                            try {
                                              CommitteeServices
                                                  committeeServices =
                                                  CommitteeServices();
                                              await committeeServices
                                                  .removeMember(member);

                                              setState(() {
                                                Provider.of<CommitteeProvider>(
                                                        context,
                                                        listen: false)
                                                    .loadMembers();
                                              });
                                              Fluttertoast.showToast(
                                                  msg: "Member Removed",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 12.0);
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                  msg: "Error: $e",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 12.0);
                                            }
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: currentUser.designation == 'Head Coordinator' ||
                currentUser.designation == 'Coordinator'
            ? FloatingActionButton(
                onPressed: () {
                  _showAddMemberDialog(context);
                },
                child: FaIcon(FontAwesomeIcons.plus),
              )
            : SizedBox());
  }
}
