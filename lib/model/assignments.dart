

class TaskAss {
  final String title;
  final String description;
  final List<dynamic> submition; // Adjust type if needed
  final DateTime lastDate;
  final String id;
  final String classid;

  TaskAss({
    required this.title,
    required this.description,
    required this.submition,
    required this.lastDate,
     this.id ='',
     this.classid =''
  });

  
  factory TaskAss.fromJson(Map<String, dynamic> json) {
    return TaskAss(
      title: json['title'],
      description: json['description'],
      submition: json['submition'] ?? [],
      lastDate: DateTime.parse(json['lastdate']),
      id: json['_id'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'submition': submition,
      'lastdate': lastDate.toIso8601String(),
      '_id': id,
      'classid':classid,
    };
  }
}
