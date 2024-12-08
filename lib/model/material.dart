

class Materialfunc {
  final String name;
  final String fileId;
  final DateTime createdAt;
  final String id;

  Materialfunc({
    required this.name,
    required this.fileId,
    required this.createdAt,
    this.id=''
  });

  // Factory method to create a FileUpload instance from JSON
  factory Materialfunc.fromJson(Map<String, dynamic> json) {
    return Materialfunc(
      name: json['name'],
      fileId: json['fileid'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      id:json['_id'], // Default to current time if not present
    );
  }

  // Method to convert FileUpload instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fileid': fileId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
