import 'package:flutter/material.dart';
import 'package:attendance_app/services/google_sheets_service.dart';

class Login extends StatefulWidget {
  final GoogleSheetsService googleSheetsService;

  Login({required this.googleSheetsService});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var rows = await widget.googleSheetsService.getRows();
                  bool loginSuccess = false;
                  for (var row in rows) {
                    if (row[0] == email && row[1] == password) {
                      loginSuccess = true;
                      break;
                    }
                  }
                  if (loginSuccess) {
                    print('User logged in');
                  } else {
                    print('Login failed');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
