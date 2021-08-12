import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/auth/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = "/LogInScreen";
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethod _globalMethod = GlobalMethod();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
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
        await _auth.signInWithEmailAndPassword(
            email: _emailAddress.toLowerCase().trim(),
            password: _password.trim()).then((value) => Navigator.canPop(context)? Navigator.pop(context): null);
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
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage("images/bag11.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: ValueKey('email'),
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
                              color: Colors.black, fontWeight: FontWeight.bold),
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
                              color: Colors.black, fontWeight: FontWeight.bold),
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
                        onEditingComplete: _submitForm,
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
                                        Colors.orangeAccent.shade400),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: BorderSide(
                                              color: Colors.grey.shade300)),
                                    )),
                                onPressed: _submitForm,
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
                              ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
