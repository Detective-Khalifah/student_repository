import 'package:flutter/material.dart';
import 'package:student_repository/components/rounded_button.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';
  final String title;

  const LoginPage({required this.title});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<_LoginPageState>.
  final _logFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _logFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
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
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password must be entered!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.greenAccent,
                label: 'Log In',
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_logFormKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  } else {
                    // _logFormKey.currentState!.reset();
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
