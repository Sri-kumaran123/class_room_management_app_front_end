import 'package:flutter/material.dart';
import 'package:my_conference_app/services/workingwithuserlist_service.dart';

class TeacherStudentListPage extends StatelessWidget {
  
  final member;
  final admin;
  TeacherStudentListPage({
    required this.member,
    required this.admin,
  });

  static Future<List<Map<String,String>>> fetchpeople(
    BuildContext context,
    List<dynamic> list,
  ) async {
    final GetPeopleService ss = GetPeopleService();
    try{
        List<Map<String,String>> peoplejson = await ss.getNameList(context: context, peoplelist: list);
        return peoplejson;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String,String>>> fetchpeople2(
    BuildContext context,
    List<dynamic> list,
  ) async {
    final GetPeopleService ss = GetPeopleService();
    try{
        List<Map<String,String>> peoplejson = await ss.getNameList(context: context, peoplelist: list);
        return peoplejson;
    } catch (e) {
      return [];
    }
  }
 

  @override
  Widget build(BuildContext context) {

    Future<List<Map<String,String>>> _student =fetchpeople(context, member);
    Future<List<Map<String,String>>> _teacher =fetchpeople2(context, admin);
    return Scaffold(
      appBar: AppBar(
        title: Text('Classroom'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teachers',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
  future: _teacher,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (snapshot.hasData) {
      final teacher = snapshot.data!;
      return ListView.builder(
        itemCount: teacher.length,
        itemBuilder: (context, index) {
          return UserCard(
            name: teacher[index]["name"] ?? "",
            role: "Mentor",
            avatarUrl: teacher[index]["avatarUrl"] ?? "",
          );
        },
      );
    } else {
      return Center(child: Text("No data found."));
    }
  },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Students',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
  future: _student,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (snapshot.hasData) {
      final students = snapshot.data!;
      return ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return UserCard(
            name: students[index]["name"] ?? "",
            role: "Student",
            avatarUrl: students[index]["avatarUrl"] ?? "",
          );
        },
      );
    } else {
      return Center(child: Text("No data found."));
    }
  },
              )
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String role;
  final String avatarUrl;

  const UserCard({
    required this.name,
    required this.role,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
         // backgroundImage: 
        ),
        title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(role, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.blueAccent,
        ),
        onTap: () {
          // You can add navigation functionality here to go to user detail page
        },
      ),
    );
  }
}
