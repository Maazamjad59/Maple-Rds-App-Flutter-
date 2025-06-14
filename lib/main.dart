import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/Curriculum.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/Announcement.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/src/services/asset_bundle.dart';
import 'dart:typed_data';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,  // Ensure this is not null
    );
    runApp(SchoolManagementApp());
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
}

class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopView();
        } else if (constraints.maxWidth > 800) {
          return TabletView();
        } else {
          return MobileView();
        }
      },
    );
  }
}

// Define these views below
class DesktopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 250,
            color: Colors.red.shade700,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  'Maple RDS Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildMenuItem(Icons.dashboard, "Dashboard"),
                _buildMenuItem(Icons.school, "Students"),
                _buildMenuItem(Icons.people, "Faculty"),
                _buildMenuItem(Icons.schedule, "Attendance"),
                _buildMenuItem(Icons.book, "Curriculum"),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Stats Overview
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildStatCard("Total Students", "450", Icons.school),
                        _buildStatCard("Total Faculty", "25", Icons.people),
                        _buildStatCard("Attendance Today", "90%", Icons.schedule),
                        _buildStatCard("Ongoing Courses", "18", Icons.book),
                        _buildStatCard("Pending Fees", "\$12,000", Icons.money),
                        _buildStatCard("Events", "3 Upcoming", Icons.event),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Menu Item
  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onTap: () {}, // Add Navigation Logic Here
      ),
    );
  }

  // Stats Card Widget
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red.shade700),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

class TabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Maple RDS - Tablet')),
      body: Center(child: Text('This is the Tablet View')),
    );
  }
}

class MobileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Maple RDS - Mobile')),
      body: Center(child: Text('This is the Mobile View')),
    );
  }
}



class SchoolManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maple RDS Portal',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen_paper.png'), // Ensure this image is added to assets
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0), // Leaves space on left and right
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/Maple_logo-removebg-preview.png'), // Ensure this image is added to assets
                      radius: 100,

                    ),
                    SizedBox(height: 10),
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoadingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text('Don\'t have an account? Sign up', style: TextStyle(color: Colors.black87)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Maple_logo-removebg-preview.png',
              width: 300,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),  // Loading spinner
            SizedBox(height: 20),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Define a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pass the key to the Scaffold
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Main_wp2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildProfileWidget(),
            SizedBox(height: 5), // Reduced space for better alignment
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Today's Classes Section
                    _buildSectionHeading('TODAY CLASSES (3)'),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSectionContent([
                            _buildClassItem(
                                'The Basic of Typography II',
                                'Room C1, Faculty of Art & Design',
                                'Gabriel Sutton'),
                            _buildClassItem(
                                'Design Psychology: Principle of...',
                                'Room C1, Faculty of Art & Design',
                                'Jessie Reeves'),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    // Your Tasks Section
                    _buildSectionHeading('YOUR TASKS (4)'),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSectionContent([
                            _buildTaskItem('3 days left',
                                'The Basic of Typography II'),
                            _buildTaskItem('10 days left',
                                'Design Psychology: Principle of...'),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  // Profile Widget (Centered)
  Widget _buildProfileWidget() {
    return Container(
      margin: EdgeInsets.only(top: 270),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Picture (Centered)
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          SizedBox(height: 10), // Space between picture and text
          // Name and Role (Below the picture)
          Column(
            children: [
              Text(
                'Welcome, Maaz',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 4), // Space between name and role
              Text(
                'Your role: Admin',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section Heading Widget (Transparent)
  Widget _buildSectionHeading(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent, // Transparent background
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70, // White text for visibility
        ),
      ),
    );
  }

  // Section Content Widget
  Widget _buildSectionContent(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  // Class Item Widget
  Widget _buildClassItem(String title, String location, String instructor) {
    return ListTile(
      leading: Icon(Icons.schedule, color: Colors.blue),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            instructor,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to the Calendar Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      },
    );
  }

  // Task Item Widget
  Widget _buildTaskItem(String deadline, String task) {
    return ListTile(
      leading: Icon(Icons.assignment, color: Colors.red),
      title: Text(
        task,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        deadline,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  // Footer Buttons Widget
  Widget _buildFooterButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          _buildFooterButton('Faculty', Icons.people, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FacultyRecordsScreen(),
              ),
            );
          }),

          _buildFooterButton('Settings', Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          }),
          _buildFooterButton('Calendar', Icons.calendar_today, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarPage(),
              ),
            );
          }),
          _buildFooterButton('News Feed', Icons.newspaper_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsFeedScreen(),
              ),
            );
          }),

          // New button to open the side menu
          _buildFooterButton('Menu', Icons.menu, () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          }),
        ],
      ),
    );
  }

  // Footer Button Widget
  Widget _buildFooterButton(String title, IconData icon, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.blue),
          onPressed: onPressed,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Drawer Widget
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawerHeader.png'),
                scale: 3.0,
                fit: BoxFit.none,
              ),
            ),

            child: Align(
              alignment: Alignment.bottomCenter,  // Change alignment as needed
              child: Text(
                ' ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,  // Controls multi-line text alignment
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.school,color:Colors.blue),
            title: Text('Students'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentsDataScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.school,color:Colors.blue),
            title: Text('Attendance'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people,color:Colors.blue,),
            title: Text('Faculty'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacultyRecordsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book,color:Colors.blue),
            title: Text('Curriculum'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolCurriculumScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings,color:Colors.blue),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,color:Colors.blue),
            title: Text('Calendar'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper_outlined,color:Colors.blue),
            title: Text('News Feed'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsFeedScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people_alt,color:Colors.blue),
            title: Text('Registered Students'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisteredStudentsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Faculty Attendance Screen
              },
              child: Text('Faculty Attendance'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Student Attendance Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentAttendanceScreen()),
                );
              },
              child: Text('Student Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentAttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('students').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No students found.'));
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var student = students[index].data() as Map<String, dynamic>;

              // Get student name and attendance
              String studentName = student['personalDetails']['studentName'];
              String attendance = student['academicDetails']['attendance'].toString();

              // Check if the student has attendance data, if so, display
              if (attendance.isNotEmpty) {
                return ListTile(
                  title: Text(studentName),
                  subtitle: Text('Attendance: $attendance%'),
                );
              }

              return Container(); // Empty container if no attendance data
            },
          );
        },
      ),
    );
  }
}

class StudentAttendanceDetailsScreen extends StatefulWidget {
  final String studentName;

  StudentAttendanceDetailsScreen({required this.studentName});

  @override
  _StudentAttendanceDetailsScreenState createState() => _StudentAttendanceDetailsScreenState();
}

class _StudentAttendanceDetailsScreenState extends State<StudentAttendanceDetailsScreen> {
  Map<String, bool> attendance = {
    '2023-10-01': true,
    '2023-10-02': false,
    '2023-10-03': true,
    // Add more dates and attendance status here
  };

  void _updateAttendance(String date, bool isPresent) {
    setState(() {
      attendance[date] = isPresent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.studentName}\'s Attendance'),
      ),
      body: ListView.builder(
        itemCount: attendance.length,
        itemBuilder: (context, index) {
          String date = attendance.keys.elementAt(index);
          bool isPresent = attendance[date]!;
          return ListTile(
            title: Text(date),
            trailing: Checkbox(
              value: isPresent,
              onChanged: (value) {
                _updateAttendance(date, value!);
              },
            ),
          );
        },
      ),
    );
  }
}

class StudentsDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Data', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: Colors.black), // Set icon color to black
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/new_back.png'), // Ensure image exists in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button for Adding New Student
                _buildOptionButton(
                  context,
                  'Add New Student',
                  Icons.person_add,
                  AddStudentPage(),
                  Colors.red.withOpacity(0.5), // Semi-transparent red background
                ),
                SizedBox(height: 20),
                // Button for Showing Student Records
                _buildOptionButton(
                  context,
                  'Show Student Records',
                  Icons.list,
                  ShowStudentRecordsPage(),
                  Colors.green.withOpacity(0.5), // Semi-transparent green background
                ),
                SizedBox(height: 20),
                // Button for Updating Student Database
                _buildOptionButton(
                  context,
                  'Update Student Database',
                  Icons.edit,
                  UpdateStudentPage(),
                  Colors.blue.withOpacity(0.5), // Semi-transparent blue background
                ),
                SizedBox(height: 20),
                // Button for Generating Student Reports
                _buildOptionButton(
                  context,
                  'Generate Student Reports',
                  Icons.assignment,
                  GenerateReportsPage(),
                  Colors.orange.withOpacity(0.7), // Semi-transparent orange background
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, IconData icon, Widget page, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners for the button
        ),
        backgroundColor: color, // Set background color with opacity
        side: BorderSide(color: Colors.red, width: 2), // Optional: Red border outline
        elevation: 5, // Add shadow for the button
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white), // White icon color
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white), // White text color
          ),
        ],
      ),
    );
  }
}

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('students');

  // Controllers for text fields
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _studentAgeController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fatherOccupationController = TextEditingController();
  final TextEditingController _fatherPhoneController = TextEditingController();
  String _gender = 'Male'; // Default gender
  String _admissionStatus = 'Active'; // Default admission status

  void _addStudent() {
    String studentName = _studentNameController.text.trim();
    String motherName = _motherNameController.text.trim();
    String fatherName = _fatherNameController.text.trim();
    String studentAge = _studentAgeController.text.trim();
    String gradeLevel = _gradeLevelController.text.trim();
    String address = _addressController.text.trim();
    String fatherOccupation = _fatherOccupationController.text.trim();
    String fatherPhone = _fatherPhoneController.text.trim();

    if (studentName.isNotEmpty &&
        motherName.isNotEmpty &&
        fatherName.isNotEmpty &&
        studentAge.isNotEmpty &&
        gradeLevel.isNotEmpty &&
        address.isNotEmpty &&
        fatherOccupation.isNotEmpty &&
        fatherPhone.isNotEmpty) {
      _databaseRef.push().set({
        'studentName': studentName,
        'motherName': motherName,
        'fatherName': fatherName,
        'studentAge': studentAge,
        'gradeLevel': gradeLevel,
        'address': address,
        'fatherOccupation': fatherOccupation,
        'fatherPhone': fatherPhone,
        'gender': _gender,
        'admissionStatus': _admissionStatus, // Add admission status
      }).then((_) {
        print('Student added successfully');
        // Clear all fields after submission
        _studentNameController.clear();
        _motherNameController.clear();
        _fatherNameController.clear();
        _studentAgeController.clear();
        _gradeLevelController.clear();
        _addressController.clear();
        _fatherOccupationController.clear();
        _fatherPhoneController.clear();
      }).catchError((error) {
        print('Failed to add student: $error');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Admission Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Admission Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _studentNameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _motherNameController,
              decoration: InputDecoration(
                labelText: "Mother's Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _fatherNameController,
              decoration: InputDecoration(
                labelText: "Father's Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _studentAgeController,
              decoration: InputDecoration(
                labelText: 'Student Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _gradeLevelController,
              decoration: InputDecoration(
                labelText: 'Grade Level',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _fatherOccupationController,
              decoration: InputDecoration(
                labelText: "Father's Occupation",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _fatherPhoneController,
              decoration: InputDecoration(
                labelText: "Father's Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            Text(
              'Gender',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Radio(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Admission Status',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _admissionStatus,
              items: ['Active', 'Dormant', 'Inactive']
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _admissionStatus = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addStudent,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowStudentRecordsPage extends StatefulWidget {
  @override
  _ShowStudentRecordsPageState createState() => _ShowStudentRecordsPageState();
}

class _ShowStudentRecordsPageState extends State<ShowStudentRecordsPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('students');
  String _sortBy = 'studentName'; // Default sorting by student name

  // Sort students based on the selected criteria
  void _sortStudents(String criteria) {
    setState(() {
      _sortBy = criteria;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Records',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: Colors.black), // Set icon color to black
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortStudents,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'studentName',
                child: Text('Sort by Student Name'),
              ),
              PopupMenuItem(
                value: 'studentAge',
                child: Text('Sort by Student Age'),
              ),
              PopupMenuItem(
                value: 'gradeLevel',
                child: Text('Sort by Grade Level'),
              ),
              PopupMenuItem(
                value: 'admissionStatus',
                child: Text('Sort by Admission Status'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/School.png'), // Ensure image exists in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Firebase Animated List
          FirebaseAnimatedList(
            query: _databaseRef,
            sort: (a, b) {
              final aValue = a.value as Map<dynamic, dynamic>? ?? {};
              final bValue = b.value as Map<dynamic, dynamic>? ?? {};

              switch (_sortBy) {
                case 'studentName':
                  return (aValue['studentName'] ?? '').compareTo(bValue['studentName'] ?? '');
                case 'studentAge':
                  return (aValue['studentAge'] ?? '').compareTo(bValue['studentAge'] ?? '');
                case 'gradeLevel':
                  return (aValue['gradeLevel'] ?? '').compareTo(bValue['gradeLevel'] ?? '');
                case 'admissionStatus':
                  return (aValue['admissionStatus'] ?? '').compareTo(bValue['admissionStatus'] ?? '');
                default:
                  return 0;
              }
            },
            itemBuilder: (context, snapshot, animation, index) {
              final student = snapshot.value as Map<dynamic, dynamic>? ?? {};
              final key = snapshot.key;

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white.withOpacity(0.8), // Slight transparency on tiles
                child: ListTile(
                  title: Text(
                    student['studentName'] ?? 'No Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grade: ${student['gradeLevel'] ?? 'N/A'}'),
                      Text('Status: ${student['admissionStatus'] ?? 'N/A'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteStudent(key!);
                    },
                  ),
                  onTap: () {
                    _showStudentDetails(context, student);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Show student details in a dialog
  void _showStudentDetails(BuildContext context, Map<dynamic, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Student Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Student Name: ${student['studentName'] ?? 'N/A'}'),
                Text("Mother's Name: ${student['motherName'] ?? 'N/A'}"),
                Text("Father's Name: ${student['fatherName'] ?? 'N/A'}"),
                Text('Age: ${student['studentAge'] ?? 'N/A'}'),
                Text('Grade Level: ${student['gradeLevel'] ?? 'N/A'}'),
                Text('Address: ${student['address'] ?? 'N/A'}'),
                Text("Father's Occupation: ${student['fatherOccupation'] ?? 'N/A'}"),
                Text("Father's Phone: ${student['fatherPhone'] ?? 'N/A'}"),
                Text('Gender: ${student['gender'] ?? 'N/A'}'),
                Text('Admission Status: ${student['admissionStatus'] ?? 'N/A'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Delete a student
  void _deleteStudent(String key) {
    _databaseRef.child(key).remove().then((_) {
      print('Student deleted successfully');
    }).catchError((error) {
      print('Failed to delete student: $error');
    });
  }
}



class UpdateStudentPage extends StatefulWidget {
  @override
  _UpdateStudentPageState createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('students');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  void _updateStudent(String key) {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String grade = _gradeController.text.trim();

    if (name.isNotEmpty && age.isNotEmpty && grade.isNotEmpty) {
      _databaseRef.child(key).update({
        'name': name,
        'age': age,
        'grade': grade,
      }).then((_) {
        print('Student updated successfully');
        _nameController.clear();
        _ageController.clear();
        _gradeController.clear();
      }).catchError((error) {
        print('Failed to update student: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update logic will be handled when a student is selected
              },
              child: Text('Update Student'),
            ),
          ],
        ),
      ),
    );
  }
}



class GenerateReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Student Reports'),
      ),
      body: Center(
        child: Text(
          'Student Reports will be generated here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}



class FacultyRecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows the background to extend under the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        title: Text(
          'Faculty Records',
          style: TextStyle(
            color: Colors.black, // Make title text black
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Make icons black
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/School.png', // Change to your actual image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionButton(
                  context, 'Add New Employee', Icons.person_add, Colors.blue, AddEmployeePage(),
                ),
                SizedBox(height: 20),
                _buildOptionButton(
                  context, 'Update Employee Record', Icons.edit, Colors.orange, EmployeeListPage(),
                ),
                SizedBox(height: 20),
                _buildOptionButton(
                  context, 'Employee List', Icons.list, Colors.green, EmployeeListPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20),
        backgroundColor: color.withOpacity(0.8), // Slightly transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        shadowColor: Colors.black45,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  String _employmentStatus = 'Active'; // Default status

  List<Map<String, String>> _workExperience = [];
  List<Map<String, String>> _educationHistory = [];

  void _addEmployee() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('employees').add({
          'name': _nameController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'title': _titleController.text,
          'department': _departmentController.text,
          'employmentStatus': _employmentStatus, // Add employment status
          'salary': _salaryController.text, // Add salary field
          'workExperience': _workExperience,
          'educationHistory': _educationHistory,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add employee: $e')),
        );
      }
    }
  }

  void _addWorkExperience() {
    setState(() {
      _workExperience.add({'skill': '', 'certification': ''});
    });
  }

  void _addEducation() {
    setState(() {
      _educationHistory.add({'degree': '', 'institution': '', 'year': ''});
    });
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white.withOpacity(0.7), // Transparent background for tiles
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Employee', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/School.png', // Change to your actual image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildSection('Personal Information', [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Full Name'),
                        validator: (value) => value!.isEmpty ? 'Enter name' : null,
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ]),
                    _buildSection('Current Employment Details', [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Position'),
                      ),
                      TextFormField(
                        controller: _departmentController,
                        decoration: InputDecoration(labelText: 'Department'),
                      ),
                      TextFormField(
                        controller: _salaryController,
                        decoration: InputDecoration(labelText: 'Salary'),
                        keyboardType: TextInputType.number,
                      ),
                      DropdownButtonFormField<String>(
                        value: _employmentStatus,
                        items: ['Active', 'Non-Active']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (value) => setState(() => _employmentStatus = value!),
                        decoration: InputDecoration(labelText: 'Employment Status'),
                      ),
                    ]),
                    _buildSection('Work Experience', [
                      ..._workExperience.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Skill'),
                              onChanged: (value) => _workExperience[index]['skill'] = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Certification'),
                              onChanged: (value) => _workExperience[index]['certification'] = value,
                            ),
                          ],
                        );
                      }).toList(),
                      TextButton(onPressed: _addWorkExperience, child: Text('Add Work Experience')),
                    ]),
                    _buildSection('Education History', [
                      ..._educationHistory.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Degree'),
                              onChanged: (value) => _educationHistory[index]['degree'] = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Institution'),
                              onChanged: (value) => _educationHistory[index]['institution'] = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Graduation Year'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _educationHistory[index]['year'] = value,
                            ),
                          ],
                        );
                      }).toList(),
                      TextButton(onPressed: _addEducation, child: Text('Add Education')),
                    ]),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addEmployee,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateEmployeePage extends StatefulWidget {
  final String employeeKey;

  UpdateEmployeePage({required this.employeeKey});

  @override
  _UpdateEmployeePageState createState() => _UpdateEmployeePageState();
}

class _UpdateEmployeePageState extends State<UpdateEmployeePage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('employees');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    try {
      DataSnapshot snapshot = await _databaseRef.child(widget.employeeKey).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> employeeData = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _nameController.text = employeeData['name'] ?? '';
          _ageController.text = employeeData['age'] ?? '';
          _positionController.text = employeeData['position'] ?? '';
        });
      }
    } catch (e) {
      print('Failed to fetch employee data: $e');
    }
  }

  void _updateEmployee() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String age = _ageController.text.trim();
      String position = _positionController.text.trim();

      _databaseRef.child(widget.employeeKey).update({
        'name': name,
        'age': age,
        'position': position,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee updated successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        print('Failed to update employee: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update employee: $error')),
        );
      });
    }
  }

  void _generatePDF() async {
    final pdf = pw.Document();
    final employeeData = {
      'Name': _nameController.text,
      'Age': _ageController.text,
      'Position': _positionController.text,
    };

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Employee Details', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              ...employeeData.entries.map((entry) {
                return pw.Text('${entry.key}: ${entry.value}');
              }).toList(),
            ],
          );
        },
      ),
    );

    // Save the PDF and open the print dialog
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Update Employee', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/School.png'), // Ensure image is available in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 400, // Adjust width for better centering
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Prevent unnecessary stretching
                    children: [
                      _buildSection('Employee Information', [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Full Name'),
                          validator: (value) => value!.isEmpty ? 'Enter name' : null,
                        ),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? 'Enter age' : null,
                        ),
                        TextFormField(
                          controller: _positionController,
                          decoration: InputDecoration(labelText: 'Position'),
                          validator: (value) => value!.isEmpty ? 'Enter position' : null,
                        ),
                      ]),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateEmployee,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Update Employee',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _generatePDF,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Print Employee Data',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 5,
      color: Colors.white.withOpacity(0.85), // Slight transparency
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class EmployeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Image
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/School.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Transparent Header
            AppBar(
              title: Text(
                'Employee List',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0, // Remove the shadow for a fully transparent effect
            ),
            // Employee List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                builder: (context, snapshot) {
                  // Show loading indicator when data is being fetched
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Show error message if any
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Show empty state if no employees are found
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No employees found.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    );
                  }

                  // Fetch and sort employees by employment status
                  var employees = snapshot.data!.docs;
                  employees.sort((a, b) {
                    var aStatus = (a.data() as Map<String, dynamic>)['employmentStatus'] ?? 'Non-Active';
                    var bStatus = (b.data() as Map<String, dynamic>)['employmentStatus'] ?? 'Non-Active';
                    // Sort Active employees first
                    if (aStatus == 'Active' && bStatus != 'Active') return -1;
                    if (aStatus != 'Active' && bStatus == 'Active') return 1;
                    return 0; // If both have the same status
                  });

                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      var employee = employees[index];
                      var employeeData = employee.data() as Map<String, dynamic>;
                      String name = employeeData['name'] ?? 'No Name';
                      String title = employeeData['title'] ?? 'No Title';
                      String department = employeeData['department'] ?? 'No Department';
                      String email = employeeData['email'] ?? 'No Email';
                      String phone = employeeData['phone'] ?? 'No Phone';
                      String employmentStatus = employeeData['employmentStatus'] ?? 'Non-Active';

                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white.withOpacity(0.8), // Slightly transparent background for tiles
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: employmentStatus == 'Active' ? Colors.green : Colors.red,
                            child: Text(
                              name[0], // Display the first letter of the name
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Title: $title'),
                              Text('Department: $department'),
                              Text('Email: $email'),
                              Text('Phone: $phone'),
                              Text(
                                'Status: $employmentStatus',
                                style: TextStyle(
                                  color: employmentStatus == 'Active' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateEmployeePage(employeeKey: employee.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SchoolCurriculumScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Curriculum'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCurriculumPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('curriculum').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No curriculum found.'));
          }

          final curriculumList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: curriculumList.length,
            itemBuilder: (context, index) {
              final curriculum = Curriculum.fromMap(
                curriculumList[index].data() as Map<String, dynamic>,
                curriculumList[index].id,
              );

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(curriculum.subject),
                  subtitle: Text('Grade: ${curriculum.gradeLevel}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateCurriculumPage(
                                curriculumId: curriculum.id,
                                curriculumData: curriculum.toMap(),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteCurriculum(curriculum.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteCurriculum(String curriculumId) async {
    try {
      await _firestore.collection('curriculum').doc(curriculumId).delete();
      print('Curriculum deleted successfully');
    } catch (e) {
      print('Failed to delete curriculum: $e');
    }
  }
}

class AddCurriculumPage extends StatefulWidget {
  @override
  _AddCurriculumPageState createState() => _AddCurriculumPageState();
}

class _AddCurriculumPageState extends State<AddCurriculumPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _academicYearController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addCurriculum() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('curriculum').add({
          'subject': _subjectController.text,
          'gradeLevel': _gradeLevelController.text,
          'description': _descriptionController.text,
          'academicYear': _academicYearController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Curriculum added successfully')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add curriculum: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Curriculum'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subject';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gradeLevelController,
                  decoration: InputDecoration(labelText: 'Grade Level'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the grade level';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: _academicYearController,
                  decoration: InputDecoration(labelText: 'Academic Year'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the academic year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addCurriculum,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateCurriculumPage extends StatefulWidget {
  final String curriculumId;
  final Map<String, dynamic> curriculumData;

  UpdateCurriculumPage({required this.curriculumId, required this.curriculumData});

  @override
  _UpdateCurriculumPageState createState() => _UpdateCurriculumPageState();
}

class _UpdateCurriculumPageState extends State<UpdateCurriculumPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _academicYearController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing curriculum data
    _subjectController.text = widget.curriculumData['subject'] ?? '';
    _gradeLevelController.text = widget.curriculumData['gradeLevel'] ?? '';
    _descriptionController.text = widget.curriculumData['description'] ?? '';
    _academicYearController.text = widget.curriculumData['academicYear'] ?? '';
  }

  void _updateCurriculum() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('curriculum').doc(widget.curriculumId).update({
          'subject': _subjectController.text,
          'gradeLevel': _gradeLevelController.text,
          'description': _descriptionController.text,
          'academicYear': _academicYearController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Curriculum updated successfully')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update curriculum: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Curriculum'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subject';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gradeLevelController,
                  decoration: InputDecoration(labelText: 'Grade Level'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the grade level';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: _academicYearController,
                  decoration: InputDecoration(labelText: 'Academic Year'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the academic year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateCurriculum,
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceStatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Attendance Stats')));
  }
}

class NewsFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'News Feed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/School.png', // Background image path
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // News Feed Content
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('announcements')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No announcements found.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              final announcements = snapshot.data!.docs.map((doc) {
                return Announcement.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();

              return LayoutBuilder(
                builder: (context, constraints) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      // If there are fewer announcements, center them
                      double spacing = (announcements.length < 3)
                          ? (constraints.maxHeight / 3)
                          : 16;

                      return Padding(
                        padding: EdgeInsets.only(top: (index == 0) ? spacing : 16),
                        child: AnnouncementCard(announcement: announcements[index]),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostAnnouncementScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (announcement.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                announcement.imageUrl!,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  announcement.description,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posted by: ${announcement.postedBy}',
                      style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      announcement.date.toString().split(' ')[0], // Show only date
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Screen')),
    );
  }
}

class PostAnnouncementScreen extends StatefulWidget {
  @override
  _PostAnnouncementScreenState createState() => _PostAnnouncementScreenState();
}

class _PostAnnouncementScreenState extends State<PostAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _postAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;
      if (_image != null) {
        final storageRef = FirebaseStorage.instance.ref('announcements/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      final announcement = Announcement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: imageUrl,
        date: DateTime.now(),
        postedBy: 'Admin', // Replace with actual user
      );

      await FirebaseFirestore.instance.collection('announcements').add(announcement.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Announcement'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 16),
              if (_image != null) Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Add Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _postAnnouncement,
                child: Text('Post Announcement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _eventController = TextEditingController();
  Map<DateTime, List<String>> events = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();
    for (var doc in snapshot.docs) {
      final date = (doc['date'] as Timestamp).toDate();
      final event = doc['event'] as String;
      setState(() {
        events[date] = [...(events[date] ?? []), event];
      });
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<void> _addEvent(DateTime date, String event) async {
    await FirebaseFirestore.instance.collection('events').add({
      'date': Timestamp.fromDate(date),
      'event': event,
    });
    setState(() {
      events[date] = [...(events[date] ?? []), event];
    });
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event'),
        content: TextField(
          controller: _eventController,
          decoration: InputDecoration(hintText: 'Enter event name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isNotEmpty && _selectedDay != null) {
                _addEvent(_selectedDay!, _eventController.text);
                _eventController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Class Schedule', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red, // Set the header background to red
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/School.png'), // Ensure image exists in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Spacer to add space between header and calendar
                SizedBox(height: 100),
                // Centered Table Calendar
                Center(
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    eventLoader: _getEventsForDay,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      outsideTextStyle: TextStyle(color: Colors.grey),
                      weekendTextStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Show selected day events
                if (_selectedDay != null)
                  Column(
                    children: [
                      Text(
                        'Selected Day: ${_selectedDay!.toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      ..._getEventsForDay(_selectedDay!).map((event) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(event, style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: Icon(Icons.event, color: Colors.red),
                          ),
                        ),
                      )),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        elevation: 8,
        hoverElevation: 12,
      ),
    );
  }
}


class RegisteredStudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent header
        elevation: 0, // Removes shadow
        title: Text(
          'Registered Students',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/School.png', // Your background image
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('students').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No students found.'));
              }

              final students = snapshot.data!.docs;

              // Sorting students by class and admission status
              students.sort((a, b) {
                int classComparison = a['academicDetails']['class']
                    .compareTo(b['academicDetails']['class']);
                if (classComparison != 0) return classComparison;

                return a['personalDetails']['admissionStatus']
                    .compareTo(b['personalDetails']['admissionStatus']);
              });

              // Categorize students by class
              Map<String, List<QueryDocumentSnapshot>> studentsByClass = {};
              for (var student in students) {
                String studentClass = student['academicDetails']['class'] ?? 'Unknown';
                studentsByClass.putIfAbsent(studentClass, () => []).add(student);
              }

              return ListView(
                padding: EdgeInsets.all(16),
                children: studentsByClass.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class Section Title
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Class: ${entry.key}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Student List for this Class
                      Column(
                        children: entry.value.map((studentDoc) {
                          final student = studentDoc.data() as Map<String, dynamic>;
                          final studentId = studentDoc.id;

                          return Card(
                            elevation: 4,
                            color: Colors.white.withOpacity(0.8), // Slight transparency
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(student['personalDetails']['studentName'] ?? 'No Name'),
                              subtitle: Text('Admission Status: ${student['personalDetails']['admissionStatus'] ?? 'N/A'}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteStudent(studentId);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentDetailsPage(studentId: studentId),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterStudentPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteStudent(String studentId) async {
    try {
      await FirebaseFirestore.instance.collection('students').doc(studentId).delete();
      print('Student deleted successfully');
    } catch (e) {
      print('Failed to delete student: $e');
    }
  }
}



class RegisterStudentPage extends StatefulWidget {
  @override
  _RegisterStudentPageState createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Personal Details
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _admissionDateController = TextEditingController();
  final TextEditingController _admissionStatusController = TextEditingController();

  // Controllers for Academic Details
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final List<TextEditingController> _courseControllers = [TextEditingController()];
  final TextEditingController _attendanceController = TextEditingController();

  // Controllers for Fees Details
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final Map<String, bool> _feePaymentStatus = {};

  // Controllers for other tabs (Assignment, Exam)
  final TextEditingController _assignmentTitleController = TextEditingController();
  final TextEditingController _examScoreController = TextEditingController();

  // Attendance Tab State
  String selectedMonth = 'January'; // Default selected month
  int workingDays = 0;
  Map<String, List<String>> monthlyAttendance = {}; // Map to store attendance for each month
  double attendancePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this); // Updated length to 6
    // Initialize fee payment status for all months as false (unpaid)
    for (var month in _months) {
      _feePaymentStatus[month] = false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentNameController.dispose();
    _motherNameController.dispose();
    _fatherNameController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _admissionDateController.dispose();
    _admissionStatusController.dispose();
    _classController.dispose();
    _gradeController.dispose();
    for (var controller in _courseControllers) {
      controller.dispose();
    }
    _attendanceController.dispose();
    _assignmentTitleController.dispose();
    _examScoreController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked); // Format the date
      });
    }
  }

  void _submitStudentData() async {
    // Collect all data from controllers
    Map<String, dynamic> studentData = {
      'personalDetails': {
        'studentName': _studentNameController.text,
        'motherName': _motherNameController.text,
        'fatherName': _fatherNameController.text,
        'dateOfBirth': _dateOfBirthController.text,
        'gender': _genderController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'admissionDate': _admissionDateController.text,
        'admissionStatus': _admissionStatusController.text,
      },
      'academicDetails': {
        'class': _classController.text,
        'grade': _gradeController.text,
        'registeredCourses': _courseControllers.map((controller) => controller.text).toList(),
        'attendance': _attendanceController.text,
      },
      'feeDetails': _feePaymentStatus,
      'assignmentDetails': {
        'assignmentTitle': _assignmentTitleController.text,
      },
      'examDetails': {
        'examScore': _examScoreController.text,
      },
    };

    try {
      await FirebaseFirestore.instance.collection('students').add(studentData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student registered successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register student: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Student',
          style: TextStyle(color: Colors.black), // Set text color to black
        ),
        backgroundColor: Colors.white, // Set AppBar background to white
        iconTheme: IconThemeData(color: Colors.black), // Set back icon color to black
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black, // Set tab text color to black
          unselectedLabelColor: Colors.grey, // Set unselected tab text color to grey
          indicatorColor: Colors.blue, // Set tab indicator color to blue
          tabs: [
            Tab(text: 'Personal Details'),
            Tab(text: 'Academic Details'),
            Tab(text: 'Fees Details'),
            Tab(text: 'Assignment Details'),
            Tab(text: 'Exam Details'),
            Tab(text: 'Attendance'), // New Attendance Tab
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Personal Details Tab
          _buildPersonalDetailsTab(),
          // Academic Details Tab
          _buildAcademicDetailsTab(),
          // Fees Details Tab
          _buildFeesDetailsTab(),
          // Assignment Details Tab
          _buildAssignmentDetailsTab(),
          // Exam Details Tab
          _buildExamDetailsTab(),
          // Attendance Tab
          _buildAttendanceTab(), // New Attendance Tab
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitStudentData,
        child: Icon(Icons.save, color: Colors.white),
        backgroundColor: Colors.blue, // Set FAB color to blue
      ),
    );
  }

  // Personal Details Tab
  Widget _buildPersonalDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField('Student Name', _studentNameController),
          SizedBox(height: 10),
          _buildTextField("Mother's Name", _motherNameController),
          SizedBox(height: 10),
          _buildTextField("Father's Name", _fatherNameController),
          SizedBox(height: 10),
          _buildDateField('Date of Birth', _dateOfBirthController),
          SizedBox(height: 10),
          _buildDropdownField('Gender', ['Male', 'Female', 'Other'], _genderController),
          SizedBox(height: 10),
          _buildTextField('Address', _addressController),
          SizedBox(height: 10),
          _buildTextField('Phone Number', _phoneController, keyboardType: TextInputType.phone),
          SizedBox(height: 10),
          _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
          SizedBox(height: 10),
          _buildDateField('Admission Date', _admissionDateController),
          SizedBox(height: 10),
          _buildDropdownField('Admission Status', ['Active', 'Inactive', 'Pending'], _admissionStatusController),
        ],
      ),
    );
  }

  // Academic Details Tab
  Widget _buildAcademicDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField('Class', _classController),
          SizedBox(height: 10),
          _buildTextField('Grade', _gradeController),
          SizedBox(height: 10),
          ..._courseControllers.asMap().entries.map((entry) {
            int index = entry.key;
            return Column(
              children: [
                _buildTextField('Course ${index + 1}', _courseControllers[index]),
                SizedBox(height: 10),
              ],
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _courseControllers.add(TextEditingController());
              });
            },
            child: Text('Add More Courses'),
          ),
          SizedBox(height: 20),
          _buildTextField('Attendance (%)', _attendanceController, keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  // Fees Details Tab
  Widget _buildFeesDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Fee Payment Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Table(
            border: TableBorder.all(color: Colors.grey),
            children: [
              TableRow(
                children: ['January', 'February', 'March'].map((month) {
                  return _buildMonthCell(month);
                }).toList(),
              ),
              TableRow(
                children: ['April', 'May', 'June'].map((month) {
                  return _buildMonthCell(month);
                }).toList(),
              ),
              TableRow(
                children: ['July', 'August', 'September'].map((month) {
                  return _buildMonthCell(month);
                }).toList(),
              ),
              TableRow(
                children: ['October', 'November', 'December'].map((month) {
                  return _buildMonthCell(month);
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Month Cell for Fees Details
  Widget _buildMonthCell(String month) {
    bool isPaid = _feePaymentStatus[month] ?? false;

    return GestureDetector(
      onTap: () {
        _showFeePaymentDialog(month);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPaid ? Colors.green[100] : Colors.red[100],
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                month,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Icon(
                isPaid ? Icons.check_circle : Icons.cancel,
                color: isPaid ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fee Payment Dialog
  void _showFeePaymentDialog(String month) {
    bool isPaid = _feePaymentStatus[month] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Fee Payment Status'),
          content: Text('Has the fee for $month been paid?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _feePaymentStatus[month] = true; // Mark as paid
                });
                Navigator.pop(context);
              },
              child: Text('Paid', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _feePaymentStatus[month] = false; // Mark as unpaid
                });
                Navigator.pop(context);
              },
              child: Text('Unpaid', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Assignment Details Tab
  Widget _buildAssignmentDetailsTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField('Assignment Title', _assignmentTitleController),
        ],
      ),
    );
  }

  // Attendance Tab
  Widget _buildAttendanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Dropdown to select month
          DropdownButton<String>(
            value: selectedMonth,
            items: _months.map((month) {
              return DropdownMenuItem(
                value: month,
                child: Text(month),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
                workingDays = monthlyAttendance[selectedMonth]?.length ?? 0;
              });
            },
          ),
          SizedBox(height: 20),

          // Input for number of working days
          TextField(
            decoration: InputDecoration(
              labelText: 'Number of Working Days',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                int newWorkingDays = int.tryParse(value) ?? 0;

                if (newWorkingDays > 0) {
                  // Preserve existing attendance records
                  List<String> existingRecords = monthlyAttendance[selectedMonth] ?? [];
                  if (existingRecords.isEmpty || newWorkingDays != existingRecords.length) {
                    monthlyAttendance[selectedMonth] =
                    List<String>.filled(newWorkingDays, 'Absent');
                  }
                }

                workingDays = newWorkingDays;
              });
            },
          ),
          SizedBox(height: 20),

          // Display attendance buttons for each date
          if (workingDays > 0)
            Column(
              children: [
                Text(
                  'Mark Attendance for $selectedMonth:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Generate dates dynamically
                ...List.generate(workingDays, (index) {
                  DateTime firstDayOfMonth =
                  DateTime(DateTime.now().year, _months.indexOf(selectedMonth) + 1, 1);
                  DateTime attendanceDate = firstDayOfMonth.add(Duration(days: index));

                  String status = monthlyAttendance[selectedMonth]?[index] ?? 'Absent';

                  return ListTile(
                    title: Text(DateFormat('yyyy-MM-dd').format(attendanceDate)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          monthlyAttendance[selectedMonth]![index] =
                          status == 'Present' ? 'Absent' : 'Present';
                        });
                      },
                      child: Text(status),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: status == 'Present' ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),

                // Button to calculate attendance percentage
                ElevatedButton(
                  onPressed: () {
                    int presentDays = monthlyAttendance[selectedMonth]!.where((status) => status == 'Present').length;
                    setState(() {
                      attendancePercentage = workingDays > 0 ? (presentDays / workingDays) * 100 : 0;
                    });
                  },
                  child: Text('Calculate Attendance Percentage'),
                ),
                SizedBox(height: 20),

                // Display attendance percentage
                if (attendancePercentage > 0)
                  Text(
                    'Attendance Percentage for $selectedMonth: ${attendancePercentage.toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // Exam Details Tab
  Widget _buildExamDetailsTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField('Exam Score', _examScoreController, keyboardType: TextInputType.number),
        ],
      ),
    );
  }




  // Helper method to build a text field with decoration
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
    );
  }

  // Helper method to build a date field
  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context, controller),
    );
  }

  // Helper method to build a dropdown field
  Widget _buildDropdownField(String label, List<String> items, TextEditingController controller) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          controller.text = value!;
        });
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}


class StudentDetailsPage extends StatelessWidget {
  final String studentId;

  StudentDetailsPage({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Details',
          style: TextStyle(color: Colors.black87), // Correct placement
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color:Colors.black87,
            onPressed: () async {
              // Fetch the student data
              final studentSnapshot = await FirebaseFirestore.instance
                  .collection('students')
                  .doc(studentId)
                  .get();

              if (!studentSnapshot.exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Student data not found.')),
                );
                return;
              }

              final studentData = studentSnapshot.data() as Map<String, dynamic>;

              // Navigate to the EditStudentDetailsPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentDetailsPage(
                    studentId: studentId,
                    studentData: studentData, // Pass the studentData here
                  ),
                ),
              );
            },
          ),

          IconButton(
            icon: Icon(Icons.more_vert),
            color: Colors.black87,// Menu icon
            onPressed: () {
              // Navigate to the PrintOptionsPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrintOptionsPage(studentId: studentId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('students').doc(studentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No student data found.'));
          }

          final studentData = snapshot.data!.data() as Map<String, dynamic>?;
          if (studentData == null) {
            return Center(child: Text('Student data is null.'));
          }

          // Build the UI using the studentData
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Personal Details', Icons.person),
                _buildDetailCard([
                  _buildDetailItem('Student Name', studentData['personalDetails']?['studentName'] ?? 'N/A'),
                  _buildDetailItem("Mother's Name", studentData['personalDetails']?['motherName'] ?? 'N/A'),
                  _buildDetailItem("Father's Name", studentData['personalDetails']?['fatherName'] ?? 'N/A'),
                  _buildDetailItem('Date of Birth', studentData['personalDetails']?['dateOfBirth'] ?? 'N/A'),
                  _buildDetailItem('Gender', studentData['personalDetails']?['gender'] ?? 'N/A'),
                  _buildDetailItem('Address', studentData['personalDetails']?['address'] ?? 'N/A'),
                  _buildDetailItem('Phone Number', studentData['personalDetails']?['phone'] ?? 'N/A'),
                  _buildDetailItem('Email', studentData['personalDetails']?['email'] ?? 'N/A'),
                  _buildDetailItem('Admission Date', studentData['personalDetails']?['admissionDate'] ?? 'N/A'),
                  _buildDetailItem('Admission Status', studentData['personalDetails']?['admissionStatus'] ?? 'N/A'),
                ]),
                SizedBox(height: 20),
                _buildSectionTitle('Academic Details', Icons.school),
                _buildDetailCard([
                  _buildDetailItem('Class', studentData['academicDetails']?['class'] ?? 'N/A'),
                  _buildDetailItem('Grade', studentData['academicDetails']?['grade'] ?? 'N/A'),
                  _buildDetailItem('Overall Attendance (%)', studentData['academicDetails']?['attendance']?.toString() ?? 'N/A'),
                ]),
                SizedBox(height: 20),
                _buildSectionTitle('Monthly Attendance', Icons.calendar_today),
                _buildDetailCard(
                  (studentData['monthlyAttendance'] as Map<String, dynamic>?)?.entries.map((entry) {
                    return _buildDetailItem(
                      entry.key, // Month name (e.g., "January")
                      '${entry.value}%', // Attendance percentage
                    );
                  }).toList() ?? [
                    _buildDetailItem('No monthly attendance data found.', ''),
                  ],
                ),
                SizedBox(height: 20),
                _buildSectionTitle('Fee Details', Icons.attach_money),
                _buildDetailCard(
                  (studentData['feeDetails'] as Map<String, dynamic>?)?.entries.map((entry) {
                    return _buildDetailItem(
                      entry.key,
                      entry.value ? 'Paid ✅' : 'Unpaid ❌',
                    );
                  }).toList() ?? [
                    _buildDetailItem('No fee details found.', ''),
                  ],
                ),
                SizedBox(height: 20),
                _buildSectionTitle('Assignment Details', Icons.assignment),
                _buildDetailCard([
                  _buildDetailItem('Assignment Title', studentData['assignmentDetails']?['assignmentTitle'] ?? 'N/A'),
                ]),
                SizedBox(height: 20),
                _buildSectionTitle('Exam Details', Icons.assessment),
                _buildDetailCard([
                  _buildDetailItem('Exam Score', studentData['examDetails']?['examScore']?.toString() ?? 'N/A'),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white.withOpacity(0.8), // Slight transparency added
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class EditStudentDetailsPage extends StatefulWidget {
  final String studentId;
  final Map<String, dynamic> studentData;

  EditStudentDetailsPage({required this.studentId, required this.studentData});

  @override
  _EditStudentDetailsPageState createState() => _EditStudentDetailsPageState();
}

class _EditStudentDetailsPageState extends State<EditStudentDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Personal Details
  final _studentNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _admissionDateController = TextEditingController();
  final _admissionStatusController = TextEditingController();

  // Controllers for Academic Details
  final _classController = TextEditingController();
  final _gradeController = TextEditingController();
  final _attendanceController = TextEditingController();
  final List<TextEditingController> _courseControllers = [];

  // Controllers for Assignment Details
  final _assignmentTitleController = TextEditingController();

  // Controllers for Exam Details
  final _examScoreController = TextEditingController();

  // Fee Payment Status
  Map<String, bool> _feePaymentStatus = {
    'Tuition Fee': false,
    'Library Fee': false,
    'Transport Fee': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize Personal Details
    _studentNameController.text = widget.studentData['personalDetails']['studentName'];
    _motherNameController.text = widget.studentData['personalDetails']['motherName'];
    _fatherNameController.text = widget.studentData['personalDetails']['fatherName'];
    _dateOfBirthController.text = widget.studentData['personalDetails']['dateOfBirth'];
    _genderController.text = widget.studentData['personalDetails']['gender'];
    _addressController.text = widget.studentData['personalDetails']['address'];
    _phoneController.text = widget.studentData['personalDetails']['phone'];
    _emailController.text = widget.studentData['personalDetails']['email'];
    _admissionDateController.text = widget.studentData['personalDetails']['admissionDate'];
    _admissionStatusController.text = widget.studentData['personalDetails']['admissionStatus'];

    // Initialize Academic Details
    _classController.text = widget.studentData['academicDetails']['class'];
    _gradeController.text = widget.studentData['academicDetails']['grade'];
    _attendanceController.text = widget.studentData['academicDetails']['attendance'];
    for (var course in widget.studentData['academicDetails']['registeredCourses']) {
      _courseControllers.add(TextEditingController(text: course));
    }

    // Initialize Assignment Details
    _assignmentTitleController.text = widget.studentData['assignmentDetails']['assignmentTitle'];

    // Initialize Exam Details
    _examScoreController.text = widget.studentData['examDetails']['examScore'];

    // Initialize Fee Details
    _feePaymentStatus = Map.from(widget.studentData['feeDetails']);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _saveStudentDetails() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedStudentData = {
        'personalDetails': {
          'studentName': _studentNameController.text,
          'motherName': _motherNameController.text,
          'fatherName': _fatherNameController.text,
          'dateOfBirth': _dateOfBirthController.text,
          'gender': _genderController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'admissionDate': _admissionDateController.text,
          'admissionStatus': _admissionStatusController.text,
        },
        'academicDetails': {
          'class': _classController.text,
          'grade': _gradeController.text,
          'registeredCourses': _courseControllers.map((controller) => controller.text).toList(),
          'attendance': _attendanceController.text,
        },
        'feeDetails': _feePaymentStatus,
        'assignmentDetails': {
          'assignmentTitle': _assignmentTitleController.text,
        },
        'examDetails': {
          'examScore': _examScoreController.text,
        },
      };

      try {
        // Update Firestore document
        await FirebaseFirestore.instance
            .collection('students')
            .doc(widget.studentId)
            .update(updatedStudentData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student details updated successfully!')),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update student details: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove the shadow
        centerTitle: true, // Center the title
        title: Text(
          'Edit Student Details',
          style: TextStyle(
            color: Colors.black, // Set text color to black
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Set icon color to black
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveStudentDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 16.0, // Horizontal space between tiles
            runSpacing: 16.0, // Vertical space between tiles
            children: [
              // Personal Details
              _buildSectionTile(
                title: 'Personal Details',
                icon: Icons.person,
                children: [
                  _buildTextField('Student Name', _studentNameController),
                  _buildTextField("Mother's Name", _motherNameController),
                  _buildTextField("Father's Name", _fatherNameController),
                  _buildDateField('Date of Birth', _dateOfBirthController),
                  _buildDropdownField('Gender', _genderController, ['Male', 'Female', 'Other']),
                  _buildTextField('Address', _addressController),
                  _buildTextField('Phone Number', _phoneController, keyboardType: TextInputType.phone),
                  _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                  _buildDateField('Admission Date', _admissionDateController),
                  _buildDropdownField('Admission Status', _admissionStatusController, ['Active', 'Inactive']),
                ],
              ),

              // Academic Details
              _buildSectionTile(
                title: 'Academic Details',
                icon: Icons.school,
                children: [
                  _buildTextField('Class', _classController),
                  _buildTextField('Grade', _gradeController),
                  _buildTextField('Attendance (%)', _attendanceController, keyboardType: TextInputType.number),
                  ..._courseControllers.map((controller) {
                    return _buildTextField('Course', controller);
                  }).toList(),
                ],
              ),

              // Fee Details
              _buildSectionTile(
                title: 'Fee Details',
                icon: Icons.attach_money,
                children: [
                  ..._feePaymentStatus.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      onChanged: (value) {
                        setState(() {
                          _feePaymentStatus[entry.key] = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),

              // Assignment Details
              _buildSectionTile(
                title: 'Assignment Details',
                icon: Icons.assignment,
                children: [
                  _buildTextField('Assignment Title', _assignmentTitleController),
                ],
              ),

              // Exam Details
              _buildSectionTile(
                title: 'Exam Details',
                icon: Icons.assessment,
                children: [
                  _buildTextField('Exam Score', _examScoreController, keyboardType: TextInputType.number),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a tiled section
  Widget _buildSectionTile({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Section Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: controller.text.isNotEmpty ? controller.text : null,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        controller.text = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }
}

class PrintOptionsPage extends StatelessWidget {
  final String studentId;

  PrintOptionsPage({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Options', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPrintButton(
              context,
              'Print Student Details',
              Icons.print,
                  () async {
                final studentData = await _fetchStudentData();
                await _generateStudentDetailsPdf(studentData);
              },
            ),
            SizedBox(height: 20),
            _buildPrintButton(
              context,
              'Print Bonafide Certificate',
              Icons.assignment,
                  () async {
                final studentData = await _fetchStudentData();
                await _generateBonafideCertificatePdf(studentData);
              },
            ),
            SizedBox(height: 20),
            _buildPrintButton(
              context,
              'Print Attendance Data',
              Icons.calendar_today,
                  () async {
                final studentData = await _fetchStudentData();
                await _generateAttendancePdf(studentData);
              },
            ),
            SizedBox(height: 20),
            _buildPrintButton(
              context,
              'Print Fees Data',
              Icons.attach_money,
                  () async {
                final studentData = await _fetchStudentData();
                await _generateFeesPdf(studentData);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a print button
  Widget _buildPrintButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Fetch student data from Firestore
  Future<Map<String, dynamic>> _fetchStudentData() async {
    final studentData = await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .get();
    return studentData.data()!;
  }

  // Generate and print student details PDF
  Future<void> _generateStudentDetailsPdf(Map<String, dynamic> studentData) async {
    final pdf = pw.Document();

    // Load background image
    final ByteData imageData = await rootBundle.load('assets/Maple Letterhead1.png'); // Change path accordingly
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final pw.MemoryImage backgroundImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background Image
              pw.Positioned.fill(
                child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
              ),
              // Content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Title
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'Student Details',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Personal Details
                  _buildCenteredHeading('Personal Details'),
                  _buildPdfDetailItem('Student Name', studentData['personalDetails']['studentName']),
                  _buildPdfDetailItem("Mother's Name", studentData['personalDetails']['motherName']),
                  _buildPdfDetailItem("Father's Name", studentData['personalDetails']['fatherName']),
                  _buildPdfDetailItem('Date of Birth', studentData['personalDetails']['dateOfBirth']),
                  _buildPdfDetailItem('Gender', studentData['personalDetails']['gender']),
                  _buildPdfDetailItem('Address', studentData['personalDetails']['address']),
                  _buildPdfDetailItem('Phone Number', studentData['personalDetails']['phone']),
                  _buildPdfDetailItem('Email', studentData['personalDetails']['email']),
                  _buildPdfDetailItem('Admission Date', studentData['personalDetails']['admissionDate']),
                  _buildPdfDetailItem('Admission Status', studentData['personalDetails']['admissionStatus']),
                  pw.SizedBox(height: 20),

                  // Academic Details
                  _buildCenteredHeading('Academic Details'),
                  _buildPdfDetailItem('Class', studentData['academicDetails']['class']),
                  _buildPdfDetailItem('Grade', studentData['academicDetails']['grade']),
                  _buildPdfDetailItem('Attendance (%)', studentData['academicDetails']['attendance']),
                  pw.SizedBox(height: 20),

                  // Fee Details
                  _buildCenteredHeading('Fee Details'),
                  ...(studentData['feeDetails'] as Map<String, dynamic>).entries.map((entry) {
                    return _buildPdfDetailItem(entry.key, entry.value ? 'Paid ✅' : 'Unpaid ❌');
                  }).toList(),
                  pw.SizedBox(height: 20),

                  // Assignment Details
                  _buildCenteredHeading('Assignment Details'),
                  _buildPdfDetailItem('Assignment Title', studentData['assignmentDetails']['assignmentTitle']),
                  pw.SizedBox(height: 20),

                  // Exam Details
                  _buildCenteredHeading('Exam Details'),
                  _buildPdfDetailItem('Exam Score', studentData['examDetails']['examScore']),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF document
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

// Helper function for PDF detail items
  pw.Widget _buildPdfDetailItem(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('$label: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }

// Helper function for Centered Headings
  pw.Widget _buildCenteredHeading(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
      ),
    );
  }

  // Generate and print Bonafide Certificate PDF
  Future<void> _generateBonafideCertificatePdf(Map<String, dynamic> studentData) async {
    final pdf = pw.Document();

    // Load background image
    final ByteData imageData = await rootBundle.load('assets/Maple Letterhead.png'); // Change path accordingly
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final pw.MemoryImage backgroundImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background Image
              pw.Positioned.fill(
                child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
              ),
              // Content
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center, // Center content vertically
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Bonafide Certificate Heading
                  pw.Text(
                    'Bonafide Certificate',
                    style: pw.TextStyle(
                      fontSize: 24,  // Reduced size
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline, // Underlined
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Certificate Content
                  pw.Text(
                    'This is to certify that ${studentData['personalDetails']['studentName']} is a bonafide student of our school, '
                        'Maple Foundation Academy. He/She is currently enrolled in ${studentData['academicDetails']['class']} and is '
                        'performing exceptionally well in academics and extracurricular activities.',
                    style: pw.TextStyle(fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 20),

                  // More Content (can be extended based on needs)
                  pw.Text(
                    'He/She has been a dedicated student and has shown excellent attendance and discipline throughout the academic year.',
                    style: pw.TextStyle(fontSize: 14),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 20),

                  // Footer Text (System Generated)
                  pw.Text(
                    'System Generated Certificate. No signature is required.',
                    style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF document
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Generate and print Attendance Data PDF
  Future<void> _generateAttendancePdf(Map<String, dynamic> studentData) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Extract attendance details from studentData
    final attendanceDetails = studentData['attendanceDetails'] as Map<String, dynamic>? ?? {};

    // Debug: Print attendanceDetails to verify its structure
    print('Attendance Details: $attendanceDetails');

    // List to store widgets for each month's attendance
    List<pw.Widget> monthWidgets = [];

    // Check if attendanceDetails is empty
    if (attendanceDetails.isEmpty) {
      monthWidgets.add(
        pw.Text(
          'No attendance data available.',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
      );
    } else {
      // Loop through each month in attendanceDetails
      attendanceDetails.forEach((month, dailyData) {
        final monthData = dailyData as Map<String, dynamic>? ?? {};

        // Debug: Print monthData to verify its structure
        print('Month: $month, Data: $monthData');

        // Calculate total days and present days for the month
        int totalDays = monthData.length;
        int presentDays = monthData.values.where((val) => val == true).length;
        double attendancePercentage = (totalDays > 0) ? (presentDays / totalDays) * 100 : 0;

        // Add a header for the month's attendance
        monthWidgets.add(
          pw.Text(
            '$month Attendance: ${attendancePercentage.toStringAsFixed(2)}%',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        );

        // Create a table for daily attendance
        monthWidgets.add(
          pw.Table.fromTextArray(
            headers: ['Date', 'Status'], // Table headers
            data: monthData.entries.map((entry) {
              return [entry.key, entry.value ? 'Present ✅' : 'Absent ❌']; // Table rows
            }).toList(),
          ),
        );

        // Add spacing between months
        monthWidgets.add(pw.SizedBox(height: 10));
      });
    }

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title of the PDF
              pw.Text(
                'Attendance Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20), // Add spacing

              // Add all month widgets to the PDF
              ...monthWidgets,
            ],
          );
        },
      ),
    );

    // Print or save the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Generate and print Fees Data PDF
  Future<void> _generateFeesPdf(Map<String, dynamic> studentData) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Fees Data', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...(studentData['feeDetails'] as Map<String, dynamic>).entries.map((entry) {
                return pw.Text('${entry.key}: ${entry.value ? 'Paid' : 'Unpaid'}');
              }).toList(),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}



class PersonalDetailsTab extends StatelessWidget {
  final String studentId;

  PersonalDetailsTab({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('students').doc(studentId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No personal details found.'));
        }

        final student = snapshot.data!.data() as Map<String, dynamic>;

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildDetailItem('Name', student['studentName'] ?? 'N/A'),
            _buildDetailItem("Mother's Name", student['motherName'] ?? 'N/A'),
            _buildDetailItem("Father's Name", student['fatherName'] ?? 'N/A'),
            _buildDetailItem('Age', student['studentAge'] ?? 'N/A'),
            _buildDetailItem('Grade Level', student['gradeLevel'] ?? 'N/A'),
            _buildDetailItem('Address', student['address'] ?? 'N/A'),
            _buildDetailItem("Father's Occupation", student['fatherOccupation'] ?? 'N/A'),
            _buildDetailItem("Father's Phone", student['fatherPhone'] ?? 'N/A'),
            _buildDetailItem('Gender', student['gender'] ?? 'N/A'),
            _buildDetailItem('Admission Status', student['admissionStatus'] ?? 'N/A'),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class AcademicDetailsTab extends StatelessWidget {
  final String studentId;

  AcademicDetailsTab({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .where('studentsEnrolled', arrayContains: studentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No academic details found.'));
        }

        final courses = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index].data() as Map<String, dynamic>;
            return Card(
                child: ListTile(
                title: Text(course['courseName'] ?? 'N/A'),
            subtitle: Text('Teacher: ${course['teacherId'] ?? 'N/A'}'),
            ),
            );
          },
        );
      },
    );
  }
}

class AttendanceDetailsTab extends StatelessWidget {
  final String studentId;

  AttendanceDetailsTab({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('studentId', isEqualTo: studentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No attendance records found.'));
        }

        final attendanceRecords = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: attendanceRecords.length,
          itemBuilder: (context, index) {
            final record = attendanceRecords[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('Date: ${record['date']?.toDate().toString() ?? 'N/A'}'),
                subtitle: Text('Status: ${record['status'] ?? 'N/A'}'),
              ),
            );
          },
        );
      },
    );
  }
}

class ExamDetailsTab extends StatelessWidget {
  final String studentId;

  ExamDetailsTab({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exams')
          .where('results.$studentId', isNull: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No exam records found.'));
        }

        final exams = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: exams.length,
          itemBuilder: (context, index) {
            final exam = exams[index].data() as Map<String, dynamic>;
            final result = exam['results'][studentId] as Map<String, dynamic>? ?? {};
            return Card(
              child: ListTile(
                title: Text(exam['examName'] ?? 'N/A'),
                subtitle: Text('Score: ${result['score'] ?? 'N/A'}'),
              ),
            );
          },
        );
      },
    );
  }
}

class FeeDetailsTab extends StatelessWidget {
  final String studentId;

  FeeDetailsTab({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('fees')
          .where('studentId', isEqualTo: studentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No fee records found.'));
        }

        final fees = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: fees.length,
          itemBuilder: (context, index) {
            final fee = fees[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('Amount Due: ${fee['amountDue'] ?? 'N/A'}'),
                subtitle: Text('Amount Paid: ${fee['amountPaid'] ?? 'N/A'}'),
              ),
            );
          },
        );
      },
    );
  }
}

class AssignmentDetailsTab extends StatelessWidget {
  final String studentId;

  AssignmentDetailsTab({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('assignments')
          .where('submissions.$studentId', isNull: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No assignment records found.'));
        }

        final assignments = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index].data() as Map<String, dynamic>;
            final submission = assignment['submissions'][studentId] as Map<String, dynamic>? ?? {};
            return Card(
              child: ListTile(
                title: Text(assignment['title'] ?? 'N/A'),
                subtitle: Text('Score: ${submission['score'] ?? 'N/A'}'),
              ),
            );
          },
        );
      },
    );
  }
}
