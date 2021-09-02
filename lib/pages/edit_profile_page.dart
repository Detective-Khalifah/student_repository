import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/pages/home_page.dart';
import 'package:student_repository/pages/welcome_page.dart';
import 'package:student_repository/services/authentication.dart';

final _firestore = FirebaseFirestore.instance;
late String docId,
    fName,
    mName,
    lName,
    phone,
    address,
    state,
    lga,
    dept,
    matriculation,
    email;
late String updatedFName = fName,
    updatedMName = mName,
    updatedLName = lName,
    updatedPhone = phone,
    updatedAddress = address;

class EditProfilePage extends StatefulWidget {
  final String matriculation;
  static const String id = 'edit_profile';

  const EditProfilePage({Key? key, required this.matriculation});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
          )
        ],
      ),
      backgroundColor: Colors.yellowAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProfileDetails(),
      ),
    );
  }

  @override
  void initState() {
    matriculation = widget.matriculation;
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({Key? key}) : super(key: key);

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

        final _profiles = snapshot.data!.docs;
        for (var profile in _profiles) {
          if (profile.get('Matriculation Number') == matriculation) {
            fName = profile.get('First Name');
            mName = profile.get('Middle Name');
            lName = profile.get('Last Name');
            phone = profile.get('Phone').toString();
            address = profile.get('Address');
            state = profile.get('State of Origin');
            lga = profile.get('Local Government (of Origin)');
            dept = profile.get('Department');
            email = profile.get('e-mail');
            docId = profile.id;
          }
        }
        return ListView(
          children: [
            TextField(
              controller: TextEditingController(text: fName),
              onChanged: (value) {
                updatedFName = value;
              },
            ),
            TextField(
              controller: TextEditingController(text: mName),
              onChanged: (value) {
                updatedMName = value;
              },
            ),
            TextField(
              controller: TextEditingController(text: lName),
              onChanged: (value) {
                updatedLName = value;
              },
            ),
            TextField(
              controller: TextEditingController(text: phone),
              onChanged: (value) {
                updatedPhone = value;
              },
            ),
            TextField(
              controller: TextEditingController(text: address),
              onChanged: (value) {
                updatedAddress = value;
              },
            ),
            TextField(
              controller: TextEditingController(
                text: state,
              ),
              enabled: false,
            ),
            TextField(
              controller: TextEditingController(text: lga),
              enabled: false,
            ),
            TextField(
              controller: TextEditingController(text: dept),
              enabled: false,
            ),
            TextField(
              controller: TextEditingController(text: matriculation),
              enabled: false,
            ),
            TextField(
              controller: TextEditingController(text: email),
              enabled: false,
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                _firestore.collection('students').doc(docId).update(
                  {
                    'First Name': updatedFName,
                    'Middle Name': updatedMName,
                    'Last Name': updatedLName,
                    'Phone': updatedPhone,
                    'Address': updatedAddress,
                  },
                );
                Navigator.popAndPushNamed(context, HomePage.id);
              },
            )
          ],
        );
      },
    );
  }
}
