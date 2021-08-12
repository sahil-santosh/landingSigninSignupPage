import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 150),
          child: Material(
            color: Colors.transparent,
            child: TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Image.asset(
                                'images/warning1.png',
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Sign out'),
                            )
                          ],
                        ),
                        content: Text('Do you wanna Sign out?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                           TextButton(
                                  onPressed: () async {
                                    await _auth.signOut().then(
                                        (value) => Navigator.canPop(context)? Navigator.pop(context): null);                                    
                                  },
                                  child: Text('Ok')),
                        ],
                      );
                    });
              },
              child: Row(
                children: [
                  Icon(Icons.exit_to_app_rounded),
                  Text('Logout'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
