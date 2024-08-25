import 'package:flutter/material.dart';
import 'package:attendance_app/services/google_sheets_service.dart';

class Register extends StatefulWidget {
  final GoogleSheetsService googleSheetsService;

  Register({required this.googleSheetsService});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String role = 'student'; // Default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            DropdownButtonFormField(
              value: role,
              items: ['student', 'teacher'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => role = val as String);
              },
            ),
            ElevatedButton(
              child: Text('Register'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.googleSheetsService.insertRow([email, password, role]);
                  print('User registered');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
