import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/components/rounded_button.dart';
import 'package:student_repository/services/authentication.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'registration';
  final String title;

  const RegistrationPage({required this.title});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final String p0, p1;
  final TextEditingController emailControl = TextEditingController(),
      pwdControl = TextEditingController();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<_RegistraionPageState>.
  final _regFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _regFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: emailControl,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-mail must be entered!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter E-mail',
                  labelText: 'E-mail',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: pwdControl,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password must be entered!';
                  }
                  p0 = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password must be entered!';
                  }
                  p1 = value;
                  return p0 == p1 ? null : 'Passwords do not match!';
                },
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.green,
                label: 'Register',
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_regFormKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    context.read<Authentication>().register(
                        email: emailControl.text, pwd: pwdControl.text);
                  } else {
                    // _regFormKey.currentState!.reset();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
