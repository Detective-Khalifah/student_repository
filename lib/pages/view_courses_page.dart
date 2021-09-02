import 'package:flutter/material.dart';
import 'package:student_repository/pages/edit_courses_page.dart';

class ViewCoursesPage extends StatefulWidget {
  static const String id = 'view_courses';

  const ViewCoursesPage({Key? key}) : super(key: key);

  @override
  _ViewCoursesPageState createState() => _ViewCoursesPageState();
}

class _ViewCoursesPageState extends State<ViewCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, EditCoursesPage.id);
            },
            child: Text('Edit Courses')),
      ),
    );
  }
}
