import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/pages/edit_profile_page.dart';
import 'package:student_repository/pages/view_courses_page.dart';
import 'package:student_repository/pages/welcome_page.dart';
import 'package:student_repository/services/authentication.dart';
import 'package:student_repository/utilities/profile_args.dart';

final _firestore = FirebaseFirestore.instance;
late String fName,
    mName,
    lName,
    phone,
    address,
    state,
    lga,
    dept,
    matriculation;

class HomePage extends StatefulWidget {
  static const String id = 'home';
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<Authentication>().logOut();
              Navigator.popAndPushNamed(context, WelcomePage.id);
            },
            icon: Icon(Icons.directions_run),
            tooltip: 'Log out',
          )
        ],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.yellowAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // TODO: Find a better Widget, call #DataStream() here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/student_128.png'),
                minRadius: 45,
                maxRadius: 100,
              ),
            ),
            DataStream(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ViewCoursesPage.id,
                          arguments: ProfileArguments(matriculation));
                    },
                    child: Text('Courses'),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditProfilePage.id,
                          arguments: ProfileArguments(matriculation));
                    },
                    child: Text('Profile'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        }

        final students = snapshot.data!.docs;
        for (var student in students) {
          final String studentMail = student
              .get('e-mail'); // TODO: Use matriculation number or username
          if (studentMail == context.read<User>().email) {
            fName = student.get('First Name');
            mName = student.get('Middle Name');
            lName = student.get('Last Name');
            phone = student.get('Phone').toString();
            address = student.get('Address');
            state = student.get('State of Origin');
            lga = student.get('Local Government (of Origin)');
            dept = student.get('Department');
            matriculation = student.get('Matriculation Number');

            return ProfileTable();
          }
        }
        return Center(child: Text('Eureka!'));
      },
    );
  }
}

class ProfileTable extends StatelessWidget {
  const ProfileTable({Key? key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Metrics')),
        DataColumn(label: Text('Deets'))
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text('First Name')),
            DataCell(Text('$fName')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Middle Name')),
            DataCell(Text('$mName')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Last Name')),
            DataCell(Text('$lName')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Phone')),
            DataCell(Text('$phone')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Address')),
            DataCell(Text('$address')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('State')),
            DataCell(Text('$state')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('L. G. A.')),
            DataCell(Text('$lga')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Department')),
            DataCell(Text('$dept')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Matriculation #')),
            DataCell(Text('$matriculation')),
          ],
        ),
      ],
    );
  }
}
