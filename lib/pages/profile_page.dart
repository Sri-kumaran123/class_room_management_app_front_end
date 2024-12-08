import 'package:flutter/material.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Profile {
  String username;
  String email;
  String imageUrl;

  Profile({required this.username, required this.email, required this.imageUrl});
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final img ="https://www.example.com/profile.jpg";
 
  
  

  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
  }

  void _showEditProfileSheet(BuildContext context) {
     
    
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                   
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(img),
                ),
                // IconButton(
                //   icon: Icon(Icons.edit, color: Colors.blue),
                //   onPressed: () {
                //     // Implement change profile picture functionality here
                //   },
                // ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Username: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // IconButton(
                //   icon: Icon(Icons.edit, color: Colors.blue),
                //   onPressed: () {
                //     _showEditProfileSheet(context);
                //   },
                // ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}