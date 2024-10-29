class Member {
  final String name;
  final String email;
  final String photoURL;
  final String designation;

  Member({
    required this.name,
    required this.email,
    required this.photoURL,
    required this.designation,
  });

  factory Member.fromMap(Map<String, dynamic> data, String email) {
    return Member(
      name: data['name'],
      email: email,
      photoURL: data['photoURL'],
      designation: data['designation'],
    );
  }
}
