import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_repository/pages/view_courses_page.dart';
import 'package:student_repository/utilities/profile_args.dart';

final _firestore = FirebaseFirestore.instance;

var coursesList = [];
var theCourses = [];

class EditCoursesPage extends StatefulWidget {
  static const String id = 'edit_courses';
  final String matriculation;

  const EditCoursesPage({Key? key, required this.matriculation})
      : super(key: key);

  @override
  _EditCoursesPageState createState() => _EditCoursesPageState();
}

class _EditCoursesPageState extends State<EditCoursesPage> {
  late bool _hasRegisteredCoursesBefore = false;
  late List<DropdownMenuItem<String>> dropdownMenus = [];

  late List<String> first_semester_choices, second_semester_choices;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkIfRegisteredCoursesBefore();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _hasRegisteredCoursesBefore
                ? editRegistration()
                : registerFirstTime(),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, ViewCoursesPage.id,
                          arguments: ProfileArguments(widget.matriculation));
                    },
                    child: Text('View Courses')),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _checkIfRegisteredCoursesBefore() async {
    QuerySnapshot studentsRegistrations =
        await _firestore.collection('student_courses').get();
    for (var studentRegistration in studentsRegistrations.docs) {
      if (studentRegistration.id == widget.matriculation) {
        _hasRegisteredCoursesBefore = true;
        return;
      }
    }
    _hasRegisteredCoursesBefore = false;
  }

  DropdownMenuItem<String> getCourseDropdown(
      {required String code, required int unit, required String title}) {
    DropdownMenuItem<String> courseMetrics = DropdownMenuItem(
      child: Text('[$code] -- $title: $unit credit units'),
      value: '[$code] -- $title: $unit credit units',
    );
    return courseMetrics;
  }

  void addDocument() async {
    DocumentReference reference =
        _firestore.collection('student_courses').doc(widget.matriculation);
    await reference.set({
      'first_semester': first_semester_choices,
      'second_semester': second_semester_choices,
    }, SetOptions(merge: true));
  }

  /// WIDGET TREE for Students registering course for the first time.
  ///
  ///
  registerFirstTime() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: Text('No course could be fetched!'));

        return Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final courses = snapshot.data!.docs;
              addDocument();
              // print(snap.get('first_semester'));
              // print(snap.get('second_semester'));

              for (var course in courses) {
                String code = course.get('code');
                String title = course.get('title');
                int units = course.get('credit_units');

                dropdownMenus.add(
                    getCourseDropdown(code: code, unit: units, title: title));
              }

              List<String> selectedItem = [];
              for (int i = 0; i < 10; i++) {
                selectedItem.add('NONE');
              }
              return DropdownButton(
                hint: Text('4L Course'),
                items: dropdownMenus,
                value: selectedItem[index].toString(),
                onChanged: (value) {
                  setState(() {
                    selectedItem[index] = value.toString();
                  });
                },
              );
            },
            itemCount: 10,
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => SizedBox(
              height: 8.0,
            ),
          ),
        );
      },
    );
  }

  /// Widget Tree for students editing course registration.
  ///
  ///
  editRegistration() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: Text('No course could be fetched!'));

        return ListView.separated(
          itemBuilder: (context, index) {
            final courses = snapshot.data!.docs;
            for (var course in courses) {
              String code = course.get('code');
              String title = course.get('title');
              int units = course.get('credit_units');

              dropdownMenus.add(
                  getCourseDropdown(code: code, unit: units, title: title));
            }

            List<String> selectedItem = [];
            for (int i = 0; i < 10; i++) {
              selectedItem.add('NONE');
            }
            return DropdownButton(
              hint: Text('4L Course'),
              items: dropdownMenus,
              // value: selectedItem[index].toString(),
              onChanged: (value) {
                setState(() {
                  selectedItem[index] = value.toString();
                });
              },
            );
          },
          itemCount: 10,
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => SizedBox(
            height: 8.0,
          ),
        );
      },
    );
  }
}
