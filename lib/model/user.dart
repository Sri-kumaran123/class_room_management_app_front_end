import 'dart:convert';

class User{
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;
  final List<dynamic> classes;

  User({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password, 
    required this.token,
    this.classes = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name':name,
      'email':email,
      'token':token,
      'password':password,
      'classes':classes
    };
  }

  factory User.fromMap(Map<String, dynamic> map){
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      classes: map['classes'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}