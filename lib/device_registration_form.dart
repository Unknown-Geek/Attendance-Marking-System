import 'package:flutter/material.dart';
import 'package:attendance_app/services/google_sheets_service.dart';

class DeviceRegistrationForm extends StatefulWidget {
  final GoogleSheetsService googleSheetsService;

  DeviceRegistrationForm({required this.googleSheetsService});

  @override
  _DeviceRegistrationFormState createState() => _DeviceRegistrationFormState();
}

class _DeviceRegistrationFormState extends State<DeviceRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Student Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _studentNameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deviceIdController,
                decoration: InputDecoration(labelText: 'Device ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the device ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerDevice();
                  }
                },
                child: Text('Register Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerDevice() {
    widget.googleSheetsService.insertRow([
      _studentNameController.text,
      _deviceIdController.text,
    ]).then((value) {
      print('Device Registered');
      _studentNameController.clear();
      _deviceIdController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Device registered successfully!')),
      );
    }).catchError((error) {
      print('Failed to register device: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register device: $error')),
      );
    });
  }
}
