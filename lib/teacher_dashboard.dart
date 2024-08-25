import 'package:flutter/material.dart';
import 'package:attendance_app/services/google_sheets_service.dart';
import 'device_registration_form.dart';
import 'mark_attendance.dart';

class TeacherDashboard extends StatefulWidget {
  final GoogleSheetsService googleSheetsService;

  TeacherDashboard({required this.googleSheetsService});

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  List<List<dynamic>> registeredDevices = [];

  @override
  void initState() {
    super.initState();
    _fetchRegisteredDevices();
  }

  void _fetchRegisteredDevices() async {
    List<List<dynamic>> devices = await widget.googleSheetsService.getRows();
    setState(() {
      registeredDevices = devices;
    });
  }

  void _removeDevice(int index) async {
    await widget.googleSheetsService
        .deleteRow(index + 1); // Assuming the first row is the header
    _fetchRegisteredDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Schedule Overview
            Card(
              child: ListTile(
                title: Text('Today\'s Schedule'),
                subtitle: Text('Math, Science, History'),
              ),
            ),
            SizedBox(height: 16.0),
            // Upcoming Classes
            Card(
              child: ListTile(
                title: Text('Upcoming Classes'),
                subtitle: Text('Math at 10:00 AM, Science at 11:00 AM'),
              ),
            ),
            SizedBox(height: 16.0),
            // Notifications
            Card(
              child: ListTile(
                title: Text('Notifications'),
                subtitle:
                    Text('New assignment posted, Parent meeting at 3:00 PM'),
              ),
            ),
            SizedBox(height: 16.0),
            // Registered Devices
            Expanded(
              child: ListView.builder(
                itemCount: registeredDevices.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Student: ${registeredDevices[index][0]}'),
                      subtitle:
                          Text('Device ID: ${registeredDevices[index][1]}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeDevice(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to create class screen
                  },
                  child: Text('Create Class'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarkAttendance(
                              googleSheetsService: widget.googleSheetsService)),
                    );
                  },
                  child: Text('Mark Attendance'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to messaging screen
                  },
                  child: Text('Send Message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeviceRegistrationForm(
                              googleSheetsService: widget.googleSheetsService)),
                    );
                  },
                  child: Text('Register Student Device'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
