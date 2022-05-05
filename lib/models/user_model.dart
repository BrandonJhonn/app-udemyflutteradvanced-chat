
class User {
  final String uid;
  final String name;
  final String email;
  final bool onLine;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.onLine = false
  });
}