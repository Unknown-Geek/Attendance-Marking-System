import 'package:flutter/material.dart';
import 'package:attendance_app/services/google_sheets_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MarkAttendance extends StatefulWidget {
  final GoogleSheetsService googleSheetsService;

  MarkAttendance({required this.googleSheetsService});

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  bool useBluetooth = true;
  double geofenceRadius = 20.0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mark Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Option to choose Bluetooth or Wi-Fi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Use Bluetooth'),
                Switch(
                  value: useBluetooth,
                  onChanged: (value) {
                    setState(() {
                      useBluetooth = value;
                    });
                  },
                ),
                Text('Use Wi-Fi'),
              ],
            ),
            // Geofence radius slider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Geofence Radius: ${geofenceRadius.toStringAsFixed(1)} meters'),
                Slider(
                  value: geofenceRadius,
                  min: 10.0,
                  max: 100.0,
                  divisions: 18,
                  label: geofenceRadius.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      geofenceRadius = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _markAttendance();
              },
              child: Text('Start Attendance'),
            ),
          ],
        ),
      ),
    );
  }

  void _markAttendance() {
    if (useBluetooth) {
      _scanBluetoothDevices();
    } else {
      _scanWifiDevices();
    }
  }

  void _scanBluetoothDevices() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4)).then((_) {
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('${r.device.localName} found! rssi: ${r.rssi}');
          // Check geofencing and send notification
          _checkGeofencingAndNotify(r.device.id.id);
        }
      }).onDone(() {
        FlutterBluePlus.stopScan();
      });
    }).catchError((error) {
      print('Error starting Bluetooth scan: $error');
    });
  }

  void _scanWifiDevices() {
    WiFiForIoTPlugin.getSSID().then((ssid) {
      WiFiForIoTPlugin.getBSSID().then((bssid) {
        print('SSID: $ssid, BSSID: $bssid');
        // Check geofencing and send notification
        _checkGeofencingAndNotify(bssid!);
      }).catchError((error) {
        print('Error getting Wi-Fi BSSID: $error');
      });
    }).catchError((error) {
      print('Error getting Wi-Fi SSID: $error');
    });
  }

  void _checkGeofencingAndNotify(String deviceId) async {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    // Replace with the actual latitude and longitude of the teacher's location
    double teacherLatitude = 10.0000;
    double teacherLongitude = 76.0000;

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      teacherLatitude,
      teacherLongitude,
    );

    if (distance <= geofenceRadius) {
      _sendNotification(deviceId);
    }
  }

  void _sendNotification(String deviceId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'attendance_channel', // Channel ID
            'Attendance Notifications', // Channel Name
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Attendance Confirmation',
      'Please confirm your attendance for device $deviceId',
      platformChannelSpecifics,
      payload: deviceId,
    );
  }
}
