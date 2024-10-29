import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unevent/classes/member.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/services/user_service.dart';

class CommitteeServices {
  final CollectionReference techCommitteeCollection = FirebaseFirestore.instance
      .collection('committees')
      .doc('TC')
      .collection('members');

  Future<Member?> addOrUpdateMember(User user, String designation) async {
    DocumentReference memberDoc = techCommitteeCollection.doc(user.email);

    // Create a map for the new member
    Map<String, dynamic> newMember = {
      'name': user.name,
      'designation': designation,
      'photoURL': user.photoURL,
    };

    UserService().updateDesignation(designation, user.id);
    // Update the member document
    await memberDoc.set(newMember, SetOptions(merge: true));
    return Member(
        name: user.name,
        email: user.email!,
        photoURL: user.photoURL!,
        designation: designation);
  }

  Future<void> removeMember(Member member) async {
    try {
      DocumentReference memberDoc = techCommitteeCollection.doc(member.email);
      await memberDoc.delete();
      print('Member ${member.email} removed successfully');
    } catch (e) {
      print('Error removing member: $e');
    }
  }

  Future<List<Member>> fetchMembers() async {
    List<Member> members = [];
    try {
      QuerySnapshot querySnapshot = await techCommitteeCollection.get();
      for (var doc in querySnapshot.docs) {
        Member member =
            Member.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        members.add(member);
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
    return members;
  }
}
