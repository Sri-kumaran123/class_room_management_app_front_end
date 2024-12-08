import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class CodeDisplayPage extends StatelessWidget {
  final String adminCode;
  final String memberCode;
  final String className;
  final String id;

  

  CodeDisplayPage({
    required this.adminCode,
    required this.memberCode,
    required this.className,
    this.id =''
  });

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Display'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Class Name
            Center(
              child: Text(
                'Class: $className',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Admin Code Section
            _buildCodeRow(
              context,
              title: 'Admin Code',
              code: adminCode,
            ),
            SizedBox(height: 20),
            // Member Code Section
            _buildCodeRow(
              context,
              title: 'Member Code',
              code: memberCode,
            ),
            SizedBox(height: 20),
             
            
            Spacer(),
            // OK/Done Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the page
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.teal,
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeRow(BuildContext context, {required String title, required String code}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => copyToClipboard(context, code),
              icon: Icon(Icons.copy, color: Colors.teal),
              tooltip: 'Copy $title',
            ),
          ],
        ),
      ),
    );
  }
}

class UploadMaterialPage {
}
