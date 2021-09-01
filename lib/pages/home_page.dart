import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(),
      backgroundColor: Colors.yellowAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
