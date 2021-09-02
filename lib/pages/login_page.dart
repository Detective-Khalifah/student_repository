import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/components/rounded_button.dart';
import 'package:student_repository/pages/home_page.dart';
import 'package:student_repository/services/authentication.dart';

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
  final TextEditingController _emailControl = TextEditingController(),
      _pwdControl = TextEditingController();

  var loggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loggingIn,
        child: Form(
          key: _logFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _emailControl,
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
                      labelText: 'E-mail',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: _pwdControl,
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
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Hero(
                    tag: 'log',
                    child: RoundedButton(
                      colour: Colors.greenAccent,
                      label: 'Log In',
                      onPressed: () async {
                        setState(() {
                          loggingIn = true;
                        });

                        // Validate returns true if the form is valid, or false otherwise.
                        if (_logFormKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                          final login = await context
                              .read<Authentication>()
                              .logIn(
                                  email: _emailControl.text,
                                  pwd: _pwdControl.text);
                          if (login == "Logged in!")
                            Navigator.pushNamed(context, HomePage.id);
                        } else {
                          // _logFormKey.currentState!.reset();
                        }
                        setState(() {
                          loggingIn = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
