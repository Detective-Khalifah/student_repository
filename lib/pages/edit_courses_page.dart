import 'package:flutter/material.dart';
import 'package:student_repository/pages/view_courses_page.dart';

class EditCoursesPage extends StatefulWidget {
  static const String id = 'edit_courses';

  const EditCoursesPage({Key? key}) : super(key: key);

  @override
  _EditCoursesPageState createState() => _EditCoursesPageState();
}

class _EditCoursesPageState extends State<EditCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, ViewCoursesPage.id);
            },
            child: Text('View Courses')),
      ),
    );
  }
}
