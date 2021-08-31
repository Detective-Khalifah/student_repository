import 'package:flutter/material.dart';
import 'package:student_repository/pages/login_page.dart';
import 'package:student_repository/pages/registration_page.dart';
import 'package:student_repository/pages/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 2),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id: (context) => WelcomePage(
              title: 'Student Repo',
            ),
        RegistrationPage.id: (context) => RegistrationPage(
              title: 'Register',
            ),
        LoginPage.id: (context) => LoginPage(
              title: 'Log In',
            ),
      },
    );
  }
}
