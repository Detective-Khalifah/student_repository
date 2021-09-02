import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_repository/pages/edit_courses_page.dart';
import 'package:student_repository/utilities/profile_args.dart';

final _firestore = FirebaseFirestore.instance;

class ViewCoursesPage extends StatefulWidget {
  static const String id = 'view_courses';
  final String matriculation;

  const ViewCoursesPage({Key? key, required this.matriculation})
      : super(key: key);

  @override
  _ViewCoursesPageState createState() => _ViewCoursesPageState();
}

class _ViewCoursesPageState extends State<ViewCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Courses'),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('courses').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                );
              }

              final courseRegistrations = snapshot.data!.docs;
              List<DataRow> myRow = [];
              for (var courseReg in courseRegistrations) {
                String title = courseReg.get('title');
                String cu = courseReg.get('credit_units').toString();
                String code = courseReg.get('code');

                myRow.add(_getRow(code, title, cu));
              }
              return DataTable(columns: [
                DataColumn(label: Text('Code')),
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('CU'))
              ], rows: myRow);
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, EditCoursesPage.id,
                    arguments: ProfileArguments(widget.matriculation));
              },
              child: Text('Edit Courses')),
        ],
      ),
    );
  }
}

class CoursesTable extends StatelessWidget {
  final String? code, title, cu;

  const CoursesTable(
      {Key? key, this.code, required this.title, required this.cu});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Code')),
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('CU'))
      ],
      rows: [_getRow(code!, title!, cu == null ? '' : cu)],
    );
  }
}

DataRow _getRow(String code, String title, String? cu) {
  return DataRow(
    cells: [
      DataCell(Text('$code', style: GoogleFonts.adamina())),
      DataCell(Text('$title', style: GoogleFonts.acme())),
      DataCell(Text('$cu', style: GoogleFonts.alef())),
    ],
  );
}
