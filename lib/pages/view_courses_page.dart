import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/pages/edit_courses_page.dart';

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
      appBar: AppBar(),
      body: Column(children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('student_courses').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                ),
              );
            }

            final courseRegistrations = snapshot.data!.docs;
            for (var courseReg in courseRegistrations) {
              if (courseReg.id == widget.matriculation) {
                print(
                    '1st Courses: ${courseReg.get('first_registered_courses')}');
                print(
                    '2nd Courses: ${courseReg.get('second_registered_courses')}');

                return CoursesTable();
              }
            }
            return Center(child: Text('Eureka!'));
          },
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, EditCoursesPage.id);
            },
            child: Text('Edit Courses')),
      ]),
    );
  }
}

class CoursesTable extends StatelessWidget {
  const CoursesTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center();
    // return DataTable(
    //   columns: [
    //     DataColumn(label: Text('Metrics')),
    //     DataColumn(label: Text('Deets'))
    //   ],
    //   rows: [
    //     DataRow(
    //       cells: [
    //         DataCell(Text('First Name')),
    //         DataCell(Text('$fName')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('Middle Name')),
    //         DataCell(Text('$mName')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('Last Name')),
    //         DataCell(Text('$lName')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('Phone')),
    //         DataCell(Text('$phone')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('Address')),
    //         DataCell(Text('$address')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('State')),
    //         DataCell(Text('$state')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('L. G. A.')),
    //         DataCell(Text('$lga')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('Department')),
    //         DataCell(Text('$dept')),
    //       ],
    //     ),
    //     DataRow(
    //       cells: [
    //         DataCell(Text('Matriculation #')),
    //         DataCell(Text('$matriculation')),
    //       ],
    //     ),
    //   ],
    // );
  }
}
