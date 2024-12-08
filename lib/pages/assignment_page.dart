import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_conference_app/model/assignments.dart';
import 'package:my_conference_app/model/material.dart';
import 'package:my_conference_app/pages/assignmentsubmit_page.dart';
import 'package:my_conference_app/services/workingwithassignment_service.dart';
import 'package:my_conference_app/services/workingwithmatterial_service.dart';

class AssignmentsMaterialsPage extends StatelessWidget {
  final String id;
  final List<String> assign;
  final List<String> mat;
  

  AssignmentsMaterialsPage({
    required this.id,
    required this.assign,
    required this.mat,
  });

  // Fetch assignments
  static Future<List<TaskAss>> fetchAssign(
      BuildContext context, String classid, List<String> assignmentsArr) async {
    AssignmentService assService = AssignmentService();
    List<TaskAss> assignments = [];
    try {
      List<Map<String, dynamic>> assignmentJson = await assService.retiveAssignments(
        context: context,
        classid: classid,
        assignments: assignmentsArr,
      );
      assignments = assignmentJson.map((json) => TaskAss.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching assignments: $e");
    }
    return assignments;
  }

  static Future<List<Materialfunc>> fetchMat(
    BuildContext context, String classid, List<String> MatArr) async {
    MaterialService materialService = MaterialService();
    List<Materialfunc> materials= [];
    try {
      List<Map<String, dynamic>> materialJson = await materialService.retriveMaterial(
        context: context, 
        classid: classid, 
        materials: MatArr
      );
      materials = materialJson.map((json) => Materialfunc.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching assignments: $e");
    }
    return materials;
  }

 

  @override
  Widget build(BuildContext context) {
    Future<List<TaskAss>> _assignments = fetchAssign(context, id, assign);
    Future<List<Materialfunc>> _materials = fetchMat(context,  id, mat);

    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments and Materials'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Assignments section
            Text(
              'Assignments',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<TaskAss>>(
              future: _assignments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No assignments found"));
                } else {
                  return Column(
                    children: snapshot.data!.map((assignment) {
                      return AssignmentMaterialCard(
                        title: assignment.title,
                        description: assignment.description,
                        type: "Assignment",
                        // ignore: unnecessary_null_comparison
                        dueDate: assignment.lastDate != null
                            ? DateFormat('yyyy-MM-dd').format(assignment.lastDate)
                            : '',
                        assid:assignment.id,
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            // Materials section
            Text(
              'Materials',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
             FutureBuilder<List<Materialfunc>>(
              future: _materials,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No assignments found"));
                } else {
                  return Column(
                    children: snapshot.data!.map((material) {
                      return AssignmentMaterialCard(
                        title: material.name,
                        description: '',
                        type: "Material",
                        // ignore: unnecessary_null_comparison
                        dueDate: material.createdAt != null
                            ? DateFormat('yyyy-MM-dd').format(material.createdAt)
                            : '',
                        fileid: material.fileId,
                        matid: material.id,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentMaterialCard extends StatelessWidget {
  final MaterialService mats= MaterialService();
  final String title;
  final String description;
  final String type;
  final String dueDate;
  final String fileid;
  final String? matid;
  final String? assid;

  AssignmentMaterialCard({
    required this.title,
    required this.description,
    required this.type,
    this.dueDate = '',
    this.fileid='',
    this.matid=null,
    this.assid=null,
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
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            if (type == "Assignment")
              SizedBox(height: 5),
            if (type == "Assignment")
              Text(
                'Due: $dueDate',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
        onTap: () {
          if(type=="Material"){
              mats.downloadFile('download', matid!);
          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: 
                (context)  => SubmitAssignmentPage(assid: assid!)
              )
            );
          }
          // Add navigation or functionality for tapping the card here.
        },
      ),
    );
  }
}
