import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unevent/classes/member.dart';
import 'package:unevent/services/committee_services.dart';

class CommitteeProvider extends ChangeNotifier {
  late Future<List<Member>>? _members;
  Future<List<Member>>? get allMembers => _members;

  Future<void> loadMembers() async {
    _members = CommitteeServices().fetchMembers();
  }
}
