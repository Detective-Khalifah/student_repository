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
  late String selectedCourse = '';

  late List<String> first_semester_choices, second_semester_choices;
  late List<DropdownMenuItem<String>> dropdownMenus = [];

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

        return ListView.separated(
          itemBuilder: (context, index) {
            // final fcourses = snapshot.data!.docs[index].get(field);
            // final scourses = snapshot.data!['second_semester'];
            // print('First: ${fcourses.toString()}');
            // print('First: $scourses');
            // for (var course in fcourses) {
            // String code = course.get('code');
            // String title = course.get('title');
            // int units = course.get('credit_units');

            // dropdownMenus.add(
            //     getCourseDropdown(code: code, unit: units, title: title));
            // }

            List<String> selectedItem = [];
            for (int i = 0; i < 10; i++) {
              selectedItem.add('NONE');
            }
            return DropdownButton(
              hint: Text('Pick a course'),
              // value: snapshot.data!.docs[index].get('title'),
              value: selectedCourse,
              items: snapshot.data!.docs.map((course) {
                return DropdownMenuItem(
                  value: '${course.get('title')}', // WORKS
                  // value:
                  //     '[${value.get('code')}] -- ${value.get('title')}: ${value.get('credit_units')} credit units',
                  child: Text(
                    '[${course.get('code')}] -- ${course.get('title')}: ${course.get('credit_units')} CU',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                );
              }).toList(),
              onChanged: (chosenCourse) {
                setState(
                  () {
                    print('Course selected: $chosenCourse');
                    selectCourse(chosenCourse.toString());
                  },
                );
              },
            );
          },
          itemCount: snapshot.data!.docs.length,
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => SizedBox(
            height: 8.0,
          ),
        );
      },
      // final data = snapshot.data!['first_semester'];
      // print(snap.get('first_semester'));
      // print(snap.get('second_semester'));
    );
  }

  /// Widget Tree for students editing course registration.
  ///
  ///
  editRegistration() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('courses')
          .doc(widget.matriculation)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: Text('No course could be fetched!'));

        return ListView.separated(
          itemBuilder: (context, index) {
            final fcourses = snapshot.data!['first_semester'];
            final scourses = snapshot.data!['second_semester'];
            print('First: ${fcourses.toString()}');
            print('First: $scourses');
            for (var course in fcourses) {
              // String code = course.get('code');
              // String title = course.get('title');
              // int units = course.get('credit_units');

              // dropdownMenus.add(
              //     getCourseDropdown(code: code, unit: units, title: title));
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

  void selectCourse(String chosenCourse) {
    setState(() {
      selectedCourse = chosenCourse;
    });
  }
}
