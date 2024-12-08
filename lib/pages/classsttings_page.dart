import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_conference_app/model/classes.dart';
import 'package:my_conference_app/pages/create_assignment_page.dart';
import 'package:my_conference_app/pages/uploadmeterial_page.dart';



class ClassSettingsPage extends StatelessWidget {
  final Classes classdata;

  ClassSettingsPage({
    required this.classdata,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Settings'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Details Section
              Text(
                'Class Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildTextField('Class name (required)', 'Test'),
              SizedBox(height: 10),
              _buildTextField('Class description', ''),
             
              SizedBox(height: 20),
              
              // Invite Codes Section
              Text(
                'Invite Codes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              
              _buildCodeRow('Admin Code', classdata.admincode,context),
              SizedBox(height: 10),
              _buildCodeRow('Member Code', classdata.membercode,context),
              SizedBox(height: 20),

              // Navigation Buttons
              ListTile(
                title: Text('Add Material'),
                leading: Icon(Icons.book),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadFilePage(classid: classdata.id,)),
                  );
                },
              ),
              ListTile(
                title: Text('Add Assignment'),
                leading: Icon(Icons.assignment),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAssignmentPage(classid: classdata.id,)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  Widget _buildCodeRow(String title, String code,BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Text(code, style: TextStyle(color: Colors.grey)),
            SizedBox(width: 8),
            TextButton(onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Copied to clipboard!")),
            );
            }, child: Text('copy')),
          ],
        ),
      ],
    );
  }
}

