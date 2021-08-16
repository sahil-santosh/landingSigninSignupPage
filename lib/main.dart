import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/auth/forget_password.dart';
import 'package:landing_page/auth/login.dart';
import 'package:landing_page/auth/signup.dart';
import 'package:landing_page/auth/user_state.dart';
// import 'package:landing_page/landingScreen/landing_page.dart';
import 'package:landing_page/mainScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initalization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initalization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(body: Center(child: Text('Error occured'),),),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            routes: {
              LogInScreen.routeName: (ctx) => LogInScreen(),
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              MainScreen.routeName: (ctx) => MainScreen(),
              ForgetPassword.routeName: (ctx) => ForgetPassword(),
            },
            home: UserState(),
          );
        });
  }
}
