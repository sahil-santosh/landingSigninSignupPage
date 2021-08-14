import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid;
  String _name;
  String _userImageUrl;
  // String _email;
  // String _joinedAt;
  // int _phoneNumber;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    User user = _auth.currentUser;
    _uid = user.uid;
    // print('user.email ${user.email}');
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      _name = userDoc.get('name');
      // _email = user.email;
      // _joinedAt = userDoc.get('joinedAt');
      // _phoneNumber = userDoc.get('phoneNumber');
      _userImageUrl = userDoc.get('imageUrl');
    });
    // print('name $_name');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        // flexibleSpace: Container(),
        title: Text(
          _name.toString().toUpperCase() ?? '...',
          style: TextStyle(fontSize: 15.0, color: Colors.white,),
        ),
        centerTitle: true,
      ),
      // drawer: MyDrawer(),
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 165,
            child:  Material(
                borderRadius: BorderRadius.all(Radius.circular(80)),
                elevation: 8,
                child: Container(
                  height: 55,
                  width: 55,
                  child: CircleAvatar(
                    
                    backgroundImage: NetworkImage(
                      _userImageUrl ?? 'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg',
                    ),
                  ),
                ),
              ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: 1,
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: 1,
              onPressed: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
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
                                await _auth
                                    .signOut()
                                    .then((value) => Navigator.pop(context));
                              },
                              child: Text('Ok')),
                        ],
                      );
                    });
              },
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
