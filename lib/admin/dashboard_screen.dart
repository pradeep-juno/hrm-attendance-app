import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';

import 'leave_approval.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
               Get.back(); // Just close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Leave Requests'),
              onTap: () {
                Get.off(() => LeaveRequestScreen()); // Navigate fresh
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true, // This shows hamburger menu instead of back button
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to Dashboard',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
