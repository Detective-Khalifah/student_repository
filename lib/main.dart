import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_repository/pages/edit_courses_page.dart';
import 'package:student_repository/pages/edit_profile_page.dart';
import 'package:student_repository/pages/home_page.dart';
import 'package:student_repository/pages/login_page.dart';
import 'package:student_repository/pages/registration_page.dart';
import 'package:student_repository/pages/view_courses_page.dart';
import 'package:student_repository/pages/welcome_page.dart';
import 'package:student_repository/services/authentication.dart';
import 'package:student_repository/utilities/profile_args.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authentication>(
          create: (_) => Authentication(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<Authentication>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
        home: AuthenticationWrapper(),
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
          HomePage.id: (context) => HomePage(),
          EditCoursesPage.id: (context) => EditCoursesPage(),
        },
        onGenerateRoute: (setting) {
          switch (setting.name) {
            case EditProfilePage.id:
              final args = setting.arguments as ProfileArguments;

              return MaterialPageRoute(builder: (context) {
                return EditProfilePage(matriculation: args.matriculation);
              });

            case ViewCoursesPage.id:
              final args = setting.arguments as ProfileArguments;

              return MaterialPageRoute(builder: (context) {
                return ViewCoursesPage(matriculation: args.matriculation);
              });
            default:
          }
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key});

  @override
  Widget build(BuildContext context) {
    final _student = context.watch<User?>();

    if (_student != null) {
      return HomePage();
    }
    return WelcomePage(title: 'Welcome');
  }
}
