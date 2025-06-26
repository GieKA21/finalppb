import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _About createState() => _About();
}

class _About extends State<About> {
  bool _isNotificationsEnabled = true; // Keep this if you plan to use it

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text('About Page'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/underc.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0.0),
                Text(
                  'The App is still Under Construction....',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                  
                ),
                SizedBox(height: 10.0),
                Text(
                  'The project is made by: Shadiq',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 580.0), // Added spacing
                // --- Example of how to use _isNotificationsEnabled ---
                SwitchListTile(
                  title: Text(
                    'Enable Notifications',
                    style: TextStyle(color: Colors.black),
                  ),
                  value: _isNotificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isNotificationsEnabled = value;
                    });
                    // Add logic here to actually enable/disable notifications
                    print('Notifications enabled: $_isNotificationsEnabled');
                  },
                  activeColor: Colors.blueAccent,
                  inactiveThumbColor: Colors.grey,
                  tileColor:
                      Colors.black.withOpacity(0.5), // Optional: add a subtle background
                ),
                // ----------------------------------------------------
              ],
            ),
          ],
        ),
      ),
    );
  }
}