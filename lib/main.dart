import 'package:flutter/material.dart';
import 'package:attendance_app/services/google_sheets_service.dart';
import 'package:attendance_app/screens/register.dart';
import 'package:attendance_app/screens/login.dart';
import 'teacher_dashboard.dart'; // Import the TeacherDashboard

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsService googleSheetsService = GoogleSheetsService();
  await googleSheetsService.init();
  runApp(MyApp(googleSheetsService: googleSheetsService));
}

class MyApp extends StatelessWidget {
  final GoogleSheetsService googleSheetsService;

  MyApp({required this.googleSheetsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(googleSheetsService: googleSheetsService),
      routes: {
        '/teacherDashboard': (context) =>
            TeacherDashboard(googleSheetsService: googleSheetsService),
      },
    );
  }
}

class Home extends StatelessWidget {
  final GoogleSheetsService googleSheetsService;

  Home({required this.googleSheetsService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Register'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Register(googleSheetsService: googleSheetsService)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login(googleSheetsService: googleSheetsService)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Teacher Dashboard'),
              onPressed: () {
                Navigator.pushNamed(context, '/teacherDashboard');
              },
            ),
          ],
        ),
      ),
    );
  }
}
