import 'dart:convert';

class Classes {
  String id;
  String name;
  String description;
  String admincode;
  String membercode;
  List<String> admin;
  List<String> members;
  List<String> assignments;
  List<String> material;// Can be changed based on structure of assignments
  

  Classes({
    required this.id,
    required this.name,
    required this.description,
    required this.admincode,
    required this.membercode,
    required this.admin,
    required this.members,
    required this.assignments,
    required this.material
    
  });

  // From JSON
  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      admincode: json['admincode'],
      membercode: json['membercode'],
      admin: List<String>.from(json['admin']),
      members: List<String>.from(json['members']),
      assignments: List<String>.from(json['assignments']),
      material: List<String>.from(json['material']), // Adjust if assignments have a nested structure
      
    );
  }

  // To JSON
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'admincode': admincode,
      'membercode': membercode,
      'admin': admin,
      'members': members,
      'assignments': assignments,
     
    };
  }

  String toJson() => json.encode(toMap());
}
