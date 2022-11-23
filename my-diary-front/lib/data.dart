import 'dart:async';

class DiaryUser {
  int id;
  String email;
  String name;
  String role;

  DiaryUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory DiaryUser.fromJson(Map<String, dynamic> json) {
    return DiaryUser(
        id: json['id'],
        email: json['email'],
        name: json['username'],
        role: json['role']);
  }
}

class DiaryStream {
  late StreamController<String> _controller;

  DiaryStream init() {
    _controller = StreamController();
    return this;
  }

  void addEvent(String event) {
    _controller.add(event);
  }

  Stream<String> getStream() {
    return _controller.stream;
  }
}