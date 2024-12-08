//import 'dart:convert';



import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_conference_app/model/classes.dart';
//import 'package:my_conference_app/model/user.dart';
import 'package:my_conference_app/pages/assignment_page.dart';
import 'package:my_conference_app/pages/chat_screen.dart';
import 'package:my_conference_app/pages/classsttings_page.dart';
//import 'package:my_conference_app/pages/codedisplay_page.dart';
import 'package:my_conference_app/pages/teacherstudentlist_page.dart';
import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/services/workingwithclass_service.dart';
//import 'package:my_conference_app/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
//import 'package:skeleton_loader/skeleton_loader.dart';



class ClassroomHomePage extends StatefulWidget {
  @override
  _ClassroomHomePageState createState() => _ClassroomHomePageState();
}

class _ClassroomHomePageState extends State<ClassroomHomePage> {
  
  

  

  static Future<List<Classes>> fectclasses(BuildContext context) async {
  CreateClasses check = CreateClasses();

  List<Classes> classes = [];

  try {
    // Await the result of `retiveclass`
    List<Map<String, dynamic>> classesJson = await check.retiveclass(context: context);

    // Convert each JSON object into a `Classes` instance
    for (var classJson in classesJson) {
      classes.add(Classes.fromJson(classJson));
    }
  } catch (e) {
    // Handle potential errors
    debugPrint('Error fetching classes: $e');
  }

  return classes;
}
  void _showJoinCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose an option',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.group_add, color: Colors.blueAccent),
                title: Text("Join Class"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/joinclass');
                },
              ),
              ListTile(
                leading: Icon(Icons.create, color: Colors.blueAccent),
                title: Text("Create Class"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/createclass');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteClass(int index) {
    setState(() {
      
    });
  }

  void _logout( BuildContext context) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
  }
  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Class"),
        content: Text("Are you sure you want to delete this class?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
              _deleteClass(index);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Classes>> _classes =fectclasses(context);
    
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
         SliverAppBar(
            bottom:PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                height: 6.0,
                alignment: Alignment.center,
                decoration:const BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)
                  )
                ),
              ),
            ),
            expandedHeight: 200.0, // Height when expanded
            floating: false, // Don't float
            pinned: true, // Keep the app bar pinned
            backgroundColor: Colors.blue, // Blue color for the app bar
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Classroom', style: TextStyle(fontSize: 20,color: Colors.white),),
              background: Image.network(
                'https://th.bing.com/th/id/OIP.8x6PAb7DlG9akm_RvLkt-wHaD4?w=318&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7', 
                fit: BoxFit.cover,
              ),
              titlePadding: EdgeInsets.all(16),
            ),
            actions: [
              // Profile Icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25, // Small profile icon
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon:Icon(Icons.person,size: 30,),
                    color: Colors.blue,
                    onPressed: (){
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ),
              ),
              // Logout Button in action area
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    _showLogoutDialog(context); // Show logout confirmation dialog
                  },
                ),
              ),
            ],
          ),
          FutureBuilder<List<Classes>>(
            future: _classes,
            builder: (BuildContext context, AsyncSnapshot<List<Classes>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text('No classes available')),
                );
              } else {
                List<Classes> classes = snapshot.data!;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ClassroomCard(
                        title: classes[index].name,
                        description: classes[index].description,
                        id: classes[index].id,
                        assign: classes[index].assignments,
                        mat: classes[index].material,
                        adminCode: classes[index].admincode,
                        memberCode: classes[index].membercode,
                        onDelete: () => _showDeleteConfirmation(context, index),
                        classd: classes[index],
                      );
                    },
                    childCount: classes.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showJoinCreateOptions(context);
        },
        child: Icon(Icons.add, size: 32), 
        backgroundColor: Colors.blueAccent, 
        elevation: 10, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        tooltip: 'Join or Create Class',
        foregroundColor: Colors.white,
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action
                //Navigator.of(context).pop(); // Close dialog
                // You can navigate to a login screen or clear session data
                // For example: Navigator.pushReplacementNamed(context, '/login');
                Navigator.pushNamed(context, '/logout');
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

class ClassroomCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onDelete;
  final String id;
  final List<String> assign;
  final List<String> mat;
  final String adminCode;
  final String memberCode;
  final Classes classd;
  

  const ClassroomCard({
    required this.title,
    required this.description,
    required this.onDelete,
    required this.id,
    required this.assign,
    required this.mat,
    required this.adminCode,
    required this.memberCode,
    required this.classd,
   
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Action to open class details
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            //color: Colors.blueAccent.shade100.withOpacity(0.2),
            gradient: LinearGradient(
              colors: [
                 Colors.lightBlue ,
                Colors.blue,  
                Colors.lightBlue     // A deeper shade of blue
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.announcement, color: Colors.white),
                    onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(classid: classd.id,user: user,),
                      ),
                    );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.assignment, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentsMaterialsPage(assign:assign,id: id,mat: mat,),
                      ),
                    );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.people, color: Colors.white),
                    onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherStudentListPage(member: classd.members, admin: classd.admin),
                      ),
                     );
                    },
                  ),
                 !classd.members.contains(user.id)
                  ? IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassSettingsPage(classdata: classd),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

