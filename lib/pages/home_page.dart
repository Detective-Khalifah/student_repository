import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/services/authentication.dart';

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

  const HomePage({Key? key}) : super(key: key);

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
              Navigator.pop(context);
            },
            icon: Icon(Icons.directions_run),
          )
        ],
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
            DataStream()
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
          final String student_mail = student
              .get('e-mail'); // TODO: Use matriculation number or username
          if (student_mail == context.read<User>().email) {
            fName = student.get('First Name');
            mName = student.get('Middle Name');
            lName = student.get('Last Name');
            phone = student.get('Phone').toString();
            address = student.get('Address');
            state = student.get('State of Origin');
            lga = student.get('Local Government (of Origin)');
            dept = student.get('Department');
            matriculation = student.get('Matriculation Number');

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
          } else
            print('Couldn\'t find user');
        }
        return Center(child: Text('Eureka!'));
      },
    );
  }
}
