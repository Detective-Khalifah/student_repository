import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/services/authentication.dart';

final _firestore = FirebaseFirestore.instance;

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
            DataStream(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/student_128.png'),
                minRadius: 45,
                maxRadius: 100,
              ),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Metrics')),
                DataColumn(label: Text('Deets'))
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('First Name')),
                    DataCell(Text('A.')),
                  ],
                ),
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
          if (student.get('e-mail') == context.read<User>().email) {
            print('User ${context.read<User>().email} located!');
          } else
            print('Couldn\'t find user');
        }
        return Text('Eureka!');
      },
    );
  }
}
