import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landing_page/auth/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/SignUpScreen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  String _name = '';
  int _phoneNumber;
  File _pickedImage;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethod _globalMethod = GlobalMethod();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailAddress.toLowerCase().trim(),
          password: _password.trim(),
        );
      } catch (error) {
        _globalMethod.authErrorHandle(error.message, context);
        // print('error occured: ${error.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.purple, Colors.purple],
                    [Colors.purpleAccent, Colors.purpleAccent],
                  ],
                  durations: [
                    19440,
                    10800,
                  ],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Stack(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: Colors.redAccent,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage: _pickedImage == null
                              ? null
                              : FileImage(_pickedImage),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 110,
                      child: RawMaterialButton(
                        elevation: 10,
                        fillColor: Colors.purple,
                        child: Icon(Icons.add_a_photo),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Choose option',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        InkWell(
                                          onTap: _pickImageCamera,
                                          splashColor: Colors.purpleAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(Icons.camera,
                                                    color: Colors.purpleAccent),
                                              ),
                                              Text(
                                                'Camera',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _pickImageGallery,
                                          splashColor: Colors.purpleAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(Icons.image,
                                                    color: Colors.purpleAccent),
                                              ),
                                              Text(
                                                'Gallery',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _remove,
                                          splashColor: Colors.purpleAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(Icons.remove_circle,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('name'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 3) {
                              return "Name must be three character long";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Name',
                            fillColor: Colors.grey.shade300,
                          ),
                          onSaved: (value) {
                            _name = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('email'),
                          focusNode: _emailFocusNode,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email Address',
                            fillColor: Colors.grey.shade300,
                          ),
                          onSaved: (value) {
                            _emailAddress = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 6) {
                              return "Please enter a valid password";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            labelText: 'Password',
                            fillColor: Colors.grey.shade300,
                          ),
                          onSaved: (value) {
                            _password = value;
                          },
                          obscureText: _obscureText,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNumberFocusNode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('phoneNumber'),
                          focusNode: _phoneNumberFocusNode,
                          validator: (value) {
                            if (value.isEmpty || value.length < 10) {
                              return "phone number must be 10 character long";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _submitForm,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: Icon(Icons.phone_android),
                            labelText: 'Phone Number',
                            fillColor: Colors.grey.shade300,
                          ),
                          onSaved: (value) {
                            _phoneNumber = int.parse(value);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          _isLoading 
                          ? CircularProgressIndicator() 
                          : ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.pink.shade400),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                          color: Colors.grey.shade300)),
                                )),
                            onPressed: _submitForm,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Signup',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.person_add),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
