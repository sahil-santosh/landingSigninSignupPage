import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:landing_page/auth/global_method.dart';
import 'package:landing_page/auth/login.dart';
import 'package:landing_page/auth/signup.dart';
import 'package:landing_page/mainScreen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  List<String> images = [
    'https://media.istockphoto.com/photos/man-at-the-shopping-picture-id868718238?k=6&m=868718238&s=612x612&w=0&h=ZUPCx8Us3fGhnSOlecWIZ68y3H4rCiTnANtnjHk0bvo=',
    'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1138257321%2F0x0.jpg%3Ffit%3Dscale',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethod _globalMethod = GlobalMethod();

  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _googleSignIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateParse = DateTime.parse(date);
          var formattedDate =
              '${dateParse.day}-${dateParse.month}-${dateParse.year}';
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
            'id': authResult.user.uid,
            'name': authResult.user.displayName,
            'email': authResult.user.email,
            'phoneNumber': authResult.user.phoneNumber,
            'imageUrl': authResult.user.photoURL,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
        } catch (error) {
          _globalMethod.authErrorHandle(error.message, context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: images[1],
            // placeholder: (context, url) => Image.network(
            //   "https://image.flaticon.com/icons/png/512/752/752755.png",
            //   fit: BoxFit.contain,
            // ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 60),
          //   width: double.infinity,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Welcome",
          //         style: TextStyle(
          //           fontWeight: FontWeight.w600,
          //           fontSize: 40,
          //         ),
          //       ),
          //       SizedBox(height: 20),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 30),
          //         child: Text(
          //           "Welcome to the biggest online store",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontWeight: FontWeight.w400,
          //             fontSize: 30,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.grey.shade300)),
                    )),
                    onPressed: () {
                      Navigator.pushNamed(context, LogInScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.person),
                      ],
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink.shade400),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.grey.shade300)),
                        )),
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.person_add),
                      ],
                    ),
                  )),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                    ),
                  ),
                  Text(
                    'or continue with',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(color: Colors.red, width: 2),
                      primary: Colors.black,
                      // backgroundColor: Colors.red
                    ),
                    onPressed: _googleSignIn,
                    child: Text('Google +'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(color: Colors.purple, width: 2),
                      primary: Colors.black,
                      // backgroundColor: Colors.red
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, MainScreen.routeName);
                    },
                    child: Text('Sign in as a Guest'),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
