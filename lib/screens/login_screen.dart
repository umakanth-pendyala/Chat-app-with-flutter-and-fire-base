import 'package:flutter/material.dart';
import 'package:flash_chat/components/material_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';


class LoginScreen extends StatefulWidget {
  static const String loginScreenRoute = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool _doLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _doLoad,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: KTextBoxInputDecoration.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: KTextBoxInputDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CustomMaterialRoundedButton(
                  label: 'login',
                  buttonColor: Colors.blueAccent,
                  whatToDo: () async {
                    try {
                      setState(() {
                        _doLoad = true;
                      });
//                      await _auth.signInWithEmailAndPassword(email: email, password: password) == null
//                        ? print('invalid password')
//                        : Navigator.pushNamed(
//                            context, ChatScreen.chatScreenRoute);
                      if (await _auth.signInWithEmailAndPassword(email: email.trim(), password: password) != null) {
                        Navigator.pushNamed(
                            context, ChatScreen.chatScreenRoute);
                      }
                      setState(() {
                        _doLoad = false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        _doLoad = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
