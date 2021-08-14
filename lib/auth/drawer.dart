import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
    return Drawer(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 25, bottom: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(80)),
                elevation: 8,
                child: Container(
                  height: 160,
                  width: 160,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      _userImageUrl ?? 'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _name ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        
        // Container(
        //   padding: EdgeInsets.only(top: 1),
        //   child: Column(
        //     children: [

        // ListTile(
        //   leading: Icon(
        //     Icons.email,
        //     color: Colors.black,
        //   ),
        //   title: Text(
        //     "Email: " + _email ?? '',
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
        // Divider(
        //   height: 5,
        //   color: Colors.black,
        //   thickness: 1,
        // ),
        // ListTile(
        //   leading: Icon(
        //     Icons.date_range,
        //     color: Colors.black,
        //   ),
        //   title: Text(
        //     "Joined At: " + _joinedAt ?? '',
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
        // Divider(
        //   height: 5,
        //   color: Colors.black,
        //   thickness: 1,
        // ),
        // ListTile(
        //   leading: Icon(
        //     Icons.phone,
        //     color: Colors.black,
        //   ),
        //   title: Text(
        //     "Phone Number: " + _phoneNumber.toString() ?? '',
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
        // Divider(
        //   height: 5,
        //   color: Colors.black,
        //   thickness: 1,
        // ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.black,
          ),
          title: Text(
            "Log Out",
            style: TextStyle(color: Colors.black),
          ),
          onTap: () async {
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
                                (value) => Navigator.pop(context));
                          },
                          child: Text('Ok')),
                    ],
                  );
                });
          },
        ),
        // Divider(
        //   height: 5,
        //   color: Colors.black,
        //   thickness: 1,
        // ),
        // ],
        // ),
        // ),
      ],
    ));
  }
}
